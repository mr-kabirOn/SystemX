import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/device/spec_sheets.dart';

import 'fakes.dart';
import 'test_app.dart';

Future<void> go(WidgetTester tester, String location) async {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  (app.routerConfig! as GoRouter).go(location);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Wi-Fi name: explain, ask, then show it', (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api);
    await pumpApp(tester, api: api, permissions: perms);
    await go(tester, Routes.category(DeviceCategory.network));

    expect(find.text('Hidden by Android'), findsOneWidget);
    await tester.tap(find.text('Network name'));
    await tester.pumpAndSettle();
    expect(find.text('Show the Wi-Fi name'), findsOneWidget);

    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();
    expect(perms.requested, ['location']);
    expect(find.text('HomeNet'), findsOneWidget);
  });

  testWidgets('"Not now" never shows the Android dialog', (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api);
    await pumpApp(tester, api: api, permissions: perms);
    await go(tester, Routes.category(DeviceCategory.network));

    await tester.tap(find.text('Network name'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(perms.requested, isEmpty);
    expect(find.text('Hidden by Android'), findsOneWidget);
  });

  testWidgets('a blocked permission offers the settings screen',
      (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api)..statuses['phone'] = 'blocked';
    await pumpApp(tester, api: api, permissions: perms);
    await go(tester, Routes.category(DeviceCategory.sim));

    await tester.tap(find.text('SIM details'));
    await tester.pumpAndSettle();
    expect(find.textContaining("won't ask again"), findsOneWidget);
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(perms.requested, isEmpty);
    expect(api.opened, ['app_details']);
  });

  testWidgets('Location allowed but off opens Location settings',
      (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api)..statuses['location'] = 'granted';
    await pumpApp(tester, api: api, permissions: perms);
    await go(tester, Routes.category(DeviceCategory.network));

    await tester.tap(find.text('Network name'));
    await tester.pumpAndSettle();
    expect(api.opened, [SettingsActions.location]);
  });

  testWidgets('SIM: balance check dials, Phone permission adds slots',
      (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api);
    await pumpApp(tester, api: api, permissions: perms);
    await go(tester, Routes.category(DeviceCategory.sim));

    // Known from the SIM's MCC+MNC even without the permission.
    expect(find.text('GRAMEENPHONE'), findsOneWidget);
    await tester.tap(find.text('Balance · *566#'));
    await tester.tap(find.text('Internet · *121*1*4#'));
    await tester.tap(find.text('My number · *2#'));
    expect(api.dialed, ['*566#', '*121*1*4#', '*2#']);

    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('SIM details'), 300, scrollable: list);
    await tester.tap(find.text('SIM details'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();
    // With the permission, both SIMs get their codes.
    await tester.scrollUntilVisible(find.text('ROBI'), -300, scrollable: list);
    expect(find.text('Balance · *222#'), findsOneWidget);
    expect(find.text('Internet · *8444*88#'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('SIM 1'), 300, scrollable: list);
    expect(find.text('SIM 1'), findsOneWidget);
  });

  testWidgets('Privacy screen shows and changes real statuses',
      (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api);
    await pumpApp(tester, api: api, permissions: perms);
    await go(tester, Routes.privacy);

    expect(find.text('Not allowed'), findsNWidgets(5));
    await tester.tap(find.text('Location'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();
    expect(find.text('Allowed'), findsOneWidget);

    // Once allowed, only Android Settings can take it back.
    await tester.tap(find.text('Location'));
    await tester.pumpAndSettle();
    expect(api.opened, ['app_details']);
  });
}
