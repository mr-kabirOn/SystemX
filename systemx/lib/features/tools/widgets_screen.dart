import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';

/// The home-screen widgets and the Quick Settings tile, each with an Add
/// button. Android places them when the launcher supports it; otherwise the
/// steps to add them by hand are shown.
class WidgetsScreen extends ConsumerWidget {
  const WidgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final api = ref.read(deviceApiProvider);

    Future<void> add(Future<bool> Function() request, String manual) async {
      var ok = false;
      try {
        ok = await request();
      } catch (_) {}
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(manual), duration: const Duration(seconds: 6)),
        );
      }
    }

    Widget row(IconData icon, Color color, String title, String body, VoidCallback onAdd) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(children: [
            IconBadge(icon, color: color, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(body, style: context.text.bodySmall),
              ]),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(72, 40)),
              onPressed: onAdd,
              child: Text(l.wgAdd),
            ),
          ]),
        );

    return PageScaffold(
      title: l.wgTitle,
      leading: const BackButton(),
      slivers: [
        Box(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(l.wgBody, style: context.text.bodyMedium?.copyWith(color: sx.muted)),
        )),
        Box(SxCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: [
            row(SxIcons.battery, sx.battery, l.wgSmall, l.wgSmallBody,
                () => add(() => api.pinWidget('small'), l.wgManualWidget)),
            const Divider(indent: 70, endIndent: 16),
            row(SxIcons.apps, sx.accent, l.wgMedium, l.wgMediumBody,
                () => add(() => api.pinWidget('medium'), l.wgManualWidget)),
            const Divider(indent: 70, endIndent: 16),
            row(SxIcons.tabToolsOn, sx.network, l.wgTile, l.wgTileBody,
                () => add(api.addQuickTile, l.wgManualTile)),
          ]),
        )),
      ],
    );
  }
}
