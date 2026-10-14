import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/core/settings/settings.dart';

import 'fakes.dart';
import 'test_app.dart';

Future<void> go(WidgetTester tester, String location) async {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  (app.routerConfig! as GoRouter).go(location);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('turning on an alert asks for notifications first', (tester) async {
    final bg = FakeBackgroundApi();
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api);
    await pumpApp(tester, api: api, permissions: perms, background: bg);
    await go(tester, Routes.alerts);

    await tester.tap(find.text('Charge alarm'));
    await tester.pumpAndSettle();
    expect(find.text('Allow notifications'), findsOneWidget);
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();

    expect(perms.requested, ['notifications']);
    expect(bg.config.chargeAlarm, isTrue);
    await tester.tap(find.text('90%'));
    await tester.pumpAndSettle();
    expect(bg.config.chargeLimit, 90);
    expect(find.text('Notify when the battery reaches 90%'), findsOneWidget);
  });

  testWidgets('refusing notifications keeps the alert off', (tester) async {
    final bg = FakeBackgroundApi();
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api, answer: 'denied');
    await pumpApp(tester, api: api, permissions: perms, background: bg);
    await go(tester, Routes.alerts);

    await tester.tap(find.text('Live status notification'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();
    expect(bg.config.liveStatus, isFalse);
    expect(find.textContaining('Notifications are off'), findsOneWidget);
  });

  testWidgets('the temperature unit is shared with widgets and alerts', (tester) async {
    final bg = FakeBackgroundApi();
    final c = await pumpApp(tester, background: bg);
    await c.read(settingsProvider.notifier).setTempUnit(TempUnit.fahrenheit);
    await tester.pumpAndSettle();
    expect(bg.config.fahrenheit, isTrue);
  });

  testWidgets('Monitor shows history and charging sessions', (tester) async {
    await pumpApp(tester);
    await go(tester, Routes.sessions);
    final list = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(find.text('2,140 mA'), 300, scrollable: list);
    expect(find.text('+77%'), findsOneWidget); // the session; the summary shows 77%

    await go(tester, Routes.monitor);
    await tester.scrollUntilVisible(find.text('History'), 400,
        scrollable: find.byType(Scrollable).last);
    expect(find.textContaining('96 readings'), findsOneWidget);
  });

  testWidgets('clear history removes history and test results', (tester) async {
    final bg = FakeBackgroundApi();
    await pumpApp(tester, background: bg);
    await go(tester, Routes.settings);
    await tester.scrollUntilVisible(find.text('Clear all history'), 300,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Clear all history'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(bg.cleared, isTrue);
    expect(find.text('History cleared'), findsOneWidget);
  });
}
