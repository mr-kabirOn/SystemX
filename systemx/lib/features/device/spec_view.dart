import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'specs.dart';

/// Renders spec sections as cards of [InfoRow]s.
class SpecSections extends ConsumerWidget {
  const SpecSections({super.key, required this.sections, this.onAction});

  final List<SpecSection> sections;
  final void Function(SpecAction action)? onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverMainAxisGroup(slivers: [
      for (final section in sections) ...[
        if (section.title != null)
          SliverToBoxAdapter(child: SectionLabel(section.title!)),
        Box(SxCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: [
            for (final (i, spec) in section.specs.indexed) ...[
              if (i > 0) const Divider(indent: 16, endIndent: 16),
              SpecRow(spec: spec, onAction: onAction),
            ],
          ]),
        )),
      ],
    ]);
  }
}

class SpecRow extends StatelessWidget {
  const SpecRow({super.key, required this.spec, this.onAction, this.onTap});

  final Spec spec;
  final void Function(SpecAction action)? onAction;

  /// Replaces the spec's own action (used by search to open the category).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    final (color, icon) = switch (spec.tone) {
      SpecTone.good => (sx.good, SxIcons.passed),
      SpecTone.warn => (sx.warn, PhosphorIconsFill.warningCircle),
      SpecTone.bad => (sx.bad, SxIcons.failed),
      SpecTone.neutral => (spec.available ? null : sx.muted, null),
    };
    final action = spec.action;
    return InfoRow(
      label: spec.label,
      value: spec.value,
      hint: spec.hint,
      items: spec.items,
      valueColor: color,
      statusIcon: icon,
      onTap: onTap ??
          (action == null || onAction == null ? null : () => onAction!(action)),
    );
  }
}

/// Shown when a probe could not read anything on this phone.
class SpecsUnavailable extends StatelessWidget {
  const SpecsUnavailable({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SxCard(
      child: Row(children: [
        Icon(Icons.info_outline_rounded, color: context.sx.muted),
        const SizedBox(width: 12),
        Expanded(child: Text(l.specsUnavailable, style: context.text.bodyMedium)),
      ]),
    );
  }
}

/// Opens a settings screen, telling the user if the phone has none.
Future<void> openSystemSettings(
    BuildContext context, WidgetRef ref, String action) async {
  final ok = await ref.read(deviceApiProvider).openSettings(action);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).settingsUnavailable)));
  }
}
