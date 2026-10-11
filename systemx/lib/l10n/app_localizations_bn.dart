// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'SystemX';

  @override
  String get navHome => 'হোম';

  @override
  String get navDevice => 'ডিভাইস';

  @override
  String get navTests => 'টেস্ট';

  @override
  String get navMonitor => 'মনিটর';

  @override
  String get onb1Title => 'আপনার ফোনকে ভেতর থেকে জানুন';

  @override
  String get onb1Body =>
      'লাইভ তথ্য আর ফোনের প্রতিটি স্পেসিফিকেশন, এক জায়গায় পরিষ্কারভাবে।';

  @override
  String get onb2Title => 'প্রতিটি অংশ পরীক্ষা করুন';

  @override
  String get onb2Body =>
      'গাইডেড চেকআপ স্ক্রিন, স্পিকার, ক্যামেরা, সেন্সরসহ আরও অনেক কিছু পরীক্ষা করে, তারপর একটি রিপোর্ট দেয়।';

  @override
  String get onb3Title => 'প্রাইভেসি সবার আগে';

  @override
  String get onb3Body =>
      'কোনো অ্যাকাউন্ট নেই, কোনো ট্র্যাকিং নেই। আপনার তথ্য এই ফোনের বাইরে যায় না।';

  @override
  String get onbSkip => 'বাদ দিন';

  @override
  String get onbNext => 'পরবর্তী';

  @override
  String get onbStart => 'শুরু করুন';

  @override
  String get greetingMorning => 'শুভ সকাল';

  @override
  String get greetingAfternoon => 'শুভ অপরাহ্ন';

  @override
  String get greetingEvening => 'শুভ সন্ধ্যা';

  @override
  String get homeYourPhone => 'আপনার ফোন';

  @override
  String get previewBanner => 'প্রিভিউ বিল্ড: এই স্ক্রিনের মানগুলো নমুনা।';

  @override
  String get healthExcellent => 'চমৎকার অবস্থা';

  @override
  String healthSample(int passed, int total) {
    return 'নমুনা: $totalটির মধ্যে $passedটি টেস্ট পাস';
  }

  @override
  String get healthScoreLabel => 'স্কোর';

  @override
  String get runCheckup => 'চেকআপ চালান';

  @override
  String get metricCpu => 'সিপিইউ';

  @override
  String get metricMemory => 'মেমরি';

  @override
  String get metricBattery => 'ব্যাটারি';

  @override
  String get metricStorage => 'স্টোরেজ';

  @override
  String get metricNetwork => 'নেটওয়ার্ক';

  @override
  String get metricThermal => 'তাপমাত্রা';

  @override
  String freeAmount(String amount) {
    return '$amount খালি';
  }

  @override
  String get thermalNormal => 'স্বাভাবিক';

  @override
  String headroom(int percent) {
    return 'হেডরুম $percent%';
  }

  @override
  String get tipChargeLimit =>
      '৮০% হলে চার্জার খুলে দিন, ব্যাটারি দীর্ঘদিন ভালো থাকবে।';

  @override
  String get tipSetAlarm => 'অ্যালার্ম সেট করুন';

  @override
  String get comingSoon => 'পরবর্তী আপডেটে আসছে';

  @override
  String get sample => 'নমুনা';

  @override
  String get deviceTitle => 'ডিভাইস';

  @override
  String get deviceSearch => 'স্পেসিফিকেশন খুঁজুন';

  @override
  String get deviceHeroTitle => 'এই ফোন';

  @override
  String get catDevice => 'ডিভাইস';

  @override
  String get catDeviceSub => 'মডেল, নির্মাতা, কোডনেম';

  @override
  String get catSystem => 'সিস্টেম';

  @override
  String get catSystemSub => 'অ্যান্ড্রয়েড ভার্সন, সিকিউরিটি প্যাচ, কার্নেল';

  @override
  String get catProcessor => 'প্রসেসর';

  @override
  String get catProcessorSub => 'চিপ, কোর, লাইভ ক্লক স্পিড';

  @override
  String get catGpu => 'গ্রাফিক্স';

  @override
  String get catGpuSub => 'জিপিইউ, OpenGL ES, Vulkan';

  @override
  String get catMemory => 'মেমরি';

  @override
  String get catMemorySub => 'ব্যবহৃত ও খালি র‍্যাম';

  @override
  String get catStorage => 'স্টোরেজ';

  @override
  String get catStorageSub => 'ইন্টারনাল স্পেস, এসডি কার্ড, ইউএসবি';

  @override
  String get catBattery => 'ব্যাটারি';

  @override
  String get catBatterySub => 'হেলথ, তাপমাত্রা, চার্জিং স্পিড';

  @override
  String get catDisplay => 'ডিসপ্লে';

  @override
  String get catDisplaySub => 'রেজোলিউশন, রিফ্রেশ রেট, HDR';

  @override
  String get catNetwork => 'নেটওয়ার্ক';

  @override
  String get catNetworkSub => 'ওয়াই-ফাই, মোবাইল ডেটা, আইপি অ্যাড্রেস';

  @override
  String get catSim => 'সিম ও মোবাইল';

  @override
  String get catSimSub => 'অপারেটর, সিগন্যাল, ব্যালেন্স চেক';

  @override
  String get catCameras => 'ক্যামেরা';

  @override
  String get catCamerasSub => 'মেগাপিক্সেল, অ্যাপারচার, ভিডিও';

  @override
  String get catSensors => 'সেন্সর';

  @override
  String get catSensorsSub => 'প্রতিটি সেন্সর ও লাইভ রিডিং';

  @override
  String get catMedia => 'মিডিয়া';

  @override
  String get catMediaSub => 'কোডেক, DRM, অডিও আউটপুট';

  @override
  String get catFeatures => 'ফিচার';

  @override
  String get catFeaturesSub => 'ব্লুটুথ, NFC, 5G, ফিঙ্গারপ্রিন্ট';

  @override
  String get catSecurity => 'সিকিউরিটি চেক';

  @override
  String get catSecuritySub => 'স্ক্রিন লক, এনক্রিপশন, আপডেট';

  @override
  String get testsTitle => 'টেস্ট';

  @override
  String get checkupTitle => 'ফুল চেকআপ';

  @override
  String checkupMeta(int count, int minutes) {
    return '$countটি টেস্ট · প্রায় $minutes মিনিট';
  }

  @override
  String get checkupBody =>
      'স্বয়ংক্রিয় টেস্টগুলো নিজে থেকেই চলবে। বাকিগুলোর জন্য আমরা আপনাকে জিজ্ঞেস করব।';

  @override
  String get startCheckup => 'চেকআপ শুরু করুন';

  @override
  String get singleTests => 'আলাদা টেস্ট';

  @override
  String get testDisplay => 'ডিসপ্লে';

  @override
  String get testTouch => 'টাচ';

  @override
  String get testSpeaker => 'স্পিকার';

  @override
  String get testEarpiece => 'ইয়ারপিস';

  @override
  String get testMicrophone => 'মাইক্রোফোন';

  @override
  String get testVibration => 'ভাইব্রেশন';

  @override
  String get testCameras => 'ক্যামেরা';

  @override
  String get testFlashlight => 'ফ্ল্যাশলাইট';

  @override
  String get testSensors => 'সেন্সর';

  @override
  String get testButtons => 'বাটন';

  @override
  String get testWifi => 'ওয়াই-ফাই';

  @override
  String get testBluetooth => 'ব্লুটুথ';

  @override
  String get testGps => 'জিপিএস';

  @override
  String get testFingerprint => 'ফিঙ্গারপ্রিন্ট';

  @override
  String get testCharging => 'চার্জিং';

  @override
  String get testStorage => 'স্টোরেজ স্পিড';

  @override
  String get monitorTitle => 'মনিটর';

  @override
  String get monitorBody =>
      'ফোনের প্রতিটি অংশের লাইভ চার্ট। এই প্রিভিউতে চার্টগুলো নমুনা ডেটা দেখাচ্ছে।';

  @override
  String get monitorCpu => 'প্রসেসর ক্লক';

  @override
  String get monitorRam => 'মেমরি ব্যবহার';

  @override
  String get monitorBattery => 'ব্যাটারি কারেন্ট';

  @override
  String get monitorNet => 'নেটওয়ার্ক স্পিড';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get secAppearance => 'দেখতে কেমন';

  @override
  String get theme => 'থিম';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get pureBlack => 'পিওর ব্ল্যাক';

  @override
  String get pureBlackSub => 'AMOLED স্ক্রিনে ব্যাটারি বাঁচায়';

  @override
  String get wallpaperColors => 'ওয়ালপেপারের রং';

  @override
  String get wallpaperColorsSub =>
      'অ্যাকসেন্ট রং ওয়ালপেপারের সাথে মিলিয়ে নিন (অ্যান্ড্রয়েড ১২+)';

  @override
  String get secUnits => 'একক';

  @override
  String get temperature => 'তাপমাত্রা';

  @override
  String get secLanguage => 'ভাষা';

  @override
  String get langSystem => 'ফোনের ভাষা';

  @override
  String get langEnglish => 'English';

  @override
  String get langBangla => 'বাংলা';

  @override
  String get secLive => 'লাইভ ডেটা';

  @override
  String get refreshRate => 'রিফ্রেশ রেট';

  @override
  String seconds(String value) {
    return '$value সে.';
  }

  @override
  String get secPrivacy => 'প্রাইভেসি';

  @override
  String get privacyPermissions => 'প্রাইভেসি ও পারমিশন';

  @override
  String get privacyPermissionsSub => 'SystemX কী অ্যাক্সেস করতে পারে এবং কেন';

  @override
  String get secAbout => 'সম্পর্কে';

  @override
  String get version => 'ভার্সন';

  @override
  String get licenses => 'ওপেন-সোর্স লাইসেন্স';

  @override
  String get replayIntro => 'পরিচিতি আবার দেখুন';

  @override
  String get privacyBanner =>
      'আপনার তথ্য এই ফোনেই থাকে। কোনো অ্যাকাউন্ট নেই, বিজ্ঞাপন ট্র্যাকিং নেই, কিছুই আপলোড হয় না।';

  @override
  String get privacyIntro =>
      'এগুলোর কোনোটি ছাড়াই SystemX চলে। শুধু যেটা দরকার সেটাই চালু করুন।';

  @override
  String get permNotifications => 'নোটিফিকেশন';

  @override
  String get permNotificationsSub => 'লাইভ স্ট্যাটাস ও ব্যাটারি অ্যালার্ট';

  @override
  String get permLocation => 'লোকেশন';

  @override
  String get permLocationSub => 'ওয়াই-ফাই নাম ও জিপিএস টেস্ট';

  @override
  String get permPhone => 'ফোন';

  @override
  String get permPhoneSub => 'সিম স্লট ও সিগন্যালের তথ্য';

  @override
  String get permCamera => 'ক্যামেরা';

  @override
  String get permCameraSub => 'শুধু ক্যামেরা টেস্টের সময়';

  @override
  String get permMicrophone => 'মাইক্রোফোন';

  @override
  String get permMicrophoneSub => 'শুধু মাইক্রোফোন টেস্টের সময়';

  @override
  String get permNearby => 'কাছের ডিভাইস';

  @override
  String get permNearbySub => 'ব্লুটুথ টেস্ট';

  @override
  String get askWhenNeeded => 'দরকার হলে জিজ্ঞেস করবে';

  @override
  String get permAllow => 'অনুমতি দিন';

  @override
  String get permNotNow => 'এখন না';

  @override
  String copied(String label) {
    return '$label কপি হয়েছে';
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
  String get balanceTitle => 'Check balance';

  @override
  String get balanceBody =>
      'Opens your dialer with the code filled in. Nothing is dialed until you press call.';

  @override
  String balanceButton(String carrier, String code) {
    return '$carrier · $code';
  }
}
