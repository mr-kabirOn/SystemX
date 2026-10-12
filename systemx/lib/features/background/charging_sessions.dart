import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'background.dart';
import 'charging_stats.dart';

/// Charging sessions: a 30-day summary, habits worth knowing about, a chart
/// of recent charges, and each charge grouped by day.
class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sessions = ref.watch(sessionsProvider);
    final now = DateTime.now();

    return PageScaffold(
      title: l.chargingSessions,
      leading: const BackButton(),
      slivers: [
        ...sessions.when(
          loading: () => [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
          error: (_, _) => [const Box(_Empty())],
          data: (list) {
            if (list.isEmpty) return [const Box(_Empty())];
            final stats = chargeStats(list, now);
            return [
              if (stats.count > 0) ...[
                Box(_Summary(stats: stats)),
                Box(_Insights(stats: stats)),
              ],
              if (list.length >= 2)
                Box(_Chart(sessions: list.take(14).toList().reversed.toList())),
              for (final (day, items) in _byDay(list)) ...[
                SliverToBoxAdapter(child: SectionLabel(_dayLabel(l, day, now))),
                SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _SessionCard(session: items[i]),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 4)),
              ],
            ];
          },
        ),
      ],
    );
  }

  /// Sessions arrive newest first; keeps that order within each day.
  static List<(DateTime, List<ChargeSession>)> _byDay(
    List<ChargeSession> list,
  ) {
    final out = <(DateTime, List<ChargeSession>)>[];
    for (final s in list) {
      final t = DateTime.fromMillisecondsSinceEpoch(s.startMs);
      final day = DateTime(t.year, t.month, t.day);
      if (out.isNotEmpty && out.last.$1 == day) {
        out.last.$2.add(s);
      } else {
        out.add((day, [s]));
      }
    }
    return out;
  }

  static String _dayLabel(AppLocalizations l, DateTime day, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return l.csToday;
    if (day == today.subtract(const Duration(days: 1))) return l.csYesterday;
    return DateFormat.MMMEd(l.localeName).format(day);
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      child: Column(
        children: [
          const SizedBox(height: 8),
          IconBadge(SxIcons.charging, color: sx.battery, size: 52),
          const SizedBox(height: 14),
          Text(
            l.csEmptyTitle,
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            l.csEmptyBody,
            style: context.text.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.stats});

  final ChargeStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final hottest = stats.hottestC;
    final tiles = [
      (l.csCharges, '${stats.count}', sx.battery),
      (
        l.csAvgTime,
        stats.avgDuration == null ? '–' : formatDuration(stats.avgDuration!),
        sx.accent,
      ),
      (
        l.csAvgAdded,
        stats.avgAdded == null ? '–' : '+${stats.avgAdded!.round()}%',
        sx.good,
      ),
      (
        l.csAvgSpeed,
        stats.avgRate == null
            ? '–'
            : l.csPerHour(stats.avgRate!.round().toString()),
        sx.network,
      ),
      (l.csToFull, '${stats.toFull} / ${stats.count}', stats.toFull * 2 > stats.count ? sx.warn : sx.good),
      (
        l.csHottest,
        hottest == null ? '–' : formatTemp(hottest, unit),
        hottest == null ? sx.muted : _tempColor(sx, hottest),
      ),
    ];
    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(l.csSummary),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              final w = (c.maxWidth - 20) / 3;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final (label, value, color) in tiles)
                    Container(
                      width: w,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: sx.cardAlt,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: context.text.labelSmall?.copyWith(
                              color: sx.muted,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value,
                              style: SxText.readout(17, color),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Color _tempColor(SxColors sx, double c) => c >= hotChargeC
    ? sx.bad
    : c >= warmChargeC
    ? sx.warn
    : sx.good;

class _Insights extends ConsumerWidget {
  const _Insights({required this.stats});

  final ChargeStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.csInsights, style: context.text.titleMedium),
          for (final i in stats.insights) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  i == ChargeInsight.good
                      ? SxIcons.passed
                      : Icons.lightbulb_rounded,
                  size: 22,
                  color: switch (i) {
                    ChargeInsight.good => sx.good,
                    ChargeInsight.hot => sx.bad,
                    _ => sx.warn,
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(switch (i) {
                        ChargeInsight.toFull => l.csInsightToFull,
                        ChargeInsight.deepDrain => l.csInsightDeep,
                        ChargeInsight.hot => l.csInsightHot,
                        ChargeInsight.overnight => l.csInsightOvernight,
                        ChargeInsight.good => l.csInsightGood,
                      }, style: context.text.titleSmall),
                      const SizedBox(height: 2),
                      Text(switch (i) {
                        ChargeInsight.toFull => l.csInsightToFullBody,
                        ChargeInsight.deepDrain => l.csInsightDeepBody,
                        ChargeInsight.hot => l.csInsightHotBody(
                          formatTemp(stats.hottestC ?? 0, unit),
                        ),
                        ChargeInsight.overnight => l.csInsightOvernightBody,
                        ChargeInsight.good => l.csInsightGoodBody,
                      }, style: context.text.bodySmall),
                      if (i == ChargeInsight.toFull)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () => context.push(Routes.alerts),
                          icon: const Icon(Icons.alarm_rounded, size: 18),
                          label: Text(l.csSetAlarm),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Bars of charge added per session, oldest left; warm charges in amber.
class _Chart extends StatelessWidget {
  const _Chart({required this.sessions});

  final List<ChargeSession> sessions;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.csChart, style: context.text.titleMedium),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final s in sessions)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${(s.endLevel - s.startLevel).clamp(0, 100)}',
                            style: context.text.labelSmall?.copyWith(
                              color: sx.muted,
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            height:
                                4 +
                                80 *
                                    ((s.endLevel - s.startLevel).clamp(0, 100) /
                                        100),
                            decoration: BoxDecoration(
                              color: s.maxTempC >= warmChargeC
                                  ? sx.warn
                                  : sx.battery,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.csChartLegend,
            style: context.text.bodySmall?.copyWith(color: sx.muted),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard({required this.session});

  final ChargeSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final s = session;
    final time = DateFormat.jm(l.localeName);
    final start = DateTime.fromMillisecondsSinceEpoch(s.startMs);
    final end = s.endMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(s.endMs!);
    final now = DateTime.now();
    final dur = (end ?? now).difference(start);
    final added = (s.endLevel - s.startLevel).clamp(0, 100);
    final rate = chargeRate(s, now);
    final nf = NumberFormat.decimalPattern(l.localeName);

    Widget metric(String label, String value, [Color? color]) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.text.labelSmall?.copyWith(color: sx.muted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: SxText.readout(14, color ?? sx.ink, weight: FontWeight.w600),
          ),
        ],
      ),
    );

    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${time.format(start)} – ${end == null ? l.csNow : time.format(end)}',
                  style: context.text.titleSmall,
                ),
              ),
              if (end == null)
                StatusChip(
                  l.batCharging,
                  color: sx.battery,
                  icon: Icons.bolt_rounded,
                )
              else
                Text(
                  formatDuration(dur),
                  style: context.text.labelLarge?.copyWith(color: sx.muted),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Where the charge started and ended on a 0–100% track.
          Row(
            children: [
              Text('${s.startLevel}%', style: context.text.labelMedium),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) {
                    final w = c.maxWidth;
                    return Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: sx.cardAlt,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        Positioned(
                          left: w * s.startLevel.clamp(0, 100) / 100,
                          width: (w * added / 100).clamp(4, w),
                          top: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: sx.battery,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text('${s.endLevel}%', style: context.text.labelMedium),
              const SizedBox(width: 10),
              Text(l.csAdded(added), style: SxText.readout(14, sx.good)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              metric(
                l.csSpeed,
                rate == null ? '–' : l.csPerHour(rate.round().toString()),
              ),
              metric(
                l.csAvg,
                s.avgMa == null ? '–' : '${nf.format(s.avgMa)} mA',
              ),
              metric(
                l.csPeak,
                s.peakMa == null ? '–' : '${nf.format(s.peakMa)} mA',
              ),
              metric(
                l.csMaxTemp,
                formatTemp(s.maxTempC, unit),
                _tempColor(sx, s.maxTempC),
              ),
            ],
          ),
          if (s.capacityMah != null) ...[
            const SizedBox(height: 10),
            Text(
              l.csMeasured(nf.format(s.capacityMah)),
              style: context.text.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
