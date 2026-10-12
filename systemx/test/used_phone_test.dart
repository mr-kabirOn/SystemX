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

  UsedPhoneReport eval({SellerClaims claims = const SellerClaims(), TestHistory? h, int? cap}) =>
      evaluateUsedPhone(
        l: l,
        snap: snap,
        claims: claims,
        history: h ?? history(),
        capacityPercent: cap,
        now: now,
      );

  test('box sizes round up from what Android reports', () {
    expect(boxStorageGb(snap.storage!), 128);
    expect(boxRamGb(snap.memory!), 8);
  });

  test('model claims match names, numbers and partial names', () {
    final id = snap.identity!;
    expect(modelMatches('pixel 8', id), isTrue);
    expect(modelMatches('Pixel-8', id), isTrue);
    expect(modelMatches('Galaxy S24', id), isFalse);
  });

  test('a clean phone with a recent checkup passes', () {
    final r = eval(claims: const SellerClaims(model: 'Pixel 8', storageGb: 128, ramGb: 8), cap: 92);
    expect(r.verdict, UsedVerdict.clean);
    expect(r.problems, isEmpty);
  });

  test('wrong storage or a failed test is a problem', () {
    expect(eval(claims: const SellerClaims(storageGb: 256)).verdict, UsedVerdict.problems);
    final failed = eval(h: history(failed: true));
    expect(failed.verdict, UsedVerdict.problems);
    expect(failed.problems.map((c) => c.title), contains(HwTest.speaker.title(l)));
  });

  test('worn battery asks for a closer look; no recent checkup is incomplete', () {
    expect(eval(cap: 72).verdict, UsedVerdict.checkFirst);
    expect(eval(cap: 60).verdict, UsedVerdict.problems);
    final old = eval(h: history(at: now.subtract(const Duration(days: 3))));
    expect(old.verdict, UsedVerdict.incomplete);
    expect(old.checkup, isNull);
  });

  testWidgets('screen flags a claim mismatch and shares a PDF', (tester) async {
    final shared = <(Uint8List, String)>[];
    final results = MemoryResultsStore()
      ..data = jsonEncode(history(at: DateTime.now().subtract(const Duration(hours: 1))).toJson());
    await pumpApp(tester, results: results, sharedFiles: shared);
    await go(tester, Routes.usedPhone);

    await tester.enterText(find.byType(TextField).first, 'Galaxy S24 Ultra');
    await tester.pumpAndSettle();
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('Problems found'), 300, scrollable: list);
    await tester.scrollUntilVisible(
        find.text('Seller says Galaxy S24 Ultra, phone is Pixel 8'), 300, scrollable: list);

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
    final bytes = await buildUsedPhonePdf(l, snap, const SellerClaims(), r, now);
    expect(bytes.length, greaterThan(1000));
  });
}
