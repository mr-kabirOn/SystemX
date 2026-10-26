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

  /// The name set in Settings (About phone).
  String? deviceName;

  /// Settings.Secure.ANDROID_ID; unique per app signing key on Android 8+.
  String? androidId;

  /// Carrier or regional build code, e.g. Samsung's CSC ("KOO", "BKD").
  String? salesCode;

  /// ISO 3166 code of the country the build was made for, e.g. "KR".
  String? salesCountryIso;

  /// [salesCountryIso] as a country name in the phone's language.
  String? salesCountry;

  /// The maker's region name for the build, e.g. "KOREA", "GLOBAL".
  String? salesRegion;

  /// Default locale of the build, e.g. "ko-KR".
  String? productLocale;

  /// API level the phone launched with.
  int? firstApiLevel;
  String? hardwareRevision;

  /// The maker's Android skin and version, e.g. "One UI 8.0".
  String? oemSkin;

  /// Samsung Knox warranty bit: false while intact.
  bool? warrantyVoid;
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

  /// Full charge cycles SystemX worked out from the charging sessions it
  /// recorded since [trackedSinceMs]. Used when [cycleCount] is unknown.
  double? trackedCycles;
  int? trackedSinceMs;
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

class AppEntry {
  AppEntry({
    required this.packageName,
    required this.label,
    required this.system,
    required this.installedMs,
    required this.updatedMs,
  });
  String packageName;
  String label;
  String? versionName;
  bool system;
  int installedMs;
  int updatedMs;

  /// PNG, 96 px.
  Uint8List? icon;

  /// Sizes need Usage access; null without it.
  int? appBytes;
  int? dataBytes;
  int? cacheBytes;
}

/// Foreground use of one app during one day.
class AppUsage {
  AppUsage({
    required this.packageName,
    required this.label,
    required this.foregroundMs,
    required this.opens,
  });
  String packageName;
  String label;
  int foregroundMs;

  /// Times the app came to the foreground from another app or the lock screen.
  int opens;

  /// Estimated battery used while the app was on screen, in percentage
  /// points; null when SystemX has no battery history for that time.
  double? batteryPct;
}

/// Screen time for one local day, from Android's usage records.
class UsageDay {
  UsageDay({required this.dayStartMs, required this.screenOnMs, required this.apps});
  int dayStartMs;
  int screenOnMs;

  /// Unlocks (Android 9+); null on older versions.
  int? unlocks;

  /// Battery used while unplugged, in percentage points, from SystemX's
  /// history; null without history for that day.
  int? drainPct;

  /// The part of [drainPct] used with the screen on.
  double? screenDrainPct;

  /// Most used first.
  List<AppUsage> apps;
}

class ScreenTimeReport {
  ScreenTimeReport({required this.days, required this.icons});

  /// Same order as the requested day starts.
  List<UsageDay> days;

  /// PNG, 96 px, by package name.
  Map<String, Uint8List> icons;
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

  /// Opens a web page or mail link in another app. False if none can.
  bool openLink(String url);

  /// Apps that show in the launcher (no QUERY_ALL_PACKAGES needed).
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  List<AppEntry> apps();

  /// Whether the user allowed Usage access, which app sizes need.
  bool usageAccessGranted();

  /// Opens Android's App info page, where Clear cache lives.
  void openAppDetails(String packageName);

  /// Screen time for the days starting at [dayStartsMs] (local midnights,
  /// oldest first). Needs Usage access; days are empty without it.
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  ScreenTimeReport screenTime(List<int> dayStartsMs);
}

/// Runtime permissions, asked from the current activity.
/// [kind] is "location", "phone", "camera", "microphone" or "notifications".
/// Status is "granted", "denied" or "blocked" (denied with "don't ask again";
/// only the system settings screen can change it).
@HostApi()
abstract class PermissionApi {
  String status(String kind);
  @async
  String request(String kind);
}

/// Hardware actions for the diagnostics.
/// One reading from the CPU stress test.
class StressSample {
  StressSample({
    required this.elapsedMs,
    required this.workPerSec,
    required this.batteryTempC,
    required this.thermalStatus,
    required this.running,
  });
  int elapsedMs;

  /// Work units finished per second across all cores since the last sample.
  double workPerSec;
  double batteryTempC;
  double? cpuTempC;
  int thermalStatus;
  bool running;

  /// Why it stopped: "done", "user", "hot", "battery", "left" or "error".
  String? stopReason;
}

@HostApi()
abstract class HardwareTestApi {
  /// Vibrates with alternating on/off durations in milliseconds.
  void vibrate(List<int> pattern);
  bool hasVibrator();
  bool hasTorch();

  /// Returns false when no torch could be switched.
  bool setTorch(bool on);

  /// Window brightness 0–1, or -1 to follow the system setting again.
  void setBrightness(double level);

  /// "on", "off" or "none" (no Bluetooth hardware).
  String bluetoothState();

  @async
  void playTone(double freqHz, int durationMs, bool earpiece);

  /// Records from the microphone; returns the peak level in dBFS.
  @async
  double recordClip(int durationMs);

  /// Plays the last recorded clip on the loudspeaker.
  @async
  void playClip();

  /// Plays a tone on the speaker while recording; returns how much louder
  /// the tone frequency was than the silence before it, in dB.
  @async
  double loopback(double freqHz);

  /// System biometric prompt: "success", "cancelled", "none_enrolled" or
  /// "unavailable". The app never sees biometric data.
  @async
  String authenticate(String title, String subtitle, String cancel);

  /// Asks where to save a file (system file picker); false if cancelled.
  @async
  bool saveDocument(String fileName, String mimeType, Uint8List bytes);

  /// Starts the CPU stress test. Returns null when started, or why it
  /// won't start: "hot" (already warm) or "battery" (too low).
  String? startStress(int durationMs);

  /// The latest reading; also tells the runner the screen is still open.
  StressSample stressSample();
  void stopStress();

  /// Keeps the screen on while a test runs.
  void keepScreenOn(bool on);

  /// Asks for the display's highest refresh rate (true) or the default.
  void preferHighRefresh(bool high);
}

/// Alerts, live status and values the background code needs from the app.
/// Stored natively so workers and receivers can read it without Flutter.
class BackgroundConfig {
  BackgroundConfig({
    required this.liveStatus,
    required this.statusIcon,
    required this.chargeAlarm,
    required this.chargeLimit,
    required this.batteryLow,
    required this.lowLevel,
    required this.batteryHot,
    required this.hotC,
    required this.chargingDone,
    required this.storageFull,
    required this.storagePercent,
    required this.weeklySummary,
    required this.checkupReminder,
    required this.fahrenheit,
    required this.lastCheckupMs,
  });

  bool liveStatus;

  /// What the status bar icon shows: "battery_level", "battery_temp" or
  /// "net_speed".
  String statusIcon;
  bool chargeAlarm;
  int chargeLimit;
  bool batteryLow;
  int lowLevel;
  bool batteryHot;
  int hotC;
  bool chargingDone;
  bool storageFull;
  int storagePercent;
  bool weeklySummary;
  bool checkupReminder;
  bool fahrenheit;

  /// When the last checkup finished; 0 if never.
  int lastCheckupMs;
}

class HistorySample {
  HistorySample({
    required this.timeMs,
    required this.level,
    required this.tempC,
    required this.memUsed,
    required this.charging,
  });

  /// Wall-clock time (ms since epoch).
  int timeMs;
  int level;
  double tempC;

  /// Fraction of RAM in use, 0–1.
  double memUsed;
  bool charging;

  /// Whether the screen was on; null for samples from before it was recorded.
  bool? screenOn;
}

class ChargeSession {
  ChargeSession({
    required this.startMs,
    required this.startLevel,
    required this.endLevel,
    required this.maxTempC,
  });

  int startMs;

  /// null while still charging.
  int? endMs;
  int startLevel;
  int endLevel;
  int? peakMa;
  int? avgMa;
  double maxTempC;

  /// Full battery capacity measured over this charge (mAh in / % gained);
  /// null when the charge was too short or the counter isn't usable.
  int? capacityMah;
}

@HostApi()
abstract class BackgroundApi {
  BackgroundConfig getConfig();

  /// Saves the config and starts or stops the live status service and the
  /// background work to match.
  void setConfig(BackgroundConfig config);

  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  List<HistorySample> history(int sinceMs);

  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  List<ChargeSession> sessions(int limit);

  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void clearHistory();

  /// Redraws the home screen widgets now.
  void refreshWidgets();

  /// Whether Android lets this app post notifications at all.
  bool notificationsEnabled();
}

/// Google Play in-app review and updates.
@HostApi()
abstract class PlayApi {
  /// Shows Play's rating card if Play decides to (it limits how often).
  void requestReview();

  /// Offers a flexible update when Play has a newer version; installs it
  /// once downloaded.
  void checkForUpdate();
}
