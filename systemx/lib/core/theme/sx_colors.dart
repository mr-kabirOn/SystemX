import 'package:flutter/material.dart';

/// SystemX design tokens. Every screen reads colors from here, never from
/// literals, so dark, light and pure-black themes stay consistent.
///
/// Each hardware area owns one hue (cpu, ram, battery...) and uses it the same
/// way everywhere. Status colors (good / warn / bad) are separate from those.
@immutable
class SxColors extends ThemeExtension<SxColors> {
  const SxColors({
    required this.bg,
    required this.card,
    required this.cardAlt,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.cpu,
    required this.ram,
    required this.battery,
    required this.storage,
    required this.network,
    required this.thermal,
    required this.display,
    required this.camera,
    required this.sensors,
    required this.good,
    required this.warn,
    required this.bad,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
  });

  final Color bg;
  final Color card;
  final Color cardAlt;
  final Color ink;
  final Color muted;
  final Color line;
  final Color accent;
  final Color onAccent;

  final Color cpu;
  final Color ram;
  final Color battery;
  final Color storage;
  final Color network;
  final Color thermal;
  final Color display;
  final Color camera;
  final Color sensors;

  final Color good;
  final Color warn;
  final Color bad;

  /// Gradient used on feature cards (device hero, full checkup).
  final Color heroStart;
  final Color heroEnd;
  final Color onHero;

  static const dark = SxColors(
    bg: Color(0xFF0B0E17),
    card: Color(0xFF141928),
    cardAlt: Color(0xFF1B2133),
    ink: Color(0xFFECEEF8),
    muted: Color(0xFF8C93AE),
    line: Color(0xFF252B3E),
    accent: Color(0xFF5C8DFF),
    onAccent: Color(0xFF0B1020),
    cpu: Color(0xFFFF9447),
    ram: Color(0xFFA98BFF),
    battery: Color(0xFF3DD68C),
    storage: Color(0xFF5CA2FF),
    network: Color(0xFF33D1E5),
    thermal: Color(0xFFFF6B6F),
    display: Color(0xFFF2C94C),
    camera: Color(0xFFF28CC4),
    sensors: Color(0xFF7FD3A8),
    good: Color(0xFF3DD68C),
    warn: Color(0xFFFFB547),
    bad: Color(0xFFFF6B6F),
    heroStart: Color(0xFF1E3A7B),
    heroEnd: Color(0xFF141A2E),
    onHero: Color(0xFFCFDDFF),
  );

  static final amoled = dark.copyWith(
    bg: const Color(0xFF000000),
    card: const Color(0xFF0E1119),
    cardAlt: const Color(0xFF161A27),
    line: const Color(0xFF1E2333),
    heroEnd: const Color(0xFF0E1119),
  );

  static const light = SxColors(
    bg: Color(0xFFF5F6FB),
    card: Color(0xFFFFFFFF),
    cardAlt: Color(0xFFEEF0F8),
    ink: Color(0xFF161A2C),
    muted: Color(0xFF5E6584),
    line: Color(0xFFE3E5F0),
    accent: Color(0xFF2563EB),
    onAccent: Color(0xFFFFFFFF),
    cpu: Color(0xFFE8711F),
    ram: Color(0xFF8452F0),
    battery: Color(0xFF14965A),
    storage: Color(0xFF2B78E4),
    network: Color(0xFF0B9AAE),
    thermal: Color(0xFFDD3E45),
    display: Color(0xFFB98A0B),
    camera: Color(0xFFC2408A),
    sensors: Color(0xFF238A5A),
    good: Color(0xFF14965A),
    warn: Color(0xFFC27406),
    bad: Color(0xFFD23A41),
    heroStart: Color(0xFF2563EB),
    heroEnd: Color(0xFF1D4ED8),
    onHero: Color(0xFFDCE7FF),
  );

  @override
  SxColors copyWith({
    Color? bg,
    Color? card,
    Color? cardAlt,
    Color? ink,
    Color? muted,
    Color? line,
    Color? accent,
    Color? onAccent,
    Color? cpu,
    Color? ram,
    Color? battery,
    Color? storage,
    Color? network,
    Color? thermal,
    Color? display,
    Color? camera,
    Color? sensors,
    Color? good,
    Color? warn,
    Color? bad,
    Color? heroStart,
    Color? heroEnd,
    Color? onHero,
  }) {
    return SxColors(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      cardAlt: cardAlt ?? this.cardAlt,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      cpu: cpu ?? this.cpu,
      ram: ram ?? this.ram,
      battery: battery ?? this.battery,
      storage: storage ?? this.storage,
      network: network ?? this.network,
      thermal: thermal ?? this.thermal,
      display: display ?? this.display,
      camera: camera ?? this.camera,
      sensors: sensors ?? this.sensors,
      good: good ?? this.good,
      warn: warn ?? this.warn,
      bad: bad ?? this.bad,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      onHero: onHero ?? this.onHero,
    );
  }

  @override
  SxColors lerp(ThemeExtension<SxColors>? other, double t) {
    if (other is! SxColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SxColors(
      bg: l(bg, other.bg),
      card: l(card, other.card),
      cardAlt: l(cardAlt, other.cardAlt),
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      line: l(line, other.line),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      cpu: l(cpu, other.cpu),
      ram: l(ram, other.ram),
      battery: l(battery, other.battery),
      storage: l(storage, other.storage),
      network: l(network, other.network),
      thermal: l(thermal, other.thermal),
      display: l(display, other.display),
      camera: l(camera, other.camera),
      sensors: l(sensors, other.sensors),
      good: l(good, other.good),
      warn: l(warn, other.warn),
      bad: l(bad, other.bad),
      heroStart: l(heroStart, other.heroStart),
      heroEnd: l(heroEnd, other.heroEnd),
      onHero: l(onHero, other.onHero),
    );
  }
}

extension SxThemeX on BuildContext {
  SxColors get sx => Theme.of(this).extension<SxColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
}
