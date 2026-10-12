import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/tools/stress_test.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

StressSample _s(int sec, double work, {double temp = 35}) => StressSample(
      elapsedMs: sec * 1000,
      workPerSec: work,
      batteryTempC: temp,
      thermalStatus: 0,
      running: true,
    );

void main() {
  test('verdict compares the end with the start of the run', () {
    final steady = evaluateStress([for (var i = 1; i <= 60; i++) _s(i, 1000)]);
    expect(steady!.verdict, StressVerdict.steady);
    expect(steady.retainedPercent, 100);

    final drop = evaluateStress([
      for (var i = 1; i <= 60; i++) _s(i, i < 30 ? 1000 : 600, temp: 30 + i / 10),
    ]);
    expect(drop!.verdict, StressVerdict.throttles);
    expect(drop.retainedPercent, 60);
    expect(drop.peakTempC, 36);

    expect(evaluateStress([for (var i = 1; i <= 20; i++) _s(i, 1000)]), isNull);
  });

  testWidgets('runs, keeps the screen on, and shows a result', (tester) async {
    final hw = FakeHardwareTestApi();
    await pumpApp(tester, hardware: hw);
    await go(tester, Routes.stress);

    await tester.tap(find.text('Start test'));
    await tester.pump();
    expect(hw.calls, containsAll(['startStress', 'keepScreenOn:true']));
    await tester.pump(const Duration(seconds: 61));
    await tester.pump();
    expect(hw.calls, contains('keepScreenOn:false'));
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('Performance at the end'), 300, scrollable: list);
    expect(find.text('Slows down a little when hot'), findsOneWidget);
  });

  testWidgets('a warm phone is refused with an explanation', (tester) async {
    final hw = FakeHardwareTestApi()..stressRefusal = 'hot';
    await pumpApp(tester, hardware: hw);
    await go(tester, Routes.stress);
    await tester.tap(find.text('Start test'));
    await tester.pumpAndSettle();
    expect(find.textContaining('already warm'), findsOneWidget);
    expect(hw.calls, isNot(contains('keepScreenOn:true')));
  });
}
