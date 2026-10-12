import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/live_chart.dart';
import 'background.dart';

/// 24 h / 7 day history charts for the Monitor tab.
class HistoryCard extends ConsumerStatefulWidget {
  const HistoryCard({super.key});

  @override
  ConsumerState<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends ConsumerState<HistoryCard> {
  HistoryRange _range = HistoryRange.day;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final samples = ref.watch(historyProvider(_range)).value ?? const <HistorySample>[];

    Widget chart(String title, List<double> v, Color color, String Function(double) f,
            {double? minY, double? maxY}) =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 14),
          Eyebrow(title, color: color),
          const SizedBox(height: 6),
          LiveChart(series: [ChartSeries(v, color)], format: f, height: 90, minY: minY, maxY: maxY),
        ]);

    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(l.history, style: context.text.titleMedium)),
          SegmentedButton<HistoryRange>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: HistoryRange.day, label: Text(l.range24h)),
              ButtonSegment(value: HistoryRange.week, label: Text(l.range7d)),
            ],
            selected: {_range},
            onSelectionChanged: (s) => setState(() => _range = s.first),
          ),
        ]),
        if (samples.length < 2) ...[
          const SizedBox(height: 12),
          Text(l.historyEmpty, style: context.text.bodySmall?.copyWith(color: sx.muted)),
        ] else ...[
          chart(l.metricBattery, [for (final s in samples) s.level.toDouble()], sx.battery,
              (v) => '${v.round()}%', minY: 0, maxY: 100),
          chart(l.chartTemperature, [for (final s in samples) s.tempC], sx.thermal,
              (v) => formatTemp(v, unit)),
          chart(l.monitorRam, [for (final s in samples) s.memUsed], sx.ram,
              (v) => '${(v * 100).round()}%', minY: 0, maxY: 1),
          const SizedBox(height: 6),
          Text(l.historyNote(samples.length), style: context.text.bodySmall),
        ],
      ]),
    );
  }
}

/// Entry to the charging sessions list.
class SessionsTile extends StatelessWidget {
  const SessionsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: IconBadge(SxIcons.charging, color: sx.battery, size: 36),
        title: Text(l.chargingSessions),
        subtitle: Text(l.chargingSessionsSub),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push(Routes.sessions),
      ),
    );
  }
}
