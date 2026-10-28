import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../../ui/widgets/test_tile.dart';
import 'checkup_screen.dart';
import 'test_catalog.dart';
import 'test_results.dart';
import 'test_runner.dart';

class TestsScreen extends ConsumerWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final history = ref.watch(testHistoryProvider).value ?? const TestHistory();
    final last = history.lastCheckup;

    return PageScaffold(
      title: l.testsTitle,
      slivers: [
        Box(SxCard(
          gradient: heroGradient(sx),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(l.checkupTitle, color: sx.onHero),
              const SizedBox(height: 8),
              Text(l.checkupMeta(HwTest.values.length, checkupMinutes),
                  style: context.text.titleLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 6),
              Text(l.checkupBody,
                  style: context.text.bodyMedium?.copyWith(color: sx.onHero)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: sx.onHero,
                    foregroundColor: sx.heroEnd,
                  ),
                  onPressed: () => context.push(Routes.checkup),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l.startCheckup),
                ),
              ),
            ],
          ),
        )),
        if (last != null)
          Box(SxCard(
            onTap: () => context.push(Routes.report(0)),
            child: Row(children: [
              Text(last.scoreText, style: context.text.displaySmall),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.lastCheckup, style: context.text.titleSmall),
                  Text(
                    '${formatDate(last.at, l.localeName)} · ${l.passedOf(last.count(TestStatus.passed), last.results.length)}',
                    style: context.text.bodySmall,
                  ),
                ]),
              ),
              Icon(Icons.chevron_right_rounded, color: sx.muted),
            ]),
          )),
        SliverToBoxAdapter(child: SectionLabel(l.toolsTitle)),
        Box(SxCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(children: [
            CategoryRow(
              icon: SxIcons.security,
              color: sx.good,
              title: l.upTitle,
              subtitle: l.upEntryBody,
              onTap: () => context.push(Routes.usedPhone),
            ),
            const Divider(indent: 66, endIndent: 14),
            CategoryRow(
              icon: SxIcons.speed,
              color: sx.cpu,
              title: l.stTitle,
              subtitle: l.stEntryBody,
              onTap: () => context.push(Routes.stress),
            ),
            const Divider(indent: 66, endIndent: 14),
            CategoryRow(
              icon: SxIcons.display,
              color: sx.display,
              title: l.rrTitle,
              subtitle: l.rrEntryBody,
              onTap: () => context.push(Routes.refreshRate),
            ),
            const Divider(indent: 66, endIndent: 14),
            CategoryRow(
              icon: SxIcons.touch,
              color: sx.accent,
              title: l.trTitle,
              subtitle: l.trEntryBody,
              onTap: () => context.push(Routes.touchRate),
            ),
          ]),
        )),
        for (final g in TestGroup.values) ...[
          SliverToBoxAdapter(child: SectionLabel(groupTitle(l, g))),
          SliverGrid.builder(
            itemCount: HwTest.values.where((t) => t.group == g).length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 130,
              // Grows with the font size so two-line labels still fit.
              mainAxisExtent: 70 + MediaQuery.textScalerOf(context).scale(42),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, i) {
              final t = HwTest.values.where((t) => t.group == g).elementAt(i);
              final status = history.latest[t]?.status ?? TestStatus.notRun;
              return TestTile(
                icon: t.icon,
                color: t.color(sx),
                label: t.title(l),
                status: status,
                statusLabel: statusLook(context, status).$3,
                onTap: () => context.push(Routes.runTest(t)),
              );
            },
          ),
        ],
        if (history.checkups.length > 1) ...[
          SliverToBoxAdapter(child: SectionLabel(l.pastCheckups)),
          Box(
            SxCard(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(children: [
                for (final (i, c) in history.checkups.indexed)
                  ListTile(
                    title: Text(formatDate(c.at, l.localeName)),
                    subtitle: Text(l.passedOf(c.count(TestStatus.passed), c.results.length)),
                    trailing: Text(c.scoreText, style: context.text.titleLarge),
                    onTap: () => context.push(Routes.report(i)),
                  ),
              ]),
            ),
            bottom: 0,
          ),
        ],
      ],
    );
  }
}
