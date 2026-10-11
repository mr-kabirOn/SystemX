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
import '../device/device_data.dart';
import '../device/spec_view.dart';
import '../live/health.dart';
import '../live/live_data.dart';
import '../live/live_screens.dart';

/// Words for a health score.
String scoreWord(AppLocalizations l, int score) => score >= 90
    ? l.healthExcellent
    : score >= 75
        ? l.scoreGood
        : score >= 50
            ? l.scoreFair
            : l.scorePoor;

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
    final live = ref.watch(liveProvider);
    final snap = ref.watch(fullSnapshotProvider).value;
    final s = live.latest;

    final score = healthScore(
      battery: snap?.battery,
      storage: snap?.storage,
      live: s,
    );
    final tip = pickTips(
      live: s,
      storage: snap?.storage,
      security: snap?.security,
    ).first;

    final memUsed = s == null ? 0 : s.memTotal - s.memAvailable;
    final storage = snap?.storage;
    final storageUsed = storage == null ? 0 : storage.total - storage.free;
    final load = live.cpuLoad.isEmpty ? null : live.cpuLoad.last;
    final ma = s?.currentNowMa;
    final headroom = live.headroom;

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
                    Text(snap?.identity?.marketName ?? l.homeYourPhone,
                        style: context.text.headlineMedium),
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

            // Health score
            SxCard(
              padding: const EdgeInsets.all(18),
              onTap: score == null ? null : () => _showScore(context, score),
              child: Row(children: [
                GaugeRing(
                  value: (score?.score ?? 0) / 100,
                  color: _scoreColor(sx, score?.score),
                  size: 104,
                  stroke: 11,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(score == null ? '–' : '${score.score}',
                        style: context.text.displaySmall),
                    Eyebrow(l.healthScoreLabel),
                  ]),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(score == null ? l.homeYourPhone : scoreWord(l, score.score),
                          style: context.text.titleLarge),
                      const SizedBox(height: 4),
                      Text(l.noCheckupYet, style: context.text.bodySmall),
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
                value: s == null ? '–' : avgGhz(s.cpuKhz).toStringAsFixed(2),
                unit: 'GHz',
                color: sx.cpu,
                sub: load == null ? null : '${l.loadEstimate} ${(load * 100).round()}%',
                visual: Sparkline(values: live.cpuGhz, color: sx.cpu),
                onTap: () => context.push(Routes.live(LiveMetric.cpu)),
              ),
              right: StatTile(
                label: l.metricMemory,
                value: s == null ? '–' : formatDouble(memUsed / (1 << 30)),
                unit: s == null ? null : '/ ${formatAdvertisedRam(s.memTotal)}',
                color: sx.ram,
                sub: s == null ? null : l.freeAmount(formatBytes(s.memAvailable)),
                visual: MeterBar(
                    value: s == null || s.memTotal == 0 ? 0 : memUsed / s.memTotal,
                    color: sx.ram),
                onTap: () => context.push(Routes.category(DeviceCategory.memory)),
              ),
            ),
            _TileRow(
              left: StatTile(
                label: l.metricBattery,
                value: s == null ? '–' : '${s.batteryLevel}',
                unit: '%',
                color: sx.battery,
                sub: s == null
                    ? null
                    : [
                        formatTemp(s.batteryTempC, unit),
                        if (ma != null && ma > 0)
                          '${formatDouble(ma * s.voltageMv / 1e6)} W',
                      ].join(' · '),
                visual: MeterBar(value: (s?.batteryLevel ?? 0) / 100, color: sx.battery),
                onTap: () => context.push(Routes.live(LiveMetric.battery)),
              ),
              right: StatTile(
                label: l.metricStorage,
                value: storage == null ? '–' : formatStorage(storageUsed).split(' ').first,
                unit: storage == null ? null : '/ ${formatStorage(storage.total)}',
                color: sx.storage,
                sub: storage == null ? null : l.freeAmount(formatStorage(storage.free)),
                visual: MeterBar(
                    value: storage == null || storage.total == 0
                        ? 0
                        : storageUsed / storage.total,
                    color: sx.storage),
                onTap: () => context.push(Routes.category(DeviceCategory.storage)),
              ),
            ),
            _TileRow(
              left: StatTile(
                label: l.metricNetwork,
                value: '↓ ${formatRate(live.downBps)}',
                color: sx.network,
                sub: '↑ ${formatRate(live.upBps)}',
                visual: Sparkline(values: live.down, color: sx.network),
                onTap: () => context.push(Routes.live(LiveMetric.network)),
              ),
              right: StatTile(
                label: l.metricThermal,
                value: s == null ? '–' : thermalStatusName(l, s.thermalStatus),
                color: sx.thermal,
                sub: headroom == null
                    ? (s == null ? null : formatTemp(s.batteryTempC, unit))
                    : l.headroom(headroomPercent(headroom)),
                visual: MeterBar(value: headroom?.clamp(0.0, 1.0) ?? 0, color: sx.thermal),
                onTap: () => context.push(Routes.live(LiveMetric.thermal)),
              ),
            ),

            // One tip at a time, most urgent first.
            _TipCard(tip: tip),
          ],
        ),
      ),
    );
  }

  static Color _scoreColor(SxColors sx, int? score) => score == null
      ? sx.muted
      : score >= 75
          ? sx.good
          : score >= 50
              ? sx.warn
              : sx.bad;

  void _showScore(BuildContext context, HealthScore score) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final l = AppLocalizations.of(context);
        final sx = context.sx;
        String name(HealthFactor f) => switch (f) {
              HealthFactor.battery => l.factorBattery,
              HealthFactor.temperature => l.factorTemperature,
              HealthFactor.storage => l.factorStorage,
              HealthFactor.memory => l.factorMemory,
              HealthFactor.checkup => l.factorCheckup,
            };
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.scoreHow, style: context.text.headlineSmall),
                const SizedBox(height: 8),
                Text(l.scoreExplain, style: context.text.bodyMedium),
                const SizedBox(height: 16),
                for (final p in score.parts) ...[
                  Row(children: [
                    Expanded(child: Text(name(p.factor), style: context.text.titleSmall)),
                    Text(l.weightN(p.weight), style: context.text.bodySmall),
                    const SizedBox(width: 12),
                    Text('${(p.value * 100).round()}',
                        style: SxText.readout(14, _scoreColor(sx, (p.value * 100).round()))),
                  ]),
                  const SizedBox(height: 6),
                  MeterBar(value: p.value, color: _scoreColor(sx, (p.value * 100).round())),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TipCard extends ConsumerWidget {
  const _TipCard({required this.tip});

  final Tip tip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final v = tip.value;
    final (icon, color, text) = switch (tip.kind) {
      TipKind.batteryHot => (SxIcons.thermal, sx.thermal,
          l.tipBatteryHot(formatTemp((v ?? 0).toDouble(), unit))),
      TipKind.storageLow => (SxIcons.storage, sx.storage, l.tipStorageLow(v?.toInt() ?? 0)),
      TipKind.noScreenLock => (SxIcons.security, sx.bad, l.tipNoScreenLock),
      TipKind.patchOld => (SxIcons.system, sx.warn, l.tipPatchOld(v?.toInt() ?? 0)),
      TipKind.memoryLow => (SxIcons.ram, sx.ram, l.tipMemoryLow),
      TipKind.unplug => (SxIcons.charging, sx.battery, l.tipUnplug(v?.toInt() ?? 0)),
      TipKind.chargeHabit => (SxIcons.battery, sx.battery, l.tipChargeLimit),
    };
    final action = tip.settingsAction;
    return SxCard(
      color: sx.cardAlt,
      padding: EdgeInsets.fromLTRB(14, 12, action == null ? 14 : 8, 12),
      child: Row(children: [
        IconBadge(icon, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: context.text.bodyMedium)),
        if (action != null)
          TextButton(
            onPressed: () => openSystemSettings(context, ref, action),
            child: Text(l.tipOpen),
          ),
      ]),
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
