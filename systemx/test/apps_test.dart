import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/apps/apps_screen.dart';
import 'package:systemx/features/device/device_screen.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  test('apps sort by size or cache and hide system apps', () async {
    final all = await (FakeDeviceApi()..usageGranted = true).apps();
    expect(
      arrangeApps(all, sort: AppSort.size).map((a) => a.label),
      ['WhatsApp', 'Spotify'],
    );
    expect(
      arrangeApps(all, sort: AppSort.cache, showSystem: true)
          .map((a) => a.label),
      ['Spotify', 'Chrome', 'WhatsApp'],
    );
    expect(
      arrangeApps(all, sort: AppSort.name, showSystem: true, query: 'whats')
          .map((a) => a.label),
      ['WhatsApp'],
    );
  });

  testWidgets('without Usage access: explains and links to the setting',
      (tester) async {
    final api = FakeDeviceApi();
    await pumpApp(tester, api: api);
    await go(tester, Routes.apps);

    expect(find.text('See app sizes'), findsOneWidget);
    await tester.tap(find.text('Allow usage access'));
    expect(api.opened, [AppsActions.usageAccess]);

    await tester.tap(find.text('Free up space'));
    await tester.pump();
    expect(api.opened.last, AppsActions.manageStorage);
  });

  testWidgets('with Usage access: sizes, totals, and a tap opens App info',
      (tester) async {
    final api = FakeDeviceApi()..usageGranted = true;
    await pumpApp(tester, api: api);
    await go(tester, Routes.apps);

    expect(find.text('See app sizes'), findsNothing);
    expect(find.text('TOTAL SIZE'), findsOneWidget);
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('WhatsApp'), 300,
        scrollable: list);
    expect(find.text('2.3 GB · cache 90 MB'), findsOneWidget);
    await tester.tap(find.text('WhatsApp'));
    expect(api.openedApps, ['com.whatsapp']);

    await tester.tap(find.text('System apps'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Chrome'), 300,
        scrollable: list);
    expect(find.text('Chrome'), findsOneWidget);
  });

  testWidgets('the Device tab links to Apps', (tester) async {
    await pumpApp(tester);
    await go(tester, Routes.device);
    final list = find
        .descendant(
            of: find.byType(DeviceScreen), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(find.text('Installed apps'), 300,
        scrollable: list);
    await tester.tap(find.text('Installed apps'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
  });
}
