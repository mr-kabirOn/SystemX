import 'package:flutter/material.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../../ui/widgets/permission_sheet.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;

    final perms = <(IconData, Color, String, String)>[
      (SxIcons.notifications, sx.accent, l.permNotifications, l.permNotificationsSub),
      (SxIcons.gps, sx.network, l.permLocation, l.permLocationSub),
      (SxIcons.device, sx.cpu, l.permPhone, l.permPhoneSub),
      (SxIcons.camera, sx.camera, l.permCamera, l.permCameraSub),
      (SxIcons.mic, sx.ram, l.permMicrophone, l.permMicrophoneSub),
      (SxIcons.nearby, sx.storage, l.permNearby, l.permNearbySub),
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
                ListTile(
                  leading: IconBadge(p.$1, color: p.$2, size: 36),
                  title: Text(p.$3),
                  subtitle: Text(p.$4),
                  trailing: StatusChip(l.askWhenNeeded),
                  onTap: () async {
                    final allowed = await showPermissionSheet(
                      context,
                      icon: p.$1,
                      color: p.$2,
                      title: p.$3,
                      reason: p.$4,
                    );
                    if (allowed && context.mounted) showComingSoon(context);
                  },
                ),
              ],
            ]),
          ),
          bottom: 0,
        ),
      ],
    );
  }
}
