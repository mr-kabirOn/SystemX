import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/tests/test_catalog.dart';
import 'package:systemx/features/tests/test_results.dart';
import 'package:systemx/features/tools/used_phone.dart';
import 'package:systemx/features/tools/used_phone_screen.dart';
import 'package:systemx/l10n/app_localizations.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('en'));
  final now = DateTime(2026, 10, 12, 12);
  late DeviceSnapshot snap;

  setUpAll(() async {
    snap = await loadSnapshot(FakeDeviceApi(), Probe.values.toSet());
  });

  TestHistory history({bool failed = false, DateTime? at}) {
    final c = Checkup(at ?? now.subtract(const Duration(hours: 1)), [
      for (final t in HwTest.values)
        TestResult(t, failed && t == HwTest.speaker ? TestStatus.failed : TestStatus.passed,
            at: now),
    ]);
    return TestHistory(checkups: [c]);
  }

  UsedPhoneReport eval({TestHistory? h, int? cap}) =>
      evaluateUsedPhone(
        l: l,
        snap: snap,
        history: h ?? history(),
        capacityPercent: cap,
        now: now,
      );

  test('box sizes round up from what Android reports', () {
    expect(boxStorageGb(snap.storage!), 128);
    expect(boxRamGb(snap.memory!), 8);
  });

  test('a clean phone with a recent checkup passes', () {
    final r = eval(cap: 92);
    expect(r.verdict, UsedVerdict.clean);
    expect(r.problems, isEmpty);
    expect(r.passed, r.rated.length);
    expect(r.worst(CheckGroup.software), CheckLevel.ok);
  });

  test('a failed hardware test is a problem in its group', () {
    final failed = eval(h: history(failed: true));
    expect(failed.verdict, UsedVerdict.problems);
    expect(failed.problems.map((c) => c.title), contains(HwTest.speaker.title(l)));
    expect(failed.worst(CheckGroup.hardware), CheckLevel.bad);
    expect(failed.worst(CheckGroup.battery), CheckLevel.ok);
  });

  test('worn battery asks for a closer look; no recent checkup is incomplete', () {
    expect(eval(cap: 72).verdict, UsedVerdict.checkFirst);
    expect(eval(cap: 60).verdict, UsedVerdict.problems);
    final old = eval(h: history(at: now.subtract(const Duration(days: 3))));
    expect(old.verdict, UsedVerdict.incomplete);
    expect(old.checkup, isNull);
  });

  testWidgets('screen: disclaimer, checklist ticks and a PDF', (tester) async {
    final shared = <(Uint8List, String)>[];
    final results = MemoryResultsStore()
      ..data = jsonEncode(history(at: DateTime.now().subtract(const Duration(hours: 1))).toJson());
    final api = FakeDeviceApi();
    await pumpApp(tester, api: api, results: results, sharedFiles: shared);
    await go(tester, Routes.usedPhone);

    expect(find.text('About this assessment'), findsOneWidget);
    expect(find.textContaining('not responsible for purchase decisions'), findsOneWidget);
    expect(find.text('No problems found'), findsOneWidget);

    final list = find
        .descendant(of: find.byType(UsedPhoneScreen), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(find.text('IMEI matches the box'), 300, scrollable: list);
    await tester.ensureVisible(find.text('IMEI matches the box'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('IMEI matches the box'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show IMEI'));
    await tester.scrollUntilVisible(find.text('1 of 7 confirmed'), -200, scrollable: list);
    expect(api.dialed, ['*#06#']);

    await tester.scrollUntilVisible(find.text('Create report (PDF)'), 300, scrollable: list);
    await tester.runAsync(() async {
      await tester.tap(find.text('Create report (PDF)'));
      for (var i = 0; i < 50 && shared.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    });
    expect(shared.single.$2, startsWith('SystemX-used-phone-'));
    expect(String.fromCharCodes(shared.single.$1.take(4)), '%PDF');
  });

  test('PDF builds offline from the report', () async {
    final r = eval(cap: 90);
    final bytes = await buildUsedPhonePdf(l, snap, r, {BuyerCheck.imei}, now);
    expect(bytes.length, greaterThan(1000));
  });
}
