import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../apps/screen_time.dart';
import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/live_chart.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../background/battery_health.dart';
import '../background/history_widgets.dart';
import '../live/live_data.dart';
import '../live/live_screens.dart';

class MonitorScreen extends ConsumerWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final live = ref.watch(liveProvider);
    final s = live.latest;

    String last(List<double> v, String Function(double) f) =>
        v.isEmpty ? '–' : f(v.last);

    final charts = <_Chart>[
      _Chart(l.monitorCpu, last(live.cpuGhz, (v) => v.toStringAsFixed(2)), 'GHz',
          [ChartSeries(live.cpuGhz, sx.cpu)], (v) => '${v.toStringAsFixed(2)} GHz',
          LiveMetric.cpu, minY: 0),
      _Chart(l.monitorRam, last(live.memUsed, (v) => '${(v * 100).round()}'), '%',
          [ChartSeries(live.memUsed, sx.ram)], (v) => '${(v * 100).round()}%', null,
          minY: 0, maxY: 1),
      if (s?.currentNowMa != null)
        _Chart(l.monitorBattery, last(live.batteryMa, (v) => '${v > 0 ? '+' : ''}${v.round()}'), 'mA',
            [ChartSeries(live.batteryMa, sx.battery)], (v) => '${v.round()} mA',
            LiveMetric.battery),
      _Chart(l.monitorNet, '↓ ${formatRate(live.downBps)}', '↑ ${formatRate(live.upBps)}',
          [ChartSeries(live.down, sx.network, label: '↓'), ChartSeries(live.up, sx.accent, label: '↑')],
          formatRate, LiveMetric.network, minY: 0),
      _Chart(l.monitorTemp, s == null ? '–' : formatTemp(s.batteryTempC, unit), '',
          [
            ChartSeries(live.batteryTemp, sx.thermal, label: l.metricBattery),
            if (live.cpuTemp.isNotEmpty) ChartSeries(live.cpuTemp, sx.cpu, label: l.metricCpu),
          ],
          (v) => formatTemp(v, unit), LiveMetric.thermal),
    ];

    return PageScaffold(
      title: l.monitorTitle,
      actions: [
        IconButton(
          tooltip: live.paused ? l.resume : l.pause,
          icon: Icon(live.paused ? Icons.play_arrow_rounded : Icons.pause_rounded),
          onPressed: () => ref.read(liveProvider.notifier).setPaused(!live.paused),
        ),
      ],
      slivers: [
        Box(Text(l.monitorBody, style: context.text.bodyMedium?.copyWith(color: sx.muted))),
        SliverList.separated(
          itemCount: charts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final c = charts[i];
            final metric = c.metric;
            return SxCard(
              onTap: metric == null ? null : () => context.push(Routes.live(metric)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Eyebrow(c.title, color: c.series.first.color)),
                    if (live.paused) StatusChip(l.paused, color: sx.muted),
                  ]),
                  const SizedBox(height: 8),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: c.value, style: SxText.readout(26, sx.ink)),
                    if (c.unit.isNotEmpty)
                      TextSpan(
                          text: ' ${c.unit}',
                          style: SxText.readout(13, sx.muted, weight: FontWeight.w500)),
                  ])),
                  const SizedBox(height: 12),
                  LiveChart(
                    series: c.series,
                    format: c.format,
                    height: 96,
                    minY: c.minY,
                    maxY: c.maxY,
                    semanticLabel: c.title,
                  ),
                ],
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        const Box(HistoryCard()),
        const Box(BatteryHealthTile()),
        const Box(ScreenTimeTile()),
        const Box(SessionsTile(), bottom: 0),
      ],
    );
  }
}

class _Chart {
  _Chart(this.title, this.value, this.unit, this.series, this.format, this.metric,
      {this.minY, this.maxY});
  final String title;
  final String value;
  final String unit;
  final List<ChartSeries> series;
  final String Function(double) format;
  final LiveMetric? metric;
  final double? minY;
  final double? maxY;
}
