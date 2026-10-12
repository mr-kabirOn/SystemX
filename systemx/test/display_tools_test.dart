import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/tools/display_tools.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  test('rate uses the median gap and ignores duplicates and pauses', () {
    final t = [
      for (var i = 0; i < 40; i++) Duration(microseconds: i * 8333), // 120 Hz
      const Duration(seconds: 2), // a pause
    ];
    expect(rateFromTimestamps([...t, t[3]]), closeTo(120, 0.1));
    expect(rateFromTimestamps(t.take(5).toList()), isNull);
  });

  testWidgets('refresh test asks for the fastest mode and resets it', (tester) async {
    final hw = FakeHardwareTestApi();
    await pumpApp(tester, hardware: hw);
    await go(tester, Routes.refreshRate);
    await tester.tap(find.text('Measure'));
    for (var i = 0; i < 240; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(hw.calls, containsAll(['highRefresh:true', 'keepScreenOn:true', 'keepScreenOn:false']));
    expect(find.text('Measured refresh rate'.toUpperCase()), findsOneWidget);
    await go(tester, Routes.home);
    expect(hw.calls, contains('highRefresh:false'));
  });

  testWidgets('touch test reports the event rate', (tester) async {
    await pumpApp(tester);
    await go(tester, Routes.touchRate);
    final center = tester.getCenter(find.text('Draw here'));
    final g = TestPointer(1, PointerDeviceKind.touch);
    var now = Duration.zero;
    await tester.sendEventToBinding(g.down(center, timeStamp: now));
    for (var i = 1; i <= 30; i++) {
      now += const Duration(microseconds: 4167); // 240 Hz
      await tester.sendEventToBinding(g.move(center + Offset(i.toDouble(), 0), timeStamp: now));
    }
    await tester.pump();
    expect(find.text('240 Hz'), findsNWidgets(2));
  });
}
