import 'package:flutter/foundation.dart';

/// Debug-only logging: release builds write nothing to the system log.
void logDebug(String message) {
  if (kDebugMode) debugPrint('SystemX: $message');
}
