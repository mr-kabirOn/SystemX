import 'package:flutter/material.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import 'cards.dart';

/// Explains why a permission is needed before Android's own dialog appears.
/// Resolves to true when the user taps Allow.
Future<bool> showPermissionSheet(
  BuildContext context, {
  required IconData icon,
  required Color color,
  required String title,
  required String reason,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
      final l = AppLocalizations.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(icon, color: color, size: 52),
              const SizedBox(height: 16),
              Text(title, style: context.text.headlineSmall),
              const SizedBox(height: 8),
              Text(reason, style: context.text.bodyLarge),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l.permNotNow),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l.permAllow),
                  ),
                ),
              ]),
            ],
          ),
        ),
      );
    },
  );
  return result ?? false;
}
