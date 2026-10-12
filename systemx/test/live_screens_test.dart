import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/live/live_data.dart';
import 'package:systemx/features/live/live_screens.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';
import 'test_app.dart';

Future<void> go(WidgetTester tester, String location) async {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  (app.routerConfig! as GoRouter).go(location);
  await tester.pumpAndSettle();
}

/// Takes [n] live readings, as the timer would.
Future<void> ticks(WidgetTester tester, ProviderContainer c, [int n = 3]) async {
  for (var i = 0; i < n; i++) {
    await tester.runAsync(() => c.read(liveProvider.notifier).tick());
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('dashboard shows live values, score and a tip', (tester) async {
    final c = await pumpApp(tester);
    await ticks(tester, c);

    expect(find.text('Pixel 8'), findsOneWidget);
    expect(find.text('78 %'), findsOneWidget); // battery tile
    expect(find.text('↓ 2.5 MB/s'), findsOneWidget);
    expect(find.text('↑ 200 KB/s'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);
    expect(find.text('Headroom 64%'), findsOneWidget);
    expect(find.text('Excellent health'), findsOneWidget);
    expect(find.textContaining('Unplug at 80%'), findsOneWidget);

    await tester.tap(find.text('SCORE'));
    await tester.pumpAndSettle();
    expect(find.text('How the score works'), findsOneWidget);
    expect(find.text('Free storage'), findsOneWidget);
  });

  testWidgets('tiles open the live detail screens', (tester) async {
    final c = await pumpApp(tester);
    await ticks(tester, c);

    await tester.tap(find.text('CPU'));
    await tester.pumpAndSettle();
    expect(find.text('Average clock'), findsOneWidget);
    expect(find.text('Load (estimate)'), findsOneWidget);
    expect(find.text('A510'), findsNWidgets(4));
    expect(find.text('Google Tensor G3'.toUpperCase()), findsOneWidget);
  });

  testWidgets('each live screen renders and can pause', (tester) async {
    final c = await pumpApp(tester);
    await ticks(tester, c);
    for (final m in LiveMetric.values) {
      await go(tester, Routes.live(m));
      expect(tester.takeException(), isNull, reason: m.name);
      expect(find.text('Live'), findsNothing, reason: m.name);
    }

    await go(tester, Routes.live(LiveMetric.battery));
    expect(find.text('+2140 mA · 9 W'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause'));
    await tester.pump();
    expect(find.text('Paused'), findsOneWidget);
    expect(c.read(liveProvider).paused, isTrue);
  });

  testWidgets('Monitor charts follow the live readings', (tester) async {
    final c = await pumpApp(tester);
    await tester.tap(find.text('Monitor').last);
    await tester.pumpAndSettle();
    await ticks(tester, c, 4);

    expect(find.text('Processor clock'.toUpperCase()), findsOneWidget);
    expect(find.text('↓ 2.5 MB/s ↑ 200 KB/s'), findsOneWidget);
    expect(find.text('+2140 mA'), findsOneWidget);

    await tester.tap(find.text('NETWORK SPEED'));
    await tester.pumpAndSettle();
    expect(find.text('Download'), findsOneWidget);
  });

  testWidgets('Wi-Fi meter shows the live signal and the best so far',
      (tester) async {
    await pumpApp(tester);
    await go(tester, Routes.wifiMeter);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('-52'), findsOneWidget);
    expect(find.text('Excellent'), findsOneWidget);
    expect(find.text('-52 dBm'), findsOneWidget);
    expect(find.text('5 GHz'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a phone without current or CPU temperature says so',
      (tester) async {
    final c = await pumpApp(tester, api: _NoSensorsApi());
    await ticks(tester, c);
    await go(tester, Routes.live(LiveMetric.thermal));
    expect(find.textContaining("doesn't let apps read the CPU temperature"),
        findsOneWidget);
  });
}

class _NoSensorsApi extends FakeDeviceApi {
  @override
  Future<LiveStats> live() async {
    final s = await super.live();
    s.cpuTempC = null;
    s.currentNowMa = null;
    return s;
  }
}
