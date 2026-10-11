import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = PageController();
  int _index = 0;

  static const _count = 3;

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
    final pages = [
      (const _RingsArt(), l.onb1Title, l.onb1Body),
      (const _TestsArt(), l.onb2Title, l.onb2Body),
      (const _ShieldArt(), l.onb3Title, l.onb3Body),
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
                final p = pages[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Expanded(child: Center(child: p.$1)),
                      Text(p.$2,
                          textAlign: TextAlign.center,
                          style: context.text.headlineLarge),
                      const SizedBox(height: 12),
                      Text(p.$3,
                          textAlign: TextAlign.center,
                          style: context.text.bodyLarge?.copyWith(color: sx.muted)),
                      const SizedBox(height: 24),
                    ],
                  ),
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
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          for (final (i, it) in items.indexed)
            Stack(clipBehavior: Clip.none, children: [
              SxCard(
                padding: EdgeInsets.zero,
                child: Center(child: IconBadge(it.$1, color: it.$2, size: 46)),
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
