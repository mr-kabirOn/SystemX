import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/background/charging_stats.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

ChargeSession _s(DateTime start, Duration d, int from, int to, {double temp = 34, int? cap}) =>
    ChargeSession(
      startMs: start.millisecondsSinceEpoch,
      endMs: start.add(d).millisecondsSinceEpoch,
      startLevel: from,
      endLevel: to,
      maxTempC: temp,
      avgMa: 1800,
      peakMa: 2900,
      capacityMah: cap,
    );

void main() {
  final now = DateTime(2026, 10, 12, 12);

  test('rate is percent per hour, null for tiny charges', () {
    expect(chargeRate(_s(now, const Duration(hours: 2), 20, 80), now), closeTo(30, 0.01));
    expect(chargeRate(_s(now, const Duration(minutes: 2), 20, 21), now), isNull);
  });

  test('stats summarise the last 30 days and pick habits', () {
    final list = [
      _s(now.subtract(const Duration(days: 1)), const Duration(hours: 1), 30, 100),
      _s(now.subtract(const Duration(days: 2)), const Duration(hours: 1), 10, 100, temp: 41),
      _s(now.subtract(const Duration(days: 3)), const Duration(hours: 1), 12, 100),
      _s(now.subtract(const Duration(days: 40)), const Duration(hours: 1), 50, 60), // too old
    ];
    final st = chargeStats(list, now);
    expect(st.count, 3);
    expect(st.toFull, 3);
    expect(st.deepDrain, 2);
    expect(st.hot, 1);
    expect(st.hottestC, 41);
    expect(st.avgDuration, const Duration(hours: 1));
    expect(st.insights, [ChargeInsight.hot, ChargeInsight.toFull, ChargeInsight.deepDrain]);
  });

  test('gentle charging is called out as good', () {
    final st = chargeStats([_s(now.subtract(const Duration(days: 1)), const Duration(hours: 1), 30, 80)], now);
    expect(st.insights, [ChargeInsight.good]);
  });

  testWidgets('screen shows summary, habits, chart and grouped sessions', (tester) async {
    final today = DateTime.now();
    final bg = FakeBackgroundApi()
      ..chargeSessions = [
        _s(today.subtract(const Duration(hours: 3)), const Duration(hours: 1), 25, 85, cap: 4600),
        _s(today.subtract(const Duration(days: 1, hours: 2)), const Duration(hours: 2), 10, 100, temp: 42),
      ];
    await pumpApp(tester, background: bg);
    await go(tester, Routes.sessions);

    expect(find.text('LAST 30 DAYS'), findsOneWidget);
    expect(find.text('The battery got warm while charging'), findsOneWidget);
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('TODAY'), 300, scrollable: list);
    await tester.scrollUntilVisible(find.text('+60%'), 300, scrollable: list);
    await tester.scrollUntilVisible(find.text('Measured capacity 4,600 mAh'), 300, scrollable: list);
    await tester.scrollUntilVisible(find.text('YESTERDAY'), 300, scrollable: list);
  });

  testWidgets('empty state explains how charges get recorded', (tester) async {
    await pumpApp(tester, background: FakeBackgroundApi()..chargeSessions = []);
    await go(tester, Routes.sessions);
    expect(find.text('No charges recorded yet'), findsOneWidget);
  });
}
