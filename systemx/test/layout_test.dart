import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';

import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  testWidgets('wide screens get a side rail, phones the bottom bar', (tester) async {
    await pumpApp(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    tester.view.physicalSize = const Size(2560, 1600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('Device tab copies the whole spec sheet', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String;
      return null;
    });
    addTearDown(() =>
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
    await pumpApp(tester);
    await go(tester, Routes.device);
    await tester.tap(find.byTooltip('Copy all specs'));
    await tester.pumpAndSettle();
    expect(copied, contains('Pixel 8'));
    expect(copied, contains('Tensor G3'));
    expect(find.text('All specs copied'), findsOneWidget);
  });
}
