import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'features/background/background.dart';
import 'features/play/play.dart';
import 'core/settings/settings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/sx_colors.dart';
import 'l10n/app_localizations.dart';

class SystemXApp extends ConsumerWidget {
  const SystemXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    // Keeps the native config in sync (temperature unit, last checkup).
    ref.listen(backgroundConfigProvider, (_, _) {});
    ref.listen(updateCheckProvider, (_, _) {});

    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      var dark = settings.pureBlack ? SxColors.amoled : SxColors.dark;
      var light = SxColors.light;

      if (settings.dynamicColor &&
          lightDynamic != null &&
          darkDynamic != null) {
        dark = dark.copyWith(
          accent: darkDynamic.primary,
          onAccent: darkDynamic.onPrimary,
          heroStart: Color.alphaBlend(
              darkDynamic.primary.withValues(alpha: 0.32), dark.card),
          onHero: darkDynamic.onPrimaryContainer,
        );
        light = light.copyWith(
          accent: lightDynamic.primary,
          onAccent: lightDynamic.onPrimary,
          heroStart: lightDynamic.primary,
          heroEnd: Color.alphaBlend(
              Colors.black.withValues(alpha: 0.25), lightDynamic.primary),
          onHero: lightDynamic.onPrimary.withValues(alpha: 0.88),
        );
      }

      return MaterialApp.router(
        title: 'SystemX',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(light, Brightness.light),
        darkTheme: buildTheme(dark, Brightness.dark),
        themeMode: settings.themeMode,
        locale: settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router,
      );
    });
  }
}
