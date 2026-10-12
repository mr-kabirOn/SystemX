import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/sx_colors.dart';
import '../../features/tests/test_results.dart';
import '../sx_icons.dart';
import 'cards.dart';

/// Grid tile for a single hardware test. The dot shows the last result.
class TestTile extends StatelessWidget {
  const TestTile({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.status = TestStatus.notRun,
    this.statusLabel,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final TestStatus status;

  /// Spoken with the label, since the dot is color only.
  final String? statusLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    final (badge, badgeColor) = switch (status) {
      TestStatus.passed => (SxIcons.passed, sx.good),
      TestStatus.failed => (SxIcons.failed, sx.bad),
      TestStatus.skipped => (SxIcons.skipped, sx.muted),
      TestStatus.notRun => (SxIcons.notTested, sx.muted.withValues(alpha: 0.7)),
    };
    return Semantics(
      label: statusLabel == null ? label : '$label, $statusLabel',
      button: onTap != null,
      excludeSemantics: true,
      child: SxCard(
      onTap: onTap,
      radius: SxRadius.tile,
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
      child: Stack(fit: StackFit.expand, clipBehavior: Clip.none, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: IconBadge(icon, color: color, size: 40)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium,
            ),
          ],
        ),
        Positioned(
          top: -6,
          right: -2,
          child: Icon(badge, size: 18, color: badgeColor),
        ),
      ]),
      ),
    );
  }
}
