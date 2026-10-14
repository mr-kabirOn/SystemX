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
/// of recent charges (tap a bar for its details), and each charge by day.
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
              child: Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator())),
            ),
          ],
          error: (_, _) => [const Box(_Empty())],
          data: (list) {
            if (list.isEmpty) return [const Box(_Empty())];
            final stats = chargeStats(list, now);
            final charted = list.where(isValidCharge).take(14).toList().reversed.toList();
            return [
              if (stats.count > 0) ...[
                Box(_Summary(stats: stats)),
                Box(_Insights(stats: stats)),
              ],
              if (charted.length >= 2) Box(_Chart(sessions: charted)),
              for (final (day, items) in _byDay(list)) ...[
                SliverToBoxAdapter(child: SectionLabel(_dayLabel(l, day, now))),
                SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => SessionCard(session: items[i]),
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
  static List<(DateTime, List<ChargeSession>)> _byDay(List<ChargeSession> list) {
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

String chargeTime(AppLocalizations l, Duration d) => formatChargeTime(d, h: l.csHourShort, min: l.csMinShort);

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      child: Column(children: [
        const SizedBox(height: 8),
        IconBadge(SxIcons.charging, color: sx.battery, size: 52),
        const SizedBox(height: 14),
        Text(l.csEmptyTitle, style: context.text.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(l.csEmptyBody, style: context.text.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 8),
      ]),
    );
  }
}

Color tempColor(SxColors sx, double c) => switch (tempLevel(c)) {
      TempLevel.hot => sx.bad,
      TempLevel.warm => sx.warn,
      TempLevel.normal => sx.ink,
    };

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
      (l.csCharges, '${stats.count}'),
      (l.csAvgTime, stats.avgDuration == null ? '–' : chargeTime(l, stats.avgDuration!)),
      (l.csAvgAdded, stats.avgAdded == null ? '–' : '${stats.avgAdded!.round()}%'),
      (l.csAvgSpeed, stats.overallRate == null ? '–' : l.csPerHourLong(stats.overallRate!.round())),
      (l.csToFull, l.csOfCount(stats.toFull, stats.count)),
      (l.csHottest, hottest == null ? '–' : formatTemp(hottest, unit)),
    ];
    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Eyebrow(l.csSummary),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, c) {
          final w = (c.maxWidth - 10) / 2;
          return Wrap(spacing: 10, runSpacing: 10, children: [
            for (final (label, value) in tiles)
              Container(
                width: w,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: BoxDecoration(color: sx.cardAlt, borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: context.text.labelMedium?.copyWith(color: sx.muted), maxLines: 2),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(value, style: SxText.readout(18, sx.ink)),
                  ),
                ]),
              ),
          ]);
        }),
        const SizedBox(height: 12),
        Text(
          [
            l.csBasedOnValid(stats.count, minChargeMinutes),
            if (stats.excluded > 0) l.csExcluded(stats.excluded),
            l.csSpeedDefinition,
          ].join(' '),
          style: context.text.bodySmall?.copyWith(color: sx.muted),
        ),
      ]),
    );
  }
}

class _Insights extends ConsumerWidget {
  const _Insights({required this.stats});

  final ChargeStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final temp = formatTemp(stats.hottestC ?? 0, unit);
    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.csInsights, style: context.text.titleMedium),
        for (final i in stats.insights) ...[
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(
              switch (i) {
                ChargeInsight.good => SxIcons.passed,
                ChargeInsight.hot => Icons.warning_rounded,
                _ => Icons.info_rounded,
              },
              size: 22,
              color: switch (i) {
                ChargeInsight.good => sx.good,
                ChargeInsight.hot => sx.bad,
                ChargeInsight.warmOften => sx.warn,
                _ => sx.accent,
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  switch (i) {
                    ChargeInsight.toFull => l.csInsightToFull,
                    ChargeInsight.deepDrain => l.csInsightDeep,
                    ChargeInsight.hot => l.csInsightHot,
                    ChargeInsight.warmOften => l.csInsightWarm,
                    ChargeInsight.overnight => l.csInsightOvernight,
                    ChargeInsight.good => l.csInsightGood,
                  },
                  style: context.text.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  switch (i) {
                    ChargeInsight.toFull => l.csInsightToFullBody,
                    ChargeInsight.deepDrain => l.csInsightDeepBody,
                    ChargeInsight.hot => l.csInsightHotBody(temp, stats.hot),
                    ChargeInsight.warmOften => l.csInsightWarmBody(stats.warm, temp),
                    ChargeInsight.overnight => l.csInsightOvernightBody,
                    ChargeInsight.good => l.csInsightGoodBody,
                  },
                  style: context.text.bodySmall,
                ),
                if (i == ChargeInsight.toFull)
                  TextButton.icon(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                    onPressed: () => context.push(Routes.alerts),
                    icon: const Icon(Icons.alarm_rounded, size: 18),
                    label: Text(l.csSetAlarm),
                  ),
              ]),
            ),
          ]),
        ],
        const SizedBox(height: 10),
        Text(l.csTempSource, style: context.text.bodySmall?.copyWith(color: sx.muted)),
      ]),
    );
  }
}

/// Points gained per valid charge, oldest left, with each bar's date.
/// Tapping a bar opens that charge's details.
class _Chart extends StatelessWidget {
  const _Chart({required this.sessions});

  final List<ChargeSession> sessions;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final date = DateFormat.Md(l.localeName);
    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.csChart, style: context.text.titleMedium),
        const SizedBox(height: 2),
        Text(l.csChartSub(sessions.length), style: context.text.bodySmall?.copyWith(color: sx.muted)),
        const SizedBox(height: 14),
        SizedBox(
          height: 132,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (final s in sessions)
              Expanded(
                child: Semantics(
                  button: true,
                  label: '${date.format(DateTime.fromMillisecondsSinceEpoch(s.startMs))}: +${s.endLevel - s.startLevel}%',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      builder: (_) => Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: SessionCard(session: s, showDate: true),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text('${s.endLevel - s.startLevel}',
                            style: context.text.labelSmall?.copyWith(color: sx.muted, fontSize: 10)),
                        const SizedBox(height: 3),
                        Container(
                          height: 4 + 80 * ((s.endLevel - s.startLevel).clamp(0, 100) / 100),
                          decoration: BoxDecoration(
                            color: switch (tempLevel(s.maxTempC)) {
                              TempLevel.hot => sx.bad,
                              TempLevel.warm => sx.warn,
                              TempLevel.normal => sx.battery,
                            },
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            date.format(DateTime.fromMillisecondsSinceEpoch(s.startMs)),
                            style: context.text.labelSmall?.copyWith(color: sx.muted, fontSize: 10),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 10),
        Text(l.csChartLegend, style: context.text.bodySmall?.copyWith(color: sx.muted)),
      ]),
    );
  }
}

/// One charge. Connections too short to measure say so instead of showing
/// a meaningless rate or "+0%".
class SessionCard extends ConsumerWidget {
  const SessionCard({super.key, required this.session, this.showDate = false});

  final ChargeSession session;
  final bool showDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final s = session;
    final time = DateFormat.jm(l.localeName);
    final start = DateTime.fromMillisecondsSinceEpoch(s.startMs);
    final end = s.endMs == null ? null : DateTime.fromMillisecondsSinceEpoch(s.endMs!);
    final now = DateTime.now();
    final dur = (end ?? now).difference(start);
    final gained = s.endLevel - s.startLevel;
    final rate = chargeRate(s, now);
    final short = end != null && !isValidCharge(s);
    final nf = NumberFormat.decimalPattern(l.localeName);

    Widget metric(String label, String value, [Color? color]) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: context.text.labelSmall?.copyWith(color: sx.muted)),
            const SizedBox(height: 2),
            Text(value, style: SxText.readout(14, color ?? sx.ink, weight: FontWeight.w600)),
          ]),
        );

    final header = Row(children: [
      Expanded(
        child: Text(
          [
            if (showDate) DateFormat.MMMEd(l.localeName).format(start),
            '${time.format(start)} – ${end == null ? l.csNow : time.format(end)}',
          ].join(' · '),
          style: context.text.titleSmall,
        ),
      ),
      if (end == null)
        StatusChip(l.batCharging, color: sx.battery, icon: Icons.bolt_rounded)
      else
        Text(chargeTime(l, dur), style: context.text.labelLarge?.copyWith(color: sx.muted)),
    ]);

    if (short) {
      return SxCard(
        color: sx.cardAlt,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          header,
          const SizedBox(height: 6),
          Text(l.csShort(s.startLevel, s.endLevel), style: context.text.bodySmall),
        ]),
      );
    }

    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        header,
        const SizedBox(height: 12),
        // Where the charge started and ended on a 0–100% track.
        Row(children: [
          Text('${s.startLevel}%', style: context.text.labelMedium),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(builder: (context, c) {
              final w = c.maxWidth;
              final added = gained.clamp(0, 100);
              return Stack(children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(color: sx.cardAlt, borderRadius: BorderRadius.circular(99)),
                ),
                Positioned(
                  left: w * s.startLevel.clamp(0, 100) / 100,
                  width: (w * added / 100).clamp(4, w),
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(color: sx.battery, borderRadius: BorderRadius.circular(99)),
                  ),
                ),
              ]);
            }),
          ),
          const SizedBox(width: 8),
          Text('${s.endLevel}%', style: context.text.labelMedium),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          metric(l.csAddedLabel, '+$gained%', sx.good),
          metric(l.csSpeed, rate == null ? '–' : l.csPerHourLong(rate.round())),
          metric(l.csMaxTemp, formatTemp(s.maxTempC, unit), tempColor(sx, s.maxTempC)),
        ]),
        if (s.avgMa != null || s.peakMa != null) ...[
          const SizedBox(height: 10),
          Row(children: [
            metric(l.csAvgCurrent, s.avgMa == null ? '–' : '${nf.format(s.avgMa)} mA'),
            metric(l.csPeak, s.peakMa == null ? '–' : '${nf.format(s.peakMa)} mA'),
            const Spacer(),
          ]),
        ],
        if (s.capacityMah != null) ...[
          const SizedBox(height: 10),
          Text(l.csMeasured(nf.format(s.capacityMah)), style: context.text.bodySmall),
        ],
      ]),
    );
  }
}
