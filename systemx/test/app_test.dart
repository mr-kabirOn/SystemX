import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:systemx/core/format.dart';
import 'package:systemx/core/settings/settings.dart';

import 'test_app.dart';

Future<ProviderContainer> _container() async {
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsNotifier.keys),
  );
  return ProviderContainer(overrides: [prefsProvider.overrideWithValue(prefs)]);
}

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('format', () {
    test('temperature follows the chosen unit', () {
      expect(formatTemp(31.4, TempUnit.celsius), '31.4 °C');
      expect(formatTemp(31.4, TempUnit.fahrenheit), '88.5 °F');
    });

    test('bytes keep one decimal instead of truncating', () {
      expect(formatBytes(7.6 * 1024 * 1024 * 1024), '7.6 GB');
      expect(formatBytes(512), '512 B');
    });
  });

  group('settings', () {
    test('defaults to light theme and Celsius', () async {
      final c = await _container();
      final s = c.read(settingsProvider);
      expect(s.themeMode, ThemeMode.light);
      expect(s.tempUnit, TempUnit.celsius);
      expect(s.onboardingDone, isFalse);
    });

    test('changes persist across a restart', () async {
      final c1 = await _container();
      await c1.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark);
      await c1.read(settingsProvider.notifier).setLocale('bn');
      await c1.read(settingsProvider.notifier).completeOnboarding();

      final c2 = await _container();
      final s = c2.read(settingsProvider);
      expect(s.themeMode, ThemeMode.dark);
      expect(s.localeCode, 'bn');
      expect(s.onboardingDone, isTrue);

      await c2.read(settingsProvider.notifier).setLocale(null);
      expect(c2.read(settingsProvider).localeCode, isNull);
    });
  });

  testWidgets('first launch shows onboarding, then the dashboard',
      (tester) async {
    await pumpApp(tester, onboarded: false);
    expect(find.text('Know your phone, inside out'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Pixel 8'), findsOneWidget);
    expect(find.text('Run checkup'), findsOneWidget);

    await tester.tap(find.text('Device'));
    await tester.pumpAndSettle();
    expect(find.text('Processor'), findsOneWidget);
  });
}
