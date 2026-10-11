import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../device/device_data.dart';
import 'report_pdf.dart';
import 'test_results.dart';
import 'test_runner.dart';

/// A checkup's report: score, failures first (each with a fix), then the
/// rest. Exports to PDF for saving or sharing.
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key, required this.index});

  /// Position in the checkup history, 0 = newest.
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final history = ref.watch(testHistoryProvider).value;
    final c = history == null || index >= history.checkups.length
        ? null
        : history.checkups[index];

    if (c == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.reportTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final score = c.score;
    final color = score >= 90 ? sx.good : score >= 70 ? sx.warn : sx.bad;
    final passed = c.count(TestStatus.passed);
    final failed = c.count(TestStatus.failed);
    final skipped = c.count(TestStatus.skipped);
    final snap = ref.watch(fullSnapshotProvider).value;

    Future<void> export({required bool share}) async {
      final pdf = await buildReportPdf(c, l, snap);
      if (!context.mounted) return;
      final name = reportFileName(c);
      final ok = share
          ? await ref.read(shareFileProvider)(pdf, name, l.reportShareSubject)
          : await ref.read(saveFileProvider)(pdf, name);
      if (!share && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ok ? l.reportSaved : l.reportNotSaved)));
      }
    }

    return PageScaffold(
      title: l.reportTitle,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            GaugeRing(
              value: score / 100,
              color: color,
              size: 104,
              stroke: 11,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('$score', style: context.text.displaySmall),
                Eyebrow(l.ofHundred),
              ]),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(reportHeadline(l, score), style: context.text.titleLarge),
                const SizedBox(height: 4),
                Text(l.reportCounts(passed, failed, skipped), style: context.text.bodySmall),
                Text(reportDate(c.at, l), style: context.text.bodySmall),
              ]),
            ),
          ]),
        )),
        Box(SxCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: [
            for (final (i, r) in c.ordered.indexed) ...[
              if (i > 0) const Divider(indent: 56, endIndent: 16),
              _ResultRow(result: r),
            ],
          ]),
        )),
        Box(
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => export(share: false),
                icon: const Icon(Icons.save_alt_rounded),
                label: Text(l.savePdf),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => export(share: true),
                icon: const Icon(Icons.share_rounded),
                label: Text(l.shareReport),
              ),
            ),
          ]),
          bottom: 0,
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result});
  final TestResult result;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final (icon, color, word) = statusLook(context, result.status);
    final fix = result.status == TestStatus.failed ? fixHint(l, result.test) : null;
    final detail = [?result.note, ?fix].join('\n');
    return Semantics(
      label: '${result.test.title(l)}, $word. $detail',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 18),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(result.test.title(l), style: context.text.titleSmall),
              if (detail.isNotEmpty)
                Text(detail, style: context.text.bodySmall?.copyWith(color: sx.muted)),
            ]),
          ),
        ]),
      ),
    );
  }
}
