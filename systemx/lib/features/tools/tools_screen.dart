import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';

/// One tool on the Tools tab.
class ToolEntry {
  const ToolEntry(this.icon, this.color, this.label, this.route);

  final IconData icon;
  final Color color;
  final String label;
  final String route;
}

/// The Tools tab's sections, in order. Built from the context so labels
/// follow the language and colors the theme.
List<(String, List<ToolEntry>)> toolSections(AppLocalizations l, SxColors sx) => [
      (l.tsMonitor, [
        ToolEntry(SxIcons.tabMonitorOn, sx.accent, l.monitorTitle, Routes.monitor),
        ToolEntry(SxIcons.notifications, sx.accent, l.tsLiveStatus, Routes.alerts),
      ]),
      (l.tsCheck, [
        ToolEntry(SxIcons.security, sx.good, l.upTitle, Routes.usedPhone),
        ToolEntry(SxIcons.speed, sx.cpu, l.stTitle, Routes.stress),
        ToolEntry(SxIcons.display, sx.display, l.rrTitle, Routes.refreshRate),
        ToolEntry(SxIcons.touch, sx.accent, l.trTitle, Routes.touchRate),
      ]),
      (l.tsUsage, [
        ToolEntry(SxIcons.screenTime, sx.accent, l.stmTitle, Routes.screenTime),
        ToolEntry(SxIcons.dataUsage, sx.network, l.duTitle, Routes.dataUsage),
        ToolEntry(SxIcons.battery, sx.battery, l.bhTitle, Routes.batteryHealth),
        ToolEntry(SxIcons.charging, sx.battery, l.chargingSessions, Routes.sessions),
        ToolEntry(SxIcons.apps, sx.storage, l.appsTitle, Routes.apps),
      ]),
      (l.tsNetwork, [
        ToolEntry(SxIcons.network, sx.network, l.wifiMeter, Routes.wifiMeter),
      ]),
    ];

/// Every tool in one place, grouped like the sections above.
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return PageScaffold(
      title: l.toolsTitle,
      slivers: [
        for (final (title, tools) in toolSections(l, sx)) ...[
          SliverToBoxAdapter(child: SectionLabel(title)),
          SliverGrid.builder(
            itemCount: tools.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              // Grows with the font size so two-line labels still fit.
              mainAxisExtent: 66 + MediaQuery.textScalerOf(context).scale(36),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, i) => ToolTile(tool: tools[i]),
          ),
        ],
      ],
    );
  }
}

class ToolTile extends StatelessWidget {
  const ToolTile({super.key, required this.tool});

  final ToolEntry tool;

  @override
  Widget build(BuildContext context) => Semantics(
        label: tool.label,
        button: true,
        excludeSemantics: true,
        child: SxCard(
          onTap: () => context.push(tool.route),
          radius: SxRadius.tile,
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconBadge(tool.icon, color: tool.color, size: 40),
            const SizedBox(height: 8),
            Text(
              tool.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall,
            ),
          ]),
        ),
      );
}
