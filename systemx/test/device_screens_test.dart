import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/device/spec_sheets.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';
import 'test_app.dart';

Future<void> openDeviceTab(WidgetTester tester) async {
  await tester.tap(find.text('Device').last);
  await tester.pumpAndSettle();
}

Future<void> go(WidgetTester tester, String location) async {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  (app.routerConfig! as GoRouter).go(location);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Device tab shows this phone and real summaries',
      (tester) async {
    await pumpApp(tester);
    await openDeviceTab(tester);

    expect(find.text('Pixel 8'), findsOneWidget);
    expect(find.text('GOOGLE · SHIBA'), findsOneWidget);
    expect(find.text('Google Tensor G3 · 9 cores · 4 nm'), findsOneWidget);
    expect(find.text('Android 16 · API 36'), findsOneWidget);
  });

  testWidgets('a category opens with its specs', (tester) async {
    await pumpApp(tester);
    await openDeviceTab(tester);
    await tester.tap(find.text('Graphics'));
    await tester.pumpAndSettle();

    expect(find.text('Mali-G715'), findsOneWidget);
    expect(find.text('1.3.278'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Pixel 8'), findsOneWidget);
  });

  testWidgets('processor refreshes live while open', (tester) async {
    final api = _CountingApi();
    await pumpApp(tester, api: api);
    await openDeviceTab(tester);
    await tester.tap(find.text('Processor'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Clusters'), findsOneWidget);

    final before = api.cpuCalls;
    await tester.pump(const Duration(seconds: 3));
    expect(api.cpuCalls, greaterThan(before));
    await unmount(tester);
  });

  testWidgets('security check links to the right settings screen',
      (tester) async {
    final api = FakeDeviceApi();
    await pumpApp(tester, api: api);
    await go(tester, Routes.category(DeviceCategory.security));

    await tester.tap(find.text('Developer options'));
    await tester.pump();
    expect(api.opened, [SettingsActions.developer]);
  });

  testWidgets('every category renders without errors', (tester) async {
    await pumpApp(tester, api: FakeDeviceApi()..phoneGranted = true);
    for (final c in DeviceCategory.values) {
      await go(tester, Routes.category(c));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: c.name);
      expect(find.textContaining("didn't share"), findsNothing, reason: c.name);
    }
    await unmount(tester);
  });

  testWidgets('a failed probe shows a clear message', (tester) async {
    await pumpApp(tester, api: FakeDeviceApi(failing: {'gpu'}));
    await go(tester, Routes.category(DeviceCategory.gpu));
    expect(find.textContaining("didn't share"), findsOneWidget);
  });
}

class _CountingApi extends FakeDeviceApi {
  int cpuCalls = 0;

  @override
  Future<CpuInfo> cpu() {
    cpuCalls++;
    return super.cpu();
  }
}
