// Renders every main screen to PNG with the real fonts, for design review.
// Run:  flutter test screenshots --update-goldens
// Output: screenshots/out/*.png
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:systemx/app.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/core/settings/settings.dart';

Future<void> _loadFonts() async {
  Future<void> load(String family, String path) async {
    final bytes = File(path).readAsBytesSync();
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }

  await load('Sora', 'assets/fonts/Sora.ttf');
  await load('Figtree', 'assets/fonts/Figtree.ttf');
  await load('JetBrainsMono', 'assets/fonts/JetBrainsMono.ttf');
  final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
  await load('MaterialIcons',
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
}

Future<void> _shoot(
  WidgetTester tester,
  String name,
  String route, {
  bool onboarded = true,
  ThemeMode theme = ThemeMode.dark,
}) async {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsNotifier.keys),
  );
  final c = ProviderContainer(
      overrides: [prefsProvider.overrideWithValue(prefs)]);
  if (onboarded) await c.read(settingsProvider.notifier).completeOnboarding();
  await c.read(settingsProvider.notifier).setThemeMode(theme);

  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  tester.view.padding = const FakeViewPadding(top: 63, bottom: 63);

  await tester.pumpWidget(UncontrolledProviderScope(
    container: c,
    child: const SystemXApp(),
  ));
  await tester.pumpAndSettle();
  if (route != Routes.home && route != Routes.welcome) {
    c.read(routerProvider).go(route);
    await tester.pumpAndSettle();
  }
  await tester.pump(const Duration(seconds: 2));
  await expectLater(
      find.byType(MaterialApp), matchesGoldenFile('out/$name.png'));
  c.dispose();
}

void main() {
  setUpAll(_loadFonts);

  testWidgets('screens', (tester) async {
    await _shoot(tester, '1_onboarding', Routes.welcome, onboarded: false);
    await _shoot(tester, '2_home', Routes.home);
    await _shoot(tester, '3_device', Routes.device);
    await _shoot(tester, '4_tests', Routes.tests);
    await _shoot(tester, '5_monitor', Routes.monitor);
    await _shoot(tester, '6_settings', Routes.settings);
    await _shoot(tester, '7_privacy', Routes.privacy);
    await _shoot(tester, '8_home_light', Routes.home, theme: ThemeMode.light);
    addTearDown(tester.view.reset);
  });
}
