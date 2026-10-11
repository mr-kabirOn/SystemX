import 'dart:typed_data';

import 'package:systemx/platform/platform.dart';

/// Pixel 8 style readings, so tests don't need a phone.
class FakeDeviceApi extends DeviceInfoApi {
  FakeDeviceApi({this.failing = const {}});

  /// Method names that throw, to check one failure doesn't hide the rest.
  final Set<String> failing;
  final List<String> opened = [];
  final List<String> dialed = [];
  bool phoneGranted = false;
  bool locationGranted = false;

  Future<T> _r<T>(String name, T Function() value) async {
    if (failing.contains(name)) throw Exception('$name failed');
    return value();
  }

  @override
  Future<DeviceIdentity> identity() => _r('identity', () => DeviceIdentity(
        manufacturer: 'Google',
        brand: 'Google',
        model: 'Pixel 8',
        marketName: 'Pixel 8',
        codename: 'shiba',
        product: 'shiba',
        board: 'shiba',
        hardware: 'shiba',
        isTablet: false,
      ));

  @override
  Future<SystemInfo> system() => _r('system', () => SystemInfo(
        release: '16',
        sdk: 36,
        securityPatch: '2026-09-05',
        buildId: 'BP2A.250905.005',
        buildDisplay: 'BP2A.250905.005',
        fingerprint: 'google/shiba/shiba:16/BP2A.250905.005/1:user/release-keys',
        incremental: '13540000',
        buildType: 'user',
        tags: 'release-keys',
        buildTimeMs: DateTime(2026, 9, 1).millisecondsSinceEpoch,
        bootloader: 'ripcurrent-16.0',
        baseband: 'g5300i-250605',
        kernel: '6.1.124-android14-11',
        vm: 'Dalvik 2.1.0',
        uptimeMs: const Duration(hours: 50, minutes: 3).inMilliseconds,
        locale: 'en-US',
        timezone: 'Asia/Dhaka',
        playServices: '25.36.33',
        playStore: '47.8.19',
        playSystemUpdate: '2026-09-01',
        treble: true,
        seamlessUpdates: true,
        dynamicPartitions: true,
        rootDetected: false,
        encryption: 'encrypted',
      ));

  @override
  Future<CpuInfo> cpu() => _r('cpu', () {
        CpuCore core(int i, int max, String part) => CpuCore(
            index: i,
            online: true,
            minKhz: 300000,
            maxKhz: max,
            curKhz: max ~/ 2,
            partName: part);
        return CpuInfo(
          socManufacturer: 'Google',
          socModel: 'Zuma',
          hardware: 'Zuma',
          cores: 9,
          coreList: [
            for (var i = 0; i < 4; i++) core(i, 1704000, 'Cortex-A510'),
            for (var i = 4; i < 8; i++) core(i, 2367000, 'Cortex-A715'),
            core(8, 2914000, 'Cortex-X3'),
          ],
          governor: 'sched_pixel',
          abis: ['arm64-v8a'],
          features: 'fp asimd aes pmull sha1 sha2',
          arch: 'aarch64',
        );
      });

  @override
  Future<GpuInfo> gpu() => _r('gpu', () => GpuInfo(
        renderer: 'Mali-G715',
        vendor: 'ARM',
        glVersion: 'OpenGL ES 3.2 v1.r44p1',
        glEsVersion: '3.2',
        vulkanVersion: '1.3.278',
        extensions: 112,
      ));

  @override
  Future<MemoryStats> memory() => _r('memory', () => MemoryStats(
        total: 7816 * 1024 * 1024,
        available: 2970 * 1024 * 1024,
        threshold: 216 * 1024 * 1024,
        low: false,
        advertised: 8 * 1024 * 1024 * 1024,
        swapTotal: 8 * 1024 * 1024 * 1024,
        swapFree: 6 * 1024 * 1024 * 1024,
      ));

  @override
  Future<StorageInfo> storage() => _r('storage', () => StorageInfo(
        total: 128000000000,
        free: 41000000000,
        advertised: 128000000000,
        fsType: 'f2fs',
        volumes: [
          StorageVolumeInfo(
              label: 'Internal shared storage',
              primary: true,
              removable: false,
              state: 'mounted',
              total: 110000000000,
              free: 41000000000),
        ],
      ));

  @override
  Future<BatteryInfo> battery() => _r('battery', () => BatteryInfo(
        level: 78,
        status: 2,
        plugged: 1,
        health: 2,
        tempC: 33.1,
        voltageMv: 4210,
        technology: 'Li-ion',
        present: true,
        currentNowMa: 2140,
        currentAvgMa: 2010,
        chargeCounterMah: 3284,
        chargeTimeRemainingMs: const Duration(minutes: 42).inMilliseconds,
        cycleCount: 212,
        designCapacityMah: 4575,
      ));

  @override
  Future<DisplayInfo> display() => _r('display', () => DisplayInfo(
        width: 1080,
        height: 2400,
        densityDpi: 420,
        xdpi: 425.0,
        ydpi: 425.0,
        refreshRate: 120,
        refreshRates: [60, 120],
        hdrTypes: ['HDR10', 'HLG', 'HDR10+'],
        wideColor: true,
        hasCutout: true,
        brightness: 128,
        timeoutMs: 30000,
        fontScale: 1.0,
      ));

  @override
  Future<NetworkInfo> network() => _r('network', () => NetworkInfo(
        transport: 'wifi',
        connected: true,
        validated: true,
        metered: false,
        vpn: false,
        downKbps: 300000,
        upKbps: 120000,
        iface: 'wlan0',
        ipv4: ['192.168.1.23'],
        ipv6: ['fe80::1'],
        dns: ['192.168.1.1'],
        gateway: '192.168.1.1',
        wifiEnabled: true,
        ssid: locationGranted ? 'HomeNet' : null,
        rssi: -52,
        linkMbps: 866,
        freqMhz: 5180,
        wifiStandard: 6,
        wifiNameNeedsLocation: !locationGranted,
        operatorName: 'Grameenphone',
        networkCountry: 'BD',
        roaming: false,
        signalLevel: 3,
        signalDbm: -95,
        dataNetworkType: phoneGranted ? '4G LTE' : null,
        phonePermission: phoneGranted,
      ));

  @override
  Future<SimInfo> sim() => _r('sim', () => SimInfo(
        permissionGranted: phoneGranted,
        slotCount: 2,
        simOperator: '47001',
        simOperatorName: 'Grameenphone',
        country: 'BD',
        simState: 5,
        cards: phoneGranted
            ? [
                SimCard(
                    slot: 1,
                    carrier: 'Grameenphone',
                    displayName: 'GP',
                    country: 'BD',
                    mcc: '470',
                    mnc: '01',
                    embedded: false,
                    dataSim: true,
                    networkType: '4G LTE'),
                SimCard(
                    slot: 2,
                    carrier: 'Robi',
                    country: 'BD',
                    mcc: '470',
                    mnc: '02',
                    embedded: false,
                    dataSim: false),
              ]
            : [],
      ));

  @override
  Future<List<CameraInfo>> cameras() => _r('cameras', () => [
        CameraInfo(
          id: '0',
          facing: 'back',
          pixelW: 8160,
          pixelH: 6144,
          sensorWmm: 9.8,
          sensorHmm: 7.4,
          apertures: [1.68],
          focalLengths: [6.9],
          ois: true,
          flash: true,
          hardwareLevel: 'Level 3',
          raw: true,
          logicalMulti: false,
          maxVideo: '4K',
        ),
        CameraInfo(
          id: '1',
          facing: 'front',
          pixelW: 3648,
          pixelH: 2736,
          sensorWmm: 4.1,
          sensorHmm: 3.1,
          apertures: [2.2],
          focalLengths: [2.7],
          ois: false,
          flash: false,
          hardwareLevel: 'Full',
          raw: false,
          logicalMulti: false,
          maxVideo: '4K',
        ),
      ]);

  @override
  Future<List<SensorInfo>> sensors() => _r('sensors', () => [
        SensorInfo(
            type: 1,
            typeName: 'accelerometer',
            name: 'LSM6DSV Accelerometer',
            vendor: 'STMicro',
            power: 0.17,
            maxRange: 78.4,
            resolution: 0.0024,
            minDelayUs: 2404,
            wakeUp: false,
            version: 1),
        SensorInfo(
            type: 5,
            typeName: 'light',
            name: 'TMD3719 Ambient Light',
            vendor: 'AMS',
            power: 0.1,
            maxRange: 65535,
            resolution: 1,
            minDelayUs: 0,
            wakeUp: false,
            version: 1),
      ]);

  @override
  Future<MediaInfo> media() => _r('media', () => MediaInfo(
        codecs: [
          CodecInfo(
              name: 'c2.exynos.h264.decoder',
              encoder: false,
              types: ['video/avc'],
              hardware: true),
          CodecInfo(
              name: 'c2.android.avc.encoder',
              encoder: true,
              types: ['video/avc'],
              hardware: false),
          CodecInfo(
              name: 'c2.google.av1.decoder',
              encoder: false,
              types: ['video/av01'],
              hardware: true),
          CodecInfo(
              name: 'c2.android.opus.decoder',
              encoder: false,
              types: ['audio/opus'],
              hardware: false),
        ],
        widevineLevel: 'L1',
        widevineVersion: '18.0.0',
        hdcp: 'HDCP-2.3',
        audioOutputs: ['Speaker', 'Earpiece'],
        lowLatency: true,
        proAudio: true,
        spatial: true,
      ));

  @override
  Future<FeaturesInfo> features() => _r('features', () => FeaturesInfo(
        systemFeatures: [
          'android.hardware.bluetooth',
          'android.hardware.bluetooth_le',
          'android.hardware.fingerprint',
          'android.hardware.nfc',
          'android.hardware.uwb',
          'android.hardware.usb.host',
          'android.hardware.location.gps',
        ],
        le2mPhy: true,
        leCodedPhy: true,
        leExtendedAdvertising: true,
        leAudio: true,
        wifi5Ghz: true,
        wifi6Ghz: true,
        wifi6: true,
        wifi7: false,
        nfcEnabled: true,
      ));

  @override
  Future<SecurityInfo> security() => _r('security', () => SecurityInfo(
        screenLock: true,
        encryption: 'encrypted',
        securityPatch: '2026-09-05',
        devOptions: true,
        adb: false,
        verifiedBoot: 'green',
        bootloaderLocked: true,
        rootDetected: false,
        biometricStatus: 'enrolled',
      ));

  /// Advances on every [live] call so rates and charts have changing data.
  int liveTicks = 0;

  /// Adds wobble to live readings so screenshot charts aren't flat lines.
  bool vary = false;

  @override
  Future<LiveStats> live() => _r('live', () {
        final t = liveTicks++;
        return LiveStats(
          timeMs: 1000000 + t * 1000,
          cpuKhz: [
            for (var i = 0; i < 4; i++) 852000 + (t % 3) * 100000,
            for (var i = 0; i < 4; i++) 1183000,
            0,
          ],
          cpuMaxKhz: [
            for (var i = 0; i < 4; i++) 1704000,
            for (var i = 0; i < 4; i++) 2367000,
            2914000,
          ],
          memTotal: 7816 * 1024 * 1024,
          memAvailable: 2970 * 1024 * 1024,
          batteryLevel: 78,
          batteryStatus: 2,
          plugged: 1,
          batteryTempC: vary ? 33.1 + (t % 7) * 0.1 : 33.1,
          voltageMv: 4210,
          currentNowMa: vary ? 2140 - (t * 37) % 300 : 2140,
          // 2.5 MB down and 200 KB up per second.
          rxBytes: 5000000000 + t * 2500000 + (vary ? (t * t % 5) * 400000 : 0),
          txBytes: 800000000 + t * 200000,
          thermalStatus: 0,
          thermalHeadroom: 0.36,
          cpuTempC: 41.5,
        );
      });

  @override
  Future<bool> openSettings(String action) async {
    opened.add(action);
    return true;
  }

  @override
  Future<void> dial(String code) async => dialed.add(code);

  @override
  Future<bool> openLink(String url) async {
    opened.add(url);
    return true;
  }
}

/// Grants or denies permissions without a phone, and updates [api] so the
/// next probe reflects the change.
class FakePermissionApi extends PermissionApi {
  FakePermissionApi(this.api, {this.answer = 'granted'});

  final FakeDeviceApi api;

  /// What `request` returns.
  String answer;
  final Map<String, String> statuses = {};
  final List<String> requested = [];

  @override
  Future<String> status(String kind) async => statuses[kind] ?? 'denied';

  @override
  Future<String> request(String kind) async {
    requested.add(kind);
    statuses[kind] = answer;
    if (answer == 'granted') {
      if (kind == 'phone') api.phoneGranted = true;
      if (kind == 'location') api.locationGranted = true;
    }
    return answer;
  }
}

/// Hardware actions without hardware: records what was asked.
class FakeHardwareTestApi extends HardwareTestApi {
  final List<String> calls = [];
  String bluetooth = 'on';
  double loopbackDb = 24;
  double clipPeak = -14;
  String authResult = 'success';
  bool saveResult = true;
  Uint8List? saved;

  @override
  Future<void> vibrate(List<int> pattern) async => calls.add('vibrate');
  @override
  Future<bool> hasVibrator() async => true;
  @override
  Future<bool> hasTorch() async => true;
  @override
  Future<bool> setTorch(bool on) async {
    calls.add('torch $on');
    return true;
  }

  @override
  Future<void> setBrightness(double level) async {}
  @override
  Future<String> bluetoothState() async => bluetooth;
  @override
  Future<void> playTone(double freqHz, int durationMs, bool earpiece) async =>
      calls.add(earpiece ? 'earpiece' : 'speaker');
  @override
  Future<double> recordClip(int durationMs) async => clipPeak;
  @override
  Future<void> playClip() async => calls.add('playClip');
  @override
  Future<double> loopback(double freqHz) async => loopbackDb;
  @override
  Future<String> authenticate(String title, String subtitle, String cancel) async => authResult;
  @override
  Future<bool> saveDocument(String fileName, String mimeType, Uint8List bytes) async {
    saved = bytes;
    return saveResult;
  }
}

/// Background config, history and sessions in memory.
class FakeBackgroundApi extends BackgroundApi {
  BackgroundConfig config = BackgroundConfig(
    liveStatus: false,
    statusIcon: 'battery_level',
    chargeAlarm: false,
    chargeLimit: 80,
    batteryLow: false,
    lowLevel: 15,
    batteryHot: false,
    hotC: 45,
    chargingDone: false,
    storageFull: false,
    storagePercent: 90,
    weeklySummary: false,
    checkupReminder: false,
    fahrenheit: false,
    lastCheckupMs: 0,
  );
  final List<BackgroundConfig> saved = [];
  bool cleared = false;

  /// One sample every 15 minutes for the last 24 hours.
  List<HistorySample> samples = [
    for (var i = 0; i < 96; i++)
      HistorySample(
        timeMs: DateTime(2026, 10, 12).millisecondsSinceEpoch - (96 - i) * 900000,
        level: 100 - i ~/ 2,
        tempC: 30 + (i % 10) / 2,
        memUsed: 0.55 + (i % 7) / 50,
        charging: false,
      ),
  ];

  List<ChargeSession> chargeSessions = [
    ChargeSession(
      startMs: DateTime(2026, 10, 11, 22, 10).millisecondsSinceEpoch,
      endMs: DateTime(2026, 10, 11, 23, 52).millisecondsSinceEpoch,
      startLevel: 23,
      endLevel: 100,
      peakMa: 2140,
      avgMa: 1630,
      maxTempC: 36.4,
    ),
  ];

  @override
  Future<BackgroundConfig> getConfig() async => config;

  @override
  Future<void> setConfig(BackgroundConfig c) async {
    config = c;
    saved.add(c);
  }

  @override
  Future<List<HistorySample>> history(int sinceMs) async =>
      cleared ? [] : samples;

  @override
  Future<List<ChargeSession>> sessions(int limit) async =>
      cleared ? [] : chargeSessions;

  @override
  Future<void> clearHistory() async => cleared = true;

  @override
  Future<void> refreshWidgets() async {}

  @override
  Future<bool> notificationsEnabled() async => true;
}

class FakePlayApi extends PlayApi {
  int reviews = 0;
  int updateChecks = 0;

  @override
  Future<void> requestReview() async => reviews++;

  @override
  Future<void> checkForUpdate() async => updateChecks++;
}
