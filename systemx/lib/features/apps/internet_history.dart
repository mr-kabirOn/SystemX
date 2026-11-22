import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/format.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'apps_screen.dart';
import 'screen_time.dart' show UsageAccessCard, lastDayStarts;

/// Days of history shown.
const historyDays = 30;

final dataHistoryProvider = FutureProvider.autoDispose<List<DataTotalDay>>((ref) =>
    ref.watch(deviceApiProvider).dataHistory(lastDayStarts(DateTime.now(), historyDays)));

/// Mobile and Wi-Fi bytes summed over [days].
({int mobile, int wifi}) sumData(Iterable<DataTotalDay> days) {
  var mobile = 0, wifi = 0;
  for (final d in days) {
    mobile += d.mobileRx + d.mobileTx;
    wifi += d.wifiRx + d.wifiTx;
  }
  return (mobile: mobile, wifi: wifi);
}

/// Whole-phone internet usage for the last 30 days, mobile data (every SIM)
/// and Wi-Fi, like a data meter app: totals for today, yesterday, the week
/// and the month, a daily chart and a day-by-day list.
class InternetHistoryScreen extends ConsumerStatefulWidget {
  const InternetHistoryScreen({super.key});

  @override
  ConsumerState<InternetHistoryScreen> createState() => _InternetHistoryScreenState();
}

class _InternetHistoryScreenState extends ConsumerState<InternetHistoryScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () {
      ref.invalidate(usageAccessProvider);
      ref.invalidate(dataHistoryProvider);
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
    final history = ref.watch(dataHistoryProvider);
    return PageScaffold(
      title: l.ihTitle,
      leading: const BackButton(),
      slivers: [
        if (granted == false)
          Box(UsageAccessCard(
            icon: SxIcons.dataUsage,
            body: l.ihAccessBody,
            onAllow: () => ref.read(deviceApiProvider).openSettings(AppsActions.usageAccess),
          ))
        else
          ...history.when(
            skipLoadingOnRefresh: true,
            loading: () => [
              const SliverToBoxAdapter(
                child: Padding(padding: EdgeInsets.only(top: 48), child: Center(child: CircularProgressIndicator())),
              ),
            ],
            error: (_, _) => [Box(Center(child: Text(l.ihNone)))],
            data: (days) => _content(context, days),
          ),
      ],
    );
  }

  List<Widget> _content(BuildContext context, List<DataTotalDay> days) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    if (days.isEmpty) return [Box(Center(child: Text(l.ihNone)))];
    final month = sumData(days);
    final week = sumData(days.skip(days.length - 7));
    final today = sumData([days.last]);
    final yesterday = sumData(days.length > 1 ? [days[days.length - 2]] : const []);
    final date = DateFormat.MMMEd(l.localeName);

    Widget stat(String label, int bytes, Color dot) => Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(label, style: context.text.bodySmall?.copyWith(color: sx.onHero.withValues(alpha: 0.8))),
            ]),
            const SizedBox(height: 2),
            Text(formatStorage(bytes), style: context.text.titleMedium?.copyWith(color: sx.onHero)),
          ]),
        );

    TableRow row(String label, ({int mobile, int wifi}) v, {bool bold = false}) {
      final style = bold ? context.text.titleSmall : context.text.bodyMedium;
      Widget cell(String t, {TextAlign align = TextAlign.end}) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(t, textAlign: align, style: style),
          );
      return TableRow(children: [
        cell(label, align: TextAlign.start),
        cell(formatStorage(v.mobile)),
        cell(formatStorage(v.wifi)),
        cell(formatStorage(v.mobile + v.wifi)),
      ]);
    }

    final maxDay = days.fold<int>(1, (m, d) {
      final t = d.mobileRx + d.mobileTx + d.wifiRx + d.wifiTx;
      return t > m ? t : m;
    });
    final used = days.reversed.where((d) => d.mobileRx + d.mobileTx + d.wifiRx + d.wifiTx > 0).toList();

    return [
      Box(SxCard(
        gradient: heroGradient(sx),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Eyebrow(l.ihMonth, color: sx.onHero.withValues(alpha: 0.8)),
          const SizedBox(height: 8),
          Text(formatStorage(month.mobile + month.wifi), style: SxText.readout(34, sx.onHero, weight: FontWeight.w600)),
          const SizedBox(height: 14),
          Row(children: [
            stat(l.netMobile, month.mobile, sx.accent),
            stat(l.specWifi, month.wifi, sx.network),
          ]),
        ]),
      )),
      Box(SxCard(
        child: Table(
          columnWidths: const {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(), 2: FlexColumnWidth(), 3: FlexColumnWidth()},
          children: [
            TableRow(children: [
              const SizedBox(),
              for (final h in [l.netMobile, l.specWifi, l.specTotal])
                Text(h, textAlign: TextAlign.end, style: context.text.labelSmall?.copyWith(color: sx.muted)),
            ]),
            row(l.csToday, today),
            row(l.csYesterday, yesterday),
            row(l.stmWeek, week),
            row(l.ihMonth, month, bold: true),
          ],
        ),
      )),
      Box(SxCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.ihChart, style: context.text.titleMedium),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              for (final d in days)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 110 * (d.wifiRx + d.wifiTx) / maxDay,
                        decoration: BoxDecoration(
                          color: sx.network,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                        ),
                      ),
                      Container(height: 110 * (d.mobileRx + d.mobileTx) / maxDay, color: sx.accent),
                    ]),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Text(date.format(DateTime.fromMillisecondsSinceEpoch(days.first.dayStartMs)),
                style: context.text.labelSmall?.copyWith(color: sx.muted)),
            const Spacer(),
            Text(l.csToday, style: context.text.labelSmall?.copyWith(color: sx.muted)),
          ]),
        ]),
      )),
      SliverToBoxAdapter(child: SectionLabel(l.ihDaily)),
      if (used.isEmpty)
        Box(SxCard(child: Text(l.ihNone, style: context.text.bodyMedium?.copyWith(color: sx.muted))))
      else
        Box(SxCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Table(
            columnWidths: const {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(), 2: FlexColumnWidth(), 3: FlexColumnWidth()},
            children: [
              TableRow(children: [
                const SizedBox(),
                for (final h in [l.netMobile, l.specWifi, l.specTotal])
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(h, textAlign: TextAlign.end, style: context.text.labelSmall?.copyWith(color: sx.muted)),
                  ),
              ]),
              for (final d in used)
                row(
                  date.format(DateTime.fromMillisecondsSinceEpoch(d.dayStartMs)),
                  (mobile: d.mobileRx + d.mobileTx, wifi: d.wifiRx + d.wifiTx),
                ),
            ],
          ),
        )),
      Box(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(l.duNote, style: context.text.bodySmall?.copyWith(color: sx.muted)),
      )),
    ];
  }
}
