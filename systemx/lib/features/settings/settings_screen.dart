import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/links.dart';
import '../../core/router.dart';
import '../../platform/platform.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../background/background.dart';
import '../tests/test_results.dart';

final _packageInfoProvider =
    FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

/// Wallpaper colors exist on Android 12+ only.
final _dynamicSupportedProvider = FutureProvider<bool>(
    (ref) async => await DynamicColorPlugin.getCorePalette() != null);

/// Deletes history, charging sessions and test results after confirming.
Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.clearHistory),
      content: Text(l.clearHistoryConfirm),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.clear)),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await ref.read(backgroundApiProvider).clearHistory();
  } catch (_) {}
  await ref.read(testHistoryProvider.notifier).clear();
  ref.invalidate(historyProvider);
  ref.invalidate(sessionsProvider);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.historyCleared)));
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final version = ref.watch(_packageInfoProvider).value;
    final dynamicSupported =
        ref.watch(_dynamicSupportedProvider).value ?? false;

    return PageScaffold(
      title: l.settingsTitle,
      leading: const BackButton(),
      slivers: [
        SliverList.list(children: [
          // Appearance
          SectionLabel(l.secAppearance),
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              _ChoiceRow<ThemeMode>(
                title: l.theme,
                value: s.themeMode,
                onChanged: n.setThemeMode,
                options: {
                  ThemeMode.system: l.themeSystem,
                  ThemeMode.light: l.themeLight,
                  ThemeMode.dark: l.themeDark,
                },
              ),
              const Divider(indent: 16, endIndent: 16),
              SwitchListTile(
                title: Text(l.pureBlack),
                subtitle: Text(l.pureBlackSub),
                value: s.pureBlack,
                onChanged: s.themeMode == ThemeMode.light ? null : n.setPureBlack,
              ),
              if (dynamicSupported)
                SwitchListTile(
                  title: Text(l.wallpaperColors),
                  subtitle: Text(l.wallpaperColorsSub),
                  value: s.dynamicColor,
                  onChanged: n.setDynamicColor,
                ),
            ]),
          ),

          // Units & live data
          SectionLabel(l.secUnits),
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              _ChoiceRow<TempUnit>(
                title: l.temperature,
                value: s.tempUnit,
                onChanged: n.setTempUnit,
                options: const {
                  TempUnit.celsius: '°C',
                  TempUnit.fahrenheit: '°F',
                },
              ),
              const Divider(indent: 16, endIndent: 16),
              _ChoiceRow<RefreshRate>(
                title: l.refreshRate,
                value: s.refreshRate,
                onChanged: n.setRefreshRate,
                options: {
                  RefreshRate.fast: l.seconds('0.5'),
                  RefreshRate.normal: l.seconds('1'),
                  RefreshRate.relaxed: l.seconds('2'),
                },
              ),
            ]),
          ),

          // Language
          SectionLabel(l.secLanguage),
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              for (final (code, label) in [
                (null, l.langSystem),
                ('en', l.langEnglish),
                ('bn', l.langBangla),
              ])
                ListTile(
                  title: Text(label),
                  trailing: s.localeCode == code
                      ? Icon(Icons.check_rounded, color: sx.accent)
                      : null,
                  onTap: () => n.setLocale(code),
                ),
            ]),
          ),

          // Alerts
          SectionLabel(l.secAlerts),
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: IconBadge(SxIcons.notifications, color: sx.accent, size: 36),
              title: Text(l.alertsTitle),
              subtitle: Text(l.alertsRowSub),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(Routes.alerts),
            ),
          ),

          // Privacy
          SectionLabel(l.secPrivacy),
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              ListTile(
                leading: IconBadge(SxIcons.security, color: sx.good, size: 36),
                title: Text(l.privacyPermissions),
                subtitle: Text(l.privacyPermissionsSub),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.privacy),
              ),
              const Divider(indent: 66, endIndent: 14),
              ListTile(
                leading: IconBadge(Icons.delete_outline_rounded, color: sx.bad, size: 36),
                title: Text(l.clearHistory),
                subtitle: Text(l.clearHistorySub),
                onTap: () => _confirmClear(context, ref),
              ),
            ]),
          ),

          // About
          SectionLabel(l.secAbout),
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              ListTile(
                title: Text(l.version),
                trailing: Text(
                  version == null ? '' : '${version.version} (${version.buildNumber})',
                  style: context.text.bodyMedium?.copyWith(color: sx.muted),
                ),
              ),
              ListTile(
                title: Text(l.privacyPolicy),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.policy),
              ),
              if (AppLinks.feedbackEmail.isNotEmpty)
                ListTile(
                  title: Text(l.sendFeedback),
                  trailing: const Icon(Icons.mail_outline_rounded),
                  onTap: () => ref.read(deviceApiProvider).openLink(
                      'mailto:${AppLinks.feedbackEmail}?subject=SystemX%20feedback'),
                ),
              ListTile(
                title: Text(l.licenses),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'SystemX',
                  applicationVersion: version?.version,
                ),
              ),
              ListTile(
                title: Text(l.replayIntro),
                trailing: const Icon(Icons.replay_rounded),
                onTap: () async {
                  await n.resetOnboarding();
                  if (context.mounted) context.go(Routes.welcome);
                },
              ),
            ]),
          ),
        ]),
      ],
    );
  }
}

/// Title above a full-width segmented control.
class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.text.titleSmall),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<T>(
              showSelectedIcon: false,
              segments: [
                for (final e in options.entries)
                  ButtonSegment(value: e.key, label: Text(e.value)),
              ],
              selected: {value},
              onSelectionChanged: (sel) => onChanged(sel.first),
            ),
          ),
        ],
      ),
    );
  }
}
