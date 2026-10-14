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
import '../../ui/widgets/page_scaffold.dart';
import '../device/device_data.dart';
import '../device/spec_sheets.dart';
import 'background.dart';

/// How sure the capacity estimate is, from how many charges back it and how
/// closely they agree.
enum Confidence { insufficient, low, medium, high }

/// Health band from the estimate; [insufficient] until there are enough
/// measurements to say.
enum HealthBand { insufficient, good, fair, poor }

/// Battery capacity measured from recent charges.
class CapacityEstimate {
  const CapacityEstimate({
    this.mah,
    this.minMah,
    this.maxMah,
    this.percentOfDesign,
    this.count = 0,
    this.confidence = Confidence.insufficient,
    this.points = const [],
  });

  /// Median of the most recent measurements (raw, never capped).
  final int? mah;

  /// Lowest and highest of those measurements.
  final int? minMah;
  final int? maxMah;

  /// [mah] against the design capacity, raw (can exceed 100).
  final int? percentOfDesign;

  /// The user-facing health percentage: [percentOfDesign] capped at 100,
  /// since a battery can't hold more than it was designed for and readings
  /// above that are measurement variation. The raw ratio stays available.
  int? get healthPercent => percentOfDesign == null ? null : (percentOfDesign! > 100 ? 100 : percentOfDesign);

  /// Measurements behind [mah].
  final int count;
  final Confidence confidence;

  /// Every measurement with the time its charge started, oldest first.
  final List<(DateTime, int)> points;

  HealthBand get band {
    final p = percentOfDesign;
    if (p == null || confidence == Confidence.insufficient) return HealthBand.insufficient;
    if (p >= 80) return HealthBand.good;
    if (p >= 65) return HealthBand.fair;
    return HealthBand.poor;
  }
}

/// How many recent charges the estimate is based on. A median of several
/// smooths out one odd charge (a hot phone, a charger that throttled).
const capacityWindow = 5;

/// Charges needed before a health band is shown.
const minCapacityCharges = 3;

/// Median of the last [capacityWindow] measured charges. Confidence:
/// high with 5 charges within 8% of each other, medium with 3 within 15%,
/// low otherwise; insufficient below [minCapacityCharges].
CapacityEstimate estimateCapacity(List<ChargeSession> sessions, double? designMah) {
  // Sessions arrive newest first.
  final measured = [
    for (final s in sessions)
      if (s.capacityMah case final c?) (DateTime.fromMillisecondsSinceEpoch(s.startMs), c),
  ];
  if (measured.isEmpty) return const CapacityEstimate();
  final recent = [for (final m in measured.take(capacityWindow)) m.$2]..sort();
  final mid = recent.length ~/ 2;
  final median = recent.length.isOdd ? recent[mid] : ((recent[mid - 1] + recent[mid]) / 2).round();
  final spread = (recent.last - recent.first) / median;
  final confidence = recent.length < minCapacityCharges
      ? Confidence.insufficient
      : recent.length >= capacityWindow && spread <= 0.08
          ? Confidence.high
          : spread <= 0.15
              ? Confidence.medium
              : Confidence.low;
  final pct = designMah != null && designMah > 0 ? (median * 100 / designMah).round() : null;
  return CapacityEstimate(
    mah: median,
    minMah: recent.first,
    maxMah: recent.last,
    percentOfDesign: pct,
    count: recent.length,
    confidence: confidence,
    points: measured.reversed.toList(),
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
    final design = battery?.designCapacityMah;
    final est = estimateCapacity(sessions, design);
    final drain = drainRates(week);
    final noCounter = battery != null && battery.chargeCounterMah == null;
    final nf = NumberFormat.decimalPattern(l.localeName);

    final band = est.band;
    final pct = est.percentOfDesign;
    final color = switch (band) {
      HealthBand.good => sx.good,
      HealthBand.fair => sx.warn,
      HealthBand.poor => sx.bad,
      HealthBand.insufficient => sx.muted,
    };
    // One display rule: the ring shows health (ratio capped at 100%); the
    // raw ratio appears once, labelled as estimated.
    final health = est.healthPercent;
    final ringText = band == HealthBand.insufficient || health == null ? '–' : '$health%';
    final bandText = switch (band) {
      HealthBand.good => l.bhGood,
      HealthBand.fair => l.bhFair,
      HealthBand.poor => l.bhPoor,
      HealthBand.insufficient => l.bhInsufficient,
    };
    final confidenceText = switch (est.confidence) {
      Confidence.high => l.bhConfHigh,
      Confidence.medium => l.bhConfMedium,
      Confidence.low => l.bhConfLow,
      Confidence.insufficient => l.bhCollectingCharges(est.count, minCapacityCharges),
    };

    return PageScaffold(
      title: l.bhTitle,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              GaugeRing(
                value: band == HealthBand.insufficient ? 0 : (health ?? 0) / 100,
                color: color,
                size: 104,
                stroke: 11,
                child: Text(ringText, style: context.text.titleLarge),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Flexible(child: Eyebrow(l.bhEstimatedCapacity, color: sx.battery)),
                  ]),
                  const SizedBox(height: 6),
                  if (est.mah != null) ...[
                    Text('${nf.format(est.mah)} mAh', style: context.text.titleLarge),
                    if (est.count >= 2 && est.minMah != est.maxMah)
                      Text(l.bhRange(nf.format(est.minMah), nf.format(est.maxMah)),
                          style: context.text.bodySmall),
                    const SizedBox(height: 6),
                    StatusChip(bandText, color: color),
                  ] else
                    Text(noCounter ? l.bhNoCounter : l.bhNotYet, style: context.text.bodyMedium),
                ]),
              ),
            ]),
            if (est.mah != null) ...[
              const SizedBox(height: 14),
              InfoRow(
                label: l.bhDesignCapacity,
                value: design == null ? l.notAvailable : '${nf.format(design.round())} mAh',
              ),
              if (pct != null && design != null)
                InfoRow(label: l.bhOfOriginal, value: pct > 100 ? l.bhAtOriginal : l.bhEstimatedPct(pct)),
              InfoRow(label: l.bhConfidence, value: confidenceText, hint: l.bhBasedOn(est.count)),
              if (pct != null && pct > 100) ...[
                const SizedBox(height: 4),
                Text(l.bhOver100, style: context.text.bodySmall?.copyWith(color: sx.muted)),
              ],
            ],
          ]),
        )),
        if (est.points.length >= 2)
          Box(SxCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.bhTrend, style: context.text.titleMedium),
              const SizedBox(height: 4),
              Text(l.bhTrendSub, style: context.text.bodySmall?.copyWith(color: sx.muted)),
              const SizedBox(height: 12),
              _CapacityChart(points: est.points, designMah: design),
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
              InfoRow(
                label: l.bhAndroidHealth,
                value: SpecBuilder(l).batteryHealth(battery.health),
                hint: l.bhAndroidHealthHint,
              ),
              if (battery.cycleCount != null)
                InfoRow(label: l.specCycleCount, value: '${battery.cycleCount}', hint: l.cycleHint)
              else if (battery.trackedCycles != null && battery.trackedSinceMs != null)
                InfoRow(
                  label: l.bhCyclesCounted,
                  value: battery.trackedCycles!.toStringAsFixed(1),
                  hint: l.bhCyclesCountedHint(formatDate(
                    DateTime.fromMillisecondsSinceEpoch(battery.trackedSinceMs!),
                    l.localeName,
                  )),
                ),
            ]),
          )),
        Box(Text(l.bhHow, style: context.text.bodySmall?.copyWith(color: sx.muted)), bottom: 0),
      ],
    );
  }
}

/// Each measured charge as a dot at its date, on a fixed scale with the
/// design capacity as a dashed line, so one odd reading doesn't look like
/// a dramatic trend.
class _CapacityChart extends StatelessWidget {
  const _CapacityChart({required this.points, this.designMah});

  final List<(DateTime, int)> points;
  final double? designMah;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final values = points.map((p) => p.$2.toDouble());
    final ref = designMah ?? values.reduce((a, b) => a + b) / points.length;
    final lo = [ref * 0.7, ...values].reduce((a, b) => a < b ? a : b);
    final hi = [ref * 1.1, ...values].reduce((a, b) => a > b ? a : b);
    final date = DateFormat.MMMd(l.localeName);
    return Column(children: [
      SizedBox(
        height: 130,
        child: CustomPaint(
          size: Size.infinite,
          painter: _CapacityPainter(
            values: values.toList(),
            lo: lo,
            hi: hi,
            design: designMah,
            dot: sx.battery,
            line: sx.muted,
            grid: sx.line,
          ),
        ),
      ),
      const SizedBox(height: 6),
      Row(children: [
        Text(date.format(points.first.$1), style: context.text.labelSmall?.copyWith(color: sx.muted)),
        const Spacer(),
        if (designMah != null) ...[
          Container(width: 14, height: 2, color: sx.muted),
          const SizedBox(width: 6),
          Text(l.bhDesignLine, style: context.text.labelSmall?.copyWith(color: sx.muted)),
          const Spacer(),
        ],
        Text(date.format(points.last.$1), style: context.text.labelSmall?.copyWith(color: sx.muted)),
      ]),
    ]);
  }
}

class _CapacityPainter extends CustomPainter {
  _CapacityPainter({
    required this.values,
    required this.lo,
    required this.hi,
    required this.design,
    required this.dot,
    required this.line,
    required this.grid,
  });

  final List<double> values;
  final double lo, hi;
  final double? design;
  final Color dot, line, grid;

  @override
  void paint(Canvas canvas, Size size) {
    double y(double v) => size.height - (v - lo) / (hi - lo) * size.height;
    final g = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final yy = size.height * i / 4;
      canvas.drawLine(Offset(0, yy), Offset(size.width, yy), g);
    }
    if (design != null) {
      final dy = y(design!);
      final dash = Paint()
        ..color = line
        ..strokeWidth = 1.5;
      for (var x = 0.0; x < size.width; x += 10) {
        canvas.drawLine(Offset(x, dy), Offset((x + 5).clamp(0, size.width), dy), dash);
      }
    }
    final n = values.length;
    final pts = [
      for (var i = 0; i < n; i++)
        Offset(n == 1 ? size.width / 2 : 8 + (size.width - 16) * i / (n - 1), y(values[i])),
    ];
    final link = Paint()
      ..color = dot.withValues(alpha: 0.35)
      ..strokeWidth = 1.5;
    for (var i = 1; i < pts.length; i++) {
      canvas.drawLine(pts[i - 1], pts[i], link);
    }
    final fill = Paint()..color = dot;
    for (final p in pts) {
      canvas.drawCircle(p, 4.5, fill);
    }
  }

  @override
  bool shouldRepaint(_CapacityPainter old) => old.values != values || old.design != design;
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
        Text(
          [
            l.bhHours(formatDouble(hours)),
            if (rate != null && hours < 3) l.bhLowConfidence,
          ].join(' · '),
          style: context.text.bodySmall,
        ),
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
