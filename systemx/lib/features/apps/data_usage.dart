import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'apps_screen.dart';
import 'screen_time.dart';

enum DataNetwork { mobile, wifi }

/// Days of history: the last 30, like a data meter app.
const dataUsageDays = 30;

final dataUsageProvider = FutureProvider.autoDispose<DataUsageReport>((ref) =>
    ref.watch(deviceApiProvider).dataUsage(lastDayStarts(DateTime.now(), dataUsageDays)));

/// Mobile and Wi-Fi bytes summed over [days].
({int mobile, int wifi}) sumData(Iterable<DataUsageDay> days) {
  var mobile = 0, wifi = 0;
  for (final d in days) {
    mobile += d.mobileRx + d.mobileTx;
    wifi += d.wifiRx + d.wifiTx;
  }
  return (mobile: mobile, wifi: wifi);
}

/// Received and sent bytes for [network] on [day].
(int, int) dayTotals(DataUsageDay day, DataNetwork network) => switch (network) {
      DataNetwork.mobile => (day.mobileRx, day.mobileTx),
      DataNetwork.wifi => (day.wifiRx, day.wifiTx),
    };

List<AppDataUsage> dayApps(DataUsageDay day, DataNetwork network) => switch (network) {
      DataNetwork.mobile => day.mobileApps,
      DataNetwork.wifi => day.wifiApps,
    };

/// Mean data per finished day with any use; null when none had any.
int? dailyAverageBytes(List<DataUsageDay> days, DataNetwork network) {
  final full = [
    for (final d in days.take(days.length - 1))
      if (dayTotals(d, network) case (final rx, final tx) when rx + tx > 0) rx + tx,
  ];
  if (full.isEmpty) return null;
  return full.reduce((a, b) => a + b) ~/ full.length;
}

/// The row's name: the app's, or a name for Android's own buckets.
String usageName(AppLocalizations l, AppDataUsage a) => switch (a.kind) {
      'system' => l.duSystem,
      'removed' => l.duRemoved,
      'tethering' => l.duTethering,
      'other' => l.duOther,
      _ => a.label ?? a.key,
    };

/// Wi-Fi and mobile data per app for the last week, from Android's own
/// network statistics (the source of the phone's data usage screen).
class DataUsageScreen extends ConsumerStatefulWidget {
  const DataUsageScreen({super.key});

  @override
  ConsumerState<DataUsageScreen> createState() => _DataUsageScreenState();
}

class _DataUsageScreenState extends ConsumerState<DataUsageScreen> {
  late final AppLifecycleListener _lifecycle;
  DataNetwork _network = DataNetwork.mobile;
  int? _day; // null = today
  bool _all = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () {
      ref.invalidate(usageAccessProvider);
      ref.invalidate(dataUsageProvider);
    });
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
    final report = ref.watch(dataUsageProvider);

    return PageScaffold(
      title: l.duTitle,
      leading: const BackButton(),
      slivers: [
        if (granted == false)
          Box(UsageAccessCard(
            icon: SxIcons.dataUsage,
            body: l.duAccessBody,
            onAllow: () => ref.read(deviceApiProvider).openSettings(AppsActions.usageAccess),
          ))
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
            error: (_, _) => [Box(Center(child: Text(l.duNone)))],
            data: (r) => _content(context, r),
          ),
      ],
    );
  }

  List<Widget> _content(BuildContext context, DataUsageReport r) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    if (r.days.isEmpty) return [Box(Center(child: Text(l.duNone)))];
    final index = (_day ?? r.days.length - 1).clamp(0, r.days.length - 1);
    final day = r.days[index];
    final apps = dayApps(day, _network).where((a) => a.rxBytes + a.txBytes > 0).toList();
    final shown = _all ? apps : apps.take(8).toList();
    final maxBytes = apps.isEmpty ? 1 : apps.first.rxBytes + apps.first.txBytes;

    return [
      Box(SegmentedButton<DataNetwork>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(value: DataNetwork.mobile, label: Text(l.netMobile)),
          ButtonSegment(value: DataNetwork.wifi, label: Text(l.specWifi)),
        ],
        selected: {_network},
        onSelectionChanged: (s) => setState(() {
          _network = s.first;
          _all = false;
        }),
      )),
      Box(_DayCard(day: day, network: _network, isToday: index == r.days.length - 1)),
      Box(_Totals(days: r.days)),
      Box(_WeekChart(
        days: r.days,
        network: _network,
        selected: index,
        onSelect: (i) => setState(() {
          _day = i;
          _all = false;
        }),
      )),
      SliverToBoxAdapter(child: SectionLabel(l.duApps)),
      if (apps.isEmpty)
        Box(SxCard(
          child: Text(l.duNone, style: context.text.bodyMedium?.copyWith(color: sx.muted)),
        ))
      else
        Box(SxCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(children: [
            for (final (i, a) in shown.indexed) ...[
              if (i > 0) const Divider(indent: 70, endIndent: 16),
              _AppRow(
                app: a,
                icon: r.icons[a.key],
                fraction: (a.rxBytes + a.txBytes) / maxBytes,
                onTap: a.kind == 'app'
                    ? () => ref.read(deviceApiProvider).openAppDetails(a.key)
                    : null,
              ),
            ],
            if (apps.length > 8)
              TextButton(
                onPressed: () => setState(() => _all = !_all),
                child: Text(_all ? l.stmShowLess : l.stmShowAll(apps.length)),
              ),
          ]),
        )),
      SliverToBoxAdapter(child: SectionLabel(l.ihDaily)),
      Box(_DayByDay(
        days: r.days,
        onSelect: (i) => setState(() {
          _day = i;
          _all = false;
        }),
      )),
      Box(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(l.duNote, style: context.text.bodySmall?.copyWith(color: sx.muted)),
      )),
    ];
  }
}

/// A row of the usage tables: label, mobile, Wi-Fi and total.
TableRow _usageRow(BuildContext context, String label, ({int mobile, int wifi}) v,
    {bool bold = false, VoidCallback? onTap}) {
  final style = bold ? context.text.titleSmall : context.text.bodyMedium;
  Widget cell(String t, {TextAlign align = TextAlign.end}) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(t, textAlign: align, style: style),
        ),
      );
  return TableRow(children: [
    cell(label, align: TextAlign.start),
    cell(formatStorage(v.mobile)),
    cell(formatStorage(v.wifi)),
    cell(formatStorage(v.mobile + v.wifi)),
  ]);
}

TableRow _usageHeader(BuildContext context) {
  final l = AppLocalizations.of(context);
  final sx = context.sx;
  return TableRow(children: [
    const SizedBox(),
    for (final h in [l.netMobile, l.specWifi, l.specTotal])
      Text(h, textAlign: TextAlign.end, style: context.text.labelSmall?.copyWith(color: sx.muted)),
  ]);
}

const _usageColumns = {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(), 2: FlexColumnWidth(), 3: FlexColumnWidth()};

/// Today, yesterday, 7 and 30 days, mobile data and Wi-Fi side by side.
class _Totals extends StatelessWidget {
  const _Totals({required this.days});
  final List<DataUsageDay> days;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SxCard(
      child: Table(columnWidths: _usageColumns, children: [
        _usageHeader(context),
        _usageRow(context, l.csToday, sumData([days.last])),
        _usageRow(context, l.csYesterday, sumData(days.length > 1 ? [days[days.length - 2]] : const [])),
        _usageRow(context, l.stmWeek, sumData(days.skip(days.length > 7 ? days.length - 7 : 0))),
        _usageRow(context, l.ihMonth, sumData(days), bold: true),
      ]),
    );
  }
}

/// Every day of the period, newest first; tap a day to show its apps.
class _DayByDay extends StatelessWidget {
  const _DayByDay({required this.days, required this.onSelect});
  final List<DataUsageDay> days;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final date = DateFormat.MMMEd(l.localeName);
    return SxCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Table(columnWidths: _usageColumns, children: [
        _usageHeader(context),
        for (var i = days.length - 1; i >= 0; i--)
          _usageRow(
            context,
            i == days.length - 1 ? l.csToday : date.format(DateTime.fromMillisecondsSinceEpoch(days[i].dayStartMs)),
            sumData([days[i]]),
            onTap: () => onSelect(i),
          ),
      ]),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day, required this.network, required this.isToday});

  final DataUsageDay day;
  final DataNetwork network;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final date = DateTime.fromMillisecondsSinceEpoch(day.dayStartMs);
    final when = isToday ? l.csToday : DateFormat.MMMEd(l.localeName).format(date);
    final (rx, tx) = dayTotals(day, network);
    final name = network == DataNetwork.mobile ? l.netMobile : l.specWifi;
    Widget stat(String label, String value) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: context.text.titleMedium?.copyWith(color: sx.onHero)),
            const SizedBox(height: 2),
            Text(label, style: context.text.bodySmall?.copyWith(color: sx.onHero.withValues(alpha: 0.75))),
          ]),
        );
    return SxCard(
      gradient: heroGradient(sx),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Eyebrow('$name · $when', color: sx.onHero.withValues(alpha: 0.8)),
        const SizedBox(height: 8),
        Text(formatStorage(rx + tx), style: SxText.readout(34, sx.onHero, weight: FontWeight.w600)),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          stat(l.download, '↓ ${formatStorage(rx)}'),
          stat(l.upload, '↑ ${formatStorage(tx)}'),
        ]),
      ]),
    );
  }
}

/// Data per day on the chosen network; tap a bar to show that day.
class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.days, required this.network, required this.selected, required this.onSelect});

  final List<DataUsageDay> days;
  final DataNetwork network;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final weekday = DateFormat.E(l.localeName);
    int total(DataUsageDay d) => dayTotals(d, network).$1 + dayTotals(d, network).$2;
    final maxBytes = days.fold<int>(1, (m, d) => total(d) > m ? total(d) : m);
    final avg = dailyAverageBytes(days, network);
    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.ihMonth, style: context.text.titleMedium),
        if (avg != null) ...[
          const SizedBox(height: 2),
          Text(l.stmAverage(formatStorage(avg)), style: context.text.bodySmall?.copyWith(color: sx.muted)),
        ],
        const SizedBox(height: 14),
        SizedBox(
          height: 110,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (final (i, d) in days.indexed)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: i == selected,
                  label: '${weekday.format(DateTime.fromMillisecondsSinceEpoch(d.dayStartMs))}: ${formatStorage(total(d))}',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onSelect(i),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: days.length > 7 ? 1.5 : 5),
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          height: 4 + 100 * total(d) / maxBytes,
                          decoration: BoxDecoration(
                            color: i == selected ? sx.accent : sx.accent.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(days.length > 7 ? 2 : 5),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 8),
        // Thirty bars are too narrow for names: the first day and today.
        Row(children: [
          Text(DateFormat.MMMd(l.localeName).format(DateTime.fromMillisecondsSinceEpoch(days.first.dayStartMs)),
              style: context.text.labelSmall?.copyWith(color: sx.muted)),
          const Spacer(),
          Text(l.csToday, style: context.text.labelSmall?.copyWith(color: sx.muted)),
        ]),
      ]),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({required this.app, required this.icon, required this.fraction, this.onTap});

  final AppDataUsage app;
  final Uint8List? icon;
  final double fraction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final fallback = switch (app.kind) {
      'system' => SxIcons.system,
      'tethering' => SxIcons.network,
      _ => SxIcons.apps,
    };
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: icon != null
                ? Image.memory(icon!, width: 40, height: 40, gaplessPlayback: true)
                : IconBadge(fallback, color: sx.accent, size: 40),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(usageName(l, app),
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.titleSmall),
                ),
                const SizedBox(width: 8),
                Text(formatStorage(app.rxBytes + app.txBytes),
                    style: context.text.titleSmall?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
              ]),
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
              Text(l.duDownUp(formatStorage(app.rxBytes), formatStorage(app.txBytes)),
                  style: context.text.bodySmall?.copyWith(color: sx.muted)),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Entry to the data usage page (Monitor tab and Device tab).
class DataUsageTile extends StatelessWidget {
  const DataUsageTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: IconBadge(SxIcons.dataUsage, color: sx.accent, size: 36),
        title: Text(l.duTitle),
        subtitle: Text(l.duEntryBody),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push(Routes.dataUsage),
      ),
    );
  }
}
