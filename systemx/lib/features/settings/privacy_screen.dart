import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../../ui/widgets/permission_sheet.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Statuses can change in system settings while the app is in the
    // background.
    _lifecycle = AppLifecycleListener(onResume: () {
      for (final p in AppPermission.values) {
        ref.invalidate(permissionStatusProvider(p));
      }
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;

    // Permissions with a feature behind them today; the rest arrive with
    // later stages and only explain themselves for now.
    final perms = <(IconData, Color, String, String, AppPermission?)>[
      (SxIcons.notifications, sx.accent, l.permNotifications, l.permNotificationsSub, AppPermission.notifications),
      (SxIcons.gps, sx.network, l.permLocation, l.permLocationSub, AppPermission.location),
      (SxIcons.device, sx.cpu, l.permPhone, l.permPhoneSub, AppPermission.phone),
      (SxIcons.camera, sx.camera, l.permCamera, l.permCameraSub, AppPermission.camera),
      (SxIcons.mic, sx.ram, l.permMicrophone, l.permMicrophoneSub, AppPermission.microphone),
      (SxIcons.nearby, sx.storage, l.permNearby, l.permNearbySub, null),
    ];

    return PageScaffold(
      title: l.privacyPermissions,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          color: sx.good.withValues(alpha: 0.12),
          child: Row(children: [
            IconBadge(SxIcons.security, color: sx.good, size: 44),
            const SizedBox(width: 14),
            Expanded(child: Text(l.privacyBanner, style: context.text.bodyMedium)),
          ]),
        )),
        Box(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(l.privacyIntro,
              style: context.text.bodyMedium?.copyWith(color: sx.muted)),
        )),
        Box(
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              for (final (i, p) in perms.indexed) ...[
                if (i > 0) const Divider(indent: 66, endIndent: 14),
                // Status under the text (not trailing) so large fonts fit.
                InkWell(
                  onTap: () => p.$5 == null
                      ? _explain(p.$1, p.$2, p.$3, p.$4)
                      : _manage(p.$5!),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      IconBadge(p.$1, color: p.$2, size: 36),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.$3, style: context.text.titleSmall),
                          Text(p.$4, style: context.text.bodySmall),
                          const SizedBox(height: 6),
                          p.$5 == null ? StatusChip(l.askWhenNeeded) : _StatusChip(p.$5!),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ],
            ]),
          ),
          bottom: 0,
        ),
      ],
    );
  }

  Future<void> _explain(
      IconData icon, Color color, String title, String reason) async {
    final allowed = await showPermissionSheet(context,
        icon: icon, color: color, title: title, reason: reason);
    if (allowed && mounted) showComingSoon(context);
  }

  /// Asks for the permission, or opens the app's settings page once it is
  /// granted, since only Android Settings can take a permission back.
  Future<void> _manage(AppPermission p) async {
    final status = await ref.read(permissionStatusProvider(p).future);
    if (!mounted) return;
    if (status == 'granted') {
      await ref.read(deviceApiProvider).openSettings('app_details');
    } else {
      await requestPermission(context, ref, p);
    }
  }
}

class _StatusChip extends ConsumerWidget {
  const _StatusChip(this.permission);

  final AppPermission permission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final status = ref.watch(permissionStatusProvider(permission)).value;
    return switch (status) {
      'granted' => StatusChip(l.statusAllowed,
          color: sx.good, icon: Icons.check_rounded),
      'blocked' => StatusChip(l.statusBlocked,
          color: sx.warn, icon: Icons.block_rounded),
      'denied' => StatusChip(l.statusNotAllowed),
      _ => const SizedBox.shrink(),
    };
  }
}
