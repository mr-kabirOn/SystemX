import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TempUnit { celsius, fahrenheit }

/// How often live readouts refresh while a screen is visible.
enum RefreshRate {
  fast(500),
  normal(1000),
  relaxed(2000);

  const RefreshRate(this.millis);
  final int millis;
}

@immutable
class AppSettings {
  const AppSettings({
    this.onboardingDone = false,
    this.themeMode = ThemeMode.light,
    this.pureBlack = false,
    this.dynamicColor = false,
    this.tempUnit = TempUnit.celsius,
    this.localeCode,
    this.refreshRate = RefreshRate.normal,
  });

  final bool onboardingDone;
  final ThemeMode themeMode;
  final bool pureBlack;
  final bool dynamicColor;
  final TempUnit tempUnit;

  /// null follows the phone's language.
  final String? localeCode;
  final RefreshRate refreshRate;

  Locale? get locale => localeCode == null ? null : Locale(localeCode!);

  AppSettings copyWith({
    bool? onboardingDone,
    ThemeMode? themeMode,
    bool? pureBlack,
    bool? dynamicColor,
    TempUnit? tempUnit,
    String? Function()? localeCode,
    RefreshRate? refreshRate,
  }) {
    return AppSettings(
      onboardingDone: onboardingDone ?? this.onboardingDone,
      themeMode: themeMode ?? this.themeMode,
      pureBlack: pureBlack ?? this.pureBlack,
      dynamicColor: dynamicColor ?? this.dynamicColor,
      tempUnit: tempUnit ?? this.tempUnit,
      localeCode: localeCode != null ? localeCode() : this.localeCode,
      refreshRate: refreshRate ?? this.refreshRate,
    );
  }
}

/// Overridden in main() with the instance loaded before runApp.
final prefsProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw UnimplementedError('prefsProvider must be overridden'),
);

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  static const _kOnboarding = 'onboarding_done';
  static const _kTheme = 'theme_mode';
  static const _kPureBlack = 'pure_black';
  static const _kDynamic = 'dynamic_color';
  static const _kTemp = 'temp_unit';
  static const _kLocale = 'locale';
  static const _kRefresh = 'refresh_rate';

  /// When the app last asked Play for a review (ms since epoch).
  static const reviewAskedKey = 'review_asked_ms';

  static const keys = {
    _kOnboarding,
    _kTheme,
    _kPureBlack,
    _kDynamic,
    _kTemp,
    _kLocale,
    _kRefresh,
    reviewAskedKey,
  };

  SharedPreferencesWithCache get _p => ref.read(prefsProvider);

  @override
  AppSettings build() {
    final p = ref.watch(prefsProvider);
    T pick<T extends Enum>(List<T> values, String key, T fallback) {
      final name = p.getString(key);
      return values.firstWhere((v) => v.name == name, orElse: () => fallback);
    }

    return AppSettings(
      onboardingDone: p.getBool(_kOnboarding) ?? false,
      themeMode: pick(ThemeMode.values, _kTheme, ThemeMode.light),
      pureBlack: p.getBool(_kPureBlack) ?? false,
      dynamicColor: p.getBool(_kDynamic) ?? false,
      tempUnit: pick(TempUnit.values, _kTemp, TempUnit.celsius),
      localeCode: p.getString(_kLocale),
      refreshRate: pick(RefreshRate.values, _kRefresh, RefreshRate.normal),
    );
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingDone: true);
    await _p.setBool(_kOnboarding, true);
  }

  Future<void> resetOnboarding() async {
    state = state.copyWith(onboardingDone: false);
    await _p.setBool(_kOnboarding, false);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _p.setString(_kTheme, mode.name);
  }

  Future<void> setPureBlack(bool value) async {
    state = state.copyWith(pureBlack: value);
    await _p.setBool(_kPureBlack, value);
  }

  Future<void> setDynamicColor(bool value) async {
    state = state.copyWith(dynamicColor: value);
    await _p.setBool(_kDynamic, value);
  }

  Future<void> setTempUnit(TempUnit unit) async {
    state = state.copyWith(tempUnit: unit);
    await _p.setString(_kTemp, unit.name);
  }

  Future<void> setLocale(String? code) async {
    state = state.copyWith(localeCode: () => code);
    if (code == null) {
      await _p.remove(_kLocale);
    } else {
      await _p.setString(_kLocale, code);
    }
  }

  Future<void> setRefreshRate(RefreshRate rate) async {
    state = state.copyWith(refreshRate: rate);
    await _p.setString(_kRefresh, rate.name);
  }
}
