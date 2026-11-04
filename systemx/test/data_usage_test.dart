import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/apps/apps_screen.dart';
import 'package:systemx/features/apps/data_usage.dart';
import 'package:systemx/l10n/app_localizations_en.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  final l = AppLocalizationsEn();

  test('system buckets get names; apps keep theirs', () {
    AppDataUsage row(String kind, {String? label}) =>
        AppDataUsage(key: kind, kind: kind, label: label, rxBytes: 1, txBytes: 1);
    expect(usageName(l, row('system')), 'Android system');
    expect(usageName(l, row('tethering')), 'Hotspot and tethering');
    expect(usageName(l, row('removed')), 'Removed apps');
    expect(usageName(l, row('other')), 'Other apps');
    expect(usageName(l, row('app', label: 'YouTube')), 'YouTube');
  });

  test('the daily average leaves out today and empty days', () {
    DataUsageDay day(int mobile) => DataUsageDay(
        dayStartMs: 0, wifiRx: 0, wifiTx: 0, mobileRx: mobile, mobileTx: 0, wifiApps: [], mobileApps: []);
    expect(dailyAverageBytes([day(100), day(0), day(300), day(9999)], DataNetwork.mobile), 200);
    expect(dailyAverageBytes([day(0), day(50)], DataNetwork.mobile), isNull);
  });

  testWidgets('without Usage access: explains and links to the setting', (tester) async {
    final api = FakeDeviceApi();
    await pumpApp(tester, api: api);
    await go(tester, Routes.dataUsage);
    await tester.tap(find.widgetWithText(FilledButton, 'Allow usage access'));
    expect(api.opened, [AppsActions.usageAccess]);
  });

  testWidgets('mobile data first, Wi-Fi on tap, apps with download and upload', (tester) async {
    final api = FakeDeviceApi()..usageGranted = true;
    await pumpApp(tester, api: api);
    await go(tester, Routes.dataUsage);

    expect(find.text('570 MB'), findsOneWidget); // today's mobile data
    expect(find.text('Daily average 430 MB'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.text('↓ 420 MB · ↑ 12 MB'), findsOneWidget);
    expect(find.text('Hotspot and tethering'), findsOneWidget);

    await tester.tap(find.text('Wi-Fi'));
    await tester.pumpAndSettle();
    expect(find.text('1.6 GB'), findsOneWidget); // today's Wi-Fi
    expect(find.text('YouTube'), findsOneWidget);
    expect(find.text('Facebook'), findsNothing);
  });
}
