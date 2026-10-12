import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';

/// Screens at least this wide (tablets, unfolded foldables, landscape)
/// get a side rail instead of the bottom bar.
const railBreakpoint = 840.0;

/// Navigation shell. Each tab keeps its own scroll position.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tabs = [
      (SxIcons.tabHome, SxIcons.tabHomeOn, l.navHome),
      (SxIcons.tabDevice, SxIcons.tabDeviceOn, l.navDevice),
      (SxIcons.tabTests, SxIcons.tabTestsOn, l.navTests),
      (SxIcons.tabMonitor, SxIcons.tabMonitorOn, l.navMonitor),
    ];

    if (MediaQuery.sizeOf(context).width >= railBreakpoint) {
      return Scaffold(
        body: Row(children: [
          NavigationRail(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _go,
            labelType: NavigationRailLabelType.all,
            groupAlignment: -0.85,
            destinations: [
              for (final (icon, on, label) in tabs)
                NavigationRailDestination(
                  icon: Icon(icon),
                  selectedIcon: Icon(on),
                  label: Text(label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: shell),
        ]),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _go,
        destinations: [
          for (final (icon, on, label) in tabs)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: Icon(on),
              label: label,
            ),
        ],
      ),
    );
  }
}
