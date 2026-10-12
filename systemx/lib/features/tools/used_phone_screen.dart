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
import '../../ui/widgets/page_scaffold.dart';
import '../background/background.dart';
import '../background/battery_health.dart';
import '../device/device_data.dart';
import '../tests/report_pdf.dart';
import '../tests/test_results.dart';
import 'used_phone.dart';

/// Guided check for buying a second-hand phone: the seller's claims, the
/// software, the battery and a hardware checkup, ending in a verdict and a
/// PDF report the buyer and seller can keep.
class UsedPhoneScreen extends ConsumerStatefulWidget {
  const UsedPhoneScreen({super.key});

  @override
  ConsumerState<UsedPhoneScreen> createState() => _UsedPhoneScreenState();
}

class _UsedPhoneScreenState extends ConsumerState<UsedPhoneScreen> {
  final _model = TextEditingController();
  final _country = TextEditingController();
  int? _storage;
  int? _ram;
  bool _busy = false;

  @override
  void dispose() {
    _model.dispose();
    _country.dispose();
    super.dispose();
  }

  SellerClaims get _claims => SellerClaims(
        model: _model.text,
        storageGb: _storage,
        ramGb: _ram,
        country: _country.text,
      );

  UsedPhoneReport? _report(AppLocalizations l) {
    final snap = ref.watch(fullSnapshotProvider).value;
    final history = ref.watch(testHistoryProvider).value;
    if (snap == null || history == null) return null;
    final sessions = ref.watch(sessionsProvider).value ?? const <ChargeSession>[];
    final cap = estimateCapacity(sessions, snap.battery?.designCapacityMah).percentOfDesign;
    return evaluateUsedPhone(
      l: l,
      snap: snap,
      claims: _claims,
      history: history,
      capacityPercent: cap,
      now: DateTime.now(),
    );
  }

  Future<void> _savePdf() async {
    setState(() => _busy = true);
    try {
      final en = lookupAppLocalizations(const Locale('en'));
      final snap = ref.read(fullSnapshotProvider).value;
      final history = ref.read(testHistoryProvider).value ?? const TestHistory();
      final sessions = ref.read(sessionsProvider).value ?? const <ChargeSession>[];
      if (snap == null) return;
      final now = DateTime.now();
      final report = evaluateUsedPhone(
        l: en,
        snap: snap,
        claims: _claims,
        history: history,
        capacityPercent: estimateCapacity(sessions, snap.battery?.designCapacityMah).percentOfDesign,
        now: now,
      );
      final bytes = await buildUsedPhonePdf(en, snap, _claims, report, now);
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
    final report = _report(l);
    final checkup = report?.checkup;

    Widget dropdown(String hint, List<int> sizes, int? value, ValueChanged<int?> onChanged) =>
        DropdownButtonFormField<int?>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(labelText: hint),
          items: [
            DropdownMenuItem(value: null, child: Text(l.upNotSure)),
            for (final s in sizes) DropdownMenuItem(value: s, child: Text(s >= 1024 ? '${s ~/ 1024} TB' : '$s GB')),
          ],
          onChanged: onChanged,
        );

    return PageScaffold(
      title: l.upTitle,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconBadge(SxIcons.security, color: sx.good),
            const SizedBox(width: 14),
            Expanded(child: Text(l.upIntro, style: context.text.bodyMedium)),
          ]),
        )),
        Box(SxCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.upClaimsTitle, style: context.text.titleMedium),
            const SizedBox(height: 4),
            Text(l.upClaimsBody, style: context.text.bodySmall?.copyWith(color: sx.muted)),
            const SizedBox(height: 12),
            TextField(
              controller: _model,
              decoration: InputDecoration(labelText: l.upModelHint),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: dropdown(l.upStorageHint, storageSizes, _storage, (v) => setState(() => _storage = v))),
              const SizedBox(width: 10),
              Expanded(child: dropdown(l.upRamHint, ramSizes, _ram, (v) => setState(() => _ram = v))),
            ]),
            const SizedBox(height: 10),
            TextField(
              controller: _country,
              decoration: InputDecoration(labelText: l.upCountryHint),
              onChanged: (_) => setState(() {}),
            ),
          ]),
        )),
        Box(SxCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.upHardwareTitle, style: context.text.titleMedium),
            const SizedBox(height: 4),
            Text(
              checkup == null
                  ? l.upHardwareNone
                  : l.upHardwareDone(
                      DateFormat.jm(l.localeName).format(checkup.at),
                      checkup.count(TestStatus.passed),
                      checkup.results.length,
                    ),
              style: context.text.bodySmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: checkup == null
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
          ]),
        )),
        if (report != null) ...[
          Box(_VerdictCard(report: report)),
          Box(_ChecksCard(report: report)),
        ],
        Box(SxCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.upTipsTitle, style: context.text.titleMedium),
            const SizedBox(height: 8),
            for (final tip in [l.upTipImei, l.upTipAccount, l.upTipBox])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 10),
                    child: Icon(Icons.check_rounded, size: 18, color: sx.good),
                  ),
                  Expanded(child: Text(tip, style: context.text.bodyMedium)),
                ]),
              ),
            TextButton.icon(
              onPressed: () => ref.read(deviceApiProvider).dial('*#06#'),
              icon: const Icon(Icons.dialpad_rounded),
              label: Text(l.upDialImei),
            ),
          ]),
        )),
        Box(
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: report == null || _busy ? null : _savePdf,
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: Text(l.upCertificate),
            ),
          ),
          bottom: 0,
        ),
      ],
    );
  }
}

(String, String, Color) verdictLook(AppLocalizations l, SxColors sx, UsedVerdict v) => switch (v) {
      UsedVerdict.clean => (l.upClean, l.upCleanBody, sx.good),
      UsedVerdict.checkFirst => (l.upCheckFirst, l.upCheckFirstBody, sx.warn),
      UsedVerdict.problems => (l.upProblems, l.upProblemsBody, sx.bad),
      UsedVerdict.incomplete => (l.upIncomplete, l.upIncompleteBody, sx.muted),
    };

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.report});

  final UsedPhoneReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final (title, body, color) = verdictLook(l, sx, report.verdict);
    final icon = switch (report.verdict) {
      UsedVerdict.clean => SxIcons.passed,
      UsedVerdict.problems => SxIcons.failed,
      _ => SxIcons.notTested,
    };
    return SxCard(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 34),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: context.text.titleLarge?.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(body, style: context.text.bodyMedium),
          ]),
        ),
      ]),
    );
  }
}

class _ChecksCard extends StatelessWidget {
  const _ChecksCard({required this.report});

  final UsedPhoneReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    String group(CheckGroup g) => switch (g) {
          CheckGroup.claims => l.upGroupClaims,
          CheckGroup.software => l.upGroupSoftware,
          CheckGroup.battery => l.upGroupBattery,
          CheckGroup.hardware => l.upGroupHardware,
        };
    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.upResults, style: context.text.titleMedium),
        for (final g in CheckGroup.values)
          if (report.checks.any((c) => c.group == g)) ...[
            const SizedBox(height: 14),
            Eyebrow(group(g)),
            const SizedBox(height: 4),
            for (final c in report.checks.where((c) => c.group == g))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1, right: 10),
                    child: Icon(
                      switch (c.level) {
                        CheckLevel.ok => SxIcons.passed,
                        CheckLevel.bad => SxIcons.failed,
                        CheckLevel.warn => Icons.error_rounded,
                        CheckLevel.info => Icons.info_rounded,
                      },
                      size: 20,
                      color: switch (c.level) {
                        CheckLevel.ok => sx.good,
                        CheckLevel.bad => sx.bad,
                        CheckLevel.warn => sx.warn,
                        CheckLevel.info => sx.muted,
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.title, style: context.text.titleSmall),
                      Text(c.detail, style: context.text.bodySmall),
                    ]),
                  ),
                ]),
              ),
          ],
      ]),
    );
  }
}

/// The report as a PDF. English only: the PDF library can't shape Bangla.
Future<Uint8List> buildUsedPhonePdf(
  AppLocalizations l,
  DeviceSnapshot snap,
  SellerClaims claims,
  UsedPhoneReport report,
  DateTime now,
) async {
  final body = pw.Font.ttf(await rootBundle.load('assets/fonts/Inter.ttf'));
  final theme = pw.ThemeData.withFont(base: body, bold: body);
  const ink = PdfColor.fromInt(0xFF141928);
  const muted = PdfColor.fromInt(0xFF5E6584);
  const line = PdfColor.fromInt(0xFFDDE0EA);
  PdfColor levelColor(CheckLevel lv) => switch (lv) {
        CheckLevel.ok => const PdfColor.fromInt(0xFF14965A),
        CheckLevel.bad => const PdfColor.fromInt(0xFFD23A41),
        CheckLevel.warn => const PdfColor.fromInt(0xFFB7791F),
        CheckLevel.info => muted,
      };
  String levelWord(CheckLevel lv) => switch (lv) {
        CheckLevel.ok => 'OK',
        CheckLevel.bad => 'Problem',
        CheckLevel.warn => 'Check',
        CheckLevel.info => 'Note',
      };
  final (title, verdictBody) = switch (report.verdict) {
    UsedVerdict.clean => (l.upClean, l.upCleanBody),
    UsedVerdict.checkFirst => (l.upCheckFirst, l.upCheckFirstBody),
    UsedVerdict.problems => (l.upProblems, l.upProblemsBody),
    UsedVerdict.incomplete => (l.upIncomplete, l.upIncompleteBody),
  };
  final verdictColor = switch (report.verdict) {
    UsedVerdict.clean => levelColor(CheckLevel.ok),
    UsedVerdict.checkFirst => levelColor(CheckLevel.warn),
    UsedVerdict.problems => levelColor(CheckLevel.bad),
    UsedVerdict.incomplete => muted,
  };

  final id = snap.identity;
  final facts = <(String, String)>[
    if (id != null) (l.specModelName, '${id.manufacturer} ${id.marketName}'),
    if (id != null) (l.specModel, id.model),
    if (snap.storage != null) (l.upStorage, '${boxStorageGb(snap.storage!)} GB'),
    if (snap.memory != null) (l.upRam, '${boxRamGb(snap.memory!)} GB'),
    if (snap.system != null) (l.specAndroidVersion, androidName(snap.system!.sdk)),
    if (id?.salesCountry != null || id?.salesRegion != null)
      (l.upRegion, [id!.salesCountry, id.salesCode].whereType<String>().join(' · ')),
  ];
  final claimText = [
    if (claims.model.trim().isNotEmpty) claims.model.trim(),
    if (claims.storageGb != null) '${claims.storageGb} GB',
    if (claims.ramGb != null) '${claims.ramGb} GB RAM',
    if (claims.country.trim().isNotEmpty) claims.country.trim(),
  ].join(' · ');

  pw.Widget row(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(children: [
          pw.SizedBox(width: 150, child: pw.Text(k, style: const pw.TextStyle(fontSize: 10, color: muted))),
          pw.Expanded(child: pw.Text(v, style: const pw.TextStyle(fontSize: 10, color: ink))),
        ]),
      );

  final doc = pw.Document(title: l.upCertTitle, author: 'SystemX');
  doc.addPage(pw.MultiPage(
    theme: theme,
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    footer: (ctx) => pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(l.specSheetFooter, style: const pw.TextStyle(fontSize: 9, color: muted)),
      pw.Text('${ctx.pageNumber} / ${ctx.pagesCount}', style: const pw.TextStyle(fontSize: 9, color: muted)),
    ]),
    build: (ctx) => [
      pw.Text(l.upCertTitle, style: const pw.TextStyle(fontSize: 24, color: ink)),
      pw.SizedBox(height: 4),
      pw.Text(reportDate(now, l), style: const pw.TextStyle(fontSize: 11, color: muted)),
      pw.SizedBox(height: 16),
      pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: verdictColor, width: 1.2), borderRadius: pw.BorderRadius.circular(8)),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 16, color: verdictColor)),
          pw.SizedBox(height: 3),
          pw.Text(verdictBody, style: const pw.TextStyle(fontSize: 10, color: ink)),
        ]),
      ),
      pw.SizedBox(height: 16),
      pw.Text(l.reportPhone, style: const pw.TextStyle(fontSize: 13, color: ink)),
      pw.SizedBox(height: 6),
      for (final (k, v) in facts) row(k, v),
      row(l.upCertClaims, claimText.isEmpty ? l.upCertNone : claimText),
      pw.SizedBox(height: 16),
      pw.Text(l.upResults, style: const pw.TextStyle(fontSize: 13, color: ink)),
      pw.SizedBox(height: 6),
      for (final c in report.checks)
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: line, width: 0.5))),
          child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.SizedBox(
              width: 60,
              child: pw.Text(levelWord(c.level), style: pw.TextStyle(fontSize: 10, color: levelColor(c.level))),
            ),
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(c.title, style: const pw.TextStyle(fontSize: 11, color: ink)),
                pw.Text(c.detail, style: const pw.TextStyle(fontSize: 9, color: muted)),
              ]),
            ),
          ]),
        ),
      pw.SizedBox(height: 14),
      pw.Text(l.upCertNote, style: const pw.TextStyle(fontSize: 8.5, color: muted)),
    ],
  ));
  return doc.save();
}
