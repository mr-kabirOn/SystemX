import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';

/// Base surface for grouped content.
class SxCard extends StatelessWidget {
  const SxCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.gradient,
    this.onTap,
    this.radius = SxRadius.card,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: isLight && gradient == null
          ? BorderSide(color: sx.line)
          : BorderSide.none,
    );
    return Material(
      color: gradient == null ? (color ?? sx.card) : Colors.transparent,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: gradient == null ? null : BoxDecoration(gradient: gradient),
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Gradient used on feature cards.
LinearGradient heroGradient(SxColors sx) => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [sx.heroStart, sx.heroEnd],
    );

/// Uppercase label used above values and sections.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: SxText.eyebrow(color ?? context.sx.muted),
      );
}

/// Section heading with consistent spacing in scrolling lists.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
        child: Eyebrow(text),
      );
}

/// Rounded square holding an icon tinted with a metric color.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key, required this.color, this.size = 38});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: Icon(icon, color: color, size: size * 0.52),
      );
}

/// Live metric tile on the dashboard.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.unit,
    this.sub,
    this.visual,
    this.onTap,
  });

  final String label;
  final String value;
  final String? unit;
  final String? sub;
  final Color color;
  final Widget? visual;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return Semantics(
      label: '$label $value${unit ?? ''}. ${sub ?? ''}',
      button: onTap != null,
      excludeSemantics: true,
      child: SxCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        radius: SxRadius.tile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(label, color: color),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: value, style: SxText.readout(22, sx.ink)),
                if (unit != null)
                  TextSpan(
                    text: ' $unit',
                    style: SxText.readout(12, sx.muted,
                        weight: FontWeight.w500),
                  ),
              ]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (visual != null) ...[const SizedBox(height: 10), visual!],
            if (sub != null) ...[
              const SizedBox(height: 8),
              Text(sub!,
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }
}

/// Key / value row for spec lists. Long-press copies the value. An optional
/// [statusIcon] repeats the value's status so it isn't shown by color alone.
///
/// Short values sit on the right of the label. Long values (build strings,
/// kernel versions) go full width under the label, and [items] show as
/// chips, so nothing wraps into a narrow ragged column.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.hint,
    this.valueColor,
    this.statusIcon,
    this.onTap,
    this.items,
  });

  final String label;
  final String value;
  final String? hint;
  final Color? valueColor;
  final IconData? statusIcon;
  final VoidCallback? onTap;
  final List<String>? items;

  /// Values longer than this, or with line breaks, go under the label.
  static const stackAt = 22;

  bool get _stacked =>
      items != null || value.length > stackAt || value.contains('\n');

  /// Lets long identifiers break after separators instead of mid-token.
  static String _breakable(String v) =>
      v.replaceAllMapped(RegExp(r'[/_,]'), (m) => '${m[0]}\u200B');

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    final color = valueColor ?? sx.ink;
    final valueStyle =
        SxText.readout(13.5, color, weight: FontWeight.w500, tabular: false);
    final chevron = onTap == null
        ? null
        : Icon(Icons.chevron_right_rounded, size: 20, color: sx.muted);
    final status = statusIcon == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(statusIcon, size: 16, color: color),
          );
    final labelBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.titleSmall),
        if (hint != null) Text(hint!, style: context.text.bodySmall),
      ],
    );

    final Widget body;
    if (_stacked) {
      final list = items;
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Expanded(child: labelBlock), ?chevron]),
          const SizedBox(height: 8),
          if (list != null)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final item in list)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: sx.cardAlt,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: sx.line),
                    ),
                    child: Text(item,
                        style: SxText.readout(12.5, color,
                            weight: FontWeight.w500, tabular: false)),
                  ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (status != null) ...[status, const SizedBox(width: 6)],
                Expanded(
                  child: Text(_breakable(value),
                      style: valueStyle.copyWith(height: 1.4)),
                ),
              ],
            ),
        ],
      );
    } else {
      // The hint spans the whole row so it doesn't wrap beside the value.
      final row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: context.text.titleSmall)),
          const SizedBox(width: 16),
          // Value, its status icon and the chevron hug the right edge.
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (status != null) ...[status, const SizedBox(width: 6)],
                Flexible(
                  child: Text(value, textAlign: TextAlign.end, style: valueStyle),
                ),
                ?chevron,
              ],
            ),
          ),
        ],
      );
      body = hint == null
          ? row
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [row, Text(hint!, style: context.text.bodySmall)],
            );
    }

    return InkWell(
      onTap: onTap,
      onLongPress: value.isEmpty
          ? null
          : () {
              Clipboard.setData(ClipboardData(text: value));
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context).copied(label))));
            },
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, onTap == null ? 16 : 8, 12),
        child: body,
      ),
    );
  }
}

/// Category row with colored icon, title and one-line summary.
class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(children: [
          IconBadge(icon, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: context.text.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: context.sx.muted),
        ]),
      ),
    );
  }
}

/// Small pill for statuses ("Sample", "Live", "Charging").
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.color, this.icon});

  final String label;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.sx.muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(label,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall?.copyWith(color: c)),
        ),
      ]),
    );
  }
}

/// A column that fills the screen but scrolls when its content doesn't fit
/// (large font sizes, small phones). [Spacer]s work inside it.
class FillOrScroll extends StatelessWidget {
  const FillOrScroll({super.key, required this.children, this.padding = EdgeInsets.zero});

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: box.maxHeight - padding.vertical),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      );
}
