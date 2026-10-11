import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../platform/platform.dart';
import '../ui/sx_icons.dart';
import '../ui/widgets/permission_sheet.dart';
import 'theme/sx_colors.dart';

/// Runtime permissions SystemX asks for, matching the Kotlin PermissionApi.
enum AppPermission {
  location,
  phone,
  camera,
  microphone,
  notifications;

  IconData get icon => switch (this) {
        location => SxIcons.gps,
        phone => SxIcons.sim,
        camera => SxIcons.camera,
        microphone => SxIcons.mic,
        notifications => SxIcons.notifications,
      };

  Color color(SxColors sx) => switch (this) {
        location || phone => sx.network,
        camera => sx.camera,
        microphone => sx.ram,
        notifications => sx.accent,
      };

  String title(AppLocalizations l) => switch (this) {
        location => l.permLocationTitle,
        phone => l.permPhoneTitle,
        camera => l.permCameraTitle,
        microphone => l.permMicTitle,
        notifications => l.permNotifTitle,
      };

  String reason(AppLocalizations l) => switch (this) {
        location => l.permLocationReason,
        phone => l.permPhoneReason,
        camera => l.permCameraReason,
        microphone => l.permMicReason,
        notifications => l.permNotifReason,
      };

  static AppPermission? byName(String name) {
    for (final p in values) {
      if (p.name == name) return p;
    }
    return null;
  }
}

/// "granted", "denied" or "blocked". Refresh with `ref.invalidate` after a
/// request or when returning from system settings.
final permissionStatusProvider =
    FutureProvider.autoDispose.family<String, AppPermission>((ref, p) {
  return ref.watch(permissionApiProvider).status(p.name);
});

/// Explains why [permission] is needed, then shows Android's dialog. If the
/// user blocked it earlier, offers the app's settings screen instead.
/// Returns true when the permission is granted.
Future<bool> requestPermission(
    BuildContext context, WidgetRef ref, AppPermission permission) async {
  final perms = ref.read(permissionApiProvider);
  final l = AppLocalizations.of(context);
  final sx = context.sx;
  final status = await perms.status(permission.name);
  if (status == 'granted' || !context.mounted) return status == 'granted';

  final blocked = status == 'blocked';
  final go = await showPermissionSheet(
    context,
    icon: permission.icon,
    color: permission.color(sx),
    title: permission.title(l),
    reason: blocked
        ? '${permission.reason(l)}\n\n${l.permBlocked}'
        : permission.reason(l),
    allowLabel: blocked ? l.permOpenSettings : null,
  );
  if (!go) return false;
  if (blocked) {
    await ref.read(deviceApiProvider).openSettings('app_details');
    return false;
  }
  final result = await perms.request(permission.name);
  ref.invalidate(permissionStatusProvider(permission));
  return result == 'granted';
}
