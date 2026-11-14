import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  testWidgets('Add asks Android to place each widget and the tile', (tester) async {
    final api = FakeDeviceApi();
    await pumpApp(tester, api: api);
    await go(tester, Routes.widgets);
    final adds = find.widgetWithText(FilledButton, 'Add');
    expect(adds, findsNWidgets(3));
    for (var i = 0; i < 3; i++) {
      await tester.tap(adds.at(i));
      await tester.pumpAndSettle();
    }
    expect(api.pinned, ['small', 'medium', 'tile']);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('without launcher support the manual steps show', (tester) async {
    final api = FakeDeviceApi()..canPin = false;
    await pumpApp(tester, api: api);
    await go(tester, Routes.widgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Add').first);
    await tester.pump();
    expect(find.textContaining('Touch and hold an empty spot'), findsOneWidget);
  });
}
