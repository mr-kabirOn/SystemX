import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  testWidgets('turning on the floating monitor asks for both permissions, then saves', (tester) async {
    final bg = FakeBackgroundApi();
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api);
    await pumpApp(tester, api: api, permissions: perms, background: bg);
    await go(tester, Routes.floating);

    await tester.tap(find.text('Show over other apps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow')); // notifications
    await tester.pumpAndSettle();
    expect(find.text('Allow display over other apps'), findsOneWidget);
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();

    expect(perms.requested, ['notifications', 'overlay']);
    expect(bg.config.overlay, isTrue);

    await tester.tap(find.widgetWithText(FilterChip, 'Free RAM'));
    await tester.pumpAndSettle();
    expect(bg.config.overlayItems, ['fps', 'ram_free']);
  });
}
