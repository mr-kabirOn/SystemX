// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SystemX';

  @override
  String get navHome => 'Home';

  @override
  String get navDevice => 'Device';

  @override
  String get navTests => 'Tests';

  @override
  String get navMonitor => 'Monitor';

  @override
  String get onb1Title => 'Know your phone, inside out';

  @override
  String get onb1Body =>
      'Live stats and every spec your phone exposes, in one clear place.';

  @override
  String get onb2Title => 'Test every part';

  @override
  String get onb2Body =>
      'A guided checkup tests the screen, speakers, cameras, sensors and more, then gives you a report.';

  @override
  String get onb3Title => 'Private by design';

  @override
  String get onb3Body =>
      'No account, no tracking. Your data never leaves this phone.';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbNext => 'Next';

  @override
  String get onbStart => 'Get started';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get homeYourPhone => 'Your phone';

  @override
  String get healthExcellent => 'Excellent health';

  @override
  String get healthScoreLabel => 'Score';

  @override
  String get runCheckup => 'Run checkup';

  @override
  String get metricCpu => 'CPU';

  @override
  String get metricMemory => 'Memory';

  @override
  String get metricBattery => 'Battery';

  @override
  String get metricStorage => 'Storage';

  @override
  String get metricNetwork => 'Network';

  @override
  String get metricThermal => 'Thermal';

  @override
  String freeAmount(String amount) {
    return '$amount free';
  }

  @override
  String get thermalNormal => 'Normal';

  @override
  String headroom(int percent) {
    return 'Headroom $percent%';
  }

  @override
  String get tipChargeLimit => 'Unplug at 80% to slow battery wear.';

  @override
  String get tipSetAlarm => 'Set alarm';

  @override
  String get sample => 'Sample';

  @override
  String get deviceTitle => 'Device';

  @override
  String get deviceSearch => 'Search specs';

  @override
  String get deviceHeroTitle => 'This phone';

  @override
  String get catDevice => 'Device';

  @override
  String get catDeviceSub => 'Model, maker, codename';

  @override
  String get catSystem => 'System';

  @override
  String get catSystemSub => 'Android version, security patch, kernel';

  @override
  String get catProcessor => 'Processor';

  @override
  String get catProcessorSub => 'Chip, cores, live clock speeds';

  @override
  String get catGpu => 'Graphics';

  @override
  String get catGpuSub => 'GPU, OpenGL ES, Vulkan';

  @override
  String get catMemory => 'Memory';

  @override
  String get catMemorySub => 'RAM in use and available';

  @override
  String get catStorage => 'Storage';

  @override
  String get catStorageSub => 'Internal space, SD card, USB';

  @override
  String get catBattery => 'Battery';

  @override
  String get catBatterySub => 'Health, temperature, charging speed';

  @override
  String get catDisplay => 'Display';

  @override
  String get catDisplaySub => 'Resolution, refresh rate, HDR';

  @override
  String get catNetwork => 'Network';

  @override
  String get catNetworkSub => 'Wi-Fi, mobile data, IP addresses';

  @override
  String get catSim => 'SIM & mobile';

  @override
  String get catSimSub => 'Carrier, signal, balance check';

  @override
  String get catCameras => 'Cameras';

  @override
  String get catCamerasSub => 'Megapixels, aperture, video';

  @override
  String get catSensors => 'Sensors';

  @override
  String get catSensorsSub => 'Every sensor with live readings';

  @override
  String get catMedia => 'Media';

  @override
  String get catMediaSub => 'Codecs, DRM, audio outputs';

  @override
  String get catFeatures => 'Features';

  @override
  String get catFeaturesSub => 'Bluetooth, NFC, 5G, fingerprint';

  @override
  String get catSecurity => 'Security check';

  @override
  String get catSecuritySub => 'Screen lock, encryption, updates';

  @override
  String get testsTitle => 'Tests';

  @override
  String get checkupTitle => 'Full checkup';

  @override
  String checkupMeta(int count, int minutes) {
    return '$count tests · about $minutes minutes';
  }

  @override
  String get checkupBody =>
      'Automatic tests run on their own. We\'ll ask you about the rest.';

  @override
  String get startCheckup => 'Start checkup';

  @override
  String get singleTests => 'Single tests';

  @override
  String get testDisplay => 'Display';

  @override
  String get testTouch => 'Touch';

  @override
  String get testSpeaker => 'Speaker';

  @override
  String get testEarpiece => 'Earpiece';

  @override
  String get testMicrophone => 'Microphone';

  @override
  String get testVibration => 'Vibration';

  @override
  String get testCameras => 'Cameras';

  @override
  String get testFlashlight => 'Flashlight';

  @override
  String get testSensors => 'Sensors';

  @override
  String get testButtons => 'Buttons';

  @override
  String get testWifi => 'Wi-Fi';

  @override
  String get testBluetooth => 'Bluetooth';

  @override
  String get testGps => 'GPS';

  @override
  String get testFingerprint => 'Fingerprint';

  @override
  String get testCharging => 'Charging';

  @override
  String get testStorage => 'Storage speed';

  @override
  String get monitorTitle => 'Monitor';

  @override
  String get monitorBody =>
      'Live charts for every part of your phone. Drag across a chart to read earlier values.';

  @override
  String get monitorCpu => 'Processor clock';

  @override
  String get monitorRam => 'Memory use';

  @override
  String get monitorBattery => 'Battery current';

  @override
  String get monitorNet => 'Network speed';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get secAppearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get pureBlack => 'Pure black';

  @override
  String get pureBlackSub => 'Saves power on AMOLED screens';

  @override
  String get wallpaperColors => 'Wallpaper colors';

  @override
  String get wallpaperColorsSub =>
      'Match the accent to your wallpaper (Android 12+)';

  @override
  String get secUnits => 'Units';

  @override
  String get temperature => 'Temperature';

  @override
  String get secLanguage => 'Language';

  @override
  String get langSystem => 'Phone language';

  @override
  String get langEnglish => 'English';

  @override
  String get langBangla => 'বাংলা';

  @override
  String get secLive => 'Live data';

  @override
  String get refreshRate => 'Refresh rate';

  @override
  String seconds(String value) {
    return '$value s';
  }

  @override
  String get secPrivacy => 'Privacy';

  @override
  String get privacyPermissions => 'Privacy & permissions';

  @override
  String get privacyPermissionsSub => 'See what SystemX can access and why';

  @override
  String get secAbout => 'About';

  @override
  String get version => 'Version';

  @override
  String get licenses => 'Open-source licenses';

  @override
  String get replayIntro => 'Show intro again';

  @override
  String get privacyBanner =>
      'Your data stays on this phone. No account, no ads tracking, nothing uploaded.';

  @override
  String get privacyIntro =>
      'SystemX works without any of these. Turn on only what you need.';

  @override
  String get permNotifications => 'Notifications';

  @override
  String get permNotificationsSub => 'Live status and battery alerts';

  @override
  String get permLocation => 'Location';

  @override
  String get permLocationSub => 'Wi-Fi name and GPS test';

  @override
  String get permPhone => 'Phone';

  @override
  String get permPhoneSub => 'SIM slots and signal details';

  @override
  String get permCamera => 'Camera';

  @override
  String get permCameraSub => 'Only during the camera test';

  @override
  String get permMicrophone => 'Microphone';

  @override
  String get permMicrophoneSub => 'Only during the microphone test';

  @override
  String get permAllow => 'Allow';

  @override
  String get permNotNow => 'Not now';

  @override
  String copied(String label) {
    return 'Copied $label';
  }

  @override
  String get notAvailable => 'Not available on this device';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get none => 'None';

  @override
  String get unknown => 'Unknown';

  @override
  String get supported => 'Supported';

  @override
  String get notSupported => 'Not supported';

  @override
  String get detected => 'Detected';

  @override
  String get notDetected => 'Not detected';

  @override
  String get encrypted => 'Encrypted';

  @override
  String get notEncrypted => 'Not encrypted';

  @override
  String get locked => 'Locked';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get secGooglePlay => 'Google Play';

  @override
  String get secPlatform => 'Platform';

  @override
  String get secSession => 'Session';

  @override
  String get secCores => 'Cores';

  @override
  String get secCharging => 'Charging';

  @override
  String get secCapacity => 'Capacity';

  @override
  String get secSettings => 'Settings';

  @override
  String get secMobile => 'Mobile network';

  @override
  String get secVolume => 'Storage volume';

  @override
  String get secDrm => 'Video protection (DRM)';

  @override
  String get secAudio => 'Audio';

  @override
  String get secVideoCodecs => 'Video codecs';

  @override
  String get secAudioCodecs => 'Audio codecs';

  @override
  String get secHardware => 'Hardware';

  @override
  String get specModelName => 'Model name';

  @override
  String get specManufacturer => 'Manufacturer';

  @override
  String get specBrand => 'Brand';

  @override
  String get specModel => 'Model number';

  @override
  String get specCodename => 'Codename';

  @override
  String get specProduct => 'Product';

  @override
  String get specBoard => 'Board';

  @override
  String get specHardware => 'Hardware';

  @override
  String get specDeviceType => 'Device type';

  @override
  String get devicePhone => 'Phone';

  @override
  String get deviceTablet => 'Tablet';

  @override
  String get specAndroidVersion => 'Android version';

  @override
  String get specApiLevel => 'API level';

  @override
  String get specSecurityPatch => 'Security patch';

  @override
  String get specBuildNumber => 'Build number';

  @override
  String get specBuildDate => 'Build date';

  @override
  String get specBuildType => 'Build type';

  @override
  String get specIncremental => 'Incremental version';

  @override
  String get specFingerprint => 'Build fingerprint';

  @override
  String get specPlayServices => 'Google Play services';

  @override
  String get specPlayStore => 'Play Store';

  @override
  String get specPlaySystemUpdate => 'Google Play system update';

  @override
  String get specKernel => 'Kernel';

  @override
  String get specBootloader => 'Bootloader';

  @override
  String get specBaseband => 'Baseband (modem)';

  @override
  String get specRuntime => 'Runtime';

  @override
  String get specTreble => 'Project Treble';

  @override
  String get specSeamlessUpdates => 'Seamless (A/B) updates';

  @override
  String get specDynamicPartitions => 'Dynamic partitions';

  @override
  String get specEncryption => 'Encryption';

  @override
  String get specRoot => 'Root access';

  @override
  String get specUptime => 'Uptime';

  @override
  String get specLanguage => 'Language';

  @override
  String get specTimezone => 'Time zone';

  @override
  String get specChip => 'Chip';

  @override
  String get specProcess => 'Process node';

  @override
  String get specSocMaker => 'Chip maker';

  @override
  String get specSocModel => 'Chip model code';

  @override
  String get specCores => 'Cores';

  @override
  String get specClusters => 'Clusters';

  @override
  String get specCoreTypes => 'Core types';

  @override
  String get specGovernor => 'Governor';

  @override
  String get specArchitecture => 'Architecture';

  @override
  String get specAbis => 'Supported ABIs';

  @override
  String get specInstructions => 'Instruction features';

  @override
  String get coreOffline => 'Offline (sleeping)';

  @override
  String get specRenderer => 'GPU';

  @override
  String get specVendor => 'Vendor';

  @override
  String get specOpenGlEs => 'OpenGL ES';

  @override
  String get specGlDriver => 'Driver version';

  @override
  String get specVulkan => 'Vulkan';

  @override
  String get specGlExtensions => 'OpenGL extensions';

  @override
  String get specInstalled => 'Installed RAM';

  @override
  String get specUsable => 'Usable by Android';

  @override
  String get usableHint => 'Part of the RAM is reserved for the modem and GPU';

  @override
  String get specInUse => 'In use';

  @override
  String get specAvailable => 'Available';

  @override
  String get specLowMemoryAt => 'Low-memory point';

  @override
  String get lowMemoryHint =>
      'Android starts closing background apps below this';

  @override
  String get specLowMemoryNow => 'Low on memory now';

  @override
  String get specSwap => 'Swap (zRAM)';

  @override
  String get specSwapUsed => 'Swap in use';

  @override
  String get specTotal => 'Total';

  @override
  String get specUsed => 'Used';

  @override
  String get specFree => 'Free';

  @override
  String get specFileSystem => 'File system';

  @override
  String get specVolumeType => 'Type';

  @override
  String get specState => 'State';

  @override
  String get volumeInternal => 'Internal';

  @override
  String get volumeRemovable => 'Removable (SD card or USB)';

  @override
  String get volumeOther => 'Other';

  @override
  String get specLevel => 'Level';

  @override
  String get specStatus => 'Status';

  @override
  String get specPowerSource => 'Power source';

  @override
  String get specHealth => 'Health';

  @override
  String get specTemperature => 'Temperature';

  @override
  String get specVoltage => 'Voltage';

  @override
  String get specTechnology => 'Technology';

  @override
  String get specCurrentNow => 'Current now';

  @override
  String get specCurrentAvg => 'Average current';

  @override
  String get specTimeToFull => 'Time to full';

  @override
  String get specCycleCount => 'Charge cycles';

  @override
  String get cycleHint => 'Reported by the battery';

  @override
  String get specChargeCounter => 'Charge left';

  @override
  String get specEstCapacity => 'Estimated full capacity';

  @override
  String get estCapacityHint => 'Estimate, from the charge counter';

  @override
  String get specDesignCapacity => 'Design capacity';

  @override
  String get designCapacityHint =>
      'From the system power profile; some makers leave it wrong';

  @override
  String get batCharging => 'Charging';

  @override
  String get batDischarging => 'Discharging';

  @override
  String get batNotCharging => 'Plugged in, not charging';

  @override
  String get batFull => 'Full';

  @override
  String get healthGood => 'Good';

  @override
  String get healthOverheat => 'Overheating';

  @override
  String get healthDead => 'Dead';

  @override
  String get healthOverVoltage => 'Over voltage';

  @override
  String get healthFailure => 'Failure';

  @override
  String get healthCold => 'Too cold';

  @override
  String get plugBattery => 'On battery';

  @override
  String get plugAc => 'Charger';

  @override
  String get plugUsb => 'USB';

  @override
  String get plugWireless => 'Wireless';

  @override
  String get plugDock => 'Dock';

  @override
  String get specResolution => 'Resolution';

  @override
  String get specSize => 'Screen size';

  @override
  String get sizeHint => 'Calculated from the pixel density the screen reports';

  @override
  String get specAspect => 'Aspect ratio';

  @override
  String get specDensity => 'Pixel density';

  @override
  String get specRefreshRate => 'Refresh rate now';

  @override
  String get specRefreshRates => 'Supported refresh rates';

  @override
  String get specHdr => 'HDR';

  @override
  String get specWideColor => 'Wide color';

  @override
  String get specCutout => 'Camera cutout';

  @override
  String get specBrightness => 'Brightness level';

  @override
  String get brightnessHint => 'Raw value; the range depends on the maker';

  @override
  String get specTimeout => 'Screen timeout';

  @override
  String get specFontScale => 'Font size';

  @override
  String get specConnection => 'Connection';

  @override
  String get specInternet => 'Internet';

  @override
  String get netWorking => 'Working';

  @override
  String get netNoInternet => 'Connected, no internet';

  @override
  String get netMobile => 'Mobile data';

  @override
  String get netNone => 'Not connected';

  @override
  String get netOther => 'Other';

  @override
  String get specMetered => 'Metered';

  @override
  String get specVpn => 'VPN';

  @override
  String get specInterface => 'Interface';

  @override
  String get specIpv4 => 'IPv4 address';

  @override
  String get specIpv6 => 'IPv6 address';

  @override
  String get specGateway => 'Gateway';

  @override
  String get specDns => 'DNS servers';

  @override
  String get specPrivateDns => 'Private DNS';

  @override
  String get specBandwidth => 'Link capacity';

  @override
  String get bandwidthHint =>
      'Android\'s estimate of the connection\'s top speed, not a speed test';

  @override
  String get specWifi => 'Wi-Fi';

  @override
  String get specWifiName => 'Network name';

  @override
  String get wifiNameHidden => 'Hidden by Android';

  @override
  String get wifiNameHint => 'Tap to allow Location and show it';

  @override
  String get specSignal => 'Signal';

  @override
  String get signalExcellent => 'Excellent';

  @override
  String get signalGood => 'Good';

  @override
  String get signalFair => 'Fair';

  @override
  String get signalWeak => 'Weak';

  @override
  String get specWifiStandard => 'Wi-Fi standard';

  @override
  String get specFrequency => 'Frequency';

  @override
  String get specLinkSpeed => 'Link speed';

  @override
  String get specTxRx => 'Send / receive';

  @override
  String get specOperator => 'Operator';

  @override
  String get specCountry => 'Country';

  @override
  String get specRoaming => 'Roaming';

  @override
  String get specNetworkType => 'Network type';

  @override
  String get needsPhone => 'Needs Phone permission';

  @override
  String get needsPhoneHint => 'Tap to allow it and show SIM details';

  @override
  String get specSlots => 'SIM slots';

  @override
  String get specSimState => 'SIM status';

  @override
  String get specMccMnc => 'MCC / MNC';

  @override
  String get specSimDetails => 'SIM details';

  @override
  String get specCarrier => 'Carrier';

  @override
  String get specSimName => 'Name';

  @override
  String get specSimType => 'Type';

  @override
  String get simPhysical => 'Physical SIM';

  @override
  String get specDataSim => 'Used for mobile data';

  @override
  String get simAbsent => 'No SIM';

  @override
  String get simPin => 'PIN required';

  @override
  String get simPuk => 'PUK required';

  @override
  String get simLocked => 'Network locked';

  @override
  String get simReady => 'Ready';

  @override
  String get simNotReady => 'Not ready';

  @override
  String get simDisabled => 'Disabled';

  @override
  String get simError => 'Card error';

  @override
  String get cameraRear => 'Rear camera';

  @override
  String get cameraFront => 'Front camera';

  @override
  String get cameraExternal => 'External camera';

  @override
  String get specSensorSize => 'Sensor size';

  @override
  String get specAperture => 'Aperture';

  @override
  String get specFocalLength => 'Focal length';

  @override
  String get specOis => 'Optical stabilization (OIS)';

  @override
  String get specFlash => 'Flash';

  @override
  String get specMaxVideo => 'Best video';

  @override
  String get specRaw => 'RAW photos';

  @override
  String get specCamera2Level => 'Camera2 API level';

  @override
  String get specMultiCamera => 'Combines several lenses';

  @override
  String get specCameraId => 'Camera ID';

  @override
  String get specWidevine => 'Widevine level';

  @override
  String get widevineL1Hint => 'L1 allows HD and 4K streaming';

  @override
  String get specWidevineVersion => 'Widevine version';

  @override
  String get specHdcp => 'Max HDCP';

  @override
  String get specAudioOutputs => 'Audio outputs';

  @override
  String get specLowLatency => 'Low-latency audio';

  @override
  String get specProAudio => 'Pro audio';

  @override
  String get specSpatial => 'Spatial audio';

  @override
  String get codecDecode => 'Decode';

  @override
  String get codecDecodeHw => 'Decode (hardware)';

  @override
  String get codecDecodeSw => 'Decode (software)';

  @override
  String get codecEncode => 'Encode';

  @override
  String get codecEncodeHw => 'Encode (hardware)';

  @override
  String get codecEncodeSw => 'Encode (software)';

  @override
  String get featUwb => 'Ultra-wideband (UWB)';

  @override
  String get featIr => 'IR blaster';

  @override
  String get featUsbHost => 'USB host (OTG)';

  @override
  String get featFingerprint => 'Fingerprint';

  @override
  String get featFace => 'Face unlock hardware';

  @override
  String get featTelephony => 'Mobile network';

  @override
  String get featWifiRtt => 'Wi-Fi RTT (indoor location)';

  @override
  String get featLe2m => 'LE 2M PHY (faster)';

  @override
  String get featLeCoded => 'LE Coded PHY (long range)';

  @override
  String get featLeExtAdv => 'LE extended advertising';

  @override
  String get specScreenLock => 'Screen lock';

  @override
  String get lockSet => 'Set';

  @override
  String get lockNotSet => 'Not set';

  @override
  String get lockHint => 'Anyone who picks up the phone can open it';

  @override
  String get specBiometrics => 'Biometrics';

  @override
  String get bioEnrolled => 'Enrolled';

  @override
  String get bioNone => 'Not set up';

  @override
  String get bioNoHardware => 'No hardware';

  @override
  String get specDevOptions => 'Developer options';

  @override
  String get specUsbDebugging => 'USB debugging';

  @override
  String get adbHint => 'Turn off when you are not developing';

  @override
  String get specVerifiedBoot => 'Verified boot';

  @override
  String monthsOld(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months old',
      one: '1 month old',
      zero: 'This month',
    );
    return '$_temp0';
  }

  @override
  String coreN(int index) {
    return 'Core $index';
  }

  @override
  String maxFreq(String freq) {
    return 'max $freq';
  }

  @override
  String channelN(int channel) {
    return 'channel $channel';
  }

  @override
  String signalBars(int level) {
    return '$level of 4 bars';
  }

  @override
  String simN(int slot) {
    return 'SIM $slot';
  }

  @override
  String sensorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sensors',
      one: '1 sensor',
    );
    return '$_temp0';
  }

  @override
  String coresCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cores',
      one: '1 core',
    );
    return '$_temp0';
  }

  @override
  String cyclesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cycles',
      one: '1 cycle',
    );
    return '$_temp0';
  }

  @override
  String slotsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slots',
      one: '1 slot',
    );
    return '$_temp0';
  }

  @override
  String camerasCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cameras',
      one: '1 camera',
    );
    return '$_temp0';
  }

  @override
  String mainCamera(String mp) {
    return '$mp main';
  }

  @override
  String codecsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codecs',
      one: '1 codec',
    );
    return '$_temp0';
  }

  @override
  String checksPassed(int passed, int total) {
    return '$passed of $total checks passed';
  }

  @override
  String secAllFeatures(int count) {
    return 'All system features ($count)';
  }

  @override
  String get live => 'Live';

  @override
  String securityPatchOn(String date) {
    return 'Security patch $date';
  }

  @override
  String get specsUnavailable =>
      'Android didn\'t share this information on your phone.';

  @override
  String get settingsUnavailable =>
      'Your phone doesn\'t have this settings screen.';

  @override
  String get shareSpecs => 'Share spec sheet';

  @override
  String get clearSearch => 'Clear';

  @override
  String get searchHint =>
      'Search every spec on this phone, like \"Vulkan\", \"5 GHz\" or \"patch\".';

  @override
  String searchNoResults(String query) {
    return 'Nothing matches \"$query\".';
  }

  @override
  String specSheetHeader(String device, String date) {
    return '$device spec sheet · $date';
  }

  @override
  String specSheetSubject(String device) {
    return '$device specs';
  }

  @override
  String get specSheetFooter => 'Made with SystemX';

  @override
  String get permLocationTitle => 'Show the Wi-Fi name';

  @override
  String get permLocationReason =>
      'Android only shares the Wi-Fi network name with apps that have Location permission. SystemX uses it for this value and the GPS test, and never tracks where you are.';

  @override
  String get permPhoneTitle => 'Show SIM details';

  @override
  String get permPhoneReason =>
      'Phone permission lets SystemX read your SIM slots, carrier names and mobile network type. It can\'t make calls or read your phone number.';

  @override
  String get permBlocked =>
      'You turned this off earlier, so Android won\'t ask again. Open Settings › Permissions to allow it.';

  @override
  String get permOpenSettings => 'Open settings';

  @override
  String get statusAllowed => 'Allowed';

  @override
  String get statusNotAllowed => 'Not allowed';

  @override
  String get statusBlocked => 'Off in settings';

  @override
  String get balanceTitle => 'Balance and quick codes';

  @override
  String get balanceBody =>
      'Tap a code to open your dialer with it filled in. Nothing is dialed until you press call.';

  @override
  String get liveReading => 'Live reading';

  @override
  String get sensorWaiting =>
      'Waiting for a reading. Some sensors only report when something changes, like covering the proximity sensor.';

  @override
  String get sensorOnChange => 'When the value changes';

  @override
  String get sensorRange => 'Maximum range';

  @override
  String get sensorResolution => 'Resolution';

  @override
  String get sensorPower => 'Power use';

  @override
  String get sensorRate => 'Fastest rate';

  @override
  String get sensorWakeUp => 'Wake-up sensor';

  @override
  String get sensorWakeUpHint =>
      'Can wake the phone from sleep to deliver a reading';

  @override
  String get sensorVersion => 'Driver version';

  @override
  String get thermalLight => 'Light';

  @override
  String get thermalModerate => 'Moderate';

  @override
  String get thermalSevere => 'Severe';

  @override
  String get thermalCritical => 'Critical';

  @override
  String get thermalEmergency => 'Emergency';

  @override
  String get thermalShutdown => 'Shutting down';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get paused => 'Paused';

  @override
  String get avgClock => 'Average clock';

  @override
  String get loadEstimate => 'Load (estimate)';

  @override
  String get chartClockLast60 => 'Average clock · last 60 readings';

  @override
  String get loadEstimateHint =>
      'Android 8 and later hide real CPU usage from apps, so load is estimated from clock speeds.';

  @override
  String get chartCurrent => 'Charge current';

  @override
  String get currentUnavailable =>
      'Your phone doesn\'t report charging current.';

  @override
  String get chartTemperature => 'Battery temperature';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get chartNetwork => 'Network speed';

  @override
  String get networkSpeedHint =>
      'All traffic on this phone, from every app. This is not a speed test.';

  @override
  String get thermalStatus => 'Thermal status';

  @override
  String get thermalHeadroom => 'Headroom before slowdown';

  @override
  String get chartBatteryTemp => 'Battery temperature';

  @override
  String get chartCpuTemp => 'CPU temperature';

  @override
  String get cpuTempUnavailable =>
      'Your phone doesn\'t let apps read the CPU temperature. Battery temperature and thermal status are shown instead.';

  @override
  String get thermalHint =>
      'When the phone gets hot, Android slows the processor to cool down. Headroom shows how close it is to that point.';

  @override
  String get details => 'Details';

  @override
  String get scoreGood => 'Good health';

  @override
  String get scoreFair => 'Fair health';

  @override
  String get scorePoor => 'Needs attention';

  @override
  String get noCheckupYet =>
      'No checkup yet. Run one to include it in the score.';

  @override
  String get scoreHow => 'How the score works';

  @override
  String get scoreExplain =>
      'The score combines what your phone reports right now. Anything Android doesn\'t share is left out instead of guessed.';

  @override
  String get factorBattery => 'Battery health';

  @override
  String get factorTemperature => 'Temperature';

  @override
  String get factorStorage => 'Free storage';

  @override
  String get factorMemory => 'Free memory';

  @override
  String get factorCheckup => 'Last checkup';

  @override
  String get tipNoScreenLock =>
      'No screen lock is set. Anyone who picks up your phone can open it.';

  @override
  String get tipMemoryLow =>
      'Memory is almost full, so Android is closing background apps.';

  @override
  String get tipOpen => 'Open';

  @override
  String get monitorTemp => 'Temperature';

  @override
  String weightN(int weight) {
    return 'weight $weight';
  }

  @override
  String tipBatteryHot(String temp) {
    return 'Phone is warm ($temp). Close heavy apps or take off the case for a while.';
  }

  @override
  String tipStorageLow(int percent) {
    return 'Storage is $percent% full. Free up space to keep apps fast.';
  }

  @override
  String tipPatchOld(int months) {
    return 'Security patch is $months months old. Check for a system update.';
  }

  @override
  String tipUnplug(int level) {
    return 'Charged to $level%. Unplugging around 80% slows battery wear.';
  }

  @override
  String get permCameraTitle => 'Test the cameras';

  @override
  String get permCameraReason =>
      'SystemX opens the camera only during the camera test. Photos stay on screen and are never saved or uploaded.';

  @override
  String get permMicTitle => 'Test the microphone';

  @override
  String get permMicReason =>
      'SystemX records a few seconds only during the microphone tests, plays it back once, then discards it. Nothing is saved or uploaded.';

  @override
  String get tDeadPixels => 'Dead pixels';

  @override
  String get tColorBanding => 'Color banding';

  @override
  String get tBurnIn => 'Burn-in';

  @override
  String get tMultiTouch => 'Multi-touch';

  @override
  String get tBrightness => 'Brightness range';

  @override
  String get tSpeakerMic => 'Speaker to microphone';

  @override
  String get tHeadphones => 'Wired headphones';

  @override
  String get tUsbAudio => 'USB audio';

  @override
  String get tVolumeUp => 'Volume up button';

  @override
  String get tVolumeDown => 'Volume down button';

  @override
  String get tRearCamera => 'Rear camera';

  @override
  String get tFrontCamera => 'Front camera';

  @override
  String get tAccelerometer => 'Accelerometer';

  @override
  String get tGyroscope => 'Gyroscope';

  @override
  String get tCompass => 'Compass';

  @override
  String get tProximity => 'Proximity sensor';

  @override
  String get tLight => 'Light sensor';

  @override
  String get tBarometer => 'Barometer';

  @override
  String get tMobileSignal => 'Mobile signal';

  @override
  String get gAudio => 'Audio';

  @override
  String get gHaptics => 'Haptics & buttons';

  @override
  String get gConnectivity => 'Connectivity';

  @override
  String get gBiometrics => 'Biometrics';

  @override
  String get gPower => 'Charging & storage';

  @override
  String get automaticTests => 'Automatic tests';

  @override
  String get automaticTestsBody =>
      'These run on their own. Keep the phone still and the room quiet for the speaker test.';

  @override
  String get bioNoDataNote =>
      'Android checks your fingerprint or face. SystemX only learns whether it matched.';

  @override
  String get bioPromptTitle => 'Biometrics test';

  @override
  String get bioPromptSubtitle => 'Touch the sensor or look at the screen';

  @override
  String get buttonDoesNothing => 'The button does nothing';

  @override
  String get cancel => 'Cancel';

  @override
  String get checkupIntro =>
      'Automatic tests run first. Then each test tells you what to do, and you can skip any of them.';

  @override
  String get checkupPrep =>
      'Have wired headphones, a USB audio device and a charger nearby if you can. Location helps the GPS test.';

  @override
  String get done => 'Done';

  @override
  String get fixAudio =>
      'Clean the grille with a soft dry brush, remove any case or screen protector covering it, and test again.';

  @override
  String get fixBiometrics =>
      'Clean the sensor and your finger, re-enroll in Settings › Security, and test again.';

  @override
  String get fixCamera =>
      'Clean the lens and check nothing covers it. If the image stays blurry, the camera may need service.';

  @override
  String get fixCharging =>
      'Try another cable and charger, and clean the port gently with a wooden toothpick.';

  @override
  String get fixConnectivity =>
      'Turn it off and on in Quick Settings, restart the phone, and test again.';

  @override
  String get fixConnector => 'Clean the port and try another device.';

  @override
  String get fixDisplay =>
      'Restart the phone and test again. Marks that stay usually mean the screen needs service.';

  @override
  String get fixHaptics =>
      'Restart the phone and test again. If it still fails, the part may need service.';

  @override
  String get fixSensor => 'Remove the case, restart the phone and test again.';

  @override
  String get fixStorage => 'Free up some space and test again.';

  @override
  String get flashOn => 'Flashlight is on';

  @override
  String get flashTurningOn => 'Turning on the flashlight…';

  @override
  String get gpsStarting => 'Looking for satellites…';

  @override
  String get holdPhone => 'Hold the phone in your hand';

  @override
  String get holdToEar => 'Hold the phone to your ear, then tap Play';

  @override
  String get iAccelerometer =>
      'Tilt the phone to roll the ball into all four corners.';

  @override
  String get iBiometrics =>
      'Tap Start and use your fingerprint or face as you do to unlock.';

  @override
  String get iBrightness => 'Watch the screen dim and brighten.';

  @override
  String get iCharging =>
      'Plug in a charger. SystemX measures the charging current for a few seconds.';

  @override
  String get iCompass =>
      'Turn around slowly in a full circle while holding the phone flat.';

  @override
  String get iEarpiece =>
      'This tone plays through the small speaker you hold to your ear on calls.';

  @override
  String get iFlashlight => 'Look at the back of the phone.';

  @override
  String get iFrontCamera =>
      'Point the front camera at your face, tap to focus, then take a photo.';

  @override
  String get iGps =>
      'Stand near a window or go outside. Finding satellites can take a minute.';

  @override
  String get iGyroscope =>
      'Rotate the phone in any direction, like turning a steering wheel.';

  @override
  String get iHeadphones =>
      'Connect wired headphones: through the 3.5 mm jack, as USB-C headphones, or with a USB-C adapter.';

  @override
  String get iLight =>
      'Cover the top of the screen with your hand, then uncover it or hold it under a light.';

  @override
  String get iMicrophone =>
      'Tap Record and say a few words. SystemX plays it back right away.';

  @override
  String get iMultiTouch => 'Put as many fingers on the screen as you can.';

  @override
  String get iProximity =>
      'Cover the top of the screen near the earpiece with your hand, then move it away.';

  @override
  String get iRearCamera =>
      'Point the rear camera at something with detail, tap to focus, then take a photo.';

  @override
  String get iSpeaker => 'A tone plays through the loudspeaker.';

  @override
  String get iUsbAudio => 'Connect USB-C headphones or a USB audio adapter.';

  @override
  String get iVibration => 'The phone vibrates in a short pattern.';

  @override
  String get iVolumeDown => 'Press the volume down button.';

  @override
  String get iVolumeUp => 'Press the volume up button.';

  @override
  String get itDoesntWork => 'It doesn\'t recognise me';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get lastCheckup => 'Last checkup';

  @override
  String get listen => 'Listen';

  @override
  String get measuring => 'Measuring…';

  @override
  String get nBanding => 'Visible color bands';

  @override
  String get nBluetoothOff => 'Bluetooth is off';

  @override
  String get nBrightnessBad => 'Brightness didn\'t change smoothly';

  @override
  String get nBrightnessOk => 'Full range works';

  @override
  String get nBurnIn => 'Ghost images visible';

  @override
  String get nButtonNoResponse => 'No response';

  @override
  String get nCameraError => 'The camera couldn\'t start';

  @override
  String get nConnected => 'Connected';

  @override
  String get nCouldNotRead => 'Couldn\'t read the hardware state';

  @override
  String get nDeadPixels => 'Dots that don\'t change color';

  @override
  String get nFlashBad => 'Didn\'t light up';

  @override
  String get nFlashOk => 'Lights up';

  @override
  String get nGpsNone => 'No satellites found';

  @override
  String get nLoopFail => 'The microphone didn\'t pick up the speaker tone';

  @override
  String get nMicError => 'The microphone is busy or unavailable';

  @override
  String get nNfcOff => 'NFC is off';

  @override
  String get nNoBiometrics => 'No fingerprint or face hardware';

  @override
  String get nNoBluetooth => 'No Bluetooth on this phone';

  @override
  String get nNoBurnIn => 'No ghost images';

  @override
  String get nNoCharger => 'No charger at hand';

  @override
  String get nNoDeadPixels => 'No dead pixels';

  @override
  String get nNoFrontCamera => 'No front camera';

  @override
  String get nNoHeadphones => 'No headphones at hand';

  @override
  String get nNoNfc => 'No NFC on this phone';

  @override
  String get nNoRearCamera => 'No rear camera';

  @override
  String get nNoSensor => 'This phone doesn\'t have this sensor';

  @override
  String get nNoSignal => 'No mobile signal';

  @override
  String get nNoSignalInfo => 'The phone doesn\'t report signal strength';

  @override
  String get nNoSim => 'No SIM card';

  @override
  String get nNoUsbAudio => 'No USB audio device at hand';

  @override
  String get nNoneEnrolled => 'No fingerprint or face is set up';

  @override
  String get nNotRecognised => 'Not recognised';

  @override
  String get nOnNotConnected => 'On, not connected';

  @override
  String get nPermissionDenied => 'Permission not allowed';

  @override
  String get nPhotoBad => 'Blurry or broken photo';

  @override
  String get nPhotoOk => 'Preview and photo work';

  @override
  String get nRecognised => 'Recognised';

  @override
  String get nSensorNoResponse => 'The sensor didn\'t respond';

  @override
  String get nSensorResponds => 'Responds to movement';

  @override
  String get nSmooth => 'Smooth gradients';

  @override
  String get nStorageError => 'Couldn\'t write a test file';

  @override
  String get nStorageMismatch => 'Data read back didn\'t match';

  @override
  String get nToneHeard => 'Tone heard';

  @override
  String get nToneNotHeard => 'Tone not heard';

  @override
  String get nVeryQuiet => 'Very quiet';

  @override
  String get nVibrationBad => 'No vibration felt';

  @override
  String get nVibrationOk => 'Vibration felt';

  @override
  String get nWifiOff => 'Wi-Fi is off';

  @override
  String get noChargerAtHand => 'No charger at hand';

  @override
  String get noHeadphonesAtHand => 'No headphones at hand';

  @override
  String get noUsbAudioAtHand => 'No USB audio at hand';

  @override
  String get ofHundred => 'of 100';

  @override
  String get pastCheckups => 'Past checkups';

  @override
  String get playAgain => 'Play again';

  @override
  String get playTone => 'Play tone';

  @override
  String get playing => 'Playing…';

  @override
  String get playingBack => 'Playing it back…';

  @override
  String get pressTheButton => 'Press the button';

  @override
  String get qBanding => 'Do the colors fade smoothly, without stripes?';

  @override
  String get qBrightness => 'Did the screen get dimmer and brighter?';

  @override
  String get qBurnIn =>
      'Did you see faint shapes that stay, like a status bar or keyboard?';

  @override
  String get qDeadPixels =>
      'Did you see any dots that stayed black, white or a different color?';

  @override
  String get qFeltVibration => 'Did you feel the vibration?';

  @override
  String get qFlashOn => 'Is the flashlight shining?';

  @override
  String get qHeardTone => 'Did you hear the tone clearly?';

  @override
  String get qHeardVoice => 'Did you hear your voice clearly?';

  @override
  String get qPhotoClear => 'Is the photo clear and in focus?';

  @override
  String get record3s => 'Record 3 seconds';

  @override
  String get recordAgain => 'Record again';

  @override
  String get recording => 'Recording… speak now';

  @override
  String get reportDisclaimer =>
      'Made on this phone by SystemX. Interactive results reflect the answers given during the checkup.';

  @override
  String get reportGreat => 'Your phone is in great shape';

  @override
  String get reportNeedsWork => 'Some parts need attention';

  @override
  String get reportNotSaved => 'Not saved';

  @override
  String get reportOk => 'Mostly good, with a few issues';

  @override
  String get reportPhone => 'Phone';

  @override
  String get reportResults => 'Results';

  @override
  String get reportSaved => 'Report saved';

  @override
  String get reportShareSubject => 'SystemX checkup report';

  @override
  String get reportTitle => 'Checkup report';

  @override
  String get retake => 'Retake';

  @override
  String get savePdf => 'Save PDF';

  @override
  String get sensorNotResponding => 'The sensor doesn\'t respond';

  @override
  String get shareReport => 'Share report';

  @override
  String get showAgain => 'Show again';

  @override
  String get skip => 'Skip';

  @override
  String get skippedByYou => 'Skipped';

  @override
  String get speakAfterTap => 'Tap Record, then speak';

  @override
  String get start => 'Start';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusNotRun => 'Not run';

  @override
  String get statusPassed => 'Passed';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get stop => 'Stop';

  @override
  String get stopCheckupBody => 'Results so far are saved in a report.';

  @override
  String get stopCheckupTitle => 'Stop the checkup?';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get tapToContinue => 'Tap to continue';

  @override
  String get testAgain => 'Test again';

  @override
  String get testingAutomatically => 'Testing…';

  @override
  String get touchEveryZone => 'Touch every square';

  @override
  String get tryAgain => 'Try again';

  @override
  String get vibrateAgain => 'Vibrate again';

  @override
  String get waitingForCharger => 'Waiting for a charger';

  @override
  String get waitingToConnect => 'Waiting for it to connect';

  @override
  String gpsSatellites(int seen, int used) {
    return '$seen satellites seen · $used in use';
  }

  @override
  String maxTouches(int count) {
    return 'Most at once: $count';
  }

  @override
  String nAllZones(int total) {
    return 'All $total zones respond';
  }

  @override
  String nSomeZones(int hit, int total) {
    return '$hit of $total zones responded';
  }

  @override
  String nChargingDetected(String source) {
    return 'Detected · $source';
  }

  @override
  String nChargingPeak(String source, int peak) {
    return 'Detected · $source · $peak mA peak';
  }

  @override
  String nGpsFix(int used, int accuracy) {
    return 'Fix · $used satellites · ±$accuracy m';
  }

  @override
  String nGpsNoFix(int seen) {
    return '$seen satellites seen, no fix yet. Try outdoors.';
  }

  @override
  String nImplausible(String value) {
    return 'Implausible reading: $value';
  }

  @override
  String nLoopOk(int db) {
    return 'Tone heard (+$db dB)';
  }

  @override
  String nLuxRange(int min, int max) {
    return '$min–$max lx';
  }

  @override
  String nPeakLevel(int db) {
    return 'Peak $db dBFS';
  }

  @override
  String nStorageSpeed(int write, int read) {
    return 'Write $write MB/s · read $read MB/s';
  }

  @override
  String nTouches(int count) {
    return 'Up to $count touches at once';
  }

  @override
  String passedOf(int passed, int total) {
    return '$passed of $total passed';
  }

  @override
  String progressOf(int done, int total) {
    return '$done of $total';
  }

  @override
  String reportCounts(int passed, int failed, int skipped) {
    return '$passed passed · $failed failed · $skipped skipped';
  }

  @override
  String secondsElapsed(int seconds) {
    return '$seconds s';
  }

  @override
  String get nDetected => 'Detected';

  @override
  String get nNoVibrator => 'No vibration motor';

  @override
  String get nButtonWorks => 'Button works';

  @override
  String get nNoFlash => 'No flashlight on this phone';

  @override
  String get nLocationOff => 'Skipped because Location is off';

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String hoursAgo(int n) {
    return '$n h ago';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days ago',
      one: 'yesterday',
    );
    return '$_temp0';
  }

  @override
  String lastCheckupLine(String ago, int passed, int total) {
    return 'Last checkup $ago · $passed of $total passed';
  }

  @override
  String get alertsTitle => 'Alerts and live status';

  @override
  String get alertsRowSub =>
      'Charge alarm, battery and storage alerts, live notification';

  @override
  String get alertsUnavailable => 'Alerts are not available on this phone.';

  @override
  String get alertsIntro =>
      'Everything here is off until you turn it on. Each type has its own notification channel, so you can also mute it in Android settings.';

  @override
  String get secLiveStatus => 'Live status';

  @override
  String get secBatteryAlerts => 'Battery';

  @override
  String get secStorageAlerts => 'Storage';

  @override
  String get secSummaries => 'Summaries and reminders';

  @override
  String get secAlerts => 'Alerts';

  @override
  String get liveStatus => 'Live status notification';

  @override
  String get liveStatusSub =>
      'An ongoing notification with live battery, temperature, power, network and RAM.';

  @override
  String get statusBarShows => 'Status bar icon';

  @override
  String get chargeAlarm => 'Charge alarm';

  @override
  String get notifyAt => 'Notify at';

  @override
  String get chargingDone => 'Charging finished';

  @override
  String get chargingDoneSub => 'With a summary of the charge';

  @override
  String get batteryLowAlert => 'Battery low';

  @override
  String get batteryHotAlert => 'Battery hot';

  @override
  String get storageAlert => 'Storage almost full';

  @override
  String get weeklySummary => 'Weekly summary';

  @override
  String get weeklySummarySub =>
      'Charges, hottest temperature and lowest level, every week';

  @override
  String get checkupReminder => 'Monthly checkup reminder';

  @override
  String get checkupReminderSub => 'When your last checkup is a month old';

  @override
  String get alertsFootnote =>
      'Without live status, SystemX checks every 15 minutes, and every 2 minutes while charging. History is kept on this phone for 8 days.';

  @override
  String get notificationsNeeded =>
      'Notifications are off for SystemX, so this can\'t be turned on.';

  @override
  String get permNotifTitle => 'Allow notifications';

  @override
  String get permNotifReason =>
      'SystemX only notifies you about the alerts you turn on here, and shows live status if you start it.';

  @override
  String get history => 'History';

  @override
  String get range24h => '24 h';

  @override
  String get range7d => '7 days';

  @override
  String get historyEmpty =>
      'History builds up in the background. Check back in an hour.';

  @override
  String get chargingSessions => 'Charging sessions';

  @override
  String get chargingSessionsSub =>
      'Each charge with its speed and temperature';

  @override
  String get sessionsEmpty =>
      'No charges recorded yet. Plug in your phone to start.';

  @override
  String get clearHistory => 'Clear all history';

  @override
  String get clearHistorySub =>
      'Battery history, charging sessions and test results';

  @override
  String get clearHistoryConfirm =>
      'This deletes battery history, charging sessions and all test results from this phone. Settings are kept.';

  @override
  String get clear => 'Clear';

  @override
  String get historyCleared => 'History cleared';

  @override
  String chargeAlarmSub(int level) {
    return 'Notify when the battery reaches $level%';
  }

  @override
  String batteryLowSub(int level) {
    return 'Notify at $level% when not charging';
  }

  @override
  String batteryHotSub(String temp) {
    return 'Notify at $temp';
  }

  @override
  String storageAlertSub(int percent) {
    return 'Notify when storage is $percent% full';
  }

  @override
  String historyNote(int count) {
    return '$count readings, taken every 15 minutes in the background';
  }

  @override
  String get wifiMeter => 'Wi-Fi signal meter';

  @override
  String get wifiMeterOff => 'Connect to Wi-Fi to measure its signal.';

  @override
  String get wifiMeterHint =>
      'Walk around slowly. The ring fills as the signal gets stronger, so you can find the best spot for working or placing your router.';

  @override
  String get bestHere => 'Best so far';

  @override
  String healthScoreSpoken(int score, String word) {
    return 'Health score $score of 100, $word';
  }

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get codeBalance => 'Balance';

  @override
  String get codeInternet => 'Internet';

  @override
  String get codeMinutes => 'Minutes';

  @override
  String get codeSms => 'SMS';

  @override
  String get codeOwnNumber => 'My number';

  @override
  String get codeMenu => 'Menu & offers';

  @override
  String get codeEmergency => 'Emergency balance';

  @override
  String get codeCare => 'Customer care';

  @override
  String codeButton(String label, String code) {
    return '$label · $code';
  }

  @override
  String get specDeviceName => 'Device name';

  @override
  String get specOemSkin => 'Manufacturer UI';

  @override
  String get specLaunchedWith => 'Launched with';

  @override
  String get specHwRevision => 'Hardware revision';

  @override
  String get secSales => 'Sales region';

  @override
  String get specSalesCode => 'Sales code';

  @override
  String get salesCodeHint => 'The regional build code (CSC on Samsung phones)';

  @override
  String get specSalesCountry => 'Sales country';

  @override
  String get specSalesRegion => 'Region';

  @override
  String get specProductLocale => 'Default language';

  @override
  String get secIdentifiers => 'Identifiers';

  @override
  String get specAndroidId => 'Android ID';

  @override
  String get androidIdHint =>
      'Unique to this phone and app. Changes after a factory reset.';

  @override
  String get specImei => 'IMEI and serial number';

  @override
  String get imeiHint =>
      'Android 10 and later shows these only to the phone\'s own apps. Tap to dial *#06#.';

  @override
  String get specWarranty => 'Knox warranty';

  @override
  String get warrantyIntact => 'Intact (0x0)';

  @override
  String get warrantyVoid => 'Void (0x1)';

  @override
  String get warrantyHint =>
      'Set permanently if unofficial software was ever installed';

  @override
  String get specCycleCountTracked => 'Charge cycles (estimated)';

  @override
  String cycleTrackedHint(String date) {
    return 'Counted by SystemX from charging since $date. This phone doesn\'t report the battery\'s own count.';
  }

  @override
  String get specSensorTotal => 'Total sensors';

  @override
  String get specSensorKinds => 'Sensor types';

  @override
  String get specSensorWakeUp => 'Wake-up sensors';

  @override
  String get specSensorVendor => 'Manufacturer-specific';

  @override
  String get sensorGroupMotion => 'Motion';

  @override
  String get sensorGroupPosition => 'Position';

  @override
  String get sensorGroupEnvironment => 'Environment';

  @override
  String get sensorGroupHealth => 'Health';

  @override
  String get sensorGroupOther => 'Other';

  @override
  String get appsTitle => 'Apps';

  @override
  String get appsEntry => 'Installed apps';

  @override
  String get appsEntryBody => 'Size and cache of each app';

  @override
  String appsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '1 app',
    );
    return '$_temp0';
  }

  @override
  String get appsTotalSize => 'Total size';

  @override
  String get appsCacheTotal => 'Cache';

  @override
  String get appsUsageTitle => 'See app sizes';

  @override
  String get appsUsageBody =>
      'Allow Usage access so SystemX can read how much storage each app and its cache use. Nothing leaves your phone.';

  @override
  String get appsUsageButton => 'Allow usage access';

  @override
  String get appsCacheTitle => 'Clearing cache';

  @override
  String get appsCacheBody =>
      'Android doesn\'t let one app clear other apps\' cache. Tap an app, then Storage, then Clear cache. Your phone\'s storage manager can also free space in one place.';

  @override
  String get appsFreeUp => 'Free up space';

  @override
  String get appsSortSize => 'Size';

  @override
  String get appsSortCache => 'Cache';

  @override
  String get appsSortName => 'Name';

  @override
  String get appsSortRecent => 'Updated';

  @override
  String get appsShowSystem => 'System apps';

  @override
  String appsSizeLine(String size, String cache) {
    return '$size · cache $cache';
  }

  @override
  String get appsSearch => 'Search apps';

  @override
  String get appsEmpty => 'No apps match';

  @override
  String get bhTitle => 'Battery health';

  @override
  String get bhEntry => 'Battery health';

  @override
  String get bhEntryBody => 'Measured capacity and drain per hour';

  @override
  String bhBasedOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count measured charges',
      one: 'Based on 1 measured charge',
    );
    return '$_temp0';
  }

  @override
  String get bhNotYet =>
      'Not measured yet. A measurement is taken each time you charge by 15% or more while SystemX\'s background features are on.';

  @override
  String get bhNoCounter =>
      'This phone doesn\'t report its battery charge counter, so capacity can\'t be measured.';

  @override
  String get bhTrend => 'Measured capacity by charge';

  @override
  String get bhDrain => 'Drain per hour (last 7 days)';

  @override
  String get bhScreenOn => 'Screen on';

  @override
  String get bhStandby => 'Standby';

  @override
  String bhPerHour(String rate) {
    return '$rate% per hour';
  }

  @override
  String bhHours(String hours) {
    return '$hours h measured';
  }

  @override
  String get bhCollecting => 'Collecting data';

  @override
  String get bhDrainNote =>
      'Estimates from SystemX\'s background readings, not a prediction of remaining battery life. They become more reliable after 3+ hours of each; with Live status on, readings are more frequent.';

  @override
  String get bhHow =>
      'How this works: each charge of 15% or more is measured with the battery\'s own charge counter (charge that went in ÷ percent gained). The estimate is the middle value of the last 5 measurements. It is an estimate, not a hardware test: heat, fast charging and the phone\'s calibration can move it a few percent either way.';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get stTitle => 'CPU stress test';

  @override
  String get stEntryBody => 'Does it slow down when hot?';

  @override
  String get stIntro =>
      'Runs every processor core at full speed and watches whether performance holds as the phone warms up.';

  @override
  String get stSafety =>
      'The phone will get warm. The test stops on its own if the battery reaches 45 °C, Android reports severe heat, the battery drops below 15%, or you leave this screen. Stop it any time.';

  @override
  String stMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get stStart => 'Start test';

  @override
  String get stAgain => 'Run again';

  @override
  String get stStop => 'Stop';

  @override
  String get stRefusedHot =>
      'The phone is already warm. Let it cool down for a few minutes, then try again.';

  @override
  String get stRefusedBattery =>
      'Battery is below 20%. Plug in the charger or charge first.';

  @override
  String stRunning(int seconds) {
    return 'Running · $seconds s left';
  }

  @override
  String get stPerformance => 'Performance';

  @override
  String get stPerfAxis => 'Performance (start = 100%)';

  @override
  String get stTempAxis => 'Battery temperature';

  @override
  String get stSteady => 'Stays fast under load';

  @override
  String get stSteadyBody => 'Performance held steady as the phone warmed up.';

  @override
  String get stSlight => 'Slows down a little when hot';

  @override
  String get stSlightBody =>
      'The phone eased off to stay cool. This is normal for most phones.';

  @override
  String get stThrottles => 'Slows down a lot when hot';

  @override
  String get stThrottlesBody =>
      'Performance dropped noticeably as it warmed up. Long games or video calls may stutter, especially in a case or while charging.';

  @override
  String get stTooShort => 'Not enough data';

  @override
  String get stTooShortBody =>
      'The test needs at least 30 seconds to give a result.';

  @override
  String get stStoppedHot =>
      'Stopped early to protect the phone: it got too warm.';

  @override
  String get stStoppedBattery => 'Stopped early: the battery is low.';

  @override
  String get stStoppedLeft => 'Stopped because the app went to the background.';

  @override
  String get stStoppedError => 'Stopped: readings weren\'t available.';

  @override
  String get stRetained => 'Performance at the end';

  @override
  String get stBatteryTemp => 'Battery temperature';

  @override
  String get stCpuPeak => 'Highest processor temperature';

  @override
  String get stDuration => 'Duration';

  @override
  String stSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String get rrTitle => 'Refresh rate test';

  @override
  String get rrEntryBody => 'How smoothly the screen really redraws';

  @override
  String get rrIntro =>
      'Counts how many times per second the screen redraws while the bar moves. SystemX asks for the display\'s fastest mode first.';

  @override
  String get rrStart => 'Measure';

  @override
  String get rrMeasuring => 'Measuring…';

  @override
  String get rrMeasured => 'Measured refresh rate';

  @override
  String get rrMatches => 'Matches what the display supports.';

  @override
  String rrLower(String max) {
    return 'Lower than the $max Hz the display supports. Battery saver, adaptive refresh or the phone\'s settings may be limiting it.';
  }

  @override
  String get rrReported => 'Highest rate the display reports';

  @override
  String get trTitle => 'Touch response test';

  @override
  String get trEntryBody => 'How often touch positions reach apps';

  @override
  String get trIntro =>
      'Move a finger around the box below without lifting it.';

  @override
  String get trDraw => 'Draw here';

  @override
  String get trNow => 'Touch rate';

  @override
  String get trBest => 'Highest';

  @override
  String get trNote =>
      'This is the rate apps receive touch positions. The \"touch sampling rate\" in phone adverts can be higher, as some of it is used inside Android.';

  @override
  String get upTitle => 'Used phone check';

  @override
  String get upEntryBody => 'Check a phone before you buy it';

  @override
  String get upIntro =>
      'This assessment helps you evaluate a pre-owned phone before purchase. It reviews software integrity and battery condition, guides you through a hardware checkup, and lists the points to confirm with the seller.';

  @override
  String get upHardwareTitle => 'Hardware checkup';

  @override
  String get upHardwareNone =>
      'Tests the screen, touch, speakers, microphone, cameras, sensors, connectivity and charging. Takes about 6 minutes; each step is explained.';

  @override
  String get upRunCheckup => 'Run hardware checkup';

  @override
  String get upRunAgain => 'Run again';

  @override
  String get upResults => 'Results';

  @override
  String get upGroupSoftware => 'Software';

  @override
  String get upGroupBattery => 'Battery';

  @override
  String get upGroupHardware => 'Hardware';

  @override
  String get upClean => 'No problems found';

  @override
  String get upCleanBody =>
      'All checks passed. Complete the buyer\'s checklist before you pay.';

  @override
  String get upCheckFirst => 'Check these before buying';

  @override
  String get upCheckFirstBody =>
      'No faults were found, but some items deserve a closer look before you buy.';

  @override
  String get upProblems => 'Problems found';

  @override
  String get upProblemsBody =>
      'One or more checks found a fault. Review each item below and discuss it with the seller.';

  @override
  String get upIncomplete => 'Run the hardware checkup to finish';

  @override
  String get upIncompleteBody =>
      'Software and battery checks are complete. Run the hardware checkup to test the screen, speakers, cameras, sensors and more.';

  @override
  String get upStorage => 'Storage';

  @override
  String get upRam => 'RAM';

  @override
  String get upRegion => 'Sales region';

  @override
  String get upRoot => 'Root access';

  @override
  String get upRootOk => 'Not detected';

  @override
  String get upRootBad =>
      'Detected: the system has been modified. Banking apps may refuse to work and updates may fail.';

  @override
  String get upBootloader => 'Bootloader';

  @override
  String get upBootloaderOk => 'Locked (as shipped)';

  @override
  String get upBootloaderBad =>
      'Unlocked: unofficial software can be installed. Ask why.';

  @override
  String get upVerifiedBoot => 'Verified boot';

  @override
  String get upVerifiedBootOk => 'Green: the software is the maker\'s own';

  @override
  String upVerifiedBootBad(String state) {
    return '$state: the software isn\'t fully the maker\'s own';
  }

  @override
  String get upKnoxOk => 'Intact (0x0)';

  @override
  String get upKnoxBad =>
      'Tripped (0x1): unofficial software was installed at some point. Samsung Pay and Secure Folder won\'t work.';

  @override
  String get upHealthOk => 'Good';

  @override
  String get upHealthBad => 'Android reports a battery fault';

  @override
  String upCapacity(int pct) {
    return 'About $pct% of the original capacity';
  }

  @override
  String get upTests => 'Hardware tests';

  @override
  String get upCertificate => 'Create report (PDF)';

  @override
  String get upCertTitle => 'Used phone report';

  @override
  String get upCertNote =>
      'This report was generated on the device by SystemX and reflects its condition at the time shown. Results are based on information reported by the phone\'s software and on tests performed by the user. SystemX cannot detect every fault or verify ownership, network lock, IMEI blacklist status, water damage, internal repairs or replaced parts, and accepts no responsibility for purchase decisions.';

  @override
  String get copyAll => 'Copy all specs';

  @override
  String get copiedAll => 'All specs copied';

  @override
  String get upDisclaimerTitle => 'About this assessment';

  @override
  String get upDisclaimer =>
      'Results are based on information reported by the phone\'s software and on the tests you perform. SystemX cannot detect every fault or verify ownership, network lock, IMEI blacklist status, water damage, internal repairs or replaced parts. Use it together with a physical inspection. SystemX is not responsible for purchase decisions.';

  @override
  String get upStepDevice => 'Device checks';

  @override
  String get upStepHardware => 'Hardware checkup';

  @override
  String get upStepChecklist => 'Buyer\'s checklist';

  @override
  String upChecksPassed(int passed, int total) {
    return '$passed of $total checks passed';
  }

  @override
  String get upAllClear => 'All clear';

  @override
  String upIssues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count issues',
      one: '1 issue',
    );
    return '$_temp0';
  }

  @override
  String upToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count to review',
      one: '1 to review',
    );
    return '$_temp0';
  }

  @override
  String get upNotRun => 'Not run yet';

  @override
  String upHardwareDoneAt(String time, int passed, int total) {
    return 'Completed at $time · $passed of $total passed';
  }

  @override
  String get upIdentityTitle => 'Device identity';

  @override
  String get upIdentityBody =>
      'Compare these details with the listing and the box. They are read from the phone itself.';

  @override
  String get upChecklistTitle => 'Buyer\'s checklist';

  @override
  String get upChecklistBody =>
      'Confirm these points in person before you pay. Ticked items are included in the report.';

  @override
  String upChecklistProgress(int done, int total) {
    return '$done of $total confirmed';
  }

  @override
  String get bcImei => 'IMEI matches the box';

  @override
  String get bcImeiBody =>
      'Dial *#06# and compare the number with the box and the receipt.';

  @override
  String get bcAccounts => 'Seller\'s accounts removed';

  @override
  String get bcAccountsBody =>
      'Google and Samsung accounts are signed out and Find My Device is turned off; otherwise the phone may lock after a reset.';

  @override
  String get bcBody => 'No physical damage';

  @override
  String get bcBodyBody =>
      'Inspect the frame, screen, back glass, camera lenses, buttons, ports and SIM tray for cracks, dents or signs of opening.';

  @override
  String get bcSim => 'Works with your SIM';

  @override
  String get bcSimBody =>
      'Insert your SIM card, make a short call and check that mobile data connects.';

  @override
  String get bcCharger => 'Charges with your charger';

  @override
  String get bcChargerBody =>
      'Connect your own charger and cable; the phone should show it is charging within a few seconds.';

  @override
  String get bcPaperwork => 'Box and receipt provided';

  @override
  String get bcPaperworkBody =>
      'The original box and receipt help show the phone is legitimately owned and may be needed for warranty repairs.';

  @override
  String get bcReset => 'Factory reset after purchase';

  @override
  String get bcResetBody =>
      'After paying, reset the phone yourself so that no previous data or accounts remain.';

  @override
  String get bcActionImei => 'Show IMEI';

  @override
  String get bcActionAccounts => 'Open accounts';

  @override
  String get upCertChecklist => 'Buyer\'s checklist';

  @override
  String get upCertConfirmed => 'Confirmed by buyer';

  @override
  String get upCertNotConfirmed => 'Not confirmed';

  @override
  String get csSummary => 'Last 30 days';

  @override
  String get csCharges => 'Charges';

  @override
  String get csAvgTime => 'Average duration';

  @override
  String get csAvgAdded => 'Average charge added';

  @override
  String get csAvgSpeed => 'Average charging speed';

  @override
  String get csHottest => 'Highest temperature';

  @override
  String get csInsights => 'Charging habits';

  @override
  String get csInsightToFull => 'Most charges go to 100%';

  @override
  String get csInsightToFullBody =>
      'Keeping the battery at full charge speeds up wear. Stopping around 80–85% helps it last longer; the charge alarm can remind you.';

  @override
  String get csInsightDeep => 'Often charged from below 15%';

  @override
  String get csInsightDeepBody =>
      'Deep discharges are harder on the battery. Plugging in earlier, around 20–30%, is gentler.';

  @override
  String get csInsightHot => 'The battery got hot while charging';

  @override
  String get csInsightOvernight => 'Frequent overnight charging';

  @override
  String get csInsightOvernightBody =>
      'Long overnight charges keep the battery full for hours. If your phone has a battery protection or adaptive charging setting, turn it on.';

  @override
  String get csInsightGood => 'Your charging habits look battery-friendly';

  @override
  String get csInsightGoodBody =>
      'No long full charges, deep discharges or heat in the last 30 days.';

  @override
  String get csSetAlarm => 'Set charge alarm';

  @override
  String get csChart => 'Charge added per charge';

  @override
  String get csChartLegend =>
      'Tap a bar to see that charge. Amber: battery reached 42 °C; red: 45 °C or more.';

  @override
  String get csToday => 'Today';

  @override
  String get csYesterday => 'Yesterday';

  @override
  String get csSpeed => 'Speed';

  @override
  String get csPeak => 'Peak';

  @override
  String get csMaxTemp => 'Max temp';

  @override
  String csMeasured(String mah) {
    return 'Measured capacity $mah mAh';
  }

  @override
  String get csNow => 'now';

  @override
  String get csEmptyTitle => 'No charges recorded yet';

  @override
  String get csEmptyBody =>
      'Charges are recorded while SystemX\'s background features are on. Plug in your phone, and each charge will appear here with its speed and temperature.';

  @override
  String get csToFull => 'Full charges';

  @override
  String get gpsPermissionTitle => 'Location permission needed';

  @override
  String get gpsNeedsPermission =>
      'The GPS test needs precise location to listen to satellites. SystemX doesn\'t record or store your location.';

  @override
  String get gpsLocationOffTitle => 'Location is turned off';

  @override
  String get gpsNeedsLocation =>
      'Turn on Location, then come back. The test starts again on its own.';

  @override
  String get gpsTurnOn => 'Turn on Location';

  @override
  String get onbWelcomeTitle => 'Welcome to SystemX';

  @override
  String get onbWelcomeBody =>
      'Choose your language and appearance. You can change both any time in Settings.';

  @override
  String get onbLanguage => 'Language';

  @override
  String get onbAppearance => 'Appearance';

  @override
  String get onbUsedTitle => 'Buy a used phone with confidence';

  @override
  String get onbUsedBody =>
      'Check any second-hand phone before you pay: hardware, battery health and signs of modification, with a report you can share. Know exactly what you\'re buying.';

  @override
  String get onbAlertsTitle => 'Stay ahead of your battery';

  @override
  String get onbAlertsBody =>
      'Get alerts for charge limits, heat and low battery, and keep live stats in your notification bar. Both are optional.';

  @override
  String get onbChargeAlarm => 'Charge alarm at 80%';

  @override
  String get onbLiveStatus => 'Live status in the notification bar';

  @override
  String get onbArtCharged => 'Charged to 80%. Unplug to protect your battery.';

  @override
  String get onbArtWarm =>
      'Phone is warm (42 °C). Close heavy apps for a while.';

  @override
  String get bhEstimatedCapacity => 'Estimated capacity';

  @override
  String bhRange(String min, String max) {
    return 'Measured between $min and $max mAh';
  }

  @override
  String get bhGood => 'Good';

  @override
  String get bhFair => 'Fair';

  @override
  String get bhPoor => 'Worn';

  @override
  String get bhInsufficient => 'Not enough data yet';

  @override
  String get bhConfHigh => 'High';

  @override
  String get bhConfMedium => 'Medium';

  @override
  String get bhConfLow => 'Low (measurements vary)';

  @override
  String bhCollectingCharges(int count, int needed) {
    return 'Collecting: $count of $needed charges';
  }

  @override
  String get bhDesignCapacity => 'Original (design) capacity';

  @override
  String get bhOfOriginal => 'Capacity vs original';

  @override
  String get bhOver100 =>
      'Health is shown as 100% at most. The measured capacity can read slightly above the original rating because of normal measurement variation; it means the battery is close to new.';

  @override
  String get bhConfidence => 'Confidence';

  @override
  String get bhTrendSub =>
      'Each dot is one measured charge. The dashed line is the original capacity.';

  @override
  String get bhDesignLine => 'Original';

  @override
  String get bhAndroidHealth => 'Health reported by Android';

  @override
  String get bhAndroidHealthHint =>
      'A basic status from the battery (Good, Overheat, Dead…), not a percentage';

  @override
  String get bhCyclesCounted => 'Cycles counted by SystemX';

  @override
  String bhCyclesCountedHint(String date) {
    return 'Full charges added up since $date. This is not the battery\'s lifetime count, which this phone doesn\'t report.';
  }

  @override
  String get csHourShort => 'h';

  @override
  String get csMinShort => 'min';

  @override
  String csPerHourLong(int pct) {
    return '$pct% per hour';
  }

  @override
  String csOfCount(int count, int total) {
    return '$count of $total';
  }

  @override
  String csBasedOnValid(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count charges',
      one: '1 charge',
    );
    return 'Based on $_temp0 of $minutes minutes or longer.';
  }

  @override
  String csExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shorter connections aren\'t counted.',
      one: '1 shorter connection isn\'t counted.',
    );
    return '$_temp0';
  }

  @override
  String get csSpeedDefinition =>
      'Charging speed is the total charge added divided by the total charging time.';

  @override
  String csInsightHotBody(String temp, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count charges',
      one: '1 charge',
    );
    return 'It reached $temp during $_temp0. Stop heavy use while charging, remove the case, and keep the phone out of the sun. If it keeps happening, try another charger.';
  }

  @override
  String get csInsightWarm => 'Some charges ran warm';

  @override
  String csInsightWarmBody(int count, String temp) {
    return '$count charges reached 42 °C or more (highest $temp). A brief warm peak is normal with fast charging; charging without a case helps.';
  }

  @override
  String get csTempSource =>
      'Temperatures are the battery sensor\'s highest reading during each charge.';

  @override
  String csChartSub(int count) {
    return 'Last $count charges · percent of battery gained';
  }

  @override
  String csShort(int from, int to) {
    return 'Short connection ($from% → $to%), too short to measure. Not counted in the summary.';
  }

  @override
  String get csAddedLabel => 'Added';

  @override
  String get csAvgCurrent => 'Average current';

  @override
  String get statusBarShowsNote =>
      'The value next to the clock. The notification always shows all values.';

  @override
  String get bhLowConfidence => 'low confidence';

  @override
  String get nBluetoothOn => 'Bluetooth is on and responding';

  @override
  String get bhAtOriginal => 'At or above original';

  @override
  String bhEstimatedPct(int pct) {
    return '$pct% (estimated)';
  }

  @override
  String get stmTitle => 'Screen time';

  @override
  String get stmEntryBody => 'Daily screen time, and time and battery by app';

  @override
  String stmHm(int h, int m) {
    return '$h h $m min';
  }

  @override
  String stmH(int h) {
    return '$h h';
  }

  @override
  String stmM(int m) {
    return '$m min';
  }

  @override
  String get stmUnderMin => '< 1 min';

  @override
  String get stmScreenBattery => 'Battery used with screen on';

  @override
  String get stmWeek => 'Last 7 days';

  @override
  String stmAverage(String time) {
    return 'Daily average $time';
  }

  @override
  String get stmApps => 'Apps used';

  @override
  String stmOpens(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Opened $count times',
      one: 'Opened once',
      zero: 'Not opened',
    );
    return '$_temp0';
  }

  @override
  String stmAppBattery(String pct) {
    return '≈$pct% battery';
  }

  @override
  String stmShowAll(int count) {
    return 'Show all ($count)';
  }

  @override
  String get stmShowLess => 'Show less';

  @override
  String get stmNoUse => 'No screen time recorded for this day.';

  @override
  String get stmAccessTitle => 'Allow usage access';

  @override
  String get stmAccessBody =>
      'Screen time is read from Android\'s usage records, which need Usage access. The data stays on this phone.';

  @override
  String get stmBatteryNote =>
      'Battery per app is an estimate. SystemX splits each battery drop it measures between the apps on screen at the time; background use isn\'t included. Android doesn\'t share exact per-app battery figures with apps.';

  @override
  String get stmNoBattery =>
      'Battery estimates need SystemX\'s battery history. Turn on Live status or any battery alert to start recording it.';

  @override
  String get stmTimeNote =>
      'Times come from Android\'s usage records. The home screen and lock screen count toward screen time but aren\'t listed as apps.';

  @override
  String get stmUnlocksLabel => 'Unlocks';

  @override
  String featureCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count features',
      one: '1 feature',
    );
    return '$_temp0';
  }

  @override
  String builtOn(String date) {
    return 'Built $date';
  }

  @override
  String get reportNoScore => 'No test was completed';

  @override
  String durDhm(int d, int h, int m) {
    return '$d d $h h $m min';
  }
}
