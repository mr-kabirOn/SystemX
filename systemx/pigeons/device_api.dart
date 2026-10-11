// Contract between Dart and the Kotlin system layer.
// Regenerate after editing:  dart run pigeon --input pigeons/device_api.dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/platform/device_api.g.dart',
  kotlinOut:
      'android/app/src/main/kotlin/com/systemx/app/platform/DeviceApi.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.systemx.app.platform'),
))
class DeviceIdentity {
  DeviceIdentity({
    required this.manufacturer,
    required this.brand,
    required this.model,
    required this.marketName,
    required this.codename,
    required this.product,
    required this.board,
    required this.hardware,
    required this.isTablet,
  });
  String manufacturer;
  String brand;
  String model;
  String marketName;
  String codename;
  String product;
  String board;
  String hardware;
  bool isTablet;
}

class SystemInfo {
  SystemInfo({
    required this.release,
    required this.sdk,
    required this.buildId,
    required this.buildDisplay,
    required this.fingerprint,
    required this.incremental,
    required this.buildType,
    required this.tags,
    required this.buildTimeMs,
    required this.bootloader,
    required this.kernel,
    required this.vm,
    required this.uptimeMs,
    required this.locale,
    required this.timezone,
    required this.rootDetected,
    required this.encryption,
  });
  String release;
  int sdk;
  String? securityPatch;
  String buildId;
  String buildDisplay;
  String fingerprint;
  String incremental;
  String buildType;
  String tags;
  int buildTimeMs;
  String bootloader;
  String? baseband;
  String kernel;
  String vm;
  int uptimeMs;
  String locale;
  String timezone;
  String? playServices;
  String? playStore;
  String? playSystemUpdate;
  bool? treble;
  bool? seamlessUpdates;
  bool? dynamicPartitions;
  bool rootDetected;

  /// "encrypted", "unencrypted" or "unknown".
  String encryption;
}

class CpuCore {
  CpuCore({required this.index, required this.online});
  int index;
  bool online;
  int? minKhz;
  int? maxKhz;
  int? curKhz;
  String? partName;
}

class CpuInfo {
  CpuInfo({
    required this.cores,
    required this.coreList,
    required this.abis,
    required this.arch,
  });
  String? socManufacturer;
  String? socModel;
  String? hardware;
  int cores;
  List<CpuCore> coreList;
  String? governor;
  List<String> abis;
  String? features;
  String arch;
}

class GpuInfo {
  GpuInfo({required this.glEsVersion, required this.extensions});
  String? renderer;
  String? vendor;
  String? glVersion;
  String glEsVersion;
  String? vulkanVersion;
  int extensions;
}

class MemoryStats {
  MemoryStats({
    required this.total,
    required this.available,
    required this.threshold,
    required this.low,
  });
  int total;
  int available;
  int threshold;
  bool low;
  int? advertised;
  int? swapTotal;
  int? swapFree;
}

class StorageVolumeInfo {
  StorageVolumeInfo({
    required this.label,
    required this.primary,
    required this.removable,
    required this.state,
  });
  String label;
  bool primary;
  bool removable;
  String state;
  int? total;
  int? free;
}

class StorageInfo {
  StorageInfo({required this.total, required this.free, required this.volumes});
  int total;
  int free;
  int? advertised;
  String? fsType;
  List<StorageVolumeInfo> volumes;
}

class BatteryInfo {
  BatteryInfo({
    required this.level,
    required this.status,
    required this.plugged,
    required this.health,
    required this.tempC,
    required this.voltageMv,
    required this.present,
  });
  int level;

  /// BatteryManager.BATTERY_STATUS_* value.
  int status;

  /// BatteryManager.BATTERY_PLUGGED_* bitmask (0 = on battery).
  int plugged;

  /// BatteryManager.BATTERY_HEALTH_* value.
  int health;
  double tempC;
  int voltageMv;
  String? technology;
  bool present;

  /// Normalised so positive means charging, in milliamps.
  int? currentNowMa;
  int? currentAvgMa;
  int? chargeCounterMah;
  int? chargeTimeRemainingMs;
  int? cycleCount;
  double? designCapacityMah;
}

class DisplayInfo {
  DisplayInfo({
    required this.width,
    required this.height,
    required this.densityDpi,
    required this.xdpi,
    required this.ydpi,
    required this.refreshRate,
    required this.refreshRates,
    required this.hdrTypes,
    required this.wideColor,
    required this.hasCutout,
    required this.fontScale,
  });
  int width;
  int height;
  int densityDpi;
  double xdpi;
  double ydpi;
  double refreshRate;
  List<double> refreshRates;
  List<String> hdrTypes;
  bool wideColor;
  bool hasCutout;
  int? brightness;
  int? timeoutMs;
  double fontScale;
}

class NetworkInfo {
  NetworkInfo({
    required this.transport,
    required this.connected,
    required this.validated,
    required this.metered,
    required this.vpn,
    required this.ipv4,
    required this.ipv6,
    required this.dns,
    required this.wifiEnabled,
    required this.wifiNameNeedsLocation,
    required this.phonePermission,
  });

  /// "wifi", "cellular", "ethernet", "vpn", "none" or "other".
  String transport;
  bool connected;
  bool validated;
  bool metered;
  bool vpn;
  int? downKbps;
  int? upKbps;
  String? iface;
  List<String> ipv4;
  List<String> ipv6;
  List<String> dns;
  String? gateway;
  String? privateDns;

  bool wifiEnabled;
  String? ssid;
  String? bssid;
  int? rssi;
  int? linkMbps;
  int? txMbps;
  int? rxMbps;
  int? freqMhz;

  /// ScanResult.WIFI_STANDARD_* value.
  int? wifiStandard;
  bool wifiNameNeedsLocation;

  String? operatorName;
  String? networkCountry;
  bool? roaming;
  int? signalLevel;
  int? signalDbm;
  String? dataNetworkType;
  bool phonePermission;
}

class SimCard {
  SimCard({required this.slot, required this.embedded, required this.dataSim});
  int slot;
  String? carrier;
  String? displayName;
  String? country;
  String? mcc;
  String? mnc;
  bool embedded;
  bool dataSim;
  String? networkType;
}

class SimInfo {
  SimInfo({
    required this.permissionGranted,
    required this.slotCount,
    required this.simState,
    required this.cards,
  });
  bool permissionGranted;
  int slotCount;

  /// MCC+MNC of the default SIM, e.g. "47001". Needs no permission.
  String? simOperator;
  String? simOperatorName;
  String? country;

  /// TelephonyManager.SIM_STATE_* value.
  int simState;
  List<SimCard> cards;
}

class CameraInfo {
  CameraInfo({
    required this.id,
    required this.facing,
    required this.apertures,
    required this.focalLengths,
    required this.ois,
    required this.flash,
    required this.hardwareLevel,
    required this.raw,
    required this.logicalMulti,
  });
  String id;

  /// "back", "front" or "external".
  String facing;
  int? pixelW;
  int? pixelH;
  double? sensorWmm;
  double? sensorHmm;
  List<double> apertures;
  List<double> focalLengths;
  bool ois;
  bool flash;
  String hardwareLevel;
  bool raw;
  bool logicalMulti;
  String? maxVideo;
}

class SensorInfo {
  SensorInfo({
    required this.type,
    required this.typeName,
    required this.name,
    required this.vendor,
    required this.power,
    required this.maxRange,
    required this.resolution,
    required this.minDelayUs,
    required this.wakeUp,
    required this.version,
  });
  int type;
  String typeName;
  String name;
  String vendor;
  double power;
  double maxRange;
  double resolution;
  int minDelayUs;
  bool wakeUp;
  int version;
}

class CodecInfo {
  CodecInfo({required this.name, required this.encoder, required this.types});
  String name;
  bool encoder;
  List<String> types;
  bool? hardware;
}

class MediaInfo {
  MediaInfo({
    required this.codecs,
    required this.audioOutputs,
    required this.lowLatency,
    required this.proAudio,
  });
  List<CodecInfo> codecs;
  String? widevineLevel;
  String? widevineVersion;
  String? hdcp;
  List<String> audioOutputs;
  bool lowLatency;
  bool proAudio;
  bool? spatial;
}

class FeaturesInfo {
  FeaturesInfo({required this.systemFeatures});
  List<String> systemFeatures;
  bool? le2mPhy;
  bool? leCodedPhy;
  bool? leExtendedAdvertising;
  bool? leAudio;
  bool? wifi5Ghz;
  bool? wifi6Ghz;
  bool? wifi6;
  bool? wifi7;
  bool? nfcEnabled;
}

class SecurityInfo {
  SecurityInfo({
    required this.screenLock,
    required this.encryption,
    required this.devOptions,
    required this.adb,
    required this.rootDetected,
    required this.biometricStatus,
  });
  bool screenLock;
  String encryption;
  String? securityPatch;
  bool devOptions;
  bool adb;
  String? verifiedBoot;
  bool? bootloaderLocked;
  bool rootDetected;

  /// "enrolled", "none_enrolled", "no_hardware" or "unavailable".
  String biometricStatus;
}

/// Values that change second to second, read on every live tick.
class LiveStats {
  LiveStats({
    required this.timeMs,
    required this.cpuKhz,
    required this.cpuMaxKhz,
    required this.memTotal,
    required this.memAvailable,
    required this.batteryLevel,
    required this.batteryStatus,
    required this.plugged,
    required this.batteryTempC,
    required this.voltageMv,
    required this.rxBytes,
    required this.txBytes,
    required this.thermalStatus,
  });

  /// SystemClock.elapsedRealtime when read.
  int timeMs;

  /// Current clock per core in kHz; 0 when the core is offline or hidden.
  List<int> cpuKhz;
  List<int> cpuMaxKhz;
  int memTotal;
  int memAvailable;
  int batteryLevel;
  int batteryStatus;
  int plugged;
  double batteryTempC;
  int voltageMv;

  /// Milliamps, positive while charging.
  int? currentNowMa;

  /// Bytes since boot on all interfaces; -1 when unsupported.
  int rxBytes;
  int txBytes;

  /// PowerManager.THERMAL_STATUS_* (0 none … 6 shutdown), -1 before Android 10.
  int thermalStatus;

  /// Thermal headroom (Android 11+): 1.0 means severe throttling is reached.
  double? thermalHeadroom;

  /// Hottest CPU thermal zone, when the phone lets apps read it.
  double? cpuTempC;
}

@HostApi()
abstract class DeviceInfoApi {
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  DeviceIdentity identity();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  SystemInfo system();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  CpuInfo cpu();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  GpuInfo gpu();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  MemoryStats memory();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  StorageInfo storage();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  BatteryInfo battery();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  DisplayInfo display();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  NetworkInfo network();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  SimInfo sim();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  List<CameraInfo> cameras();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  List<SensorInfo> sensors();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  MediaInfo media();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  FeaturesInfo features();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  SecurityInfo security();
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  LiveStats live();

  /// Opens a system settings screen by intent action. Returns false if the
  /// phone has no screen for that action.
  bool openSettings(String action);

  /// Opens the dialer with a USSD code filled in (no call permission needed).
  void dial(String code);
}

/// Runtime permissions, asked from the current activity.
/// [kind] is "location", "phone" or "notifications".
/// Status is "granted", "denied" or "blocked" (denied with "don't ask again";
/// only the system settings screen can change it).
@HostApi()
abstract class PermissionApi {
  String status(String kind);
  @async
  String request(String kind);
}
