import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/live_chart.dart';
import '../../ui/widgets/page_scaffold.dart';
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

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final sessions = ref.watch(sessionsProvider);
    final time = DateFormat.jm(l.localeName);

    return PageScaffold(
      title: l.chargingSessions,
      leading: const BackButton(),
      slivers: [
        ...sessions.when(
          loading: () => [const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))],
          error: (_, _) => [Box(Text(l.historyEmpty))],
          data: (list) => list.isEmpty
              ? [Box(Text(l.sessionsEmpty, style: context.text.bodyMedium?.copyWith(color: sx.muted)))]
              : [
                  SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final s = list[i];
                      final start = DateTime.fromMillisecondsSinceEpoch(s.startMs);
                      final end = s.endMs == null ? null : DateTime.fromMillisecondsSinceEpoch(s.endMs!);
                      final dur = (end ?? DateTime.now()).difference(start);
                      return SxCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(
                              child: Text(
                                '${formatDate(start, l.localeName)} · ${time.format(start)}',
                                style: context.text.titleSmall,
                              ),
                            ),
                            if (end == null)
                              StatusChip(l.batCharging, color: sx.battery, icon: Icons.bolt_rounded),
                          ]),
                          const SizedBox(height: 6),
                          Text('${s.startLevel}% → ${s.endLevel}% · ${formatDuration(dur)}',
                              style: context.text.bodyLarge),
                          const SizedBox(height: 4),
                          Text(
                            [
                              if (s.avgMa != null) l.avgCurrent(s.avgMa!),
                              if (s.peakMa != null) l.peakCurrent(s.peakMa!),
                              l.maxTemp(formatTemp(s.maxTempC, unit)),
                            ].join(' · '),
                            style: context.text.bodySmall,
                          ),
                        ]),
                      );
                    },
                  ),
                ],
        ),
      ],
    );
  }
}
