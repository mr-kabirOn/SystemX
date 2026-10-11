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
  String get previewBanner =>
      'Preview build: the values on this screen are samples.';

  @override
  String get healthExcellent => 'Excellent health';

  @override
  String healthSample(int passed, int total) {
    return 'Sample: $passed of $total tests passed';
  }

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
  String get comingSoon => 'Coming in the next update';

  @override
  String get sample => 'Sample';

  @override
  String get deviceTitle => 'Device';

  @override
  String get deviceSearch => 'Search specs';

  @override
  String get deviceHeroTitle => 'This phone';

  @override
  String get deviceHeroSub => 'Full specs arrive in the next update';

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
      'Live charts for every part of your phone. In this preview the charts show sample data.';

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
  String get permNearby => 'Nearby devices';

  @override
  String get permNearbySub => 'Bluetooth test';

  @override
  String get askWhenNeeded => 'Ask when needed';

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
  String get cycleHint =>
      'Reported on Android 14 and later, when the maker exposes it';

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
}
