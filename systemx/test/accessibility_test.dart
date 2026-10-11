import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/live/live_data.dart';
import 'package:systemx/features/live/live_screens.dart';
import 'package:systemx/features/tests/test_catalog.dart';

import 'fakes.dart';
import 'test_app.dart';

final _routes = [
  Routes.home,
  Routes.device,
  Routes.tests,
  Routes.monitor,
  Routes.settings,
  Routes.privacy,
  Routes.alerts,
  Routes.search,
  Routes.sessions,
  Routes.checkup,
  Routes.wifiMeter,
  for (final c in DeviceCategory.values) Routes.category(c),
  for (final m in LiveMetric.values) Routes.live(m),
  Routes.runTest(HwTest.speaker),
  Routes.runTest(HwTest.multiTouch),
];

Future<void> _visitAll(WidgetTester tester, ProviderContainer c) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => c.read(liveProvider.notifier).tick());
  }
  final problems = <String>[];
  for (final r in _routes) {
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    (app.routerConfig! as GoRouter).go(r);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    for (var e = tester.takeException(); e != null; e = tester.takeException()) {
      problems.add('$r: $e');
    }
  }
  await unmount(tester);
  expect(problems, isEmpty);
}

void main() {
  testWidgets('every screen fits at 200% font size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final c = await pumpApp(tester, api: FakeDeviceApi()..phoneGranted = true);
    await _visitAll(tester, c);
  });

  testWidgets('every screen fits on a small phone', (tester) async {
    final c = await pumpApp(tester);
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2.0;
    await tester.pumpAndSettle();
    await _visitAll(tester, c);
  });

  testWidgets('every screen works on a tablet, content centered', (tester) async {
    final c = await pumpApp(tester);
    tester.view.physicalSize = const Size(2560, 1600);
    tester.view.devicePixelRatio = 2.0;
    await tester.pumpAndSettle();
    final card = tester.getRect(find.text('Run checkup').first);
    expect(card.left, greaterThan(200)); // not stretched edge to edge
    await _visitAll(tester, c);
  });

  testWidgets('dashboard tiles and gauges have spoken labels', (tester) async {
    final c = await pumpApp(tester);
    for (var i = 0; i < 3; i++) {
      await tester.runAsync(() => c.read(liveProvider.notifier).tick());
    }
    await tester.pumpAndSettle();
    final handle = tester.ensureSemantics();
    expect(find.bySemanticsLabel(RegExp(r'^Battery 78%')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'Health score \d+')), findsOneWidget);
    handle.dispose();
  });
}
