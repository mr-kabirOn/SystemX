import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/features/device/spec_sheets.dart';
import 'package:systemx/features/live/health.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';

void main() {
  final api = FakeDeviceApi();
  late BatteryInfo battery;
  late StorageInfo storage;
  late SecurityInfo security;
  late LiveStats live;

  setUp(() async {
    battery = await api.battery();
    storage = await api.storage();
    security = await api.security();
    live = await api.live();
  });

  LiveStats with_({int? avail, double? temp, int? status, int? level}) =>
      LiveStats(
        timeMs: live.timeMs,
        cpuKhz: live.cpuKhz,
        cpuMaxKhz: live.cpuMaxKhz,
        memTotal: live.memTotal,
        memAvailable: avail ?? live.memAvailable,
        batteryLevel: level ?? live.batteryLevel,
        batteryStatus: status ?? live.batteryStatus,
        plugged: live.plugged,
        batteryTempC: temp ?? live.batteryTempC,
        voltageMv: live.voltageMv,
        rxBytes: live.rxBytes,
        txBytes: live.txBytes,
        thermalStatus: live.thermalStatus,
      );

  group('health score', () {
    test('a healthy phone scores high', () {
      final s = healthScore(battery: battery, storage: storage, live: live)!;
      expect(s.score, greaterThanOrEqualTo(90));
      expect(s.parts.map((p) => p.factor), isNot(contains(HealthFactor.checkup)));
    });

    test('heat, full storage and low memory pull it down', () {
      final full = StorageInfo(total: 128000000000, free: 3000000000, volumes: []);
      final s = healthScore(
        battery: battery,
        storage: full,
        live: with_(temp: 46, avail: 300 * 1024 * 1024),
      )!;
      expect(s.score, lessThan(60));
    });

    test('missing data is left out rather than guessed', () {
      expect(healthScore(), isNull);
      final s = healthScore(storage: storage)!;
      expect(s.parts.single.factor, HealthFactor.storage);
      expect(s.score, 100);
    });

    test('a checkup result counts when there is one', () {
      final s = healthScore(battery: battery, checkupScore: 50)!;
      expect(s.score, 85); // battery 25 + temperature 20 + half of checkup 20, out of 65
    });
  });

  group('tips', () {
    test('a fine phone gets the general charging habit tip', () {
      final tips = pickTips(
          live: with_(status: 3, level: 60),
          storage: storage,
          security: security,
          now: DateTime(2026, 10, 12));
      expect(tips.map((t) => t.kind), [TipKind.chargeHabit]);
    });

    test('urgent problems come first, each with its settings screen', () {
      final full = StorageInfo(total: 100, free: 5, volumes: []);
      final noLock = SecurityInfo(
        screenLock: false,
        encryption: 'encrypted',
        securityPatch: '2026-03-05',
        devOptions: false,
        adb: false,
        rootDetected: false,
        biometricStatus: 'none_enrolled',
      );
      final tips = pickTips(
          live: with_(temp: 43, level: 85),
          storage: full,
          security: noLock,
          now: DateTime(2026, 10, 12));
      expect(tips.map((t) => t.kind), [
        TipKind.batteryHot,
        TipKind.storageLow,
        TipKind.noScreenLock,
        TipKind.patchOld,
        TipKind.unplug,
        TipKind.chargeHabit,
      ]);
      expect(tips[1].value, 95);
      expect(tips[1].settingsAction, SettingsActions.storage);
      expect(tips[3].value, 7);
    });
  });
}
