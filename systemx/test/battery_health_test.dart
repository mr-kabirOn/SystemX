import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/background/battery_health.dart';
import 'package:systemx/platform/platform.dart';

import 'permissions_test.dart' show go;
import 'test_app.dart';

ChargeSession _s(int? cap) =>
    ChargeSession(startMs: 0, startLevel: 20, endLevel: 80, maxTempC: 30, capacityMah: cap);

HistorySample _h(int minute, int level, {bool? screen = false, bool charging = false}) =>
    HistorySample(
      timeMs: minute * 60000,
      level: level,
      tempC: 30,
      memUsed: 0.5,
      charging: charging,
      screenOn: screen,
    );

void main() {
  test('capacity is the median of the latest charges', () {
    // Newest first; one odd reading (3000) doesn't move the median.
    final est = estimateCapacity(
      [_s(4600), _s(null), _s(3000), _s(4500), _s(4550), _s(4580), _s(9999)],
      5000,
    );
    expect(est.mah, 4550);
    expect(est.percentOfDesign, 91);
    expect(est.count, 5);
    expect(est.trend.first, 9999); // oldest first for the chart
    expect(estimateCapacity([_s(null)], 5000).mah, isNull);
  });

  test('drain splits screen on and standby, skipping gaps and charging', () {
    final samples = [
      // Screen off: 2% over each 15 min for 1.5 h -> 8%/h.
      for (var i = 0; i <= 6; i++) _h(i * 15, 100 - i * 2),
      // A 2 h gap: not counted.
      _h(210, 80, screen: true),
      // Screen on: 5% per 15 min for 1 h -> 20%/h.
      for (var i = 1; i <= 4; i++) _h(210 + i * 15, 80 - i * 5, screen: true),
      // Charging: ignored.
      _h(300, 70, charging: true),
      // Old samples without the screen state are ignored.
      _h(315, 69, screen: null),
      _h(330, 68, screen: null),
    ];
    final d = drainRates(samples);
    expect(d.standby, closeTo(8, 0.01));
    expect(d.screenOn, closeTo(20, 0.01));
    expect(d.hoursOff, closeTo(1.5, 0.01));
  });

  test('drain waits for an hour of data', () {
    final d = drainRates([_h(0, 90), _h(15, 89), _h(30, 88)]);
    expect(d.standby, isNull);
    expect(d.hoursOff, closeTo(0.5, 0.01));
  });

  testWidgets('screen shows the measured capacity', (tester) async {
    await pumpApp(tester);
    await go(tester, Routes.batteryHealth);
    expect(find.text('4,210 mAh'), findsOneWidget);
    expect(find.text('Based on 1 charge'), findsOneWidget);
  });
}
