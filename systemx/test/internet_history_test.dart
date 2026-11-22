import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/apps/apps_screen.dart';
import 'package:systemx/features/apps/internet_history.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  test('sums mobile and Wi-Fi separately', () {
    final s = sumData([
      DataTotalDay(dayStartMs: 0, mobileRx: 100, mobileTx: 10, wifiRx: 500, wifiTx: 50),
      DataTotalDay(dayStartMs: 1, mobileRx: 200, mobileTx: 20, wifiRx: 0, wifiTx: 0),
    ]);
    expect(s.mobile, 330);
    expect(s.wifi, 550);
  });

  testWidgets('without Usage access: explains and links to the setting', (tester) async {
    final api = FakeDeviceApi();
    await pumpApp(tester, api: api);
    await go(tester, Routes.internetHistory);
    await tester.tap(find.widgetWithText(FilledButton, 'Allow usage access'));
    expect(api.opened, [AppsActions.usageAccess]);
  });

  testWidgets('shows 30-day totals for mobile data and Wi-Fi', (tester) async {
    final api = FakeDeviceApi()..usageGranted = true;
    await pumpApp(tester, api: api);
    await go(tester, Routes.internetHistory);
    // Mobile: 30 days of 220–510 MB; Wi-Fi: 30 × 850 MB.
    expect(find.text('10.9 GB'), findsWidgets); // mobile month (card and table)
    expect(find.text('25.5 GB'), findsWidgets); // Wi-Fi month
    expect(find.text('36.5 GB'), findsWidgets); // total month (hero and table)
    expect(find.text('Today'), findsWidgets);
  });
}
