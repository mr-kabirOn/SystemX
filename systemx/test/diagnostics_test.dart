import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/tests/impl/sensor_tests.dart';
import 'package:systemx/features/tests/impl/system_tests.dart';
import 'package:systemx/features/tests/report_pdf.dart';
import 'package:systemx/features/tests/test_catalog.dart';
import 'package:systemx/features/tests/test_results.dart';
import 'package:systemx/l10n/app_localizations.dart';

import 'fakes.dart';
import 'test_app.dart';

Future<void> go(WidgetTester tester, String location) async {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  (app.routerConfig! as GoRouter).go(location);
  await tester.pumpAndSettle();
}

Future<void> push(WidgetTester tester, String location) async {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  (app.routerConfig! as GoRouter).push(location);
  await tester.pumpAndSettle();
}

void main() {
  final l = lookupAppLocalizations(const Locale('en'));

  group('automatic tests', () {
    test('Wi-Fi, Bluetooth, NFC and signal read the real state', () async {
      final api = FakeDeviceApi();
      expect(await runWifi(api, l), (TestStatus.passed, 'Connected · -52 dBm'));
      expect(await runNfc(api, l), (TestStatus.passed, 'On'));
      expect((await runMobileSignal(api, l)).$1, TestStatus.passed);
      final hw = FakeHardwareTestApi()..bluetooth = 'off';
      expect(await runBluetooth(hw, l), (TestStatus.skipped, 'Bluetooth is off'));
    });

    test('storage speed writes, reads back and cleans up', () async {
      final dir = await Directory.systemTemp.createTemp('sx');
      addTearDown(() => dir.delete(recursive: true));
      final (s, note) = await runStorageSpeed(l, () async => dir, mb: 4);
      expect(s, TestStatus.passed);
      expect(note, startsWith('Write '));
      expect(dir.listSync(), isEmpty);
    });

    test('barometer is skipped on phones without one', () async {
      final r = await runBarometer(FakeDeviceApi(), (_) => const Stream.empty(), l);
      expect(r, (TestStatus.skipped, l.nNoSensor));
    });
  });

  group('sensor challenges', () {
    test('accelerometer needs all four corners', () {
      final c = SensorChallenge(HwTest.accelerometer);
      for (var i = 0; i < 40; i++) {
        c.add([-9.8, -9.8, 0], i * 20); // tilt to bottom-right... top-left
      }
      expect(c.corners, hasLength(1));
      expect(c.done, isFalse);
    });

    test('proximity passes after covering and uncovering', () {
      final c = SensorChallenge(HwTest.proximity)..maxRange = 5;
      c.add([5], 0);
      expect(c.done, isFalse);
      c.add([0], 100);
      expect(c.progress, 0.5);
      c.add([5], 200);
      expect(c.done, isTrue);
    });

    test('light passes on a clear change in brightness', () {
      final c = SensorChallenge(HwTest.light);
      c.add([200], 0);
      c.add([10], 100);
      expect(c.done, isTrue);
    });
  });

  testWidgets('hub lists 32 tests and runs a single one', (tester) async {
    final hw = FakeHardwareTestApi();
    final store = MemoryResultsStore();
    final c = await pumpApp(tester, hardware: hw, results: store);
    await tester.tap(find.text('Tests').last);
    await tester.pumpAndSettle();
    expect(find.text('32 tests · about 6 minutes'), findsOneWidget);

    await push(tester, Routes.runTest(HwTest.speaker));
    expect(hw.calls, contains('speaker'));
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.text('Passed'), findsOneWidget);
    expect(find.text('Tone heard'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final h = await c.read(testHistoryProvider.future);
    expect(h.latest[HwTest.speaker]?.status, TestStatus.passed);
    expect(store.data, contains('speaker'));
  });

  testWidgets('a refused permission skips the test', (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api, answer: 'denied');
    await pumpApp(tester, api: api, permissions: perms);
    await push(tester, Routes.runTest(HwTest.microphone));
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();
    expect(find.text('Skipped'), findsOneWidget);
    expect(find.text('Permission not allowed'), findsOneWidget);
  });

  testWidgets('a failed test shows how to fix it', (tester) async {
    await pumpApp(tester);
    await push(tester, Routes.runTest(HwTest.vibration));
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.text('Failed'), findsOneWidget);
    expect(find.textContaining('Restart the phone'), findsOneWidget);
  });

  testWidgets('full checkup: automatic tests, skip the rest, get a report',
      (tester) async {
    final shared = <(Uint8List, String)>[];
    final hw = FakeHardwareTestApi();
    final c = await pumpApp(tester, hardware: hw, sharedFiles: shared);
    await push(tester, Routes.checkup);
    await tester.tap(find.text('Start checkup'));
    // Automatic phase (storage speed does real file I/O).
    for (var i = 0; i < 100 && find.text('Automatic tests').evaluate().isNotEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump(const Duration(milliseconds: 100));
    }

    for (var i = 0; i < 80 && find.text('Checkup report').evaluate().isEmpty; i++) {
      if (find.text('Allow').evaluate().isNotEmpty) {
        await tester.tap(find.text('Allow'));
      } else if (find.text('Tap to continue').evaluate().isNotEmpty) {
        await tester.tap(find.text('Tap to continue'));
      } else if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip').first);
      } else {
        await tester.tapAt(const Offset(200, 400)); // later display slides
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    expect(find.text('Checkup report'), findsOneWidget);
    final h = await c.read(testHistoryProvider.future);
    final checkup = h.lastCheckup!;
    expect(checkup.results, hasLength(32));
    expect(checkup.count(TestStatus.passed), greaterThanOrEqualTo(5));
    // Every automatic test ran on its own.
    for (final t in HwTest.values.where((t) => t.automatic)) {
      expect(checkup.results.firstWhere((r) => r.test == t).status,
          isNot(TestStatus.notRun), reason: t.name);
    }
    expect(find.text('${checkup.score}'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Share report'), 600,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Share report'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 2)));
    await tester.pumpAndSettle();
    expect(shared, hasLength(1));
    expect(String.fromCharCodes(shared.single.$1.take(4)), '%PDF');
    expect(shared.single.$2, startsWith('SystemX-checkup-'));
  });

  test('the PDF report builds with the phone summary', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('en');
    final snap = await loadSnapshot(FakeDeviceApi(), Probe.values.toSet());
    final c = Checkup(DateTime(2026, 10, 12, 21, 38), [
      TestResult(HwTest.earpiece, TestStatus.failed, note: 'Very quiet', at: DateTime(2026)),
      TestResult(HwTest.speaker, TestStatus.passed, at: DateTime(2026)),
    ]);
    final bytes = await buildReportPdf(c, l, snap);
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
