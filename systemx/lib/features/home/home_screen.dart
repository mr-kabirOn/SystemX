import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';

/// Sample readings for the Stage 1 preview. Replaced by live data in Stage 3.
abstract final class _Sample {
  static const cpuGhz = [1.2, 1.5, 1.35, 1.9, 1.6, 2.1, 1.7, 1.95, 1.55, 2.05, 1.82];
  static const netMbs = [0.4, 0.9, 2.8, 2.2, 1.1, 3.1, 2.6, 1.8, 2.9, 2.2, 2.4];
  static const batteryC = 31.4;
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting(AppLocalizations l) {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return l.greetingMorning;
    if (h >= 12 && h < 17) return l.greetingAfternoon;
    return l.greetingEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            // Header
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_greeting(l), style: context.text.bodyMedium?.copyWith(color: sx.muted)),
                    const SizedBox(height: 2),
                    Text(l.homeYourPhone, style: context.text.headlineMedium),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: l.settingsTitle,
                style: IconButton.styleFrom(backgroundColor: sx.card),
                onPressed: () => context.push(Routes.settings),
                icon: Icon(Icons.settings_outlined, color: sx.ink),
              ),
            ]),
            const SizedBox(height: 14),
            _PreviewBanner(text: l.previewBanner),
            const SizedBox(height: 12),

            // Health score
            SxCard(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                GaugeRing(
                  value: 0.92,
                  color: sx.good,
                  size: 104,
                  stroke: 11,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('92', style: context.text.displaySmall),
                    Eyebrow(l.healthScoreLabel),
                  ]),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.healthExcellent, style: context.text.titleLarge),
                      const SizedBox(height: 4),
                      Text(l.healthSample(30, 32), style: context.text.bodySmall),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 42),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () => context.go(Routes.tests),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: Text(l.runCheckup),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12),

            // Live tiles
            _TileRow(
              left: StatTile(
                label: l.metricCpu,
                value: '1.82',
                unit: 'GHz',
                color: sx.cpu,
                sub: '8 cores',
                visual: Sparkline(values: _Sample.cpuGhz, color: sx.cpu),
                onTap: () => showComingSoon(context),
              ),
              right: StatTile(
                label: l.metricMemory,
                value: '5.1',
                unit: '/ 8 GB',
                color: sx.ram,
                sub: l.freeAmount(formatBytes(2.9 * 1024 * 1024 * 1024)),
                visual: MeterBar(value: 0.64, color: sx.ram),
                onTap: () => showComingSoon(context),
              ),
            ),
            _TileRow(
              left: StatTile(
                label: l.metricBattery,
                value: '78',
                unit: '%',
                color: sx.battery,
                sub: formatTemp(_Sample.batteryC, unit),
                visual: MeterBar(value: 0.78, color: sx.battery),
                onTap: () => showComingSoon(context),
              ),
              right: StatTile(
                label: l.metricStorage,
                value: '87',
                unit: '/ 128 GB',
                color: sx.storage,
                sub: l.freeAmount('41 GB'),
                visual: MeterBar(value: 0.68, color: sx.storage),
                onTap: () => showComingSoon(context),
              ),
            ),
            _TileRow(
              left: StatTile(
                label: l.metricNetwork,
                value: '2.4',
                unit: 'MB/s',
                color: sx.network,
                sub: '↑ 180 KB/s · Wi-Fi 6',
                visual: Sparkline(values: _Sample.netMbs, color: sx.network),
                onTap: () => showComingSoon(context),
              ),
              right: StatTile(
                label: l.metricThermal,
                value: l.thermalNormal,
                color: sx.thermal,
                sub: l.headroom(64),
                visual: MeterBar(value: 0.36, color: sx.thermal),
                onTap: () => showComingSoon(context),
              ),
            ),

            // Tip
            SxCard(
              color: sx.cardAlt,
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(children: [
                IconBadge(SxIcons.battery, color: sx.battery),
                const SizedBox(width: 12),
                Expanded(child: Text(l.tipChargeLimit, style: context.text.bodyMedium)),
                TextButton(
                  onPressed: () => showComingSoon(context),
                  child: Text(l.tipSetAlarm),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two tiles side by side with equal height.
class _TileRow extends StatelessWidget {
  const _TileRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: left),
              const SizedBox(width: 10),
              Expanded(child: right),
            ],
          ),
        ),
      );
}

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: sx.warn.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(Icons.science_outlined, size: 18, color: sx.warn),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: sxStyle(SxFonts.body, 12.5, FontWeight.w500, color: sx.warn)),
        ),
      ]),
    );
  }
}
