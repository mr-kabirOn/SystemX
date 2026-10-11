import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/log.dart';
import '../../core/settings/settings.dart';
import '../../platform/platform.dart';
import '../tests/test_results.dart';

final playApiProvider = Provider<PlayApi>((ref) => PlayApi());

/// Runs once per launch: lets Play offer a waiting update.
final updateCheckProvider = FutureProvider<void>((ref) async {
  try {
    await ref.read(playApiProvider).checkForUpdate();
  } catch (e) {
    logDebug('update check failed: $e');
  }
});

/// Least time between two review requests.
const reviewInterval = Duration(days: 90);

/// After a checkup that went well, asks Play to show its rating card, at
/// most once every [reviewInterval]. Play may still decide not to show it.
Future<void> maybeAskForReview(Ref ref, Checkup c, {DateTime? now}) async {
  if (c.score < 90 || c.count(TestStatus.passed) < 10) return;
  final prefs = ref.read(prefsProvider);
  final t = now ?? DateTime.now();
  final last = prefs.getInt(SettingsNotifier.reviewAskedKey);
  if (last != null &&
      t.difference(DateTime.fromMillisecondsSinceEpoch(last)) < reviewInterval) {
    return;
  }
  await prefs.setInt(SettingsNotifier.reviewAskedKey, t.millisecondsSinceEpoch);
  try {
    await ref.read(playApiProvider).requestReview();
  } catch (e) {
    logDebug('review request failed: $e');
  }
}
