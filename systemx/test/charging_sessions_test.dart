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

  test('rate needs 10 minutes and 5 points', () {
    expect(chargeRate(_s(now, const Duration(hours: 2), 20, 80), now), closeTo(30, 0.01));
    expect(chargeRate(_s(now, const Duration(minutes: 2), 59, 58), now), isNull);
    expect(chargeRate(_s(now, const Duration(minutes: 30), 50, 53), now), isNull);
  });

  test('summary uses valid charges with documented formulas', () {
    final list = [
      _s(now.subtract(const Duration(days: 1)), const Duration(hours: 1), 30, 100), // 70 in 1 h
      _s(now.subtract(const Duration(days: 2)), const Duration(hours: 3), 10, 100, temp: 46), // 90 in 3 h
      _s(now.subtract(const Duration(days: 2, hours: 5)), const Duration(minutes: 2), 59, 58), // too short
      _s(now.subtract(const Duration(days: 40)), const Duration(hours: 1), 50, 60), // too old
    ];
    final st = chargeStats(list, now);
    expect(st.count, 2);
    expect(st.excluded, 1);
    expect(st.avgDuration, const Duration(hours: 2));
    expect(st.avgAdded, 80);
    // Time-weighted: 160 points / 4 h = 40, not the mean of 70 and 30 (50).
    expect(st.overallRate, closeTo(40, 0.01));
    expect(st.hot, 1);
    expect(st.insights.first, ChargeInsight.hot);
  });

  test('one warm peak is not a warning; repeated warm charges are', () {
    ChargeSession warm(int d) => _s(now.subtract(Duration(days: d)), const Duration(hours: 1), 30, 80, temp: 42.5);
    expect(chargeStats([warm(1)], now).insights, [ChargeInsight.good]);
    expect(chargeStats([warm(1), warm(2)], now).insights, [ChargeInsight.warmOften]);
    expect(
      chargeStats([_s(now.subtract(const Duration(days: 1)), const Duration(hours: 1), 30, 80, temp: 40.5)], now)
          .insights,
      [ChargeInsight.good],
    );
  });

  test('charge time reads as h and min', () {
    expect(formatChargeTime(const Duration(minutes: 52), h: 'h', min: 'min'), '52 min');
    expect(formatChargeTime(const Duration(minutes: 95), h: 'h', min: 'min'), '1 h 35 min');
  });

  testWidgets('screen shows summary, habits, chart and grouped sessions', (tester) async {
    final today = DateTime.now();
    final bg = FakeBackgroundApi()
      ..chargeSessions = [
        _s(today.subtract(const Duration(hours: 3)), const Duration(hours: 1), 25, 85, cap: 4600),
        _s(today.subtract(const Duration(days: 1, hours: 2)), const Duration(hours: 2), 10, 100, temp: 46),
        _s(today.subtract(const Duration(days: 1, hours: 5)), const Duration(minutes: 2), 59, 58),
      ];
    await pumpApp(tester, background: bg);
    await go(tester, Routes.sessions);

    expect(find.text('LAST 30 DAYS'), findsOneWidget);
    expect(find.text('The battery got hot while charging'), findsOneWidget);
    expect(find.textContaining('1 shorter connection'), findsOneWidget);
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('TODAY'), 300, scrollable: list);
    await tester.scrollUntilVisible(find.text('+60%'), 300, scrollable: list);
    await tester.scrollUntilVisible(find.text('Measured capacity 4,600 mAh'), 300, scrollable: list);
    await tester.scrollUntilVisible(find.textContaining('too short to measure'), 300, scrollable: list);
  });

  testWidgets('empty state explains how charges get recorded', (tester) async {
    await pumpApp(tester, background: FakeBackgroundApi()..chargeSessions = []);
    await go(tester, Routes.sessions);
    expect(find.text('No charges recorded yet'), findsOneWidget);
  });
}
