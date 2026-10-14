import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'background.dart';

/// Live status and alerts. Each is off until the user turns it on; the
/// notification permission is asked at that moment, never at launch.
class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final config = ref.watch(backgroundConfigProvider);
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));

    return PageScaffold(
      title: l.alertsTitle,
      leading: const BackButton(),
      slivers: [
        ...config.when(
          loading: () => [
            const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          ],
          error: (_, _) => [Box(Text(l.alertsUnavailable))],
          data: (c) {
            Future<void> set(BackgroundConfig Function(BackgroundConfig) edit) async {
              final next = edit(c);
              // Turning something on needs the notification permission first.
              if (needsNotifications(next) && !needsNotifications(c) ||
                  next.liveStatus && !c.liveStatus) {
                final ok = await requestPermission(context, ref, AppPermission.notifications);
                if (!ok) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l.notificationsNeeded)));
                  }
                  return;
                }
              }
              await ref.read(backgroundConfigProvider.notifier).change(edit);
            }

            String deg(int c) => unit == TempUnit.fahrenheit ? '${(c * 9 / 5 + 32).round()} °F' : '$c °C';

            return [
              Box(Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(l.alertsIntro,
                    style: context.text.bodyMedium?.copyWith(color: sx.muted)),
              )),
              SliverToBoxAdapter(child: SectionLabel(l.secLiveStatus)),
              Box(SxCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(children: [
                  SwitchListTile(
                    secondary: IconBadge(SxIcons.notifications, color: sx.accent, size: 36),
                    title: Text(l.liveStatus),
                    subtitle: Text(l.liveStatusSub),
                    value: c.liveStatus,
                    onChanged: (v) => set((c) => copyConfig(c, liveStatus: v)),
                  ),
                  if (c.liveStatus)
                    _Chips<String>(
                      title: l.statusBarShows,
                      note: l.statusBarShowsNote,
                      value: c.statusIcon,
                      options: {
                        'battery_level': l.metricBattery,
                        'battery_temp': l.temperature,
                        'net_speed': l.download,
                      },
                      onChanged: (v) => set((c) => copyConfig(c, statusIcon: v)),
                    ),
                ]),
              )),
              SliverToBoxAdapter(child: SectionLabel(l.secBatteryAlerts)),
              Box(SxCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(children: [
                  SwitchListTile(
                    title: Text(l.chargeAlarm),
                    subtitle: Text(l.chargeAlarmSub(c.chargeLimit)),
                    value: c.chargeAlarm,
                    onChanged: (v) => set((c) => copyConfig(c, chargeAlarm: v)),
                  ),
                  if (c.chargeAlarm)
                    _Chips<int>(
                      title: l.notifyAt,
                      value: c.chargeLimit,
                      options: const {80: '80%', 85: '85%', 90: '90%', 100: '100%'},
                      onChanged: (v) => set((c) => copyConfig(c, chargeLimit: v)),
                    ),
                  const Divider(indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: Text(l.chargingDone),
                    subtitle: Text(l.chargingDoneSub),
                    value: c.chargingDone,
                    onChanged: (v) => set((c) => copyConfig(c, chargingDone: v)),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: Text(l.batteryLowAlert),
                    subtitle: Text(l.batteryLowSub(c.lowLevel)),
                    value: c.batteryLow,
                    onChanged: (v) => set((c) => copyConfig(c, batteryLow: v)),
                  ),
                  if (c.batteryLow)
                    _Chips<int>(
                      title: l.notifyAt,
                      value: c.lowLevel,
                      options: const {10: '10%', 15: '15%', 20: '20%', 30: '30%'},
                      onChanged: (v) => set((c) => copyConfig(c, lowLevel: v)),
                    ),
                  const Divider(indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: Text(l.batteryHotAlert),
                    subtitle: Text(l.batteryHotSub(deg(c.hotC))),
                    value: c.batteryHot,
                    onChanged: (v) => set((c) => copyConfig(c, batteryHot: v)),
                  ),
                  if (c.batteryHot)
                    _Chips<int>(
                      title: l.notifyAt,
                      value: c.hotC,
                      options: {for (final t in const [40, 43, 45, 48]) t: deg(t)},
                      onChanged: (v) => set((c) => copyConfig(c, hotC: v)),
                    ),
                ]),
              )),
              SliverToBoxAdapter(child: SectionLabel(l.secStorageAlerts)),
              Box(SxCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(children: [
                  SwitchListTile(
                    title: Text(l.storageAlert),
                    subtitle: Text(l.storageAlertSub(c.storagePercent)),
                    value: c.storageFull,
                    onChanged: (v) => set((c) => copyConfig(c, storageFull: v)),
                  ),
                  if (c.storageFull)
                    _Chips<int>(
                      title: l.notifyAt,
                      value: c.storagePercent,
                      options: const {85: '85%', 90: '90%', 95: '95%'},
                      onChanged: (v) => set((c) => copyConfig(c, storagePercent: v)),
                    ),
                ]),
              )),
              SliverToBoxAdapter(child: SectionLabel(l.secSummaries)),
              Box(
                SxCard(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(children: [
                    SwitchListTile(
                      title: Text(l.weeklySummary),
                      subtitle: Text(l.weeklySummarySub),
                      value: c.weeklySummary,
                      onChanged: (v) => set((c) => copyConfig(c, weeklySummary: v)),
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    SwitchListTile(
                      title: Text(l.checkupReminder),
                      subtitle: Text(l.checkupReminderSub),
                      value: c.checkupReminder,
                      onChanged: (v) => set((c) => copyConfig(c, checkupReminder: v)),
                    ),
                  ]),
                ),
              ),
              Box(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(l.alertsFootnote,
                      style: context.text.bodySmall?.copyWith(color: sx.muted)),
                ),
                bottom: 0,
              ),
            ];
          },
        ),
      ],
    );
  }
}

/// A labelled single choice. Segments share the width equally and never
/// re-wrap when the selection changes, so the card stays steady.
class _Chips<T> extends StatelessWidget {
  const _Chips({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
    this.note,
  });

  final String title;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title, style: context.text.labelLarge),
        if (note != null) ...[
          const SizedBox(height: 2),
          Text(note!, style: context.text.bodySmall),
        ],
        const SizedBox(height: 8),
        SegmentedButton<T>(
          showSelectedIcon: false,
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          segments: [
            for (final MapEntry(:key, value: label) in options.entries)
              ButtonSegment(
                value: key,
                label: FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1)),
              ),
          ],
          selected: {value},
          onSelectionChanged: (v) => onChanged(v.first),
        ),
      ]),
    );
  }
}
