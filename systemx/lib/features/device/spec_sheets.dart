import 'dart:math' as math;

import '../../core/format.dart';
import '../../core/settings/settings.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import 'device_data.dart';
import 'soc_names.dart';
import 'specs.dart';

/// System settings screens the security check links to.
abstract final class SettingsActions {
  static const security = 'android.settings.SECURITY_SETTINGS';
  static const systemUpdate = 'android.settings.SYSTEM_UPDATE_SETTINGS';
  static const developer = 'android.settings.APPLICATION_DEVELOPMENT_SETTINGS';
  static const location = 'android.settings.LOCATION_SOURCE_SETTINGS';
  static const storage = 'android.settings.INTERNAL_STORAGE_SETTINGS';
  static const appDetails = 'app_details';
}

/// Turns probe results into labelled rows. Pure, so it is unit tested.
class SpecBuilder {
  SpecBuilder(this.l, {this.tempUnit = TempUnit.celsius, DateTime? now})
    : now = now ?? DateTime.now();

  final AppLocalizations l;
  final TempUnit tempUnit;
  final DateTime now;

  final _sections = <SpecSection>[];
  String? _title;
  List<Spec> _specs = [];

  void _section(String? title) {
    _flush();
    _title = title;
  }

  void _flush() {
    if (_specs.isNotEmpty) _sections.add(SpecSection(_title, _specs));
    _specs = [];
  }

  /// Adds a row; a null value reads "Not available on this device".
  void _add(
    String label,
    String? value, {
    String? hint,
    SpecTone tone = SpecTone.neutral,
    SpecAction? action,
  }) {
    if (value == null || value.isEmpty && action == null) {
      _specs.add(
        Spec(
          label,
          l.notAvailable,
          hint: hint,
          available: false,
          action: action,
        ),
      );
    } else {
      _specs.add(Spec(label, value, hint: hint, tone: tone, action: action));
    }
  }

  /// Adds a row only when there is a value.
  void _opt(String label, String? value, {String? hint}) {
    if (value != null && value.isNotEmpty) _add(label, value, hint: hint);
  }

  String? _yesNo(bool? b) => b == null ? null : (b ? l.yes : l.no);
  String? _supported(bool? b) =>
      b == null ? null : (b ? l.supported : l.notSupported);

  /// Builds the rows for [category]. Empty when its probe failed.
  List<SpecSection> build(DeviceCategory category, DeviceSnapshot s) {
    _sections.clear();
    _specs = [];
    _title = null;
    switch (category) {
      case DeviceCategory.device:
        if (s.identity case final v?) _device(v);
      case DeviceCategory.system:
        if (s.system case final v?) _system(v);
      case DeviceCategory.processor:
        if (s.cpu case final v?) _cpu(v);
      case DeviceCategory.gpu:
        if (s.gpu case final v?) _gpu(v);
      case DeviceCategory.memory:
        if (s.memory case final v?) _memory(v);
      case DeviceCategory.storage:
        if (s.storage case final v?) _storage(v);
      case DeviceCategory.battery:
        if (s.battery case final v?) _battery(v);
      case DeviceCategory.display:
        if (s.display case final v?) _display(v);
      case DeviceCategory.network:
        if (s.network case final v?) _network(v);
      case DeviceCategory.sim:
        if (s.sim case final v?) _sim(v, s.network);
      case DeviceCategory.cameras:
        if (s.cameras case final v?) _cameras(v);
      case DeviceCategory.sensors:
        if (s.sensors case final v?) _sensors(v);
      case DeviceCategory.media:
        if (s.media case final v?) _media(v);
      case DeviceCategory.features:
        if (s.features case final v?) _features(v);
      case DeviceCategory.security:
        if (s.security case final v?) _security(v);
    }
    _flush();
    return List.unmodifiable(_sections);
  }

  // ---- Device & system ----

  void _device(DeviceIdentity d) {
    _add(l.specModelName, d.marketName);
    _add(l.specManufacturer, d.manufacturer);
    _add(l.specBrand, d.brand);
    _add(l.specModel, d.model);
    _add(l.specCodename, d.codename);
    _add(l.specProduct, d.product);
    _add(l.specBoard, d.board);
    _add(l.specHardware, d.hardware);
    _add(l.specDeviceType, d.isTablet ? l.deviceTablet : l.devicePhone);
    _opt(l.specDeviceName, d.deviceName);
    _opt(l.specOemSkin, d.oemSkin);
    final first = d.firstApiLevel;
    _opt(l.specLaunchedWith, first == null ? null : androidName(first));
    _opt(l.specHwRevision, d.hardwareRevision);

    _section(l.secSales);
    _opt(l.specSalesCode, d.salesCode, hint: l.salesCodeHint);
    final iso = d.salesCountryIso;
    _opt(
      l.specSalesCountry,
      iso == null ? null : (d.salesCountry == null ? iso : '${d.salesCountry} ($iso)'),
    );
    _opt(l.specSalesRegion, _titleCase(d.salesRegion));
    _opt(l.specProductLocale, d.productLocale);

    _section(l.secIdentifiers);
    _opt(l.specAndroidId, d.androidId, hint: l.androidIdHint);
    _specs.add(Spec(
      l.specImei,
      l.wifiNameHidden,
      hint: l.imeiHint,
      available: false,
      action: const Dial('*#06#'),
    ));
    final warranty = d.warrantyVoid;
    if (warranty != null) {
      _add(
        l.specWarranty,
        warranty ? l.warrantyVoid : l.warrantyIntact,
        hint: l.warrantyHint,
        tone: warranty ? SpecTone.warn : SpecTone.good,
      );
    }
  }

  static String? _titleCase(String? s) => s == null || s.isEmpty
      ? s
      : s
          .toLowerCase()
          .split(RegExp(r'[\s_]+'))
          .where((w) => w.isNotEmpty)
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join(' ');

  void _system(SystemInfo s) {
    _section(null);
    _add(l.specAndroidVersion, '${androidName(s.sdk)} (${s.release})');
    _add(l.specApiLevel, '${s.sdk}');
    final patch = parsePatch(s.securityPatch);
    if (patch != null) {
      final months = monthsSince(patch, now);
      _add(
        l.specSecurityPatch,
        formatDate(patch, l.localeName),
        hint: l.monthsOld(months),
        tone: _patchTone(months),
      );
    } else {
      _add(l.specSecurityPatch, null);
    }
    _add(l.specBuildNumber, s.buildDisplay);
    _add(
      l.specBuildDate,
      formatDate(
        DateTime.fromMillisecondsSinceEpoch(s.buildTimeMs),
        l.localeName,
      ),
    );
    _add(l.specBuildType, '${s.buildType} · ${s.tags}');
    _add(l.specIncremental, s.incremental);
    _add(l.specFingerprint, s.fingerprint);

    _section(l.secGooglePlay);
    _add(l.specPlayServices, s.playServices);
    _add(l.specPlayStore, s.playStore);
    _add(l.specPlaySystemUpdate, s.playSystemUpdate);

    _section(l.secPlatform);
    _add(l.specKernel, s.kernel);
    _add(l.specBootloader, s.bootloader);
    _add(l.specBaseband, s.baseband);
    _add(l.specRuntime, s.vm);
    _add(l.specTreble, _supported(s.treble));
    _add(l.specSeamlessUpdates, _supported(s.seamlessUpdates));
    _add(l.specDynamicPartitions, _supported(s.dynamicPartitions));
    _add(
      l.specEncryption,
      _encryption(s.encryption),
      tone: _encryptionTone(s.encryption),
    );
    _add(
      l.specRoot,
      s.rootDetected ? l.detected : l.notDetected,
      tone: s.rootDetected ? SpecTone.warn : SpecTone.neutral,
    );

    _section(l.secSession);
    _add(l.specUptime, formatDuration(Duration(milliseconds: s.uptimeMs)));
    _add(l.specLanguage, s.locale);
    _add(l.specTimezone, s.timezone);
  }

  SpecTone _patchTone(int months) => months <= 2
      ? SpecTone.good
      : months <= 6
      ? SpecTone.warn
      : SpecTone.bad;

  String? _encryption(String e) => switch (e) {
    'encrypted' => l.encrypted,
    'unencrypted' => l.notEncrypted,
    _ => null,
  };

  SpecTone _encryptionTone(String e) => switch (e) {
    'encrypted' => SpecTone.good,
    'unencrypted' => SpecTone.bad,
    _ => SpecTone.neutral,
  };

  // ---- Processor & graphics ----

  /// Marketing chip name, e.g. "Google Tensor G3".
  static String? chipName(CpuInfo c) {
    final soc = lookupSoc(c.socModel, c.hardware);
    if (soc != null) return soc.name;
    final parts = [c.socManufacturer, c.socModel].whereType<String>();
    if (parts.isNotEmpty) return parts.join(' ');
    return c.hardware;
  }

  void _cpu(CpuInfo c) {
    final soc = lookupSoc(c.socModel, c.hardware);
    _section(null);
    _add(l.specChip, chipName(c));
    _opt(l.specProcess, soc?.process);
    _opt(l.specSocMaker, c.socManufacturer);
    _opt(l.specSocModel, c.socModel);
    _add(l.specHardware, c.hardware);
    _add(l.specCores, '${c.cores}');
    _add(l.specClusters, clusterSummary(c.coreList.map((e) => e.maxKhz)));
    final parts = <String, int>{};
    for (final core in c.coreList) {
      final p = core.partName;
      if (p != null) parts[p] = (parts[p] ?? 0) + 1;
    }
    _opt(
      l.specCoreTypes,
      parts.entries.map((e) => '${e.value}× ${e.key}').join('\n'),
    );
    _add(l.specGovernor, c.governor);
    _add(l.specArchitecture, c.arch);
    _add(l.specAbis, c.abis.join(', '));
    _opt(l.specInstructions, c.features);

    _section(l.secCores);
    for (final core in c.coreList) {
      final cur = core.curKhz;
      final max = core.maxKhz;
      final hint = [
        if (core.partName != null) core.partName!,
        if (max != null) l.maxFreq(formatFreqKhz(max)),
      ].join(' · ');
      _add(
        l.coreN(core.index),
        !core.online
            ? l.coreOffline
            : cur == null
            ? null
            : formatFreqKhz(cur),
        hint: hint.isEmpty ? null : hint,
      );
    }
  }

  void _gpu(GpuInfo g) {
    _add(l.specRenderer, g.renderer);
    _add(l.specVendor, g.vendor);
    _add(l.specOpenGlEs, g.glEsVersion);
    _add(l.specGlDriver, g.glVersion);
    _add(l.specVulkan, g.vulkanVersion ?? l.notSupported);
    _add(l.specGlExtensions, g.extensions > 0 ? '${g.extensions}' : null);
  }

  // ---- Memory & storage ----

  void _memory(MemoryStats m) {
    final used = m.total - m.available;
    final pct = m.total > 0 ? (used * 100 / m.total).round() : 0;
    _add(
      l.specInstalled,
      m.advertised != null
          ? formatBytes(m.advertised!, decimals: 0)
          : formatAdvertisedRam(m.total),
    );
    _add(l.specUsable, formatBytes(m.total), hint: l.usableHint);
    _add(
      l.specInUse,
      '${formatBytes(used)} · $pct%',
      tone: pct >= 90 ? SpecTone.warn : SpecTone.neutral,
    );
    _add(l.specAvailable, formatBytes(m.available));
    _add(l.specLowMemoryAt, formatBytes(m.threshold), hint: l.lowMemoryHint);
    _add(
      l.specLowMemoryNow,
      _yesNo(m.low),
      tone: m.low ? SpecTone.warn : SpecTone.neutral,
    );
    final swap = m.swapTotal;
    if (swap != null && swap > 0) {
      _add(l.specSwap, formatBytes(swap));
      if (m.swapFree case final free?) {
        _add(l.specSwapUsed, formatBytes(swap - free));
      }
    } else {
      _add(l.specSwap, l.none);
    }
  }

  void _storage(StorageInfo st) {
    final used = st.total - st.free;
    final pct = st.total > 0 ? (used * 100 / st.total).round() : 0;
    _section(null);
    _add(l.specTotal, formatStorage(st.total));
    _add(
      l.specUsed,
      '${formatStorage(used)} · $pct%',
      tone: pct >= 90 ? SpecTone.warn : SpecTone.neutral,
      action: const OpenSettings(SettingsActions.storage),
    );
    _add(l.specFree, formatStorage(st.free));
    _add(l.specFileSystem, st.fsType);

    for (final v in st.volumes) {
      _section(v.label.isEmpty ? l.secVolume : v.label);
      if (v.total case final total?) {
        _add(l.specTotal, formatStorage(total));
        if (v.free case final free?) _add(l.specFree, formatStorage(free));
      }
      _add(
        l.specVolumeType,
        v.primary
            ? l.volumeInternal
            : (v.removable ? l.volumeRemovable : l.volumeOther),
      );
      _add(l.specState, v.state);
    }
  }

  // ---- Battery ----

  String batteryStatus(int status) => switch (status) {
    2 => l.batCharging,
    3 => l.batDischarging,
    4 => l.batNotCharging,
    5 => l.batFull,
    _ => l.unknown,
  };

  String batteryHealth(int health) => switch (health) {
    2 => l.healthGood,
    3 => l.healthOverheat,
    4 => l.healthDead,
    5 => l.healthOverVoltage,
    6 => l.healthFailure,
    7 => l.healthCold,
    _ => l.unknown,
  };

  String powerSource(int plugged) {
    if (plugged == 0) return l.plugBattery;
    return [
      if (plugged & 1 != 0) l.plugAc,
      if (plugged & 2 != 0) l.plugUsb,
      if (plugged & 4 != 0) l.plugWireless,
      if (plugged & 8 != 0) l.plugDock,
    ].join(', ');
  }

  /// Full capacity estimated from the charge counter at the current level.
  static double? estimatedCapacity(BatteryInfo b) {
    final counter = b.chargeCounterMah;
    if (counter == null || b.level < 10 || counter <= 0) return null;
    return counter * 100 / b.level;
  }

  void _battery(BatteryInfo b) {
    _section(null);
    _add(l.specLevel, b.level >= 0 ? '${b.level}%' : null);
    _add(l.specStatus, batteryStatus(b.status));
    _add(l.specPowerSource, powerSource(b.plugged));
    _add(
      l.specHealth,
      batteryHealth(b.health),
      tone: b.health == 2
          ? SpecTone.good
          : b.health == 1
          ? SpecTone.neutral
          : SpecTone.bad,
    );
    _add(
      l.specTemperature,
      formatTemp(b.tempC, tempUnit),
      tone: b.tempC >= 45
          ? SpecTone.bad
          : b.tempC >= 40
          ? SpecTone.warn
          : SpecTone.neutral,
    );
    _add(
      l.specVoltage,
      b.voltageMv > 0
          ? '${formatDouble(b.voltageMv / 1000, decimals: 2)} V'
          : null,
    );
    _add(l.specTechnology, b.technology);

    _section(l.secCharging);
    final now = b.currentNowMa;
    if (now != null) {
      final watts = now.abs() * b.voltageMv / 1e6;
      _add(
        l.specCurrentNow,
        '${now > 0 ? '+' : ''}$now mA · ${formatDouble(watts)} W',
      );
    } else {
      _add(l.specCurrentNow, null);
    }
    _opt(
      l.specCurrentAvg,
      b.currentAvgMa == null ? null : '${b.currentAvgMa} mA',
    );
    final ttf = b.chargeTimeRemainingMs;
    if (b.status == 2) {
      _add(
        l.specTimeToFull,
        ttf == null ? null : formatDuration(Duration(milliseconds: ttf)),
      );
    }

    _section(l.secCapacity);
    final tracked = b.trackedCycles;
    final since = b.trackedSinceMs;
    if (b.cycleCount != null) {
      _add(l.specCycleCount, '${b.cycleCount}', hint: l.cycleHint);
    } else if (tracked != null && since != null) {
      // Android doesn't report the count here; SystemX's own tally instead.
      _add(
        l.specCycleCountTracked,
        tracked.toStringAsFixed(1),
        hint: l.cycleTrackedHint(formatDate(
          DateTime.fromMillisecondsSinceEpoch(since),
          l.localeName,
        )),
      );
    }
    _add(
      l.specChargeCounter,
      b.chargeCounterMah == null ? null : '${b.chargeCounterMah} mAh',
    );
    final est = estimatedCapacity(b);
    final design = b.designCapacityMah;
    if (est != null) {
      final pct = design != null && design > 0
          ? ' · ${(est * 100 / design).round()}%'
          : '';
      _add(
        l.specEstCapacity,
        '${est.round()} mAh$pct',
        hint: l.estCapacityHint,
      );
    } else {
      _add(l.specEstCapacity, null, hint: l.estCapacityHint);
    }
    _add(
      l.specDesignCapacity,
      design == null ? null : '${design.round()} mAh',
      hint: l.designCapacityHint,
    );
  }

  // ---- Display ----

  void _display(DisplayInfo d) {
    final inches = displayInches(d.width, d.height, d.xdpi, d.ydpi);
    _section(null);
    _add(l.specResolution, '${d.width} × ${d.height}');
    _add(
      l.specSize,
      inches > 0 ? '${inches.toStringAsFixed(1)}"' : null,
      hint: l.sizeHint,
    );
    _add(l.specAspect, aspectRatio(d.width, d.height));
    _add(l.specDensity, '${d.densityDpi} dpi · ${densityBucket(d.densityDpi)}');
    _add(l.specRefreshRate, '${d.refreshRate.round()} Hz');
    _add(
      l.specRefreshRates,
      d.refreshRates.map((r) => '${formatDouble(r)} Hz').join(', '),
    );
    _add(
      l.specHdr,
      d.hdrTypes.isEmpty ? l.notSupported : d.hdrTypes.join(', '),
    );
    _add(l.specWideColor, _supported(d.wideColor));
    _add(l.specCutout, _yesNo(d.hasCutout));

    _section(l.secSettings);
    _opt(l.specBrightness, d.brightness?.toString(), hint: l.brightnessHint);
    if (d.timeoutMs case final ms?) {
      _add(
        l.specTimeout,
        ms < 60000
            ? l.seconds('${ms ~/ 1000}')
            : formatDuration(Duration(milliseconds: ms)),
      );
    }
    _add(l.specFontScale, '${(d.fontScale * 100).round()}%');
  }

  // ---- Network & SIM ----

  String transportName(String t) => switch (t) {
    'wifi' => 'Wi-Fi',
    'cellular' => l.netMobile,
    'ethernet' => 'Ethernet',
    'vpn' => 'VPN',
    'none' => l.netNone,
    _ => l.netOther,
  };

  String wifiQuality(int rssi) => rssi >= -55
      ? l.signalExcellent
      : rssi >= -67
      ? l.signalGood
      : rssi >= -75
      ? l.signalFair
      : l.signalWeak;

  void _network(NetworkInfo n) {
    _section(null);
    _add(l.specConnection, transportName(n.transport));
    if (n.connected) {
      _add(
        l.specInternet,
        n.validated ? l.netWorking : l.netNoInternet,
        tone: n.validated ? SpecTone.good : SpecTone.warn,
      );
      _add(l.specMetered, _yesNo(n.metered));
      _add(l.specVpn, n.vpn ? l.on : l.off);
      _opt(l.specInterface, n.iface);
      _add(l.specIpv4, n.ipv4.join('\n'));
      _opt(l.specIpv6, n.ipv6.join('\n'));
      _add(l.specGateway, n.gateway);
      _add(l.specDns, n.dns.join('\n'));
      _opt(l.specPrivateDns, n.privateDns);
      if (n.downKbps != null || n.upKbps != null) {
        _add(
          l.specBandwidth,
          '↓ ${_kbps(n.downKbps)} · ↑ ${_kbps(n.upKbps)}',
          hint: l.bandwidthHint,
        );
      }
    }

    if (n.transport == 'wifi') {
      _section('Wi-Fi');
      if (n.ssid != null) {
        _add(l.specWifiName, n.ssid);
      } else if (n.wifiNameNeedsLocation) {
        _add(
          l.specWifiName,
          l.wifiNameHidden,
          hint: l.wifiNameHint,
          action: const AskPermission('location'),
        );
      } else {
        _add(l.specWifiName, null);
      }
      _opt('BSSID', n.bssid);
      if (n.rssi case final rssi?) {
        _add(l.specSignal, '$rssi dBm · ${wifiQuality(rssi)}');
      }
      _add(l.specWifiStandard, wifiStandardName(n.wifiStandard));
      if (n.freqMhz case final f?) {
        final ch = wifiChannel(f);
        _add(
          l.specFrequency,
          ['$f MHz', ?wifiBand(f), if (ch != null) l.channelN(ch)].join(' · '),
        );
      }
      _opt(l.specLinkSpeed, n.linkMbps == null ? null : '${n.linkMbps} Mbps');
      if (n.txMbps != null || n.rxMbps != null) {
        _add(l.specTxRx, '↑ ${n.txMbps ?? '–'} · ↓ ${n.rxMbps ?? '–'} Mbps');
      }
    } else if (!n.wifiEnabled) {
      _section('Wi-Fi');
      _add(l.specWifi, l.off);
    }

    _mobile(n);
  }

  void _mobile(NetworkInfo n) {
    if (n.operatorName == null && n.signalLevel == null) return;
    _section(l.secMobile);
    _add(l.specOperator, n.operatorName);
    _opt(l.specCountry, n.networkCountry);
    _add(l.specRoaming, _yesNo(n.roaming));
    if (n.signalLevel case final level?) {
      final dbm = n.signalDbm == null ? '' : ' · ${n.signalDbm} dBm';
      _add(l.specSignal, '${l.signalBars(level)}$dbm');
    }
    if (n.phonePermission) {
      _add(l.specNetworkType, n.dataNetworkType);
    } else {
      _add(
        l.specNetworkType,
        l.needsPhone,
        hint: l.needsPhoneHint,
        action: const AskPermission('phone'),
      );
    }
  }

  String _kbps(int? kbps) {
    if (kbps == null) return '–';
    if (kbps >= 1000) return '${formatDouble(kbps / 1000)} Mbps';
    return '$kbps kbps';
  }

  String simState(int state) => switch (state) {
    1 => l.simAbsent,
    2 => l.simPin,
    3 => l.simPuk,
    4 => l.simLocked,
    5 => l.simReady,
    6 => l.simNotReady,
    7 => l.simDisabled,
    8 || 9 => l.simError,
    _ => l.unknown,
  };

  void _sim(SimInfo s, NetworkInfo? n) {
    _section(null);
    _add(l.specSlots, '${s.slotCount}');
    _add(
      l.specSimState,
      simState(s.simState),
      tone: s.simState == 5 ? SpecTone.good : SpecTone.neutral,
    );
    _opt(l.specOperator, s.simOperatorName);
    if (s.simOperator case final op? when op.length >= 5) {
      _add(l.specMccMnc, '${op.substring(0, 3)} / ${op.substring(3)}');
    }
    _opt(l.specCountry, s.country);

    if (!s.permissionGranted) {
      _add(
        l.specSimDetails,
        l.needsPhone,
        hint: l.needsPhoneHint,
        action: const AskPermission('phone'),
      );
    }
    for (final c in s.cards) {
      _section(l.simN(c.slot));
      _add(l.specCarrier, c.carrier);
      if (c.displayName != null && c.displayName != c.carrier) {
        _add(l.specSimName, c.displayName);
      }
      _opt(l.specCountry, c.country);
      if (c.mcc != null && c.mnc != null) {
        _add(l.specMccMnc, '${c.mcc} / ${c.mnc}');
      }
      _add(l.specSimType, c.embedded ? 'eSIM' : l.simPhysical);
      _add(l.specDataSim, _yesNo(c.dataSim));
      _opt(l.specNetworkType, c.networkType);
    }
    if (n != null) _mobile(n);
  }

  // ---- Cameras ----

  void _cameras(List<CameraInfo> cams) {
    final seen = <String, int>{};
    final total = {for (final c in cams) c.facing: 0};
    for (final c in cams) {
      total[c.facing] = total[c.facing]! + 1;
    }
    for (final c in cams) {
      final n = seen[c.facing] = (seen[c.facing] ?? 0) + 1;
      final name = switch (c.facing) {
        'back' => l.cameraRear,
        'front' => l.cameraFront,
        _ => l.cameraExternal,
      };
      _section(total[c.facing]! > 1 ? '$name $n' : name);
      if (c.pixelW != null && c.pixelH != null) {
        _add(
          l.specResolution,
          megapixels(c.pixelW!, c.pixelH!),
          hint: '${c.pixelW} × ${c.pixelH}',
        );
      } else {
        _add(l.specResolution, null);
      }
      if (c.sensorWmm != null && c.sensorHmm != null) {
        _add(
          l.specSensorSize,
          '${opticalFormat(c.sensorWmm!, c.sensorHmm!)} · ${formatDouble(c.sensorWmm!)} × ${formatDouble(c.sensorHmm!)} mm',
        );
      }
      _add(
        l.specAperture,
        c.apertures.isEmpty
            ? null
            : c.apertures.map((a) => 'f/${formatDouble(a)}').join(', '),
      );
      _add(
        l.specFocalLength,
        c.focalLengths.isEmpty
            ? null
            : c.focalLengths
                  .map((f) => '${formatDouble(f, decimals: 2)} mm')
                  .join(', '),
      );
      _add(l.specOis, _supported(c.ois));
      _add(l.specFlash, _yesNo(c.flash));
      _add(l.specMaxVideo, c.maxVideo);
      _add(l.specRaw, _supported(c.raw));
      _add(l.specCamera2Level, c.hardwareLevel);
      if (c.logicalMulti) _add(l.specMultiCamera, l.yes);
      _add(l.specCameraId, c.id);
    }
  }

  // ---- Sensors ----

  void _sensors(List<SensorInfo> sensors) {
    final sorted = [...sensors]..sort((a, b) => a.type.compareTo(b.type));
    _section(l.sensorCount(sensors.length));
    _add(l.specSensorTotal, '${sensors.length}');
    _add(l.specSensorKinds, '${sensors.map((s) => s.type).toSet().length}');
    _add(l.specSensorWakeUp, '${sensors.where((s) => s.wakeUp).length}',
        hint: l.sensorWakeUpHint);
    final vendor = sensors.where((s) => s.type >= _vendorSensorType).length;
    if (vendor > 0) _add(l.specSensorVendor, '$vendor');

    for (final group in SensorGroup.values) {
      final members = sorted.where((s) => sensorGroup(s.type) == group).toList();
      if (members.isEmpty) continue;
      _section('${_groupName(group)} · ${members.length}');
      for (final s in members) {
        _specs.add(
          Spec(
            s.name,
            prettyIdentifier(s.typeName),
            hint: s.vendor,
            action: ShowSensor(s),
          ),
        );
      }
    }
  }

  static const _vendorSensorType = 65536;

  String _groupName(SensorGroup g) => switch (g) {
        SensorGroup.motion => l.sensorGroupMotion,
        SensorGroup.position => l.sensorGroupPosition,
        SensorGroup.environment => l.sensorGroupEnvironment,
        SensorGroup.health => l.sensorGroupHealth,
        SensorGroup.other => l.sensorGroupOther,
      };

  // ---- Media ----

  static const _codecNames = {
    'video/avc': 'H.264 (AVC)',
    'video/hevc': 'H.265 (HEVC)',
    'video/av01': 'AV1',
    'video/x-vnd.on2.vp8': 'VP8',
    'video/x-vnd.on2.vp9': 'VP9',
    'video/dolby-vision': 'Dolby Vision',
    'video/mp4v-es': 'MPEG-4',
    'video/3gpp': 'H.263',
    'video/mpeg2': 'MPEG-2',
    'audio/mp4a-latm': 'AAC',
    'audio/opus': 'Opus',
    'audio/flac': 'FLAC',
    'audio/mpeg': 'MP3',
    'audio/vorbis': 'Vorbis',
    'audio/3gpp': 'AMR-NB',
    'audio/amr-wb': 'AMR-WB',
    'audio/raw': 'PCM',
    'audio/g711-alaw': 'G.711 A-law',
    'audio/g711-mlaw': 'G.711 µ-law',
    'audio/ac3': 'Dolby Digital',
    'audio/eac3': 'Dolby Digital Plus',
    'audio/ac4': 'Dolby AC-4',
    'audio/vnd.dts': 'DTS',
  };

  void _media(MediaInfo m) {
    _section(l.secDrm);
    _add(
      l.specWidevine,
      m.widevineLevel,
      hint: m.widevineLevel == 'L1' ? l.widevineL1Hint : null,
    );
    _opt(l.specWidevineVersion, m.widevineVersion);
    _opt(l.specHdcp, m.hdcp);

    _section(l.secAudio);
    _add(l.specAudioOutputs, m.audioOutputs.join(', '));
    _add(l.specLowLatency, _supported(m.lowLatency));
    _add(l.specProAudio, _supported(m.proAudio));
    _opt(l.specSpatial, _supported(m.spatial));

    // Collapse codecs to one row per format, preferring hardware.
    final dec = <String, bool?>{};
    final enc = <String, bool?>{};
    for (final c in m.codecs) {
      final target = c.encoder ? enc : dec;
      for (final t in c.types) {
        final prev = target[t];
        target[t] = prev == true || c.hardware == true
            ? true
            : (c.hardware ?? prev);
      }
    }
    String part(bool? hw, String withHw, String withSw, String plain) =>
        hw == null ? plain : (hw ? withHw : withSw);

    for (final kind in const ['video/', 'audio/']) {
      final types =
          {...dec.keys, ...enc.keys}.where((t) => t.startsWith(kind)).toList()
            ..sort(
              (a, b) => (_codecNames[a] ?? a).compareTo(_codecNames[b] ?? b),
            );
      if (types.isEmpty) continue;
      _section(kind == 'video/' ? l.secVideoCodecs : l.secAudioCodecs);
      for (final t in types) {
        _specs.add(
          Spec(
            _codecNames[t] ?? t,
            [
              if (dec.containsKey(t))
                part(dec[t], l.codecDecodeHw, l.codecDecodeSw, l.codecDecode),
              if (enc.containsKey(t))
                part(enc[t], l.codecEncodeHw, l.codecEncodeSw, l.codecEncode),
            ].join(' · '),
          ),
        );
      }
    }
  }

  // ---- Features ----

  /// Hardware features worth calling out, by PackageManager feature name.
  List<(String, String)> get _highlights => [
    ('android.hardware.bluetooth', 'Bluetooth'),
    ('android.hardware.bluetooth_le', 'Bluetooth Low Energy'),
    ('android.hardware.nfc', 'NFC'),
    ('android.hardware.uwb', l.featUwb),
    ('android.hardware.consumerir', l.featIr),
    ('android.hardware.usb.host', l.featUsbHost),
    ('android.hardware.fingerprint', l.featFingerprint),
    ('android.hardware.biometrics.face', l.featFace),
    ('android.hardware.location.gps', 'GPS'),
    ('android.hardware.telephony', l.featTelephony),
    ('android.hardware.wifi.direct', 'Wi-Fi Direct'),
    ('android.hardware.wifi.aware', 'Wi-Fi Aware'),
    ('android.hardware.wifi.rtt', l.featWifiRtt),
  ];

  /// Short list of headline features this phone has, for summaries.
  List<String> headlineFeatures(FeaturesInfo f) {
    final has = f.systemFeatures.toSet();
    return [
      if (has.contains('android.hardware.nfc')) 'NFC',
      if (has.contains('android.hardware.uwb')) 'UWB',
      if (f.wifi7 == true) 'Wi-Fi 7' else if (f.wifi6 == true) 'Wi-Fi 6',
      if (f.leAudio == true) 'LE Audio',
      if (has.contains('android.hardware.consumerir')) 'IR',
      if (has.contains('android.hardware.fingerprint')) l.featFingerprint,
    ];
  }

  void _features(FeaturesInfo f) {
    final has = f.systemFeatures.toSet();
    _section(l.secHardware);
    for (final (feature, label) in _highlights) {
      final present = has.contains(feature);
      var value = present ? l.yes : l.no;
      if (feature == 'android.hardware.nfc' &&
          present &&
          f.nfcEnabled != null) {
        value = f.nfcEnabled! ? l.on : l.off;
      }
      _add(label, value);
    }

    _section('Bluetooth');
    _add('LE Audio', _supported(f.leAudio));
    _add(l.featLe2m, _supported(f.le2mPhy));
    _add(l.featLeCoded, _supported(f.leCodedPhy));
    _add(l.featLeExtAdv, _supported(f.leExtendedAdvertising));

    _section('Wi-Fi');
    _add('5 GHz', _supported(f.wifi5Ghz));
    _add('6 GHz', _supported(f.wifi6Ghz));
    _add('Wi-Fi 6 (802.11ax)', _supported(f.wifi6));
    _add('Wi-Fi 7 (802.11be)', _supported(f.wifi7));

    _section(l.secAllFeatures(f.systemFeatures.length));
    for (final name in f.systemFeatures) {
      _specs.add(Spec(name, ''));
    }
  }

  // ---- Security ----

  void _security(SecurityInfo s) {
    const sec = OpenSettings(SettingsActions.security);
    _add(
      l.specScreenLock,
      s.screenLock ? l.lockSet : l.lockNotSet,
      tone: s.screenLock ? SpecTone.good : SpecTone.bad,
      hint: s.screenLock ? null : l.lockHint,
      action: sec,
    );
    final (bio, bioTone) = switch (s.biometricStatus) {
      'enrolled' => (l.bioEnrolled, SpecTone.good),
      'none_enrolled' => (l.bioNone, SpecTone.warn),
      'no_hardware' => (l.bioNoHardware, SpecTone.neutral),
      _ => (null, SpecTone.neutral),
    };
    _add(l.specBiometrics, bio, tone: bioTone, action: sec);
    _add(
      l.specEncryption,
      _encryption(s.encryption),
      tone: _encryptionTone(s.encryption),
      action: sec,
    );

    final patch = parsePatch(s.securityPatch);
    if (patch != null) {
      final months = monthsSince(patch, now);
      _add(
        l.specSecurityPatch,
        l.monthsOld(months),
        hint: formatDate(patch, l.localeName),
        tone: _patchTone(months),
        action: const OpenSettings(SettingsActions.systemUpdate),
      );
    } else {
      _add(l.specSecurityPatch, null);
    }

    const dev = OpenSettings(SettingsActions.developer);
    _add(
      l.specDevOptions,
      s.devOptions ? l.on : l.off,
      tone: s.devOptions ? SpecTone.warn : SpecTone.good,
      action: s.devOptions ? dev : null,
    );
    _add(
      l.specUsbDebugging,
      s.adb ? l.on : l.off,
      tone: s.adb ? SpecTone.warn : SpecTone.good,
      hint: s.adb ? l.adbHint : null,
      action: s.adb ? dev : null,
    );
    _add(
      l.specBootloader,
      switch (s.bootloaderLocked) {
        true => l.locked,
        false => l.unlocked,
        null => null,
      },
      tone: switch (s.bootloaderLocked) {
        true => SpecTone.good,
        false => SpecTone.warn,
        null => SpecTone.neutral,
      },
    );
    _add(
      l.specVerifiedBoot,
      s.verifiedBoot == null ? null : prettyIdentifier(s.verifiedBoot!),
      tone: switch (s.verifiedBoot) {
        'green' => SpecTone.good,
        'yellow' || 'orange' => SpecTone.warn,
        'red' => SpecTone.bad,
        _ => SpecTone.neutral,
      },
    );
    _add(
      l.specRoot,
      s.rootDetected ? l.detected : l.notDetected,
      tone: s.rootDetected ? SpecTone.warn : SpecTone.good,
    );
  }

  // ---- One-line summaries for the category list ----

  String? summary(DeviceCategory c, DeviceSnapshot s) {
    String join(List<String?> parts) =>
        parts.whereType<String>().where((p) => p.isNotEmpty).join(' · ');
    switch (c) {
      case DeviceCategory.device:
        final d = s.identity;
        return d == null ? null : join([d.manufacturer, d.codename]);
      case DeviceCategory.system:
        final v = s.system;
        return v == null ? null : join([androidName(v.sdk), 'API ${v.sdk}']);
      case DeviceCategory.processor:
        final v = s.cpu;
        if (v == null) return null;
        return join([
          chipName(v),
          l.coresCount(v.cores),
          lookupSoc(v.socModel, v.hardware)?.process,
        ]);
      case DeviceCategory.gpu:
        final v = s.gpu;
        if (v == null) return null;
        final vk = v.vulkanVersion?.split('.').take(2).join('.');
        return join([v.renderer, if (vk != null) 'Vulkan $vk']);
      case DeviceCategory.memory:
        final v = s.memory;
        if (v == null) return null;
        return join([
          v.advertised != null
              ? formatBytes(v.advertised!, decimals: 0)
              : formatAdvertisedRam(v.total),
          l.freeAmount(formatBytes(v.available)),
        ]);
      case DeviceCategory.storage:
        final v = s.storage;
        return v == null
            ? null
            : join([
                formatStorage(v.total),
                l.freeAmount(formatStorage(v.free)),
              ]);
      case DeviceCategory.battery:
        final v = s.battery;
        if (v == null) return null;
        return join([
          '${v.level}%',
          batteryHealth(v.health),
          if (v.cycleCount != null) l.cyclesCount(v.cycleCount!),
        ]);
      case DeviceCategory.display:
        final v = s.display;
        if (v == null) return null;
        final inches = displayInches(v.width, v.height, v.xdpi, v.ydpi);
        return join([
          if (inches > 0) '${inches.toStringAsFixed(1)}"',
          '${v.width}×${v.height}',
          '${math.max(v.refreshRate, v.refreshRates.fold<double>(0, math.max)).round()} Hz',
        ]);
      case DeviceCategory.network:
        final v = s.network;
        if (v == null) return null;
        if (v.transport == 'wifi') {
          final std = switch (v.wifiStandard) {
            4 => 'Wi-Fi 4',
            5 => 'Wi-Fi 5',
            6 => 'Wi-Fi 6',
            8 => 'Wi-Fi 7',
            _ => 'Wi-Fi',
          };
          return join([
            std,
            if (v.freqMhz != null) wifiBand(v.freqMhz!),
            if (v.rssi != null) '${v.rssi} dBm',
          ]);
        }
        return join([transportName(v.transport), v.operatorName]);
      case DeviceCategory.sim:
        final v = s.sim;
        if (v == null) return null;
        return join([
          v.simOperatorName ?? simState(v.simState),
          l.slotsCount(v.slotCount),
        ]);
      case DeviceCategory.cameras:
        final v = s.cameras;
        if (v == null) return null;
        final back = v.where((c) => c.facing == 'back' && c.pixelW != null);
        final main = back.isEmpty
            ? null
            : back.reduce(
                (a, b) =>
                    a.pixelW! * (a.pixelH ?? 0) >= b.pixelW! * (b.pixelH ?? 0)
                    ? a
                    : b,
              );
        return join([
          l.camerasCount(v.length),
          if (main != null)
            l.mainCamera(megapixels(main.pixelW!, main.pixelH ?? 0)),
        ]);
      case DeviceCategory.sensors:
        final v = s.sensors;
        return v == null ? null : l.sensorCount(v.length);
      case DeviceCategory.media:
        final v = s.media;
        if (v == null) return null;
        return join([
          if (v.widevineLevel != null) 'Widevine ${v.widevineLevel}',
          l.codecsCount(v.codecs.length),
        ]);
      case DeviceCategory.features:
        final v = s.features;
        return v == null ? null : join(headlineFeatures(v));
      case DeviceCategory.security:
        final v = s.security;
        if (v == null) return null;
        final specs = build(c, s).expand((x) => x.specs);
        final rated = specs.where((x) => x.tone != SpecTone.neutral);
        final passed = rated.where((x) => x.tone == SpecTone.good).length;
        return l.checksPassed(passed, rated.length);
    }
  }
}

enum SensorGroup { motion, position, environment, health, other }

/// Android's own grouping of sensor types (motion, position, environment),
/// plus health sensors. Vendor types (65536 and up) count as other.
SensorGroup sensorGroup(int type) => switch (type) {
      1 || 4 || 9 || 10 || 11 || 15 || 16 || 17 || 18 || 19 || 29 || 30 ||
      35 || 38 || 39 || 40 || 41 || 42 =>
        SensorGroup.motion,
      2 || 3 || 8 || 14 || 20 || 27 || 28 || 32 || 36 || 37 =>
        SensorGroup.position,
      5 || 6 || 7 || 12 || 13 => SensorGroup.environment,
      21 || 31 || 34 => SensorGroup.health,
      _ => SensorGroup.other,
    };
