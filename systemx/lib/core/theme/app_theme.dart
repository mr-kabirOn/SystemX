import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sx_colors.dart';
import 'sx_type.dart';

abstract final class SxRadius {
  static const card = 20.0;
  static const tile = 16.0;
  static const control = 14.0;
}

ThemeData buildTheme(SxColors c, Brightness brightness) {
  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    secondary: c.accent,
    onSecondary: c.onAccent,
    error: c.bad,
    onError: c.onAccent,
    surface: c.bg,
    onSurface: c.ink,
    onSurfaceVariant: c.muted,
    surfaceContainerLowest: c.bg,
    surfaceContainerLow: c.card,
    surfaceContainer: c.card,
    surfaceContainerHigh: c.cardAlt,
    surfaceContainerHighest: c.cardAlt,
    outline: c.line,
    outlineVariant: c.line,
  );
  final text = sxTextTheme(c.ink, c.muted);
  final isDark = brightness == Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    fontFamily: SxFonts.body,
    textTheme: text,
    extensions: [c],
    splashFactory: InkSparkle.splashFactory,
    dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: c.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      indicatorColor: c.accent.withValues(alpha: 0.24),
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith((s) => sxStyle(
            SxFonts.body,
            12,
            FontWeight.w600,
            color: s.contains(WidgetState.selected) ? c.ink : c.muted,
          )),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            size: 22,
            color: s.contains(WidgetState.selected) ? c.accent : c.muted,
          )),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        minimumSize: const Size(64, 50),
        textStyle: text.labelLarge,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SxRadius.control)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.ink,
        minimumSize: const Size(64, 50),
        side: BorderSide(color: c.line),
        textStyle: text.labelLarge,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SxRadius.control)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: c.accent, textStyle: text.labelLarge),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        backgroundColor: c.card,
        foregroundColor: c.muted,
        selectedBackgroundColor: c.accent.withValues(alpha: 0.2),
        selectedForegroundColor: c.ink,
        side: BorderSide(color: c.line),
        textStyle: text.labelMedium,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onAccent : c.muted),
      trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : c.cardAlt),
      trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : c.line),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: c.muted,
      textColor: c.ink,
      titleTextStyle: text.titleSmall,
      subtitleTextStyle: text.bodySmall,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? c.cardAlt : c.ink,
      contentTextStyle: text.bodyMedium?.copyWith(color: isDark ? c.ink : c.bg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: c.line,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.card,
      hintStyle: text.bodyMedium?.copyWith(color: c.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SxRadius.control),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
    }),
  );
}
