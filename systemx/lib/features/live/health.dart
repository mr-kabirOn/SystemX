import 'package:flutter/foundation.dart';

import '../../core/format.dart';
import '../../platform/platform.dart';
import '../device/spec_sheets.dart';

/// One input to the health score.
enum HealthFactor { battery, temperature, storage, memory, checkup }

@immutable
class HealthPart {
  const HealthPart(this.factor, this.value, this.weight);
  final HealthFactor factor;

  /// 0 (bad) to 1 (good).
  final double value;
  final int weight;
}

@immutable
class HealthScore {
  const HealthScore(this.score, this.parts);

  /// 0–100.
  final int score;
  final List<HealthPart> parts;
}

double _lerp(double x, double x0, double x1, double y0, double y1) {
  if (x <= x0) return y0;
  if (x >= x1) return y1;
  return y0 + (y1 - y0) * (x - x0) / (x1 - x0);
}

/// Health score from what the phone reports right now. Factors without data
/// are left out and the rest re-weighted, so the score never guesses.
HealthScore? healthScore({
  BatteryInfo? battery,
  StorageInfo? storage,
  LiveStats? live,
  int? checkupScore,
}) {
  final parts = <HealthPart>[];

  final health = battery?.health;
  if (health != null) {
    final v = switch (health) {
      2 => 1.0,
      3 || 7 => 0.5,
      4 || 6 => 0.1,
      5 => 0.4,
      _ => 0.8,
    };
    parts.add(HealthPart(HealthFactor.battery, v, 25));
  }

  final temp = live?.batteryTempC ?? battery?.tempC;
  if (temp != null && temp > 0) {
    var v = _lerp(temp, 35, 45, 1, 0.2);
    final status = live?.thermalStatus ?? -1;
    if (status >= 3) v = v < 0.3 ? v : 0.3;
    parts.add(HealthPart(HealthFactor.temperature, v, 20));
  }

  if (storage != null && storage.total > 0) {
    final free = storage.free / storage.total;
    parts.add(HealthPart(
        HealthFactor.storage, _lerp(free, 0.05, 0.20, 0.2, 1), 20));
  }

  if (live != null && live.memTotal > 0) {
    final avail = live.memAvailable / live.memTotal;
    parts.add(HealthPart(
        HealthFactor.memory, _lerp(avail, 0.10, 0.25, 0.3, 1), 15));
  }

  if (checkupScore != null) {
    parts.add(HealthPart(HealthFactor.checkup, checkupScore / 100, 20));
  }

  if (parts.isEmpty) return null;
  final total = parts.fold<int>(0, (s, p) => s + p.weight);
  final sum = parts.fold<double>(0, (s, p) => s + p.value * p.weight);
  return HealthScore((sum * 100 / total).round(), parts);
}

/// Advice shown on the dashboard, most urgent first.
enum TipKind {
  batteryHot,
  storageLow,
  noScreenLock,
  patchOld,
  memoryLow,
  unplug,
  chargeHabit,
}

@immutable
class Tip {
  const Tip(this.kind, {this.value, this.settingsAction});
  final TipKind kind;

  /// Number shown in the tip (°C, percent or months).
  final num? value;

  /// System settings screen the tip's button opens.
  final String? settingsAction;
}

/// Real, actionable tips for the current state. Always returns at least one.
List<Tip> pickTips({
  LiveStats? live,
  StorageInfo? storage,
  SecurityInfo? security,
  DateTime? now,
}) {
  final tips = <Tip>[];
  final temp = live?.batteryTempC;
  if (temp != null && temp >= 40) {
    tips.add(Tip(TipKind.batteryHot, value: temp));
  }
  if (storage != null && storage.total > 0) {
    final used = (storage.total - storage.free) * 100 / storage.total;
    if (used >= 90) {
      tips.add(Tip(TipKind.storageLow,
          value: used.round(), settingsAction: SettingsActions.storage));
    }
  }
  if (security != null && !security.screenLock) {
    tips.add(const Tip(TipKind.noScreenLock,
        settingsAction: SettingsActions.security));
  }
  final patch = parsePatch(security?.securityPatch);
  if (patch != null) {
    final months = monthsSince(patch, now);
    if (months >= 4) {
      tips.add(Tip(TipKind.patchOld,
          value: months, settingsAction: SettingsActions.systemUpdate));
    }
  }
  if (live != null && live.memTotal > 0 && live.memAvailable / live.memTotal < 0.1) {
    tips.add(const Tip(TipKind.memoryLow));
  }
  if (live != null && live.batteryStatus == 2 && live.batteryLevel >= 80) {
    tips.add(Tip(TipKind.unplug, value: live.batteryLevel));
  }
  tips.add(const Tip(TipKind.chargeHabit));
  return tips;
}
