import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'apps_screen.dart';

/// Days shown: today and the six before it.
const screenTimeDays = 7;

/// Local midnights of the last [n] days, oldest first.
List<int> lastDayStarts(DateTime now, int n) => [
  for (var i = n - 1; i >= 0; i--)
    DateTime(now.year, now.month, now.day - i).millisecondsSinceEpoch,
];

/// Mean screen time of the finished days that have any; null when none do.
int? dailyAverageMs(List<UsageDay> days) {
  final full = days
      .take(days.length - 1)
      .where((d) => d.screenOnMs > 0)
      .toList();
  if (full.isEmpty) return null;
  return full.fold<int>(0, (t, d) => t + d.screenOnMs) ~/ full.length;
}

/// "3 h 12 min", "45 min", "< 1 min".
String formatUsage(int ms, AppLocalizations l) {
  final minutes = ms ~/ 60000;
  if (minutes < 1) return l.stmUnderMin;
  final h = minutes ~/ 60, m = minutes % 60;
  if (h == 0) return l.stmM(m);
  return m == 0 ? l.stmH(h) : l.stmHm(h, m);
}

/// "< 1" for small estimates, whole points otherwise.
String batteryPoints(double pct) => pct < 1 ? '< 1' : '${pct.round()}';

final screenTimeProvider = FutureProvider.autoDispose<ScreenTimeReport>(
  (ref) => ref
      .watch(deviceApiProvider)
      .screenTime(lastDayStarts(DateTime.now(), screenTimeDays)),
);

/// Screen time per day for the last week, and each app's time, opens and
/// estimated battery use. Everything comes from Android's usage records
/// (Usage access) and SystemX's own battery history.
class ScreenTimeScreen extends ConsumerStatefulWidget {
  const ScreenTimeScreen({super.key});

  @override
  ConsumerState<ScreenTimeScreen> createState() => _ScreenTimeScreenState();
}

class _ScreenTimeScreenState extends ConsumerState<ScreenTimeScreen> {
  late final AppLifecycleListener _lifecycle;
  int? _day; // index into the report's days; null = today
  bool _all = false;

  @override
  void initState() {
    super.initState();
    // Coming back from Settings or another app: access or usage changed.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        ref.invalidate(usageAccessProvider);
        ref.invalidate(screenTimeProvider);
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final granted = ref.watch(usageAccessProvider).value;
    final report = ref.watch(screenTimeProvider);

    return PageScaffold(
      title: l.stmTitle,
      leading: const BackButton(),
      slivers: [
        if (granted == false)
          Box(
            _AccessCard(
              onAllow: () => ref
                  .read(deviceApiProvider)
                  .openSettings(AppsActions.usageAccess),
            ),
          )
        else
          ...report.when(
            skipLoadingOnRefresh: true,
            loading: () => [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
            error: (_, _) => [Box(Center(child: Text(l.stmNoUse)))],
            data: (r) => _content(context, r),
          ),
      ],
    );
  }

  List<Widget> _content(BuildContext context, ScreenTimeReport r) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    if (r.days.isEmpty) return [Box(Center(child: Text(l.stmNoUse)))];
    final index = (_day ?? r.days.length - 1).clamp(0, r.days.length - 1);
    final day = r.days[index];
    final apps = day.apps.where((a) => a.foregroundMs >= 1000).toList();
    final shown = _all ? apps : apps.take(8).toList();
    final maxMs = apps.isEmpty ? 1 : apps.first.foregroundMs;
    final noBattery = r.days.every((d) => d.drainPct == null);

    return [
      Box(_DayCard(day: day, isToday: index == r.days.length - 1)),
      Box(
        _WeekChart(
          days: r.days,
          selected: index,
          onSelect: (i) => setState(() {
            _day = i;
            _all = false;
          }),
        ),
      ),
      SliverToBoxAdapter(child: SectionLabel(l.stmApps)),
      if (apps.isEmpty)
        Box(
          SxCard(
            child: Text(
              l.stmNoUse,
              style: context.text.bodyMedium?.copyWith(color: sx.muted),
            ),
          ),
        )
      else
        Box(
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (final (i, a) in shown.indexed) ...[
                  if (i > 0) const Divider(indent: 70, endIndent: 16),
                  _AppRow(
                    app: a,
                    icon: r.icons[a.packageName],
                    fraction: a.foregroundMs / maxMs,
                    onTap: () => ref
                        .read(deviceApiProvider)
                        .openAppDetails(a.packageName),
                  ),
                ],
                if (apps.length > 8)
                  TextButton(
                    onPressed: () => setState(() => _all = !_all),
                    child: Text(
                      _all ? l.stmShowLess : l.stmShowAll(apps.length),
                    ),
                  ),
              ],
            ),
          ),
        ),
      Box(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.stmTimeNote,
                style: context.text.bodySmall?.copyWith(color: sx.muted),
              ),
              const SizedBox(height: 8),
              Text(
                noBattery ? l.stmNoBattery : l.stmBatteryNote,
                style: context.text.bodySmall?.copyWith(color: sx.muted),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

/// The selected day's total, unlocks and battery used with the screen on.
class _DayCard extends StatelessWidget {
  const _DayCard({required this.day, required this.isToday});

  final UsageDay day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final date = DateTime.fromMillisecondsSinceEpoch(day.dayStartMs);
    final title = isToday
        ? l.csToday
        : DateFormat.MMMEd(l.localeName).format(date);
    Widget stat(String label, String value) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: context.text.titleMedium?.copyWith(color: sx.onHero),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: context.text.bodySmall?.copyWith(
              color: sx.onHero.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
    return SxCard(
      gradient: heroGradient(sx),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(
            '${l.stmTitle} · $title',
            color: sx.onHero.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 8),
          Text(
            formatUsage(day.screenOnMs, l),
            style: SxText.readout(34, sx.onHero, weight: FontWeight.w600),
          ),
          if (day.unlocks != null || day.screenDrainPct != null) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (day.unlocks case final u?) stat(l.stmUnlocksLabel, '$u'),
                if (day.screenDrainPct case final p?)
                  stat(l.stmScreenBattery, '${batteryPoints(p)}%'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Screen time per day; tap a bar to show that day.
class _WeekChart extends StatelessWidget {
  const _WeekChart({
    required this.days,
    required this.selected,
    required this.onSelect,
  });

  final List<UsageDay> days;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final weekday = DateFormat.E(l.localeName);
    final maxMs = days.fold<int>(
      1,
      (m, d) => d.screenOnMs > m ? d.screenOnMs : m,
    );
    final avg = dailyAverageMs(days);
    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.stmWeek, style: context.text.titleMedium),
          if (avg != null) ...[
            const SizedBox(height: 2),
            Text(
              l.stmAverage(formatUsage(avg, l)),
              style: context.text.bodySmall?.copyWith(color: sx.muted),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            height: 128,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, d) in days.indexed)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: i == selected,
                      label:
                          '${weekday.format(DateTime.fromMillisecondsSinceEpoch(d.dayStartMs))}: ${formatUsage(d.screenOnMs, l)}',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => onSelect(i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 4 + 88 * d.screenOnMs / maxMs,
                                decoration: BoxDecoration(
                                  color: i == selected
                                      ? sx.accent
                                      : sx.accent.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                weekday.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    d.dayStartMs,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: context.text.labelSmall?.copyWith(
                                  color: i == selected ? sx.ink : sx.muted,
                                  fontWeight: i == selected
                                      ? FontWeight.w600
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({
    required this.app,
    required this.icon,
    required this.fraction,
    required this.onTap,
  });

  final AppUsage app;
  final Uint8List? icon;
  final double fraction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final details = [
      l.stmOpens(app.opens),
      if (app.batteryPct case final b?) l.stmAppBattery(batteryPoints(b)),
    ].join(' · ');
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: icon != null
                  ? Image.memory(
                      icon!,
                      width: 40,
                      height: 40,
                      gaplessPlayback: true,
                    )
                  : IconBadge(SxIcons.apps, color: sx.storage, size: 40),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          app.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.titleSmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatUsage(app.foregroundMs, l),
                        style: context.text.titleSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: fraction.clamp(0.02, 1.0),
                      minHeight: 5,
                      color: sx.accent,
                      backgroundColor: sx.line,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    details,
                    style: context.text.bodySmall?.copyWith(color: sx.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({required this.onAllow});

  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(SxIcons.screenTime, color: sx.accent, size: 44),
          const SizedBox(height: 14),
          Text(l.stmAccessTitle, style: context.text.titleMedium),
          const SizedBox(height: 6),
          Text(
            l.stmAccessBody,
            style: context.text.bodyMedium?.copyWith(color: sx.muted),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onAllow, child: Text(l.appsUsageButton)),
        ],
      ),
    );
  }
}

/// Entry to the screen time page (Monitor tab and Device tab).
class ScreenTimeTile extends StatelessWidget {
  const ScreenTimeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: IconBadge(SxIcons.screenTime, color: sx.accent, size: 36),
        title: Text(l.stmTitle),
        subtitle: Text(l.stmEntryBody),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push(Routes.screenTime),
      ),
    );
  }
}
