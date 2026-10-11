import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/background/alerts_screen.dart';
import '../features/background/history_widgets.dart';
import '../features/device/category_screen.dart';
import '../features/device/device_data.dart';
import '../features/device/device_screen.dart';
import '../features/device/search_screen.dart';
import '../features/home/home_screen.dart';
import '../features/live/live_screens.dart';
import '../features/monitor/monitor_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/settings/privacy_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/tests/checkup_screen.dart';
import '../features/tests/report_screen.dart';
import '../features/tests/test_catalog.dart';
import '../features/tests/tests_screen.dart';
import 'settings/settings.dart';

abstract final class Routes {
  static const welcome = '/welcome';
  static const home = '/home';
  static const device = '/device';
  static const search = '/device/search';
  static const tests = '/tests';
  static const monitor = '/monitor';
  static const settings = '/settings';
  static const privacy = '/settings/privacy';
  static const alerts = '/settings/alerts';
  static const sessions = '/sessions';

  static String category(DeviceCategory c) => '$device/${c.name}';
  static String live(LiveMetric m) => '/live/${m.name}';
  static const checkup = '/checkup';
  static String runTest(HwTest t) => '/test/${t.name}';
  static String report(int index) => '/report/$index';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Read once: the router is created at startup and onboarding navigates
  // explicitly when it finishes, so it never needs rebuilding.
  final onboarded = ref.read(settingsProvider).onboardingDone;

  return GoRouter(
    initialLocation: onboarded ? Routes.home : Routes.welcome,
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (_, _) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.device,
              builder: (_, _) => const DeviceScreen(),
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (_, _) => const SearchScreen(),
                ),
                GoRoute(
                  path: ':category',
                  redirect: (_, state) =>
                      DeviceCategory.byName(state.pathParameters['category']!) ==
                              null
                          ? Routes.device
                          : null,
                  builder: (_, state) => CategoryScreen(
                    category: DeviceCategory.byName(
                        state.pathParameters['category']!)!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.tests, builder: (_, _) => const TestsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.monitor, builder: (_, _) => const MonitorScreen()),
          ]),
        ],
      ),
      GoRoute(path: Routes.checkup, builder: (_, _) => const CheckupScreen()),
      GoRoute(path: Routes.sessions, builder: (_, _) => const SessionsScreen()),
      GoRoute(
        path: '/test/:test',
        redirect: (_, state) =>
            HwTest.byName(state.pathParameters['test']!) == null ? Routes.tests : null,
        builder: (_, state) =>
            SingleTestScreen(test: HwTest.byName(state.pathParameters['test']!)!),
      ),
      GoRoute(
        path: '/report/:index',
        builder: (_, state) =>
            ReportScreen(index: int.tryParse(state.pathParameters['index']!) ?? 0),
      ),
      GoRoute(
        path: '/live/:metric',
        redirect: (_, state) => LiveMetric.values
                .any((m) => m.name == state.pathParameters['metric'])
            ? null
            : Routes.home,
        builder: (_, state) => LiveDetailScreen(
          metric: LiveMetric.values
              .byName(state.pathParameters['metric']!),
        ),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (_, _) => const SettingsScreen(),
        routes: [
          GoRoute(path: 'privacy', builder: (_, _) => const PrivacyScreen()),
          GoRoute(path: 'alerts', builder: (_, _) => const AlertsScreen()),
        ],
      ),
    ],
  );
});
