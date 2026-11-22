import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../background/alerts_screen.dart' show ItemPicker;
import '../background/background.dart';

/// Settings for the floating monitor drawn over other apps. The box itself
/// is native (FloatingMonitor.kt), run by the live status service.
class FloatingMonitorScreen extends ConsumerStatefulWidget {
  const FloatingMonitorScreen({super.key});

  @override
  ConsumerState<FloatingMonitorScreen> createState() => _FloatingMonitorScreenState();
}

class _FloatingMonitorScreenState extends ConsumerState<FloatingMonitorScreen> {
  late final AppLifecycleListener _lifecycle;

  /// Set while the user is in Settings granting "Display over other apps".
  bool _waitingForPermission = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _onResume);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _onResume() async {
    ref.invalidate(permissionStatusProvider(AppPermission.overlay));
    if (!_waitingForPermission) return;
    _waitingForPermission = false;
    final status = await ref.read(permissionApiProvider).status(AppPermission.overlay.name);
    if (status == 'granted') {
      await ref.read(backgroundConfigProvider.notifier).change((c) => copyConfig(c, overlay: true));
    }
  }

  Future<void> _turnOn() async {
    final l = AppLocalizations.of(context);
    // The box runs in the live status service, which needs a notification.
    if (!await requestPermission(context, ref, AppPermission.notifications)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.notificationsNeeded)));
      }
      return;
    }
    if (!mounted) return;
    final perms = ref.read(permissionApiProvider);
    if (await perms.status(AppPermission.overlay.name) != 'granted') {
      if (!mounted) return;
      _waitingForPermission = true;
      // Explains, then opens Settings; the switch turns on when the user
      // comes back with the permission.
      if (!await requestPermission(context, ref, AppPermission.overlay)) return;
    }
    _waitingForPermission = false;
    await ref.read(backgroundConfigProvider.notifier).change((c) => copyConfig(c, overlay: true));
  }

  Future<void> _set(BackgroundConfig Function(BackgroundConfig) edit) =>
      ref.read(backgroundConfigProvider.notifier).change(edit);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final config = ref.watch(backgroundConfigProvider);

    return PageScaffold(
      title: l.fmTitle,
      leading: const BackButton(),
      slivers: [
        ...config.when(
          loading: () => [const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))],
          error: (_, _) => [Box(Text(l.alertsUnavailable))],
          data: (c) => [
            Box(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(l.fmBody, style: context.text.bodyMedium?.copyWith(color: sx.muted)),
            )),
            Box(SxCard(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(children: [
                SwitchListTile(
                  secondary: IconBadge(SxIcons.floating, color: sx.accent, size: 36),
                  title: Text(l.fmShow),
                  value: c.overlay,
                  onChanged: (on) => on ? _turnOn() : _set((c) => copyConfig(c, overlay: false)),
                ),
                ItemPicker(
                  title: l.fmItems,
                  options: {
                    'fps': l.fmFps,
                    'ram_used': l.liRam,
                    'ram_free': l.fmRamFree,
                    'current': l.fmCurrent,
                    'power': l.liPower,
                    'temp': l.temperature,
                  },
                  selected: c.overlayItems,
                  onChanged: (v) => _set((c) => copyConfig(c, overlayItems: v)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Row(children: [
                    Expanded(child: Text(l.fmOpacity, style: context.text.labelLarge)),
                    Text(l.fmOpacityValue(c.overlayOpacity), style: context.text.labelLarge),
                  ]),
                ),
                Slider(
                  value: c.overlayOpacity.clamp(20, 100).toDouble(),
                  min: 20,
                  max: 100,
                  divisions: 16,
                  label: l.fmOpacityValue(c.overlayOpacity),
                  onChanged: (v) => _set((c) => copyConfig(c, overlayOpacity: v.round())),
                ),
                SwitchListTile(
                  title: Text(l.fmDark),
                  value: c.overlayDark,
                  onChanged: (v) => _set((c) => copyConfig(c, overlayDark: v)),
                ),
              ]),
            )),
            Box(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.fmFpsNote, style: context.text.bodySmall?.copyWith(color: sx.muted)),
                const SizedBox(height: 8),
                Text(l.fmNotifNote, style: context.text.bodySmall?.copyWith(color: sx.muted)),
              ]),
            )),
          ],
        ),
      ],
    );
  }
}
