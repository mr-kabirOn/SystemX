import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../../ui/widgets/live_chart.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../device/device_data.dart';
import '../device/spec_sheets.dart';
import 'background.dart';

/// Battery capacity measured from recent charges.
class CapacityEstimate {
  const CapacityEstimate({this.mah, this.percentOfDesign, this.count = 0, this.trend = const []});

  /// Median of the most recent measurements.
  final int? mah;
  final int? percentOfDesign;

  /// Measurements behind [mah].
  final int count;

  /// Every measurement, oldest first, for the chart.
  final List<int> trend;
}

/// How many recent charges the estimate is based on. A median of several
/// smooths out one odd charge (a hot phone, a charger that throttled).
const capacityWindow = 5;

CapacityEstimate estimateCapacity(List<ChargeSession> sessions, double? designMah) {
  // Sessions arrive newest first.
  final caps = [for (final s in sessions) ?s.capacityMah];
  if (caps.isEmpty) return const CapacityEstimate();
  final recent = [...caps.take(capacityWindow)]..sort();
  final mid = recent.length ~/ 2;
  final median = recent.length.isOdd
      ? recent[mid]
      : ((recent[mid - 1] + recent[mid]) / 2).round();
  final pct = designMah != null && designMah > 0
      ? (median * 100 / designMah).round()
      : null;
  return CapacityEstimate(
    mah: median,
    percentOfDesign: pct,
    count: recent.length,
    trend: caps.reversed.toList(),
  );
}

/// Battery drain per hour with the screen on and off.
class DrainRates {
  const DrainRates({this.screenOn, this.standby, this.hoursOn = 0, this.hoursOff = 0});

  /// Percent per hour; null until there is at least [minDrainHours] of data.
  final double? screenOn;
  final double? standby;
  final double hoursOn;
  final double hoursOff;
}

const minDrainHours = 1.0;

/// Pairs consecutive samples taken on battery with the same screen state
/// and adds up the drop and the time between them. Gaps longer than 30
/// minutes are skipped: the state may have changed in between.
DrainRates drainRates(List<HistorySample> samples) {
  final sorted = [...samples]..sort((a, b) => a.timeMs.compareTo(b.timeMs));
  var dropOn = 0.0, dropOff = 0.0, msOn = 0, msOff = 0;
  for (var i = 1; i < sorted.length; i++) {
    final a = sorted[i - 1], b = sorted[i];
    final gap = b.timeMs - a.timeMs;
    if (a.charging || b.charging) continue;
    if (gap < 60000 || gap > 30 * 60000) continue;
    final on = a.screenOn;
    if (on == null || b.screenOn != on) continue;
    final drop = (a.level - b.level).toDouble();
    if (drop < 0) continue; // level went up: charged in between
    if (on) {
      dropOn += drop;
      msOn += gap;
    } else {
      dropOff += drop;
      msOff += gap;
    }
  }
  final hOn = msOn / 3600000, hOff = msOff / 3600000;
  return DrainRates(
    screenOn: hOn >= minDrainHours ? dropOn / hOn : null,
    standby: hOff >= minDrainHours ? dropOff / hOff : null,
    hoursOn: hOn,
    hoursOff: hOff,
  );
}

/// Battery health: measured capacity, its trend, and drain per hour.
class BatteryHealthScreen extends ConsumerWidget {
  const BatteryHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final battery = ref.watch(categorySnapshotProvider(DeviceCategory.battery)).value?.battery;
    final sessions = ref.watch(sessionsProvider).value ?? const <ChargeSession>[];
    final week = ref.watch(historyProvider(HistoryRange.week)).value ?? const <HistorySample>[];
    final est = estimateCapacity(sessions, battery?.designCapacityMah);
    final drain = drainRates(week);
    final noCounter = battery != null && battery.chargeCounterMah == null;

    final pct = est.percentOfDesign;
    final color = pct == null
        ? sx.battery
        : pct >= 80
            ? sx.good
            : pct >= 65
                ? sx.warn
                : sx.bad;
    final nf = NumberFormat.decimalPattern(l.localeName);

    return PageScaffold(
      title: l.bhTitle,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          child: Row(children: [
            GaugeRing(
              value: ((pct ?? 0) / 100).clamp(0, 1).toDouble(),
              color: color,
              size: 104,
              stroke: 11,
              child: Text(pct == null ? '–' : '$pct%', style: context.text.headlineSmall),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Eyebrow(l.bhCapacity, color: sx.battery),
                const SizedBox(height: 6),
                if (est.mah != null) ...[
                  Text('${nf.format(est.mah)} mAh', style: context.text.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    pct != null && battery?.designCapacityMah != null
                        ? l.bhOfDesign(pct, nf.format(battery!.designCapacityMah!.round()))
                        : l.bhNoDesign,
                    style: context.text.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(l.bhBasedOn(est.count), style: context.text.bodySmall),
                ] else
                  Text(
                    noCounter ? l.bhNoCounter : l.bhNotYet,
                    style: context.text.bodyMedium,
                  ),
              ]),
            ),
          ]),
        )),
        if (est.trend.length >= 2)
          Box(SxCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.bhTrend, style: context.text.titleMedium),
              const SizedBox(height: 10),
              LiveChart(
                series: [ChartSeries([for (final v in est.trend) v.toDouble()], sx.battery)],
                format: (v) => '${v.round()} mAh',
                height: 110,
              ),
            ]),
          )),
        Box(SxCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.bhDrain, style: context.text.titleMedium),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _Rate(label: l.bhScreenOn, rate: drain.screenOn, hours: drain.hoursOn)),
              const SizedBox(width: 12),
              Expanded(child: _Rate(label: l.bhStandby, rate: drain.standby, hours: drain.hoursOff)),
            ]),
            const SizedBox(height: 10),
            Text(l.bhDrainNote, style: context.text.bodySmall?.copyWith(color: sx.muted)),
          ]),
        )),
        if (battery != null)
          Box(SxCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InfoRow(label: l.specHealth, value: SpecBuilder(l).batteryHealth(battery.health)),
              if (battery.cycleCount != null)
                InfoRow(label: l.specCycleCount, value: '${battery.cycleCount}')
              else if (battery.trackedCycles != null)
                InfoRow(
                  label: l.specCycleCountTracked,
                  value: battery.trackedCycles!.toStringAsFixed(1),
                ),
              if (battery.designCapacityMah != null)
                InfoRow(
                  label: l.specDesignCapacity,
                  value: '${nf.format(battery.designCapacityMah!.round())} mAh',
                ),
            ]),
          )),
        Box(Text(l.bhHow, style: context.text.bodySmall?.copyWith(color: sx.muted)), bottom: 0),
      ],
    );
  }
}

class _Rate extends StatelessWidget {
  const _Rate({required this.label, required this.rate, required this.hours});

  final String label;
  final double? rate;
  final double hours;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sx.cardAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: context.text.labelMedium?.copyWith(color: sx.muted)),
        const SizedBox(height: 4),
        Text(
          rate == null ? l.bhCollecting : l.bhPerHour(formatDouble(rate!)),
          style: rate == null ? context.text.bodyMedium : context.text.titleMedium,
        ),
        const SizedBox(height: 2),
        Text(l.bhHours(formatDouble(hours)), style: context.text.bodySmall),
      ]),
    );
  }
}

/// Entry to the battery health screen (Monitor tab and the Battery sheet).
class BatteryHealthTile extends StatelessWidget {
  const BatteryHealthTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: IconBadge(SxIcons.battery, color: sx.battery, size: 36),
        title: Text(l.bhEntry),
        subtitle: Text(l.bhEntryBody),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push(Routes.batteryHealth),
      ),
    );
  }
}
