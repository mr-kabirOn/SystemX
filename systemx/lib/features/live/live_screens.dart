import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../../ui/widgets/live_chart.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../device/device_data.dart';
import '../device/spec_sheets.dart';
import '../device/spec_view.dart';
import '../device/specs.dart';
import 'live_data.dart';

/// Live detail screens opened from the dashboard tiles and Monitor charts.
enum LiveMetric { cpu, battery, network, thermal }

/// PowerManager.THERMAL_STATUS_* as words.
String thermalStatusName(AppLocalizations l, int status) => switch (status) {
      0 => l.thermalNormal,
      1 => l.thermalLight,
      2 => l.thermalModerate,
      3 => l.thermalSevere,
      4 => l.thermalCritical,
      5 => l.thermalEmergency,
      6 => l.thermalShutdown,
      _ => l.unknown,
    };

/// Headroom left before throttling, 0–100 (the API reports 1.0 at severe).
int headroomPercent(double headroom) =>
    ((1 - headroom) * 100).round().clamp(0, 100);

class LiveDetailScreen extends ConsumerWidget {
  const LiveDetailScreen({super.key, required this.metric});

  final LiveMetric metric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final live = ref.watch(liveProvider);
    final (title, color) = switch (metric) {
      LiveMetric.cpu => (l.catProcessor, sx.cpu),
      LiveMetric.battery => (l.catBattery, sx.battery),
      LiveMetric.network => (l.catNetwork, sx.network),
      LiveMetric.thermal => (l.metricThermal, sx.thermal),
    };

    return PageScaffold(
      title: title,
      leading: const BackButton(),
      actions: [
        IconButton(
          tooltip: live.paused ? l.resume : l.pause,
          icon: Icon(live.paused ? Icons.play_arrow_rounded : Icons.pause_rounded),
          onPressed: () =>
              ref.read(liveProvider.notifier).setPaused(!live.paused),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Center(
            child: StatusChip(live.paused ? l.paused : l.live,
                color: live.paused ? sx.muted : color, icon: Icons.circle),
          ),
        ),
      ],
      slivers: [
        if (live.latest == null)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 48),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else
          ...switch (metric) {
            LiveMetric.cpu => _cpu(context, ref, live),
            LiveMetric.battery => _battery(context, ref, live),
            LiveMetric.network => _network(context, ref, live),
            LiveMetric.thermal => _thermal(context, ref, live),
          },
      ],
    );
  }

  List<Widget> _cpu(BuildContext context, WidgetRef ref, LiveState live) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final s = live.latest!;
    final cpu = ref.watch(categorySnapshotProvider(DeviceCategory.processor)).value?.cpu;
    final load = live.cpuLoad.isEmpty ? 0.0 : live.cpuLoad.last;
    return [
      Box(SxCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (cpu != null) ...[
            Eyebrow(SpecBuilder.chipName(cpu) ?? '', color: sx.cpu),
            const SizedBox(height: 8),
          ],
          Wrap(spacing: 28, runSpacing: 12, children: [
            _Readout(avgGhz(s.cpuKhz).toStringAsFixed(2), 'GHz', l.avgClock),
            _Readout('${(load * 100).round()}', '%', l.loadEstimate),
          ]),
          const SizedBox(height: 16),
          _CoreGrid(cur: s.cpuKhz, max: s.cpuMaxKhz, parts: cpu?.coreList.map((c) => c.partName).toList()),
          const SizedBox(height: 16),
          Eyebrow(l.chartClockLast60),
          const SizedBox(height: 8),
          LiveChart(
            series: [ChartSeries(live.cpuGhz, sx.cpu)],
            format: (v) => '${v.toStringAsFixed(2)} GHz',
            minY: 0,
            semanticLabel: l.chartClockLast60,
          ),
          const SizedBox(height: 10),
          Text(l.loadEstimateHint, style: context.text.bodySmall),
        ]),
      )),
      ..._specs(context, ref, DeviceCategory.processor, skipTitles: {l.secCores}),
    ];
  }

  List<Widget> _battery(BuildContext context, WidgetRef ref, LiveState live) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final s = live.latest!;
    final b = SpecBuilder(l);
    final ma = s.currentNowMa;
    final watts = ma == null ? null : ma.abs() * s.voltageMv / 1e6;
    return [
      Box(SxCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            GaugeRing(
              value: s.batteryLevel / 100,
              color: sx.battery,
              size: 104,
              stroke: 11,
              child: Text('${s.batteryLevel}%', style: context.text.headlineSmall),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.batteryStatus(s.batteryStatus), style: context.text.titleLarge),
                const SizedBox(height: 4),
                if (ma != null)
                  Text('${ma > 0 ? '+' : ''}$ma mA · ${formatDouble(watts!)} W',
                      style: SxText.readout(16, sx.ink)),
                const SizedBox(height: 4),
                Text('${b.powerSource(s.plugged)} · ${formatTemp(s.batteryTempC, unit)}',
                    style: context.text.bodySmall),
              ]),
            ),
          ]),
          const SizedBox(height: 18),
          Eyebrow(l.chartCurrent),
          const SizedBox(height: 8),
          if (live.batteryMa.isEmpty)
            Text(l.currentUnavailable, style: context.text.bodySmall)
          else
            LiveChart(
              series: [ChartSeries(live.batteryMa, sx.battery)],
              format: (v) => '${v.round()} mA',
              semanticLabel: l.chartCurrent,
            ),
          const SizedBox(height: 16),
          Eyebrow(l.chartTemperature),
          const SizedBox(height: 8),
          LiveChart(
            height: 100,
            series: [ChartSeries(live.batteryTemp, sx.thermal)],
            format: (v) => formatTemp(v, unit),
            semanticLabel: l.chartTemperature,
          ),
        ]),
      )),
      ..._specs(context, ref, DeviceCategory.battery),
    ];
  }

  List<Widget> _network(BuildContext context, WidgetRef ref, LiveState live) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return [
      Box(SxCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: _Readout('↓ ${formatRate(live.downBps)}', '', l.download)),
            Expanded(child: _Readout('↑ ${formatRate(live.upBps)}', '', l.upload)),
          ]),
          const SizedBox(height: 16),
          Eyebrow(l.chartNetwork),
          const SizedBox(height: 8),
          LiveChart(
            series: [
              ChartSeries(live.down, sx.network, label: '↓'),
              ChartSeries(live.up, sx.accent, label: '↑'),
            ],
            format: formatRate,
            minY: 0,
            semanticLabel: l.chartNetwork,
          ),
          const SizedBox(height: 10),
          Text(l.networkSpeedHint, style: context.text.bodySmall),
        ]),
      )),
      ..._specs(context, ref, DeviceCategory.network),
    ];
  }

  List<Widget> _thermal(BuildContext context, WidgetRef ref, LiveState live) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final s = live.latest!;
    final headroom = live.headroom;
    return [
      Box(SxCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 28, runSpacing: 12, children: [
            _Readout(thermalStatusName(l, s.thermalStatus), '', l.thermalStatus),
            if (headroom != null)
              _Readout('${headroomPercent(headroom)}', '%', l.thermalHeadroom),
          ]),
          if (headroom != null) ...[
            const SizedBox(height: 12),
            MeterBar(value: headroom.clamp(0.0, 1.0), color: sx.thermal),
          ],
          const SizedBox(height: 18),
          Eyebrow(l.chartBatteryTemp),
          const SizedBox(height: 8),
          LiveChart(
            height: 110,
            series: [ChartSeries(live.batteryTemp, sx.thermal)],
            format: (v) => formatTemp(v, unit),
            semanticLabel: l.chartBatteryTemp,
          ),
          const SizedBox(height: 16),
          Eyebrow(l.chartCpuTemp),
          const SizedBox(height: 8),
          if (live.cpuTemp.isEmpty)
            Text(l.cpuTempUnavailable, style: context.text.bodySmall)
          else
            LiveChart(
              height: 110,
              series: [ChartSeries(live.cpuTemp, sx.cpu)],
              format: (v) => formatTemp(v, unit),
              semanticLabel: l.chartCpuTemp,
            ),
          const SizedBox(height: 10),
          Text(l.thermalHint, style: context.text.bodySmall),
        ]),
      )),
    ];
  }

  /// The category's spec sheet under the live charts.
  List<Widget> _specs(BuildContext context, WidgetRef ref, DeviceCategory c,
      {Set<String> skipTitles = const {}}) {
    final l = AppLocalizations.of(context);
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final snap = ref.watch(categorySnapshotProvider(c)).value;
    if (snap == null) return const [];
    final sections = SpecBuilder(l, tempUnit: unit)
        .build(c, snap)
        .where((s) => !skipTitles.contains(s.title))
        .toList();
    return [
      SliverToBoxAdapter(child: SectionLabel(l.details)),
      SpecSections(
        sections: sections,
        onAction: (a) {
          if (a is OpenSettings) openSystemSettings(context, ref, a.action);
        },
      ),
    ];
  }
}

class _Readout extends StatelessWidget {
  const _Readout(this.value, this.unit, this.label);

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text.rich(TextSpan(children: [
        TextSpan(text: value, style: SxText.readout(26, sx.ink)),
        if (unit.isNotEmpty)
          TextSpan(text: ' $unit', style: SxText.readout(13, sx.muted, weight: FontWeight.w500)),
      ])),
      Text(label, style: context.text.bodySmall),
    ]);
  }
}

/// Per-core clock tiles, fastest cluster first.
class _CoreGrid extends StatelessWidget {
  const _CoreGrid({required this.cur, required this.max, this.parts});

  final List<int> cur;
  final List<int> max;
  final List<String?>? parts;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    final l = AppLocalizations.of(context);
    final order = List.generate(cur.length, (i) => i)
      ..sort((a, b) {
        final ma = a < max.length ? max[a] : 0, mb = b < max.length ? max[b] : 0;
        return mb != ma ? mb.compareTo(ma) : a.compareTo(b);
      });
    return Wrap(spacing: 8, runSpacing: 8, children: [
      for (final i in order)
        SizedBox(
          width: 74,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: sx.cardAlt,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                parts != null && i < parts!.length && parts![i] != null
                    ? parts![i]!.replaceFirst('Cortex-', '')
                    : l.coreN(i),
                style: SxText.eyebrow(sx.muted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                cur[i] > 0 ? formatDouble(cur[i] / 1e6, decimals: 2) : l.off,
                style: SxText.readout(14, cur[i] > 0 ? sx.ink : sx.muted),
              ),
              const SizedBox(height: 6),
              MeterBar(
                value: i < max.length && max[i] > 0 ? cur[i] / max[i] : 0,
                color: sx.cpu,
              ),
            ]),
          ),
        ),
    ]);
  }
}
