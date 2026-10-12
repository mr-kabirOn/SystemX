import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/format.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../device/device_data.dart';
import '../device/spec_sheets.dart';
import 'test_results.dart';
import 'test_runner.dart' show fixHint;

String reportDate(DateTime at, AppLocalizations l) =>
    '${formatDate(at, l.localeName)}, ${DateFormat.jm(l.localeName).format(at)}';

String reportFileName(Checkup c) =>
    'SystemX-checkup-${DateFormat('yyyy-MM-dd-HHmm').format(c.at)}.pdf';

/// Saves bytes through the system "save as" picker. Overridden in tests.
final saveFileProvider =
    Provider<Future<bool> Function(Uint8List bytes, String name)>((ref) {
  final hw = ref.watch(hardwareTestApiProvider);
  return (bytes, name) => hw.saveDocument(name, 'application/pdf', bytes);
});

/// Shares a file through the Android share sheet. Overridden in tests.
final shareFileProvider =
    Provider<Future<bool> Function(Uint8List bytes, String name, String subject)>(
  (ref) => (bytes, name, subject) async {
    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/$name');
    await f.writeAsBytes(bytes, flush: true);
    final r = await SharePlus.instance.share(ShareParams(
      files: [XFile(f.path, mimeType: 'application/pdf')],
      subject: subject,
    ));
    return r.status == ShareResultStatus.success;
  },
);

/// The checkup report as a PDF, made entirely on the phone.
Future<Uint8List> buildReportPdf(
    Checkup c, AppLocalizations l, DeviceSnapshot? snap) async {
  final body = pw.Font.ttf(await rootBundle.load('assets/fonts/Inter.ttf'));
  final mono = pw.Font.ttf(await rootBundle.load('assets/fonts/JetBrainsMono.ttf'));
  final theme = pw.ThemeData.withFont(base: body, bold: body);

  const ink = PdfColor.fromInt(0xFF141928);
  const muted = PdfColor.fromInt(0xFF5E6584);
  const line = PdfColor.fromInt(0xFFDDE0EA);
  PdfColor statusColor(TestStatus s) => switch (s) {
        TestStatus.passed => const PdfColor.fromInt(0xFF14965A),
        TestStatus.failed => const PdfColor.fromInt(0xFFD23A41),
        _ => muted,
      };
  String word(TestStatus s) => switch (s) {
        TestStatus.passed => l.statusPassed,
        TestStatus.failed => l.statusFailed,
        TestStatus.skipped => l.statusSkipped,
        TestStatus.notRun => l.statusNotRun,
      };

  final identity = snap?.identity;
  final system = snap?.system;
  final b = SpecBuilder(l);
  final facts = <(String, String)>[
    if (identity != null) (l.specModelName, '${identity.manufacturer} ${identity.marketName} (${identity.model})'),
    if (system != null) (l.specAndroidVersion, '${androidName(system.sdk)} · ${l.specSecurityPatch} ${system.securityPatch ?? '–'}'),
    if (snap?.cpu != null) (l.specChip, SpecBuilder.chipName(snap!.cpu!) ?? '–'),
    if (snap?.memory != null) (l.specInstalled, formatAdvertisedRam(snap!.memory!.total)),
    if (snap?.storage != null) (l.specTotal, formatStorage(snap!.storage!.total)),
    if (snap?.battery != null) (l.factorBattery, '${b.batteryHealth(snap!.battery!.health)}${snap.battery!.cycleCount == null ? '' : ' · ${l.cyclesCount(snap.battery!.cycleCount!)}'}'),
  ];

  final doc = pw.Document(title: l.reportTitle, author: 'SystemX');
  doc.addPage(pw.MultiPage(
    theme: theme,
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    footer: (ctx) => pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(l.specSheetFooter, style: const pw.TextStyle(fontSize: 9, color: muted)),
      pw.Text('${ctx.pageNumber} / ${ctx.pagesCount}', style: const pw.TextStyle(fontSize: 9, color: muted)),
    ]),
    build: (ctx) => [
      pw.Text(l.reportTitle, style: const pw.TextStyle(fontSize: 24, color: ink)),
      pw.SizedBox(height: 4),
      pw.Text(reportDate(c.at, l), style: const pw.TextStyle(fontSize: 11, color: muted)),
      pw.SizedBox(height: 18),
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
        pw.Text('${c.score}', style: pw.TextStyle(font: mono, fontSize: 44, color: ink)),
        pw.SizedBox(width: 6),
        pw.Text('/ 100', style: pw.TextStyle(font: mono, fontSize: 14, color: muted)),
        pw.SizedBox(width: 24),
        pw.Expanded(
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(reportHeadline(l, c.score), style: const pw.TextStyle(fontSize: 15, color: ink)),
            pw.Text(l.reportCounts(c.count(TestStatus.passed), c.count(TestStatus.failed), c.count(TestStatus.skipped)),
                style: const pw.TextStyle(fontSize: 11, color: muted)),
          ]),
        ),
      ]),
      if (facts.isNotEmpty) ...[
        pw.SizedBox(height: 18),
        pw.Text(l.reportPhone, style: const pw.TextStyle(fontSize: 13, color: ink)),
        pw.SizedBox(height: 6),
        for (final (k, v) in facts)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(children: [
              pw.SizedBox(width: 150, child: pw.Text(k, style: const pw.TextStyle(fontSize: 10, color: muted))),
              pw.Expanded(child: pw.Text(v, style: const pw.TextStyle(fontSize: 10, color: ink))),
            ]),
          ),
      ],
      pw.SizedBox(height: 18),
      pw.Text(l.reportResults, style: const pw.TextStyle(fontSize: 13, color: ink)),
      pw.SizedBox(height: 6),
      for (final r in c.ordered)
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: line, width: 0.5))),
          child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.SizedBox(
              width: 70,
              child: pw.Text(word(r.status), style: pw.TextStyle(fontSize: 10, color: statusColor(r.status))),
            ),
            pw.Expanded(
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(r.test.title(l), style: const pw.TextStyle(fontSize: 11, color: ink)),
                if (r.note != null) pw.Text(r.note!, style: const pw.TextStyle(fontSize: 9, color: muted)),
                if (r.status == TestStatus.failed && fixHint(l, r.test) != null)
                  pw.Text(fixHint(l, r.test)!, style: const pw.TextStyle(fontSize: 9, color: muted)),
              ]),
            ),
          ]),
        ),
      pw.SizedBox(height: 14),
      pw.Text(l.reportDisclaimer, style: const pw.TextStyle(fontSize: 8.5, color: muted)),
    ],
  ));
  return doc.save();
}

String reportHeadline(AppLocalizations l, int score) => score >= 90
    ? l.reportGreat
    : score >= 70
        ? l.reportOk
        : l.reportNeedsWork;
