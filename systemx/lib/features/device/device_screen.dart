import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'device_data.dart';
import 'share.dart';
import 'spec_sheets.dart';

class DeviceScreen extends ConsumerWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final snap = ref.watch(fullSnapshotProvider).value;
    final builder = SpecBuilder(l);

    final identity = snap?.identity;
    final system = snap?.system;
    final patch = parsePatch(system?.securityPatch);
    final heroTitle = identity?.marketName ?? l.deviceHeroTitle;
    final heroEyebrow = identity == null
        ? 'Android'
        : '${identity.manufacturer} · ${identity.codename}';
    final heroSub = system == null
        ? null
        : [
            androidName(system.sdk),
            if (patch != null)
              l.securityPatchOn(formatDate(patch, l.localeName)),
          ].join(' · ');

    return PageScaffold(
      title: l.deviceTitle,
      actions: [
        IconButton(
          tooltip: l.copyAll,
          icon: const Icon(Icons.copy_all_rounded),
          onPressed: snap == null
              ? null
              : () async {
                  await Clipboard.setData(
                      ClipboardData(text: fullSpecSheet(builder, snap, DateTime.now())));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(l.copiedAll)));
                },
        ),
        IconButton(
          tooltip: l.shareSpecs,
          icon: const Icon(Icons.share_outlined),
          onPressed: snap == null
              ? null
              : () => ref.read(shareTextProvider)(
                    fullSpecSheet(builder, snap, DateTime.now()),
                    shareSubject(l, snap),
                  ),
        ),
      ],
      slivers: [
        Box(TextField(
          readOnly: true,
          onTap: () => context.push(Routes.search),
          decoration: InputDecoration(
            hintText: l.deviceSearch,
            prefixIcon: Icon(Icons.search_rounded, color: sx.muted),
          ),
        )),
        Box(SxCard(
          gradient: heroGradient(sx),
          padding: const EdgeInsets.all(18),
          onTap: () => context.push(Routes.category(DeviceCategory.device)),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(heroEyebrow, color: sx.onHero),
                  const SizedBox(height: 6),
                  Text(heroTitle,
                      style: context.text.headlineSmall
                          ?.copyWith(color: Colors.white)),
                  if (heroSub != null) ...[
                    const SizedBox(height: 4),
                    Text(heroSub,
                        style:
                            context.text.bodySmall?.copyWith(color: sx.onHero)),
                  ],
                ],
              ),
            ),
            Icon(SxIcons.device, size: 44, color: sx.onHero),
          ]),
        )),
        Box(
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              for (final (i, c) in DeviceCategory.values.indexed) ...[
                if (i > 0) const Divider(indent: 66, endIndent: 14),
                CategoryRow(
                  icon: c.icon,
                  color: c.color(sx),
                  title: c.title(l),
                  subtitle: _summary(builder, c, snap) ?? c.subtitle(l),
                  onTap: () => context.push(Routes.category(c)),
                ),
              ],
            ]),
          ),
        ),
        Box(
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              CategoryRow(
                icon: SxIcons.apps,
                color: sx.storage,
                title: l.appsEntry,
                subtitle: l.appsEntryBody,
                onTap: () => context.push(Routes.apps),
              ),
              const Divider(indent: 66, endIndent: 14),
              CategoryRow(
                icon: SxIcons.screenTime,
                color: sx.accent,
                title: l.stmTitle,
                subtitle: l.stmEntryBody,
                onTap: () => context.push(Routes.screenTime),
              ),
            ]),
          ),
          bottom: 0,
        ),
      ],
    );
  }
}

String? _summary(SpecBuilder b, DeviceCategory c, DeviceSnapshot? snap) {
  final s = snap == null ? null : b.summary(c, snap);
  return s == null || s.isEmpty ? null : s;
}
