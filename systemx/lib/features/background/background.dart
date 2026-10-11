import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings.dart';
import '../../platform/platform.dart';
import '../tests/test_results.dart';

final backgroundApiProvider = Provider<BackgroundApi>((ref) => BackgroundApi());

/// A copy of a [BackgroundConfig] with some fields changed.
BackgroundConfig copyConfig(
  BackgroundConfig c, {
  bool? liveStatus,
  String? statusIcon,
  bool? chargeAlarm,
  int? chargeLimit,
  bool? batteryLow,
  int? lowLevel,
  bool? batteryHot,
  int? hotC,
  bool? chargingDone,
  bool? storageFull,
  int? storagePercent,
  bool? weeklySummary,
  bool? checkupReminder,
  bool? fahrenheit,
  int? lastCheckupMs,
}) =>
    BackgroundConfig(
      liveStatus: liveStatus ?? c.liveStatus,
      statusIcon: statusIcon ?? c.statusIcon,
      chargeAlarm: chargeAlarm ?? c.chargeAlarm,
      chargeLimit: chargeLimit ?? c.chargeLimit,
      batteryLow: batteryLow ?? c.batteryLow,
      lowLevel: lowLevel ?? c.lowLevel,
      batteryHot: batteryHot ?? c.batteryHot,
      hotC: hotC ?? c.hotC,
      chargingDone: chargingDone ?? c.chargingDone,
      storageFull: storageFull ?? c.storageFull,
      storagePercent: storagePercent ?? c.storagePercent,
      weeklySummary: weeklySummary ?? c.weeklySummary,
      checkupReminder: checkupReminder ?? c.checkupReminder,
      fahrenheit: fahrenheit ?? c.fahrenheit,
      lastCheckupMs: lastCheckupMs ?? c.lastCheckupMs,
    );

/// Whether any alert or live status needs notifications.
bool needsNotifications(BackgroundConfig c) =>
    c.liveStatus ||
    c.chargeAlarm ||
    c.batteryLow ||
    c.batteryHot ||
    c.chargingDone ||
    c.storageFull ||
    c.weeklySummary ||
    c.checkupReminder;

/// The native background config. Keeps the temperature unit and the last
/// checkup time in sync, since widgets and alerts use them.
class BackgroundConfigNotifier extends AsyncNotifier<BackgroundConfig> {
  BackgroundApi get _api => ref.read(backgroundApiProvider);

  @override
  Future<BackgroundConfig> build() async {
    final c = await ref.watch(backgroundApiProvider).getConfig();
    ref.listen(settingsProvider.select((s) => s.tempUnit), (_, u) {
      change((c) => copyConfig(c, fahrenheit: u == TempUnit.fahrenheit));
    });
    ref.listen(testHistoryProvider.select((h) => h.value?.lastCheckup?.at), (_, at) {
      if (at != null) change((c) => copyConfig(c, lastCheckupMs: at.millisecondsSinceEpoch));
    });
    final fahrenheit = ref.read(settingsProvider).tempUnit == TempUnit.fahrenheit;
    if (c.fahrenheit != fahrenheit) {
      final synced = copyConfig(c, fahrenheit: fahrenheit);
      await _safeSet(synced);
      return synced;
    }
    return c;
  }

  Future<void> _safeSet(BackgroundConfig c) async {
    try {
      await _api.setConfig(c);
    } catch (e) {
      debugPrint('SystemX: could not save background config: $e');
    }
  }

  /// Applies [edit] and saves it natively (which starts or stops work).
  Future<BackgroundConfig> change(
      BackgroundConfig Function(BackgroundConfig c) edit) async {
    final current = await future;
    final next = edit(current);
    state = AsyncData(next);
    await _safeSet(next);
    return next;
  }
}

final backgroundConfigProvider =
    AsyncNotifierProvider<BackgroundConfigNotifier, BackgroundConfig>(
        BackgroundConfigNotifier.new);

enum HistoryRange {
  day(Duration(hours: 24)),
  week(Duration(days: 7));

  const HistoryRange(this.span);
  final Duration span;
}

final historyProvider = FutureProvider.autoDispose
    .family<List<HistorySample>, HistoryRange>((ref, range) {
  final since = DateTime.now().subtract(range.span).millisecondsSinceEpoch;
  return ref.watch(backgroundApiProvider).history(since);
});

final sessionsProvider = FutureProvider.autoDispose<List<ChargeSession>>(
    (ref) => ref.watch(backgroundApiProvider).sessions(50));
