import 'package:flutter/material.dart';

/// Font families bundled in assets/fonts (all OFL, no network downloads).
abstract final class SxFonts {
  static const display = 'Sora';
  static const body = 'Inter';
  static const mono = 'JetBrainsMono';

  /// Bengali letters, which the three fonts above don't have.
  static const bengali = 'NotoSansBengali';
}

/// The bundled fonts are variable fonts, so the weight has to be passed as a
/// `wght` variation as well as a [FontWeight].
TextStyle sxStyle(
  String family,
  double size,
  FontWeight weight, {
  double? height,
  double? letterSpacing,
  Color? color,
  List<FontFeature>? features,
}) {
  return TextStyle(
    fontFamily: family,
    fontFamilyFallback: const [SxFonts.bengali],
    fontSize: size,
    fontWeight: weight,
    fontVariations: [FontVariation('wght', weight.value.toDouble())],
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontFeatures: features,
  );
}

TextTheme sxTextTheme(Color ink, Color muted) {
  TextStyle d(double s, FontWeight w, {double h = 1.2, double ls = 0}) =>
      sxStyle(SxFonts.display, s, w, height: h, letterSpacing: ls, color: ink);
  TextStyle b(double s, FontWeight w, {double h = 1.45, Color? c}) =>
      sxStyle(SxFonts.body, s, w, height: h, color: c ?? ink);

  return TextTheme(
    displayLarge: d(48, FontWeight.w700, h: 1.05, ls: -1),
    displayMedium: d(38, FontWeight.w700, h: 1.08, ls: -0.8),
    displaySmall: d(30, FontWeight.w700, h: 1.1, ls: -0.5),
    headlineLarge: d(28, FontWeight.w600, ls: -0.4),
    headlineMedium: d(24, FontWeight.w600, ls: -0.3),
    headlineSmall: d(21, FontWeight.w600, ls: -0.2),
    titleLarge: d(19, FontWeight.w600, ls: -0.1),
    titleMedium: b(16, FontWeight.w600, h: 1.3),
    titleSmall: b(14, FontWeight.w600, h: 1.3),
    bodyLarge: b(16, FontWeight.w400),
    bodyMedium: b(14, FontWeight.w400),
    bodySmall: b(12.5, FontWeight.w400, c: muted),
    labelLarge: b(14, FontWeight.w600, h: 1.2),
    labelMedium: b(12, FontWeight.w600, h: 1.2),
    labelSmall: b(11, FontWeight.w500, h: 1.2),
  );
}

/// Styles that sit outside Material's text roles.
abstract final class SxText {
  static const _tabular = [FontFeature.tabularFigures()];

  /// Live readouts. Monospace + tabular digits so values don't jump.
  static TextStyle readout(double size, Color color,
          {FontWeight weight = FontWeight.w600}) =>
      sxStyle(SxFonts.mono, size, weight,
          height: 1.1, letterSpacing: -0.4, color: color, features: _tabular);

  /// Small uppercase labels above values ("CPU", "MEMORY").
  static TextStyle eyebrow(Color color) => sxStyle(
      SxFonts.mono, 10.5, FontWeight.w600,
      height: 1.2, letterSpacing: 1.1, color: color);
}
