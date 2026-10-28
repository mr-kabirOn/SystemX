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

  await load('Inter', 'assets/fonts/Inter.ttf');
  await load('NotoSansBengali', 'assets/fonts/NotoSansBengali.ttf');
  final phosphor = Directory('${Platform.environment['HOME']}/.pub-cache/hosted/pub.dev')
      .listSync()
      .whereType<Directory>()
      .lastWhere((d) => d.path.contains('phosphor_flutter-'));
  await load('packages/phosphor_flutter/PhosphorRegular',
      '${phosphor.path}/lib/fonts/Phosphor.ttf');
  await load('packages/phosphor_flutter/PhosphorFill',
      '${phosphor.path}/lib/fonts/Phosphor-Fill.ttf');
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
  Size size = const Size(1080, 2400),
  int onboardingPage = 0,
  FakeBackgroundApi? background,
  bool usage = false,
}) async {
  final api = FakeDeviceApi()
    ..phoneGranted = true
    ..usageGranted = usage
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
    backgroundApiProvider.overrideWithValue(background ?? FakeBackgroundApi()),
    hardwareTestApiProvider.overrideWithValue(FakeHardwareTestApi()),
    resultsStoreProvider.overrideWithValue(_sampleResults()),
    tempDirProvider.overrideWithValue(() async => Directory.systemTemp),
  ]);
  if (onboarded) await c.read(settingsProvider.notifier).completeOnboarding();
  await c.read(settingsProvider.notifier).setThemeMode(theme);
  if (locale != null) await c.read(settingsProvider.notifier).setLocale(locale);

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 2.625;
  tester.view.padding = const FakeViewPadding(top: 63, bottom: 63);

  await tester.pumpWidget(UncontrolledProviderScope(
    container: c,
    child: const SystemXApp(),
  ));
  await tester.pumpAndSettle();
  for (var i = 0; i < onboardingPage; i++) {
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
  }
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

/// Two weeks of varied charges, for the battery health and sessions shots.
FakeBackgroundApi _manyCharges() {
  final now = DateTime(2026, 10, 14, 15);
  ChargeSession s(int daysAgo, int hour, int minutes, int from, int to, double temp, int? cap) {
    final start = DateTime(now.year, now.month, now.day - daysAgo, hour);
    return ChargeSession(
      startMs: start.millisecondsSinceEpoch,
      endMs: start.add(Duration(minutes: minutes)).millisecondsSinceEpoch,
      startLevel: from,
      endLevel: to,
      maxTempC: temp,
      avgMa: 2400,
      peakMa: 3900,
      capacityMah: cap,
    );
  }
  return FakeBackgroundApi()
    ..chargeSessions = [
      s(0, 13, 51, 36, 90, 38.2, 4890),
      s(1, 21, 2, 59, 58, 33.0, null),
      s(1, 8, 38, 62, 83, 36.4, 4850),
      s(3, 23, 95, 18, 100, 40.5, 4905),
      s(5, 19, 30, 45, 64, 35.1, null),
      s(8, 7, 70, 22, 95, 37.0, 4870),
      s(11, 22, 80, 30, 100, 39.0, 4880),
    ];
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
    await _shoot(tester, '1b_onboarding_light', Routes.welcome,
        onboarded: false, theme: ThemeMode.light);
    for (final (i, n) in ['overview', 'used_phone', 'tests', 'alerts', 'privacy'].indexed) {
      await _shoot(tester, '1${String.fromCharCode(99 + i)}_onboarding_$n', Routes.welcome,
          onboarded: false, onboardingPage: i + 1);
    }
    for (final (i, n) in ['welcome', 'overview', 'used_phone', 'tests', 'alerts', 'privacy'].indexed) {
      await _shoot(tester, 'bn/onboarding_${i}_$n', Routes.welcome,
          onboarded: false, onboardingPage: i, locale: 'bn');
    }
    await _shoot(tester, 'bn/settings', Routes.settings, locale: 'bn');
    await _shoot(tester, 'bn/battery_health', Routes.batteryHealth, locale: 'bn', background: _manyCharges());
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
    final live = FakeBackgroundApi();
    live.config = copyConfig(live.config, liveStatus: true);
    await _shoot(tester, '21_alerts', Routes.alerts, background: live);
    await _shoot(tester, '22_sessions', Routes.sessions);
    await _shoot(tester, '23_wifi_meter', Routes.wifiMeter);
    await _shoot(tester, '24_home_bangla', Routes.home, locale: 'bn');
    await _shoot(tester, '25_report_light', Routes.report(0), theme: ThemeMode.light);
    await _shoot(tester, '26_apps', Routes.apps);
    await _shoot(tester, '27_device_info', Routes.category(DeviceCategory.device));
    await _shoot(
        tester, '28_device_sensors', Routes.category(DeviceCategory.sensors));
    await _shoot(tester, '29_battery_health', Routes.batteryHealth, background: _manyCharges());
    await _shoot(tester, '30_screen_time', Routes.screenTime, usage: true);
    const tall = Size(1080, 4400);
    await _shoot(tester, '31_processor_full', Routes.category(DeviceCategory.processor), size: tall);
    await _shoot(tester, '32_system_full', Routes.category(DeviceCategory.system), size: tall);
    await _shoot(tester, '33_graphics', Routes.category(DeviceCategory.gpu));
    await _shoot(tester, '30b_screen_time_light', Routes.screenTime, usage: true, theme: ThemeMode.light);
    await _shoot(tester, '30c_screen_time_no_access', Routes.screenTime);
    await _shoot(tester, 'bn/screen_time', Routes.screenTime, usage: true, locale: 'bn');
    await _shoot(tester, '22b_sessions_many', Routes.sessions, background: _manyCharges());
    await _shoot(tester, '30_used_phone', Routes.usedPhone);
    await _shoot(tester, '31_stress', Routes.stress);
    await _shoot(tester, '32_tests_light', Routes.tests, theme: ThemeMode.light);
    await _shoot(tester, '33_touch_grid', Routes.runTest(HwTest.touchGrid));
    addTearDown(tester.view.reset);
  });

  // Play Store phone screenshots must be at most 2:1, so these are 1080×2160.
  testWidgets('store screenshots', (tester) async {
    const store = Size(1080, 2160);
    final shots = <(String, String)>[
      ('store/1_home', Routes.home),
      ('store/2_device', Routes.device),
      ('store/3_cpu', Routes.live(LiveMetric.cpu)),
      ('store/4_battery', Routes.live(LiveMetric.battery)),
      ('store/5_tests', Routes.tests),
      ('store/6_report', Routes.report(0)),
      ('store/7_monitor', Routes.monitor),
      ('store/8_privacy', Routes.privacy),
    ];
    for (final (name, route) in shots) {
      await _shoot(tester, name, route, size: store);
    }
    await _shoot(tester, 'store/bn_1_home', Routes.home, size: store, locale: 'bn');
    await _shoot(tester, 'store/bn_2_device', Routes.device, size: store, locale: 'bn');
    addTearDown(tester.view.reset);
  });
}
