import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';

/// Bottom navigation shell. Each tab keeps its own scroll position.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(SxIcons.tabHome),
            selectedIcon: const Icon(SxIcons.tabHomeOn),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(SxIcons.tabDevice),
            selectedIcon: const Icon(SxIcons.tabDeviceOn),
            label: l.navDevice,
          ),
          NavigationDestination(
            icon: const Icon(SxIcons.tabTests),
            selectedIcon: const Icon(SxIcons.tabTestsOn),
            label: l.navTests,
          ),
          NavigationDestination(
            icon: const Icon(SxIcons.tabMonitor),
            selectedIcon: const Icon(SxIcons.tabMonitorOn),
            label: l.navMonitor,
          ),
        ],
      ),
    );
  }
}
