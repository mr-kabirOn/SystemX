import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../background/background.dart';
import '../background/battery_health.dart';
import '../device/device_data.dart';
import '../tests/report_pdf.dart';
import '../tests/test_results.dart';
import 'used_phone.dart';

/// Items the buyer has ticked. Kept while the app is open, so running the
/// checkup in between doesn't lose them.
class BuyerChecklist extends Notifier<Set<BuyerCheck>> {
  @override
  Set<BuyerCheck> build() => {};

  void toggle(BuyerCheck c) =>
      state = state.contains(c) ? ({...state}..remove(c)) : {...state, c};
}

final buyerChecklistProvider =
    NotifierProvider<BuyerChecklist, Set<BuyerCheck>>(BuyerChecklist.new);

/// Measured capacity for the verdict, only once there are enough charges
/// to give a health band; a single charge is too little to judge a battery.
int? usableCapacityPercent(List<ChargeSession> sessions, DeviceSnapshot snap) {
  final est = estimateCapacity(sessions, snap.battery?.designCapacityMah);
  return est.band == HealthBand.insufficient ? null : est.percentOfDesign;
}

/// Android's accounts screen, where the seller signs out.
const accountsSettings = 'android.settings.SYNC_SETTINGS';

String checkTitle(AppLocalizations l, BuyerCheck c) => switch (c) {
  BuyerCheck.imei => l.bcImei,
  BuyerCheck.accounts => l.bcAccounts,
  BuyerCheck.body => l.bcBody,
  BuyerCheck.sim => l.bcSim,
  BuyerCheck.charger => l.bcCharger,
  BuyerCheck.paperwork => l.bcPaperwork,
  BuyerCheck.reset => l.bcReset,
};

String checkBody(AppLocalizations l, BuyerCheck c) => switch (c) {
  BuyerCheck.imei => l.bcImeiBody,
  BuyerCheck.accounts => l.bcAccountsBody,
  BuyerCheck.body => l.bcBodyBody,
  BuyerCheck.sim => l.bcSimBody,
  BuyerCheck.charger => l.bcChargerBody,
  BuyerCheck.paperwork => l.bcPaperworkBody,
  BuyerCheck.reset => l.bcResetBody,
};

/// Pre-owned phone assessment: software and battery checks, a hardware
/// checkup and a buyer's checklist, with a verdict and a PDF report.
class UsedPhoneScreen extends ConsumerStatefulWidget {
  const UsedPhoneScreen({super.key});

  @override
  ConsumerState<UsedPhoneScreen> createState() => _UsedPhoneScreenState();
}

class _UsedPhoneScreenState extends ConsumerState<UsedPhoneScreen> {
  bool _busy = false;

  UsedPhoneReport? _report(AppLocalizations l, DeviceSnapshot? snap) {
    final history = ref.watch(testHistoryProvider).value;
    if (snap == null || history == null) return null;
    final sessions =
        ref.watch(sessionsProvider).value ?? const <ChargeSession>[];
    return evaluateUsedPhone(
      l: l,
      snap: snap,
      history: history,
      capacityPercent: usableCapacityPercent(sessions, snap),
      now: DateTime.now(),
    );
  }

  Future<void> _savePdf() async {
    setState(() => _busy = true);
    try {
      final en = lookupAppLocalizations(const Locale('en'));
      final snap = ref.read(fullSnapshotProvider).value;
      if (snap == null) return;
      final history =
          ref.read(testHistoryProvider).value ?? const TestHistory();
      final sessions =
          ref.read(sessionsProvider).value ?? const <ChargeSession>[];
      final now = DateTime.now();
      final report = evaluateUsedPhone(
        l: en,
        snap: snap,
        history: history,
        capacityPercent: usableCapacityPercent(sessions, snap),
        now: now,
      );
      final bytes = await buildUsedPhonePdf(
        en,
        snap,
        report,
        ref.read(buyerChecklistProvider),
        now,
      );
      await ref.read(shareFileProvider)(
        bytes,
        'SystemX-used-phone-${DateFormat('yyyy-MM-dd-HHmm').format(now)}.pdf',
        en.upCertTitle,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final snap = ref.watch(fullSnapshotProvider).value;
    final report = _report(l, snap);
    final ticked = ref.watch(buyerChecklistProvider);

    return PageScaffold(
      title: l.upTitle,
      leading: const BackButton(),
      slivers: [
        Box(Text(l.upIntro, style: context.text.bodyMedium)),
        Box(_Disclaimer()),
        if (report == null)
          const Box(
            Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else ...[
          Box(_Overview(report: report, ticked: ticked.length)),
          SliverToBoxAdapter(child: SectionLabel(l.upResults)),
          Box(
            _GroupCard(
              report: report,
              group: CheckGroup.software,
              icon: SxIcons.security,
              color: sx.good,
              title: l.upGroupSoftware,
            ),
          ),
          Box(
            _GroupCard(
              report: report,
              group: CheckGroup.battery,
              icon: SxIcons.battery,
              color: sx.battery,
              title: l.upGroupBattery,
            ),
          ),
          Box(_HardwareCard(report: report)),
          if (snap != null) ...[
            SliverToBoxAdapter(child: SectionLabel(l.upIdentityTitle)),
            Box(_IdentityCard(snap: snap)),
          ],
          SliverToBoxAdapter(child: SectionLabel(l.upChecklistTitle)),
          Box(_ChecklistCard(ticked: ticked)),
          Box(
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _busy ? null : _savePdf,
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: Text(l.upCertificate),
              ),
            ),
            bottom: 0,
          ),
        ],
      ],
    );
  }
}

class _Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: sx.cardAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sx.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: sx.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.upDisclaimerTitle, style: context.text.labelLarge),
                const SizedBox(height: 4),
                Text(
                  l.upDisclaimer,
                  style: context.text.bodySmall?.copyWith(color: sx.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

(String, String, Color, IconData) verdictLook(
  AppLocalizations l,
  SxColors sx,
  UsedVerdict v,
) => switch (v) {
  UsedVerdict.clean => (l.upClean, l.upCleanBody, sx.good, SxIcons.passed),
  UsedVerdict.checkFirst => (
    l.upCheckFirst,
    l.upCheckFirstBody,
    sx.warn,
    Icons.error_rounded,
  ),
  UsedVerdict.problems => (
    l.upProblems,
    l.upProblemsBody,
    sx.bad,
    SxIcons.failed,
  ),
  UsedVerdict.incomplete => (
    l.upIncomplete,
    l.upIncompleteBody,
    sx.accent,
    Icons.pending_rounded,
  ),
};

/// Verdict, checks passed and the three steps at a glance.
class _Overview extends StatelessWidget {
  const _Overview({required this.report, required this.ticked});

  final UsedPhoneReport report;
  final int ticked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final (title, body, color, icon) = verdictLook(l, sx, report.verdict);
    final total = report.rated.length;
    final passed = report.passed;
    final steps = [
      (l.upStepDevice, true),
      (l.upStepHardware, report.checkup != null),
      (l.upStepChecklist, ticked == BuyerCheck.values.length),
    ];

    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GaugeRing(
                value: total == 0 ? 0 : passed / total,
                color: color,
                size: 84,
                stroke: 9,
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.text.titleLarge?.copyWith(color: color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.upChecksPassed(passed, total),
                      style: context.text.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(body, style: context.text.bodyMedium),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, (label, done)) in steps.indexed) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: done
                            ? sx.good.withValues(alpha: 0.12)
                            : sx.cardAlt,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            done
                                ? SxIcons.passed
                                : Icons.radio_button_unchecked_rounded,
                            size: 20,
                            color: done ? sx.good : sx.muted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            textAlign: TextAlign.center,
                            style: context.text.labelSmall,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String groupSummary(AppLocalizations l, UsedPhoneReport r, CheckGroup g) {
  final bad = r.inGroup(g).where((c) => c.level == CheckLevel.bad).length;
  final warn = r.inGroup(g).where((c) => c.level == CheckLevel.warn).length;
  if (bad > 0) return l.upIssues(bad);
  if (warn > 0) return l.upToReview(warn);
  return r.inGroup(g).isEmpty ? l.upNotRun : l.upAllClear;
}

Color levelColor(SxColors sx, CheckLevel? lv) => switch (lv) {
  CheckLevel.ok => sx.good,
  CheckLevel.bad => sx.bad,
  CheckLevel.warn => sx.warn,
  _ => sx.muted,
};

IconData levelIcon(CheckLevel lv) => switch (lv) {
  CheckLevel.ok => SxIcons.passed,
  CheckLevel.bad => SxIcons.failed,
  CheckLevel.warn => Icons.error_rounded,
  CheckLevel.info => Icons.info_rounded,
};

/// One group of checks; opens by itself when something needs attention.
class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.report,
    required this.group,
    required this.icon,
    required this.color,
    required this.title,
    this.footer,
  });

  final UsedPhoneReport report;
  final CheckGroup group;
  final IconData icon;
  final Color color;
  final String title;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final worst = report.worst(group);
    final checks = report.inGroup(group).toList();
    return SxCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded:
              worst == CheckLevel.bad ||
              worst == CheckLevel.warn ||
              footer != null,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: IconBadge(icon, color: color),
          title: Text(title, style: context.text.titleSmall),
          subtitle: Text(
            groupSummary(l, report, group),
            style: context.text.bodySmall?.copyWith(
              color: levelColor(sx, worst),
            ),
          ),
          children: [
            for (final c in checks)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 10),
                      child: Icon(
                        levelIcon(c.level),
                        size: 20,
                        color: levelColor(sx, c.level),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.title, style: context.text.titleSmall),
                          const SizedBox(height: 1),
                          Text(c.detail, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ?footer,
          ],
        ),
      ),
    );
  }
}

class _HardwareCard extends StatelessWidget {
  const _HardwareCard({required this.report});

  final UsedPhoneReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final c = report.checkup;
    return _GroupCard(
      report: report,
      group: CheckGroup.hardware,
      icon: SxIcons.touch,
      color: sx.accent,
      title: l.upHardwareTitle,
      footer: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c == null
                  ? l.upHardwareNone
                  : l.upHardwareDoneAt(
                      DateFormat.jm(l.localeName).format(c.at),
                      c.count(TestStatus.passed),
                      c.results.length,
                    ),
              style: context.text.bodySmall?.copyWith(color: sx.muted),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: c == null
                  ? FilledButton.icon(
                      onPressed: () => context.push(Routes.checkup),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(l.upRunCheckup),
                    )
                  : OutlinedButton(
                      onPressed: () => context.push(Routes.checkup),
                      child: Text(l.upRunAgain),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What the phone says it is, to compare with the listing and the box.
List<(String, String)> identityRows(AppLocalizations l, DeviceSnapshot snap) {
  final id = snap.identity;
  return [
    if (id != null) (l.specModelName, '${id.manufacturer} ${id.marketName}'),
    if (id != null) (l.specModel, id.model),
    if (snap.storage != null)
      (l.upStorage, '${boxStorageGb(snap.storage!)} GB'),
    if (snap.memory != null) (l.upRam, '${boxRamGb(snap.memory!)} GB'),
    if (snap.system != null)
      (l.specAndroidVersion, androidName(snap.system!.sdk)),
    if (id?.salesCountry != null || id?.salesCode != null)
      (
        l.upRegion,
        [id!.salesCountry, id.salesCode].whereType<String>().join(' · '),
      ),
  ];
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.snap});

  final DeviceSnapshot snap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.upIdentityBody,
            style: context.text.bodySmall?.copyWith(color: sx.muted),
          ),
          const SizedBox(height: 6),
          for (final (k, v) in identityRows(l, snap))
            InfoRow(label: k, value: v),
        ],
      ),
    );
  }
}

class _ChecklistCard extends ConsumerWidget {
  const _ChecklistCard({required this.ticked});

  final Set<BuyerCheck> ticked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final total = BuyerCheck.values.length;
    final api = ref.read(deviceApiProvider);
    return SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.upChecklistBody,
            style: context.text.bodySmall?.copyWith(color: sx.muted),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: ticked.length / total,
                    minHeight: 6,
                    color: sx.good,
                    backgroundColor: sx.cardAlt,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l.upChecklistProgress(ticked.length, total),
                style: context.text.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final c in BuyerCheck.values) ...[
            const Divider(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: ticked.contains(c),
                  onChanged: (_) =>
                      ref.read(buyerChecklistProvider.notifier).toggle(c),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        ref.read(buyerChecklistProvider.notifier).toggle(c),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            checkTitle(l, c),
                            style: context.text.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(checkBody(l, c), style: context.text.bodySmall),
                          if (c == BuyerCheck.imei || c == BuyerCheck.accounts)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () => c == BuyerCheck.imei
                                    ? api.dial('*#06#')
                                    : api.openSettings(accountsSettings),
                                icon: Icon(
                                  c == BuyerCheck.imei
                                      ? Icons.dialpad_rounded
                                      : Icons.manage_accounts_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  c == BuyerCheck.imei
                                      ? l.bcActionImei
                                      : l.bcActionAccounts,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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

/// The report as a PDF. English only: the PDF library can't shape Bangla.
Future<Uint8List> buildUsedPhonePdf(
  AppLocalizations l,
  DeviceSnapshot snap,
  UsedPhoneReport report,
  Set<BuyerCheck> ticked,
  DateTime now,
) async {
  final body = pw.Font.ttf(await rootBundle.load('assets/fonts/Inter.ttf'));
  final theme = pw.ThemeData.withFont(base: body, bold: body);
  const ink = PdfColor.fromInt(0xFF141928);
  const muted = PdfColor.fromInt(0xFF5E6584);
  const line = PdfColor.fromInt(0xFFDDE0EA);
  const okColor = PdfColor.fromInt(0xFF14965A);
  const badColor = PdfColor.fromInt(0xFFD23A41);
  const warnColor = PdfColor.fromInt(0xFFB7791F);
  PdfColor colorOf(CheckLevel lv) => switch (lv) {
    CheckLevel.ok => okColor,
    CheckLevel.bad => badColor,
    CheckLevel.warn => warnColor,
    CheckLevel.info => muted,
  };
  String wordOf(CheckLevel lv) => switch (lv) {
    CheckLevel.ok => 'Pass',
    CheckLevel.bad => 'Fault',
    CheckLevel.warn => 'Review',
    CheckLevel.info => 'Note',
  };
  final (title, verdictBody, verdictColor) = switch (report.verdict) {
    UsedVerdict.clean => (l.upClean, l.upCleanBody, okColor),
    UsedVerdict.checkFirst => (l.upCheckFirst, l.upCheckFirstBody, warnColor),
    UsedVerdict.problems => (l.upProblems, l.upProblemsBody, badColor),
    UsedVerdict.incomplete => (l.upIncomplete, l.upIncompleteBody, muted),
  };
  String groupName(CheckGroup g) => switch (g) {
    CheckGroup.software => l.upGroupSoftware,
    CheckGroup.battery => l.upGroupBattery,
    CheckGroup.hardware => l.upGroupHardware,
  };

  pw.Widget heading(String t) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
    child: pw.Text(t, style: const pw.TextStyle(fontSize: 13, color: ink)),
  );
  pw.Widget kv(String k, String v) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.SizedBox(
          width: 150,
          child: pw.Text(
            k,
            style: const pw.TextStyle(fontSize: 10, color: muted),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            v,
            style: const pw.TextStyle(fontSize: 10, color: ink),
          ),
        ),
      ],
    ),
  );
  pw.Widget statusRow(String status, PdfColor color, String t, String d) =>
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 5),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: line, width: 0.5)),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 90,
              child: pw.Text(
                status,
                style: pw.TextStyle(fontSize: 10, color: color),
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    t,
                    style: const pw.TextStyle(fontSize: 11, color: ink),
                  ),
                  if (d.isNotEmpty)
                    pw.Text(
                      d,
                      style: const pw.TextStyle(fontSize: 9, color: muted),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  final doc = pw.Document(title: l.upCertTitle, author: 'SystemX');
  doc.addPage(
    pw.MultiPage(
      theme: theme,
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      footer: (ctx) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            l.specSheetFooter,
            style: const pw.TextStyle(fontSize: 9, color: muted),
          ),
          pw.Text(
            '${ctx.pageNumber} / ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: muted),
          ),
        ],
      ),
      build: (ctx) => [
        pw.Text(
          l.upCertTitle,
          style: const pw.TextStyle(fontSize: 24, color: ink),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          reportDate(now, l),
          style: const pw.TextStyle(fontSize: 11, color: muted),
        ),
        pw.SizedBox(height: 16),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: verdictColor, width: 1.2),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(fontSize: 16, color: verdictColor),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                l.upChecksPassed(report.passed, report.rated.length),
                style: const pw.TextStyle(fontSize: 10, color: ink),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                verdictBody,
                style: const pw.TextStyle(fontSize: 10, color: ink),
              ),
            ],
          ),
        ),
        heading(l.upIdentityTitle),
        for (final (k, v) in identityRows(l, snap)) kv(k, v),
        for (final g in CheckGroup.values)
          if (report.inGroup(g).isNotEmpty) ...[
            heading(groupName(g)),
            for (final c in report.inGroup(g))
              statusRow(wordOf(c.level), colorOf(c.level), c.title, c.detail),
          ],
        if (report.checkup == null) ...[
          heading(l.upGroupHardware),
          statusRow(l.upNotRun, muted, l.upHardwareTitle, ''),
        ],
        heading(l.upCertChecklist),
        for (final c in BuyerCheck.values)
          statusRow(
            ticked.contains(c) ? l.upCertConfirmed : l.upCertNotConfirmed,
            ticked.contains(c) ? okColor : muted,
            checkTitle(l, c),
            '',
          ),
        pw.SizedBox(height: 16),
        pw.Text(
          l.upCertNote,
          style: const pw.TextStyle(fontSize: 8.5, color: muted),
        ),
      ],
    ),
  );
  return doc.save();
}
