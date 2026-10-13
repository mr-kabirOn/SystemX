import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/permissions.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/logo_mark.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../background/background.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = PageController();
  int _index = 0;

  static const _count = 6;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
    if (mounted) context.go(Routes.home);
  }

  void _next() {
    if (_index == _count - 1) {
      _finish();
    } else {
      _pages.nextPage(
          duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final pages = <(Widget, String, String, Widget?)>[
      (LogoMark(size: 120, background: sx.bg, ink: sx.ink), l.onbWelcomeTitle, l.onbWelcomeBody, const _Preferences()),
      (const _RingsArt(), l.onb1Title, l.onb1Body, null),
      (const _UsedPhoneArt(), l.onbUsedTitle, l.onbUsedBody, null),
      (const _TestsArt(), l.onb2Title, l.onb2Body, null),
      (const _AlertsArt(), l.onbAlertsTitle, l.onbAlertsBody, const _AlertChoices()),
      (const _ShieldArt(), l.onb3Title, l.onb3Body, null),
    ];
    final last = _index == _count - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: AnimatedOpacity(
                opacity: last ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: TextButton(
                  onPressed: last ? null : _finish,
                  child: Text(l.onbSkip),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _count,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final (art, title, body, extra) = pages[i];
                return FillOrScroll(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  children: [
                    const Spacer(),
                    Center(child: art),
                    const Spacer(),
                    const SizedBox(height: 16),
                    Text(title, textAlign: TextAlign.center, style: context.text.headlineLarge),
                    const SizedBox(height: 12),
                    Text(body,
                        textAlign: TextAlign.center,
                        style: context.text.bodyLarge?.copyWith(color: sx.muted)),
                    if (extra != null) ...[const SizedBox(height: 20), extra],
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _count; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index ? sx.accent : sx.line,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _next,
                child: Text(last ? l.onbStart : l.onbNext),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Page 1 controls: language and appearance, applied as soon as chosen.
class _Preferences extends ConsumerWidget {
  const _Preferences();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final lang = s.localeCode ?? Localizations.localeOf(context).languageCode;

    Widget label(String t) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(t, style: context.text.labelLarge?.copyWith(color: sx.muted)),
        );

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      label(l.onbLanguage),
      SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(value: 'en', label: Text(l.langEnglish)),
          ButtonSegment(value: 'bn', label: Text(l.langBangla)),
        ],
        selected: {lang == 'bn' ? 'bn' : 'en'},
        onSelectionChanged: (v) => n.setLocale(v.first),
      ),
      const SizedBox(height: 16),
      label(l.onbAppearance),
      SegmentedButton<ThemeMode>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(value: ThemeMode.light, label: Text(l.themeLight), icon: const Icon(Icons.light_mode_rounded)),
          ButtonSegment(value: ThemeMode.dark, label: Text(l.themeDark), icon: const Icon(Icons.dark_mode_rounded)),
          ButtonSegment(value: ThemeMode.system, label: Text(l.themeSystem)),
        ],
        selected: {s.themeMode},
        onSelectionChanged: (v) => n.setThemeMode(v.first),
      ),
    ]);
  }
}

/// Alerts page controls. Both start off; turning one on asks for the
/// notification permission first, as in Settings.
class _AlertChoices extends ConsumerWidget {
  const _AlertChoices();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final c = ref.watch(backgroundConfigProvider).value;
    if (c == null) return const SizedBox.shrink();

    Future<void> set(bool on, BackgroundConfig Function(BackgroundConfig) edit) async {
      if (on && !await requestPermission(context, ref, AppPermission.notifications)) return;
      await ref.read(backgroundConfigProvider.notifier).change(edit);
    }

    return SxCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(children: [
        SwitchListTile(
          secondary: Icon(SxIcons.charging, color: sx.battery),
          title: Text(l.onbChargeAlarm),
          value: c.chargeAlarm,
          onChanged: (v) => set(v, (c) => copyConfig(c, chargeAlarm: v, chargeLimit: 80)),
        ),
        SwitchListTile(
          secondary: Icon(SxIcons.notifications, color: sx.accent),
          title: Text(l.onbLiveStatus),
          value: c.liveStatus,
          onChanged: (v) => set(v, (c) => copyConfig(c, liveStatus: v)),
        ),
      ]),
    );
  }
}

/// Used phone page: a phone with a verified badge.
class _UsedPhoneArt extends StatelessWidget {
  const _UsedPhoneArt();

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              sx.accent.withValues(alpha: 0.22),
              sx.accent.withValues(alpha: 0.0),
            ]),
          ),
        ),
        Container(
          width: 104,
          height: 176,
          decoration: BoxDecoration(
            color: sx.card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: sx.line, width: 2),
          ),
          padding: const EdgeInsets.fromLTRB(14, 22, 14, 14),
          child: Column(children: [
            for (final (icon, color) in [
              (SxIcons.battery, sx.battery),
              (SxIcons.security, sx.good),
              (SxIcons.touch, sx.accent),
            ]) ...[
              Row(children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(color: sx.cardAlt, borderRadius: BorderRadius.circular(99)),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
            ],
          ]),
        ),
        Positioned(
          right: 34,
          bottom: 22,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: sx.bg, shape: BoxShape.circle),
            child: Icon(SxIcons.passed, size: 52, color: sx.good),
          ),
        ),
      ]),
    );
  }
}

/// Alerts page: two notification cards.
class _AlertsArt extends StatelessWidget {
  const _AlertsArt();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    Widget note(IconData icon, Color color, String text) => SxCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(children: [
            IconBadge(icon, color: color, size: 34),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: context.text.titleSmall, maxLines: 2)),
          ]),
        );
    return SizedBox(
      width: 280,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        note(SxIcons.charging, sx.battery, l.onbArtCharged),
        const SizedBox(height: 10),
        note(SxIcons.thermal, sx.thermal, l.onbArtWarm),
      ]),
    );
  }
}

/// Page 1: nested gauges in the metric colors.
class _RingsArt extends StatelessWidget {
  const _RingsArt();

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return Stack(alignment: Alignment.center, children: [
      GaugeRing(value: 0.82, color: sx.battery, size: 240, stroke: 14),
      GaugeRing(value: 0.64, color: sx.ram, size: 196, stroke: 14),
      GaugeRing(value: 0.48, color: sx.cpu, size: 152, stroke: 14),
      GaugeRing(value: 0.7, color: sx.network, size: 108, stroke: 14),
      Icon(SxIcons.device, size: 38, color: sx.ink),
    ]);
  }
}

/// Page 2: a 3×3 board of tests with results.
class _TestsArt extends StatelessWidget {
  const _TestsArt();

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    final items = [
      (SxIcons.brightness, sx.display),
      (SxIcons.touch, sx.accent),
      (SxIcons.speaker, sx.network),
      (SxIcons.mic, sx.ram),
      (SxIcons.camera, sx.camera),
      (SxIcons.vibration, sx.cpu),
      (SxIcons.sensors, sx.sensors),
      (SxIcons.fingerprint, sx.accent),
      (SxIcons.charging, sx.battery),
    ];
    return SizedBox(
      width: 252,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final (i, it) in items.indexed)
            SizedBox.square(
              dimension: 76,
              child: Stack(clipBehavior: Clip.none, children: [
                Positioned.fill(
                  child: SxCard(
                    padding: EdgeInsets.zero,
                    child: Center(child: IconBadge(it.$1, color: it.$2, size: 46)),
                  ),
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: i == 4 ? sx.muted : sx.good,
                    child: Icon(i == 4 ? Icons.more_horiz : Icons.check_rounded,
                        size: 13, color: sx.bg),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}

/// Page 3: shield with a soft halo.
class _ShieldArt extends StatelessWidget {
  const _ShieldArt();

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [
          sx.good.withValues(alpha: 0.28),
          sx.good.withValues(alpha: 0.0),
        ]),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: sx.card,
            shape: BoxShape.circle,
            border: Border.all(color: sx.good.withValues(alpha: 0.5), width: 2),
          ),
          child: Icon(Icons.verified_user_rounded, size: 58, color: sx.good),
        ),
      ),
    );
  }
}
