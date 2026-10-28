import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../background/background.dart';
import '../device/device_data.dart';

/// Screens at least this wide (tablets, unfolded foldables, landscape)
/// get a side rail instead of the bottom bar.
const railBreakpoint = 840.0;

/// Least time between two refreshes of the tabs' data.
const _refreshEvery = Duration(minutes: 1);

/// Navigation shell. Each tab keeps its own scroll position.
///
/// The tabs stay alive while hidden, so their data would never reload on
/// its own: it is refreshed when the app comes back to the front (a screen
/// lock set in Settings, storage freed) and every few minutes for history.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  late final AppLifecycleListener _lifecycle;
  Timer? _history;
  DateTime _refreshed = DateTime.now();

  StatefulNavigationShell get shell => widget.shell;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _refresh);
    _history = Timer.periodic(const Duration(minutes: 5), (_) => ref.invalidate(historyProvider));
  }

  void _refresh() {
    final now = DateTime.now();
    if (now.difference(_refreshed) < _refreshEvery) return;
    _refreshed = now;
    ref
      ..invalidate(homeSnapshotProvider)
      ..invalidate(fullSnapshotProvider)
      ..invalidate(historyProvider)
      ..invalidate(sessionsProvider);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _history?.cancel();
    super.dispose();
  }

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
