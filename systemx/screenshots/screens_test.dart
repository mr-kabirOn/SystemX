// Renders every main screen to PNG with the real fonts, for design review.
// Run:  flutter test screenshots --update-goldens
// Output: screenshots/out/*.png
import 'dart:convert';
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
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/background/background.dart';
import 'package:systemx/features/live/live_data.dart';
import 'package:systemx/features/play/play.dart';
import 'package:systemx/features/live/live_screens.dart';
import 'package:systemx/features/tests/impl/system_tests.dart';
import 'package:systemx/features/tests/test_catalog.dart';
import 'package:systemx/features/tests/test_results.dart';
import 'package:systemx/platform/platform.dart';

import '../test/fakes.dart';

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
  await load('NotoSansBengali', 'assets/fonts/NotoSansBengali.ttf');
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
  String? locale,
}) async {
  final api = FakeDeviceApi()
    ..phoneGranted = true
    ..vary = true;
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsNotifier.keys),
  );
  final c = ProviderContainer(overrides: [
    prefsProvider.overrideWithValue(prefs),
    // Pixel 8 sample values, since tests have no phone to read.
    deviceApiProvider.overrideWithValue(api),
    permissionApiProvider.overrideWithValue(FakePermissionApi(api)),
    livePollingProvider.overrideWithValue(false),
    playApiProvider.overrideWithValue(FakePlayApi()),
    backgroundApiProvider.overrideWithValue(FakeBackgroundApi()),
    hardwareTestApiProvider.overrideWithValue(FakeHardwareTestApi()),
    resultsStoreProvider.overrideWithValue(_sampleResults()),
    tempDirProvider.overrideWithValue(() async => Directory.systemTemp),
  ]);
  if (onboarded) await c.read(settingsProvider.notifier).completeOnboarding();
  await c.read(settingsProvider.notifier).setThemeMode(theme);
  if (locale != null) await c.read(settingsProvider.notifier).setLocale(locale);

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
  // A minute of live readings so charts have a shape.
  for (var i = 0; i < 40; i++) {
    await tester.runAsync(() => c.read(liveProvider.notifier).tick());
  }
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 2));
  await expectLater(
      find.byType(MaterialApp), matchesGoldenFile('out/$name.png'));
  c.dispose();
}

/// A checkup like the design mockup: 30 passed, earpiece failed, GPS skipped.
MemoryResultsStore _sampleResults() {
  final at = DateTime.now().subtract(const Duration(hours: 2));
  final results = [
    for (final t in HwTest.values)
      switch (t) {
        HwTest.earpiece => TestResult(t, TestStatus.failed, note: 'Very quiet', at: at),
        HwTest.gps => TestResult(t, TestStatus.skipped, note: 'Skipped because Location is off', at: at),
        HwTest.touchGrid => TestResult(t, TestStatus.passed, note: 'All 96 zones respond', at: at),
        HwTest.charging => TestResult(t, TestStatus.passed, note: 'Detected · Charger · 2140 mA peak', at: at),
        _ => TestResult(t, TestStatus.passed, at: at),
      },
  ];
  final c = Checkup(at, results);
  return MemoryResultsStore()
    ..data = jsonEncode(TestHistory(
      latest: {for (final r in results) r.test: r},
      checkups: [c],
    ).toJson());
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
    await _shoot(tester, '9_device_processor',
        Routes.category(DeviceCategory.processor));
    await _shoot(
        tester, '10_device_battery', Routes.category(DeviceCategory.battery));
    await _shoot(
        tester, '11_device_network', Routes.category(DeviceCategory.network));
    await _shoot(tester, '12_device_security',
        Routes.category(DeviceCategory.security));
    await _shoot(tester, '13_device_sim', Routes.category(DeviceCategory.sim));
    await _shoot(tester, '14_live_cpu', Routes.live(LiveMetric.cpu));
    await _shoot(tester, '15_live_battery', Routes.live(LiveMetric.battery));
    await _shoot(tester, '16_live_network', Routes.live(LiveMetric.network));
    await _shoot(tester, '17_live_thermal', Routes.live(LiveMetric.thermal));
    await _shoot(tester, '18_report', Routes.report(0));
    await _shoot(tester, '19_test_multitouch', Routes.runTest(HwTest.multiTouch));
    await _shoot(tester, '20_checkup_intro', Routes.checkup);
    await _shoot(tester, '21_alerts', Routes.alerts);
    await _shoot(tester, '22_sessions', Routes.sessions);
    await _shoot(tester, '23_wifi_meter', Routes.wifiMeter);
    await _shoot(tester, '24_home_bangla', Routes.home, locale: 'bn');
    await _shoot(tester, '25_report_light', Routes.report(0), theme: ThemeMode.light);
    addTearDown(tester.view.reset);
  });
}
