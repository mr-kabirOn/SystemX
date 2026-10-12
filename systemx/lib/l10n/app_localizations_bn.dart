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
  String get healthExcellent => 'চমৎকার অবস্থা';

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
      'ফোনের প্রতিটি অংশের লাইভ চার্ট। আগের মান দেখতে চার্টের ওপর আঙুল টানুন।';

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
  String get notAvailable => 'এই ডিভাইসে পাওয়া যায় না';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get on => 'চালু';

  @override
  String get off => 'বন্ধ';

  @override
  String get none => 'নেই';

  @override
  String get unknown => 'অজানা';

  @override
  String get supported => 'সমর্থিত';

  @override
  String get notSupported => 'সমর্থিত নয়';

  @override
  String get detected => 'পাওয়া গেছে';

  @override
  String get notDetected => 'পাওয়া যায়নি';

  @override
  String get encrypted => 'এনক্রিপ্টেড';

  @override
  String get notEncrypted => 'এনক্রিপ্টেড নয়';

  @override
  String get locked => 'লক করা';

  @override
  String get unlocked => 'আনলক করা';

  @override
  String get secGooglePlay => 'Google Play';

  @override
  String get secPlatform => 'প্ল্যাটফর্ম';

  @override
  String get secSession => 'সেশন';

  @override
  String get secCores => 'কোর';

  @override
  String get secCharging => 'চার্জিং';

  @override
  String get secCapacity => 'ক্ষমতা';

  @override
  String get secSettings => 'সেটিংস';

  @override
  String get secMobile => 'মোবাইল নেটওয়ার্ক';

  @override
  String get secVolume => 'স্টোরেজ ভলিউম';

  @override
  String get secDrm => 'ভিডিও সুরক্ষা (DRM)';

  @override
  String get secAudio => 'অডিও';

  @override
  String get secVideoCodecs => 'ভিডিও কোডেক';

  @override
  String get secAudioCodecs => 'অডিও কোডেক';

  @override
  String get secHardware => 'হার্ডওয়্যার';

  @override
  String get specModelName => 'মডেলের নাম';

  @override
  String get specManufacturer => 'নির্মাতা';

  @override
  String get specBrand => 'ব্র্যান্ড';

  @override
  String get specModel => 'মডেল নম্বর';

  @override
  String get specCodename => 'কোডনেম';

  @override
  String get specProduct => 'প্রোডাক্ট';

  @override
  String get specBoard => 'বোর্ড';

  @override
  String get specHardware => 'হার্ডওয়্যার';

  @override
  String get specDeviceType => 'ডিভাইসের ধরন';

  @override
  String get devicePhone => 'ফোন';

  @override
  String get deviceTablet => 'ট্যাবলেট';

  @override
  String get specAndroidVersion => 'অ্যান্ড্রয়েড ভার্সন';

  @override
  String get specApiLevel => 'API লেভেল';

  @override
  String get specSecurityPatch => 'সিকিউরিটি প্যাচ';

  @override
  String get specBuildNumber => 'বিল্ড নম্বর';

  @override
  String get specBuildDate => 'বিল্ডের তারিখ';

  @override
  String get specBuildType => 'বিল্ডের ধরন';

  @override
  String get specIncremental => 'ইনক্রিমেন্টাল ভার্সন';

  @override
  String get specFingerprint => 'বিল্ড ফিঙ্গারপ্রিন্ট';

  @override
  String get specPlayServices => 'Google Play সার্ভিস';

  @override
  String get specPlayStore => 'Play Store';

  @override
  String get specPlaySystemUpdate => 'Google Play সিস্টেম আপডেট';

  @override
  String get specKernel => 'কার্নেল';

  @override
  String get specBootloader => 'বুটলোডার';

  @override
  String get specBaseband => 'বেসব্যান্ড (মডেম)';

  @override
  String get specRuntime => 'রানটাইম';

  @override
  String get specTreble => 'Project Treble';

  @override
  String get specSeamlessUpdates => 'সিমলেস (A/B) আপডেট';

  @override
  String get specDynamicPartitions => 'ডায়নামিক পার্টিশন';

  @override
  String get specEncryption => 'এনক্রিপশন';

  @override
  String get specRoot => 'রুট অ্যাক্সেস';

  @override
  String get specUptime => 'চালু থাকার সময়';

  @override
  String get specLanguage => 'ভাষা';

  @override
  String get specTimezone => 'টাইম জোন';

  @override
  String get specChip => 'চিপ';

  @override
  String get specProcess => 'প্রসেস নোড';

  @override
  String get specSocMaker => 'চিপ নির্মাতা';

  @override
  String get specSocModel => 'চিপের মডেল কোড';

  @override
  String get specCores => 'কোর';

  @override
  String get specClusters => 'ক্লাস্টার';

  @override
  String get specCoreTypes => 'কোরের ধরন';

  @override
  String get specGovernor => 'গভর্নর';

  @override
  String get specArchitecture => 'আর্কিটেকচার';

  @override
  String get specAbis => 'সমর্থিত ABI';

  @override
  String get specInstructions => 'ইনস্ট্রাকশন ফিচার';

  @override
  String get coreOffline => 'অফলাইন (ঘুমন্ত)';

  @override
  String get specRenderer => 'GPU';

  @override
  String get specVendor => 'ভেন্ডর';

  @override
  String get specOpenGlEs => 'OpenGL ES';

  @override
  String get specGlDriver => 'ড্রাইভার ভার্সন';

  @override
  String get specVulkan => 'Vulkan';

  @override
  String get specGlExtensions => 'OpenGL এক্সটেনশন';

  @override
  String get specInstalled => 'ইনস্টল করা RAM';

  @override
  String get specUsable => 'অ্যান্ড্রয়েডের ব্যবহারযোগ্য';

  @override
  String get usableHint => 'RAM-এর কিছু অংশ মডেম আর GPU-র জন্য রাখা থাকে';

  @override
  String get specInUse => 'ব্যবহৃত হচ্ছে';

  @override
  String get specAvailable => 'খালি আছে';

  @override
  String get specLowMemoryAt => 'কম মেমোরির সীমা';

  @override
  String get lowMemoryHint =>
      'এর নিচে নামলে অ্যান্ড্রয়েড ব্যাকগ্রাউন্ড অ্যাপ বন্ধ করতে শুরু করে';

  @override
  String get specLowMemoryNow => 'এখন মেমোরি কম';

  @override
  String get specSwap => 'সোয়াপ (zRAM)';

  @override
  String get specSwapUsed => 'ব্যবহৃত সোয়াপ';

  @override
  String get specTotal => 'মোট';

  @override
  String get specUsed => 'ব্যবহৃত';

  @override
  String get specFree => 'খালি';

  @override
  String get specFileSystem => 'ফাইল সিস্টেম';

  @override
  String get specVolumeType => 'ধরন';

  @override
  String get specState => 'অবস্থা';

  @override
  String get volumeInternal => 'ইন্টারনাল';

  @override
  String get volumeRemovable => 'খুলে ফেলা যায় (SD কার্ড বা USB)';

  @override
  String get volumeOther => 'অন্যান্য';

  @override
  String get specLevel => 'লেভেল';

  @override
  String get specStatus => 'অবস্থা';

  @override
  String get specPowerSource => 'পাওয়ারের উৎস';

  @override
  String get specHealth => 'স্বাস্থ্য';

  @override
  String get specTemperature => 'তাপমাত্রা';

  @override
  String get specVoltage => 'ভোল্টেজ';

  @override
  String get specTechnology => 'প্রযুক্তি';

  @override
  String get specCurrentNow => 'এখনকার কারেন্ট';

  @override
  String get specCurrentAvg => 'গড় কারেন্ট';

  @override
  String get specTimeToFull => 'পূর্ণ হতে বাকি';

  @override
  String get specCycleCount => 'চার্জ সাইকেল';

  @override
  String get cycleHint => 'ব্যাটারি নিজে জানিয়েছে';

  @override
  String get specChargeCounter => 'বাকি চার্জ';

  @override
  String get specEstCapacity => 'আনুমানিক পূর্ণ ক্ষমতা';

  @override
  String get estCapacityHint => 'আনুমানিক, চার্জ কাউন্টার থেকে হিসাব করা';

  @override
  String get specDesignCapacity => 'ডিজাইন ক্ষমতা';

  @override
  String get designCapacityHint =>
      'সিস্টেম পাওয়ার প্রোফাইল থেকে; কিছু নির্মাতা ভুল মান রেখে দেয়';

  @override
  String get batCharging => 'চার্জ হচ্ছে';

  @override
  String get batDischarging => 'চার্জ কমছে';

  @override
  String get batNotCharging => 'প্লাগ লাগানো, চার্জ হচ্ছে না';

  @override
  String get batFull => 'পূর্ণ';

  @override
  String get healthGood => 'ভালো';

  @override
  String get healthOverheat => 'অতিরিক্ত গরম';

  @override
  String get healthDead => 'নষ্ট';

  @override
  String get healthOverVoltage => 'অতিরিক্ত ভোল্টেজ';

  @override
  String get healthFailure => 'ত্রুটি';

  @override
  String get healthCold => 'অতিরিক্ত ঠান্ডা';

  @override
  String get plugBattery => 'ব্যাটারিতে চলছে';

  @override
  String get plugAc => 'চার্জার';

  @override
  String get plugUsb => 'USB';

  @override
  String get plugWireless => 'ওয়্যারলেস';

  @override
  String get plugDock => 'ডক';

  @override
  String get specResolution => 'রেজোলিউশন';

  @override
  String get specSize => 'স্ক্রিনের আকার';

  @override
  String get sizeHint => 'স্ক্রিনের জানানো পিক্সেল ঘনত্ব থেকে হিসাব করা';

  @override
  String get specAspect => 'অনুপাত';

  @override
  String get specDensity => 'পিক্সেল ঘনত্ব';

  @override
  String get specRefreshRate => 'এখনকার রিফ্রেশ রেট';

  @override
  String get specRefreshRates => 'সমর্থিত রিফ্রেশ রেট';

  @override
  String get specHdr => 'HDR';

  @override
  String get specWideColor => 'ওয়াইড কালার';

  @override
  String get specCutout => 'ক্যামেরা কাটআউট';

  @override
  String get specBrightness => 'উজ্জ্বলতার মান';

  @override
  String get brightnessHint => 'কাঁচা মান; পরিসর নির্মাতার ওপর নির্ভর করে';

  @override
  String get specTimeout => 'স্ক্রিন বন্ধ হওয়ার সময়';

  @override
  String get specFontScale => 'ফন্টের আকার';

  @override
  String get specConnection => 'সংযোগ';

  @override
  String get specInternet => 'ইন্টারনেট';

  @override
  String get netWorking => 'চলছে';

  @override
  String get netNoInternet => 'সংযুক্ত, ইন্টারনেট নেই';

  @override
  String get netMobile => 'মোবাইল ডেটা';

  @override
  String get netNone => 'সংযুক্ত নয়';

  @override
  String get netOther => 'অন্যান্য';

  @override
  String get specMetered => 'মিটারড';

  @override
  String get specVpn => 'VPN';

  @override
  String get specInterface => 'ইন্টারফেস';

  @override
  String get specIpv4 => 'IPv4 ঠিকানা';

  @override
  String get specIpv6 => 'IPv6 ঠিকানা';

  @override
  String get specGateway => 'গেটওয়ে';

  @override
  String get specDns => 'DNS সার্ভার';

  @override
  String get specPrivateDns => 'প্রাইভেট DNS';

  @override
  String get specBandwidth => 'সংযোগের ক্ষমতা';

  @override
  String get bandwidthHint =>
      'সংযোগের সর্বোচ্চ গতির ব্যাপারে অ্যান্ড্রয়েডের অনুমান, স্পিড টেস্ট নয়';

  @override
  String get specWifi => 'Wi-Fi';

  @override
  String get specWifiName => 'নেটওয়ার্কের নাম';

  @override
  String get wifiNameHidden => 'অ্যান্ড্রয়েড লুকিয়ে রেখেছে';

  @override
  String get wifiNameHint => 'দেখতে ট্যাপ করে লোকেশনের অনুমতি দিন';

  @override
  String get specSignal => 'সিগন্যাল';

  @override
  String get signalExcellent => 'চমৎকার';

  @override
  String get signalGood => 'ভালো';

  @override
  String get signalFair => 'মোটামুটি';

  @override
  String get signalWeak => 'দুর্বল';

  @override
  String get specWifiStandard => 'Wi-Fi স্ট্যান্ডার্ড';

  @override
  String get specFrequency => 'ফ্রিকোয়েন্সি';

  @override
  String get specLinkSpeed => 'লিংক স্পিড';

  @override
  String get specTxRx => 'পাঠানো / গ্রহণ';

  @override
  String get specOperator => 'অপারেটর';

  @override
  String get specCountry => 'দেশ';

  @override
  String get specRoaming => 'রোমিং';

  @override
  String get specNetworkType => 'নেটওয়ার্কের ধরন';

  @override
  String get needsPhone => 'ফোনের অনুমতি দরকার';

  @override
  String get needsPhoneHint => 'সিমের তথ্য দেখতে ট্যাপ করে অনুমতি দিন';

  @override
  String get specSlots => 'সিম স্লট';

  @override
  String get specSimState => 'সিমের অবস্থা';

  @override
  String get specMccMnc => 'MCC / MNC';

  @override
  String get specSimDetails => 'সিমের তথ্য';

  @override
  String get specCarrier => 'ক্যারিয়ার';

  @override
  String get specSimName => 'নাম';

  @override
  String get specSimType => 'ধরন';

  @override
  String get simPhysical => 'ফিজিক্যাল সিম';

  @override
  String get specDataSim => 'মোবাইল ডেটার জন্য ব্যবহৃত';

  @override
  String get simAbsent => 'সিম নেই';

  @override
  String get simPin => 'PIN দরকার';

  @override
  String get simPuk => 'PUK দরকার';

  @override
  String get simLocked => 'নেটওয়ার্ক লক করা';

  @override
  String get simReady => 'প্রস্তুত';

  @override
  String get simNotReady => 'প্রস্তুত নয়';

  @override
  String get simDisabled => 'বন্ধ করা';

  @override
  String get simError => 'কার্ডে সমস্যা';

  @override
  String get cameraRear => 'পেছনের ক্যামেরা';

  @override
  String get cameraFront => 'সামনের ক্যামেরা';

  @override
  String get cameraExternal => 'এক্সটার্নাল ক্যামেরা';

  @override
  String get specSensorSize => 'সেন্সরের আকার';

  @override
  String get specAperture => 'অ্যাপারচার';

  @override
  String get specFocalLength => 'ফোকাল লেংথ';

  @override
  String get specOis => 'অপটিক্যাল স্টেবিলাইজেশন (OIS)';

  @override
  String get specFlash => 'ফ্ল্যাশ';

  @override
  String get specMaxVideo => 'সেরা ভিডিও';

  @override
  String get specRaw => 'RAW ছবি';

  @override
  String get specCamera2Level => 'Camera2 API লেভেল';

  @override
  String get specMultiCamera => 'একাধিক লেন্স একসাথে ব্যবহার করে';

  @override
  String get specCameraId => 'ক্যামেরা আইডি';

  @override
  String get specWidevine => 'Widevine লেভেল';

  @override
  String get widevineL1Hint => 'L1 থাকলে HD আর 4K স্ট্রিমিং চলে';

  @override
  String get specWidevineVersion => 'Widevine ভার্সন';

  @override
  String get specHdcp => 'সর্বোচ্চ HDCP';

  @override
  String get specAudioOutputs => 'অডিও আউটপুট';

  @override
  String get specLowLatency => 'লো-ল্যাটেন্সি অডিও';

  @override
  String get specProAudio => 'প্রো অডিও';

  @override
  String get specSpatial => 'স্প্যাশিয়াল অডিও';

  @override
  String get codecDecode => 'ডিকোড';

  @override
  String get codecDecodeHw => 'ডিকোড (হার্ডওয়্যার)';

  @override
  String get codecDecodeSw => 'ডিকোড (সফটওয়্যার)';

  @override
  String get codecEncode => 'এনকোড';

  @override
  String get codecEncodeHw => 'এনকোড (হার্ডওয়্যার)';

  @override
  String get codecEncodeSw => 'এনকোড (সফটওয়্যার)';

  @override
  String get featUwb => 'আল্ট্রা-ওয়াইডব্যান্ড (UWB)';

  @override
  String get featIr => 'IR ব্লাস্টার';

  @override
  String get featUsbHost => 'USB হোস্ট (OTG)';

  @override
  String get featFingerprint => 'ফিঙ্গারপ্রিন্ট';

  @override
  String get featFace => 'ফেস আনলক হার্ডওয়্যার';

  @override
  String get featTelephony => 'মোবাইল নেটওয়ার্ক';

  @override
  String get featWifiRtt => 'Wi-Fi RTT (ঘরের ভেতরে লোকেশন)';

  @override
  String get featLe2m => 'LE 2M PHY (দ্রুততর)';

  @override
  String get featLeCoded => 'LE Coded PHY (দূরপাল্লা)';

  @override
  String get featLeExtAdv => 'LE এক্সটেন্ডেড অ্যাডভার্টাইজিং';

  @override
  String get specScreenLock => 'স্ক্রিন লক';

  @override
  String get lockSet => 'সেট করা';

  @override
  String get lockNotSet => 'সেট করা নেই';

  @override
  String get lockHint => 'যে কেউ ফোন হাতে নিলেই খুলতে পারবে';

  @override
  String get specBiometrics => 'বায়োমেট্রিক্স';

  @override
  String get bioEnrolled => 'যুক্ত করা আছে';

  @override
  String get bioNone => 'সেট করা নেই';

  @override
  String get bioNoHardware => 'হার্ডওয়্যার নেই';

  @override
  String get specDevOptions => 'ডেভেলপার অপশন';

  @override
  String get specUsbDebugging => 'USB ডিবাগিং';

  @override
  String get adbHint => 'ডেভেলপমেন্ট না করলে বন্ধ রাখুন';

  @override
  String get specVerifiedBoot => 'ভেরিফায়েড বুট';

  @override
  String monthsOld(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months মাস পুরোনো',
      zero: 'এই মাসের',
    );
    return '$_temp0';
  }

  @override
  String coreN(int index) {
    return 'কোর $index';
  }

  @override
  String maxFreq(String freq) {
    return 'সর্বোচ্চ $freq';
  }

  @override
  String channelN(int channel) {
    return 'চ্যানেল $channel';
  }

  @override
  String signalBars(int level) {
    return '৪টির মধ্যে $levelটি দাগ';
  }

  @override
  String simN(int slot) {
    return 'সিম $slot';
  }

  @override
  String sensorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সেন্সর',
    );
    return '$_temp0';
  }

  @override
  String coresCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কোর',
    );
    return '$_temp0';
  }

  @override
  String cyclesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count সাইকেল',
    );
    return '$_temp0';
  }

  @override
  String slotsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি স্লট',
    );
    return '$_temp0';
  }

  @override
  String camerasCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ক্যামেরা',
    );
    return '$_temp0';
  }

  @override
  String mainCamera(String mp) {
    return '$mp মূল';
  }

  @override
  String codecsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কোডেক',
    );
    return '$_temp0';
  }

  @override
  String checksPassed(int passed, int total) {
    return '$totalটির মধ্যে $passedটি চেক পাস';
  }

  @override
  String secAllFeatures(int count) {
    return 'সব সিস্টেম ফিচার ($count)';
  }

  @override
  String get live => 'লাইভ';

  @override
  String securityPatchOn(String date) {
    return 'সিকিউরিটি প্যাচ $date';
  }

  @override
  String get specsUnavailable => 'আপনার ফোনে অ্যান্ড্রয়েড এই তথ্য দেয়নি।';

  @override
  String get settingsUnavailable => 'আপনার ফোনে এই সেটিংস স্ক্রিন নেই।';

  @override
  String get shareSpecs => 'স্পেক শিট শেয়ার করুন';

  @override
  String get clearSearch => 'মুছুন';

  @override
  String get searchHint =>
      'এই ফোনের যেকোনো স্পেক খুঁজুন, যেমন \"Vulkan\", \"5 GHz\" বা \"patch\"।';

  @override
  String searchNoResults(String query) {
    return '\"$query\"-এর সাথে কিছু মেলেনি।';
  }

  @override
  String specSheetHeader(String device, String date) {
    return '$device স্পেক শিট · $date';
  }

  @override
  String specSheetSubject(String device) {
    return '$device-এর স্পেক';
  }

  @override
  String get specSheetFooter => 'SystemX দিয়ে তৈরি';

  @override
  String get permLocationTitle => 'Wi-Fi-এর নাম দেখান';

  @override
  String get permLocationReason =>
      'অ্যান্ড্রয়েড শুধু লোকেশনের অনুমতি থাকা অ্যাপকে Wi-Fi নেটওয়ার্কের নাম জানায়। SystemX এটা শুধু এই তথ্য আর GPS টেস্টের জন্য ব্যবহার করে, আপনি কোথায় আছেন তা কখনো ট্র্যাক করে না।';

  @override
  String get permPhoneTitle => 'সিমের তথ্য দেখান';

  @override
  String get permPhoneReason =>
      'ফোনের অনুমতি দিলে SystemX আপনার সিম স্লট, ক্যারিয়ারের নাম আর মোবাইল নেটওয়ার্কের ধরন পড়তে পারে। এটা দিয়ে কল করা বা আপনার ফোন নম্বর পড়া যায় না।';

  @override
  String get permBlocked =>
      'আপনি আগে এটা বন্ধ করেছেন, তাই অ্যান্ড্রয়েড আর জিজ্ঞেস করবে না। অনুমতি দিতে সেটিংস › অনুমতি খুলুন।';

  @override
  String get permOpenSettings => 'সেটিংস খুলুন';

  @override
  String get statusAllowed => 'অনুমতি আছে';

  @override
  String get statusNotAllowed => 'অনুমতি নেই';

  @override
  String get statusBlocked => 'সেটিংসে বন্ধ';

  @override
  String get balanceTitle => 'ব্যালেন্স ও দরকারি কোড';

  @override
  String get balanceBody =>
      'কোড ট্যাপ করলে সেটি বসানো অবস্থায় ডায়ালার খুলবে। আপনি কল চাপার আগে কিছুই ডায়াল হয় না।';

  @override
  String get liveReading => 'লাইভ রিডিং';

  @override
  String get sensorWaiting =>
      'রিডিংয়ের অপেক্ষা। কিছু সেন্সর শুধু কোনো পরিবর্তন হলে জানায়, যেমন প্রক্সিমিটি সেন্সর ঢাকলে।';

  @override
  String get sensorOnChange => 'মান বদলালে';

  @override
  String get sensorRange => 'সর্বোচ্চ পরিসর';

  @override
  String get sensorResolution => 'রেজোলিউশন';

  @override
  String get sensorPower => 'বিদ্যুৎ খরচ';

  @override
  String get sensorRate => 'সর্বোচ্চ হার';

  @override
  String get sensorWakeUp => 'ওয়েক-আপ সেন্সর';

  @override
  String get sensorWakeUpHint => 'রিডিং দিতে ফোনকে ঘুম থেকে জাগাতে পারে';

  @override
  String get sensorVersion => 'ড্রাইভার ভার্সন';

  @override
  String get thermalLight => 'হালকা';

  @override
  String get thermalModerate => 'মাঝারি';

  @override
  String get thermalSevere => 'তীব্র';

  @override
  String get thermalCritical => 'সংকটজনক';

  @override
  String get thermalEmergency => 'জরুরি';

  @override
  String get thermalShutdown => 'বন্ধ হয়ে যাচ্ছে';

  @override
  String get pause => 'থামান';

  @override
  String get resume => 'আবার চালান';

  @override
  String get paused => 'থামানো';

  @override
  String get avgClock => 'গড় ক্লক';

  @override
  String get loadEstimate => 'লোড (আনুমানিক)';

  @override
  String get chartClockLast60 => 'গড় ক্লক · শেষ ৬০টি রিডিং';

  @override
  String get loadEstimateHint =>
      'অ্যান্ড্রয়েড ৮ ও পরের ভার্সন অ্যাপকে আসল CPU ব্যবহার দেখায় না, তাই লোড ক্লক স্পিড থেকে অনুমান করা।';

  @override
  String get chartCurrent => 'চার্জিং কারেন্ট';

  @override
  String get currentUnavailable => 'আপনার ফোন চার্জিং কারেন্ট জানায় না।';

  @override
  String get chartTemperature => 'ব্যাটারির তাপমাত্রা';

  @override
  String get download => 'ডাউনলোড';

  @override
  String get upload => 'আপলোড';

  @override
  String get chartNetwork => 'নেটওয়ার্ক স্পিড';

  @override
  String get networkSpeedHint =>
      'এই ফোনের সব অ্যাপের মোট ট্রাফিক। এটা স্পিড টেস্ট নয়।';

  @override
  String get thermalStatus => 'তাপের অবস্থা';

  @override
  String get thermalHeadroom => 'ধীর হওয়ার আগে বাকি';

  @override
  String get chartBatteryTemp => 'ব্যাটারির তাপমাত্রা';

  @override
  String get chartCpuTemp => 'CPU-র তাপমাত্রা';

  @override
  String get cpuTempUnavailable =>
      'আপনার ফোন অ্যাপকে CPU-র তাপমাত্রা পড়তে দেয় না। এর বদলে ব্যাটারির তাপমাত্রা আর তাপের অবস্থা দেখানো হচ্ছে।';

  @override
  String get thermalHint =>
      'ফোন গরম হলে ঠান্ডা করতে অ্যান্ড্রয়েড প্রসেসরকে ধীর করে দেয়। হেডরুম দেখায় সেই সীমা থেকে কত দূরে আছে।';

  @override
  String get details => 'বিস্তারিত';

  @override
  String get scoreGood => 'ভালো অবস্থা';

  @override
  String get scoreFair => 'মোটামুটি অবস্থা';

  @override
  String get scorePoor => 'মনোযোগ দরকার';

  @override
  String get noCheckupYet => 'এখনো চেকআপ হয়নি। স্কোরে যোগ করতে একটি চালান।';

  @override
  String get scoreHow => 'স্কোর যেভাবে হিসাব হয়';

  @override
  String get scoreExplain =>
      'এই মুহূর্তে আপনার ফোন যা জানায় তা মিলিয়ে স্কোর হয়। অ্যান্ড্রয়েড যা দেয় না তা অনুমান না করে বাদ রাখা হয়।';

  @override
  String get factorBattery => 'ব্যাটারির স্বাস্থ্য';

  @override
  String get factorTemperature => 'তাপমাত্রা';

  @override
  String get factorStorage => 'খালি স্টোরেজ';

  @override
  String get factorMemory => 'খালি মেমোরি';

  @override
  String get factorCheckup => 'শেষ চেকআপ';

  @override
  String get tipNoScreenLock =>
      'কোনো স্ক্রিন লক সেট নেই। যে কেউ ফোন হাতে নিলেই খুলতে পারবে।';

  @override
  String get tipMemoryLow =>
      'মেমোরি প্রায় পূর্ণ, তাই অ্যান্ড্রয়েড ব্যাকগ্রাউন্ড অ্যাপ বন্ধ করছে।';

  @override
  String get tipOpen => 'খুলুন';

  @override
  String get monitorTemp => 'তাপমাত্রা';

  @override
  String weightN(int weight) {
    return 'গুরুত্ব $weight';
  }

  @override
  String tipBatteryHot(String temp) {
    return 'ফোন গরম ($temp)। ভারী অ্যাপ বন্ধ করুন বা কিছুক্ষণ কভার খুলে রাখুন।';
  }

  @override
  String tipStorageLow(int percent) {
    return 'স্টোরেজ $percent% পূর্ণ। অ্যাপ দ্রুত রাখতে জায়গা খালি করুন।';
  }

  @override
  String tipPatchOld(int months) {
    return 'সিকিউরিটি প্যাচ $months মাস পুরোনো। সিস্টেম আপডেট আছে কিনা দেখুন।';
  }

  @override
  String tipUnplug(int level) {
    return '$level% চার্জ হয়েছে। ৮০%-এর কাছাকাছি খুলে ফেললে ব্যাটারি কম ক্ষয় হয়।';
  }

  @override
  String get permCameraTitle => 'ক্যামেরা পরীক্ষা করুন';

  @override
  String get permCameraReason =>
      'SystemX শুধু ক্যামেরা টেস্টের সময় ক্যামেরা খোলে। ছবি স্ক্রিনেই থাকে, কখনো সেভ বা আপলোড হয় না।';

  @override
  String get permMicTitle => 'মাইক্রোফোন পরীক্ষা করুন';

  @override
  String get permMicReason =>
      'SystemX শুধু মাইক্রোফোন টেস্টের সময় কয়েক সেকেন্ড রেকর্ড করে, একবার শুনিয়ে মুছে ফেলে। কিছুই সেভ বা আপলোড হয় না।';

  @override
  String get tDeadPixels => 'ডেড পিক্সেল';

  @override
  String get tColorBanding => 'রঙের ব্যান্ডিং';

  @override
  String get tBurnIn => 'বার্ন-ইন';

  @override
  String get tMultiTouch => 'মাল্টি-টাচ';

  @override
  String get tBrightness => 'উজ্জ্বলতার পরিসর';

  @override
  String get tSpeakerMic => 'স্পিকার থেকে মাইক্রোফোন';

  @override
  String get tHeadphones => 'হেডফোন জ্যাক';

  @override
  String get tUsbAudio => 'USB অডিও';

  @override
  String get tVolumeUp => 'ভলিউম বাড়ানোর বোতাম';

  @override
  String get tVolumeDown => 'ভলিউম কমানোর বোতাম';

  @override
  String get tRearCamera => 'পেছনের ক্যামেরা';

  @override
  String get tFrontCamera => 'সামনের ক্যামেরা';

  @override
  String get tAccelerometer => 'অ্যাক্সেলেরোমিটার';

  @override
  String get tGyroscope => 'জাইরোস্কোপ';

  @override
  String get tCompass => 'কম্পাস';

  @override
  String get tProximity => 'প্রক্সিমিটি সেন্সর';

  @override
  String get tLight => 'আলো সেন্সর';

  @override
  String get tBarometer => 'ব্যারোমিটার';

  @override
  String get tMobileSignal => 'মোবাইল সিগন্যাল';

  @override
  String get gAudio => 'অডিও';

  @override
  String get gHaptics => 'ভাইব্রেশন ও বোতাম';

  @override
  String get gConnectivity => 'সংযোগ';

  @override
  String get gBiometrics => 'বায়োমেট্রিক্স';

  @override
  String get gPower => 'চার্জিং ও স্টোরেজ';

  @override
  String get automaticTests => 'স্বয়ংক্রিয় টেস্ট';

  @override
  String get automaticTestsBody =>
      'এগুলো নিজে নিজেই চলে। স্পিকার টেস্টের জন্য ফোন স্থির আর ঘর চুপচাপ রাখুন।';

  @override
  String get bioNoDataNote =>
      'অ্যান্ড্রয়েড আপনার ফিঙ্গারপ্রিন্ট বা মুখ যাচাই করে। SystemX শুধু জানে মিলেছে কিনা।';

  @override
  String get bioPromptTitle => 'বায়োমেট্রিক্স টেস্ট';

  @override
  String get bioPromptSubtitle => 'সেন্সর ছুঁয়ে দিন বা স্ক্রিনের দিকে তাকান';

  @override
  String get buttonDoesNothing => 'বোতামে কিছুই হয় না';

  @override
  String get cancel => 'বাতিল';

  @override
  String get checkupIntro =>
      'প্রথমে স্বয়ংক্রিয় টেস্টগুলো চলে। তারপর প্রতিটি টেস্ট আপনাকে কী করতে হবে বলে দেবে, আর যেকোনোটি বাদ দিতে পারবেন।';

  @override
  String get checkupPrep =>
      'সম্ভব হলে তারের হেডফোন, একটি USB অডিও ডিভাইস আর চার্জার কাছে রাখুন। লোকেশন চালু থাকলে GPS টেস্টে সুবিধা হয়।';

  @override
  String get done => 'হয়ে গেছে';

  @override
  String get fixAudio =>
      'নরম শুকনো ব্রাশ দিয়ে গ্রিল পরিষ্কার করুন, ঢেকে রাখা কভার বা স্ক্রিন প্রটেক্টর সরান, তারপর আবার পরীক্ষা করুন।';

  @override
  String get fixBiometrics =>
      'সেন্সর আর আঙুল পরিষ্কার করুন, সেটিংস › নিরাপত্তায় আবার যুক্ত করুন, তারপর আবার পরীক্ষা করুন।';

  @override
  String get fixCamera =>
      'লেন্স পরিষ্কার করুন আর কিছু ঢেকে আছে কিনা দেখুন। ছবি ঝাপসাই থাকলে ক্যামেরা সার্ভিসিং লাগতে পারে।';

  @override
  String get fixCharging =>
      'অন্য কেবল আর চার্জার দিয়ে চেষ্টা করুন, আর কাঠের খিলাল দিয়ে আলতো করে পোর্ট পরিষ্কার করুন।';

  @override
  String get fixConnectivity =>
      'কুইক সেটিংসে বন্ধ করে আবার চালু করুন, ফোন রিস্টার্ট করুন, তারপর আবার পরীক্ষা করুন।';

  @override
  String get fixConnector =>
      'পোর্ট পরিষ্কার করে অন্য ডিভাইস দিয়ে চেষ্টা করুন।';

  @override
  String get fixDisplay =>
      'ফোন রিস্টার্ট করে আবার পরীক্ষা করুন। দাগ থেকে গেলে সাধারণত স্ক্রিন সার্ভিসিং লাগে।';

  @override
  String get fixHaptics =>
      'ফোন রিস্টার্ট করে আবার পরীক্ষা করুন। তবুও ব্যর্থ হলে যন্ত্রাংশটি সার্ভিসিং লাগতে পারে।';

  @override
  String get fixSensor => 'কভার খুলে, ফোন রিস্টার্ট করে আবার পরীক্ষা করুন।';

  @override
  String get fixStorage => 'কিছু জায়গা খালি করে আবার পরীক্ষা করুন।';

  @override
  String get flashOn => 'ফ্ল্যাশলাইট জ্বলছে';

  @override
  String get flashTurningOn => 'ফ্ল্যাশলাইট চালু হচ্ছে…';

  @override
  String get gpsStarting => 'স্যাটেলাইট খোঁজা হচ্ছে…';

  @override
  String get holdPhone => 'ফোনটি হাতে ধরে রাখুন';

  @override
  String get holdToEar => 'ফোন কানে ধরুন, তারপর চালান চাপুন';

  @override
  String get iAccelerometer => 'বলটিকে চার কোণে গড়িয়ে নিতে ফোন কাত করুন।';

  @override
  String get iBiometrics =>
      'শুরু চাপুন আর আনলক করার মতো ফিঙ্গারপ্রিন্ট বা মুখ ব্যবহার করুন।';

  @override
  String get iBrightness => 'স্ক্রিন কম-বেশি উজ্জ্বল হওয়া লক্ষ্য করুন।';

  @override
  String get iCharging =>
      'চার্জার লাগান। SystemX কয়েক সেকেন্ড চার্জিং কারেন্ট মাপবে।';

  @override
  String get iCompass => 'ফোন সমান করে ধরে ধীরে ধীরে পুরো এক চক্কর ঘুরুন।';

  @override
  String get iEarpiece => 'এই শব্দটা বাজবে কলের সময় কানে ধরা ছোট স্পিকারে।';

  @override
  String get iFlashlight => 'ফোনের পেছনে তাকান।';

  @override
  String get iFrontCamera =>
      'সামনের ক্যামেরা মুখের দিকে ধরুন, ফোকাস করতে ট্যাপ করুন, তারপর ছবি তুলুন।';

  @override
  String get iGps =>
      'জানালার কাছে দাঁড়ান বা বাইরে যান। স্যাটেলাইট খুঁজতে এক মিনিট লাগতে পারে।';

  @override
  String get iGyroscope => 'স্টিয়ারিং ঘোরানোর মতো ফোনটি যেকোনো দিকে ঘোরান।';

  @override
  String get iHeadphones => 'হেডফোন জ্যাকে তারের হেডফোন লাগান।';

  @override
  String get iLight =>
      'হাত দিয়ে স্ক্রিনের ওপরের অংশ ঢাকুন, তারপর সরিয়ে নিন বা আলোর নিচে ধরুন।';

  @override
  String get iMicrophone =>
      'রেকর্ড চেপে কয়েকটি কথা বলুন। SystemX সাথে সাথে শুনিয়ে দেবে।';

  @override
  String get iMultiTouch => 'যত বেশি পারেন আঙুল স্ক্রিনে রাখুন।';

  @override
  String get iProximity =>
      'ইয়ারপিসের কাছে স্ক্রিনের ওপরের অংশ হাত দিয়ে ঢাকুন, তারপর সরিয়ে নিন।';

  @override
  String get iRearCamera =>
      'পেছনের ক্যামেরা খুঁটিনাটি আছে এমন কিছুর দিকে ধরুন, ফোকাস করতে ট্যাপ করুন, তারপর ছবি তুলুন।';

  @override
  String get iSpeaker => 'লাউডস্পিকারে একটি শব্দ বাজবে।';

  @override
  String get iUsbAudio => 'USB-C হেডফোন বা USB অডিও অ্যাডাপ্টার লাগান।';

  @override
  String get iVibration => 'ফোন অল্প সময়ের জন্য একটি ছন্দে ভাইব্রেট করবে।';

  @override
  String get iVolumeDown => 'ভলিউম কমানোর বোতাম চাপুন।';

  @override
  String get iVolumeUp => 'ভলিউম বাড়ানোর বোতাম চাপুন।';

  @override
  String get itDoesntWork => 'আমাকে চিনতে পারছে না';

  @override
  String get keepGoing => 'চালিয়ে যান';

  @override
  String get lastCheckup => 'শেষ চেকআপ';

  @override
  String get listen => 'শুনুন';

  @override
  String get measuring => 'মাপা হচ্ছে…';

  @override
  String get nBanding => 'রঙের দাগ দেখা যায়';

  @override
  String get nBluetoothOff => 'ব্লুটুথ বন্ধ';

  @override
  String get nBrightnessBad => 'উজ্জ্বলতা মসৃণভাবে বদলায়নি';

  @override
  String get nBrightnessOk => 'পুরো পরিসর কাজ করে';

  @override
  String get nBurnIn => 'ছায়ার মতো দাগ দেখা যায়';

  @override
  String get nButtonNoResponse => 'সাড়া নেই';

  @override
  String get nCameraError => 'ক্যামেরা চালু হয়নি';

  @override
  String get nConnected => 'সংযুক্ত';

  @override
  String get nCouldNotRead => 'হার্ডওয়্যারের অবস্থা পড়া যায়নি';

  @override
  String get nDeadPixels => 'কিছু বিন্দুর রং বদলায় না';

  @override
  String get nFlashBad => 'জ্বলেনি';

  @override
  String get nFlashOk => 'জ্বলে';

  @override
  String get nGpsNone => 'কোনো স্যাটেলাইট পাওয়া যায়নি';

  @override
  String get nLoopFail => 'মাইক্রোফোন স্পিকারের শব্দ ধরতে পারেনি';

  @override
  String get nMicError => 'মাইক্রোফোন ব্যস্ত বা পাওয়া যাচ্ছে না';

  @override
  String get nNfcOff => 'NFC বন্ধ';

  @override
  String get nNoBiometrics => 'ফিঙ্গারপ্রিন্ট বা ফেস হার্ডওয়্যার নেই';

  @override
  String get nNoBluetooth => 'এই ফোনে ব্লুটুথ নেই';

  @override
  String get nNoBurnIn => 'ছায়ার মতো দাগ নেই';

  @override
  String get nNoCharger => 'হাতের কাছে চার্জার নেই';

  @override
  String get nNoDeadPixels => 'ডেড পিক্সেল নেই';

  @override
  String get nNoFrontCamera => 'সামনের ক্যামেরা নেই';

  @override
  String get nNoHeadphones => 'হাতের কাছে হেডফোন নেই';

  @override
  String get nNoNfc => 'এই ফোনে NFC নেই';

  @override
  String get nNoRearCamera => 'পেছনের ক্যামেরা নেই';

  @override
  String get nNoSensor => 'এই ফোনে এই সেন্সর নেই';

  @override
  String get nNoSignal => 'মোবাইল সিগন্যাল নেই';

  @override
  String get nNoSignalInfo => 'ফোন সিগন্যালের শক্তি জানায় না';

  @override
  String get nNoSim => 'সিম কার্ড নেই';

  @override
  String get nNoUsbAudio => 'হাতের কাছে USB অডিও ডিভাইস নেই';

  @override
  String get nNoneEnrolled => 'কোনো ফিঙ্গারপ্রিন্ট বা মুখ সেট করা নেই';

  @override
  String get nNotRecognised => 'চিনতে পারেনি';

  @override
  String get nOnNotConnected => 'চালু, সংযুক্ত নয়';

  @override
  String get nPermissionDenied => 'অনুমতি দেওয়া হয়নি';

  @override
  String get nPhotoBad => 'ঝাপসা বা ভাঙা ছবি';

  @override
  String get nPhotoOk => 'প্রিভিউ আর ছবি কাজ করে';

  @override
  String get nRecognised => 'চিনতে পেরেছে';

  @override
  String get nSensorNoResponse => 'সেন্সর সাড়া দেয়নি';

  @override
  String get nSensorResponds => 'নড়াচড়ায় সাড়া দেয়';

  @override
  String get nSmooth => 'মসৃণ গ্রেডিয়েন্ট';

  @override
  String get nStorageError => 'টেস্ট ফাইল লেখা যায়নি';

  @override
  String get nStorageMismatch => 'পড়া ডেটা মেলেনি';

  @override
  String get nToneHeard => 'শব্দ শোনা গেছে';

  @override
  String get nToneNotHeard => 'শব্দ শোনা যায়নি';

  @override
  String get nVeryQuiet => 'খুব আস্তে';

  @override
  String get nVibrationBad => 'ভাইব্রেশন টের পাওয়া যায়নি';

  @override
  String get nVibrationOk => 'ভাইব্রেশন টের পাওয়া গেছে';

  @override
  String get nWifiOff => 'Wi-Fi বন্ধ';

  @override
  String get noChargerAtHand => 'হাতের কাছে চার্জার নেই';

  @override
  String get noHeadphonesAtHand => 'হাতের কাছে হেডফোন নেই';

  @override
  String get noUsbAudioAtHand => 'হাতের কাছে USB অডিও নেই';

  @override
  String get ofHundred => '১০০-এর মধ্যে';

  @override
  String get pastCheckups => 'আগের চেকআপ';

  @override
  String get playAgain => 'আবার বাজান';

  @override
  String get playTone => 'শব্দ বাজান';

  @override
  String get playing => 'বাজছে…';

  @override
  String get playingBack => 'শোনানো হচ্ছে…';

  @override
  String get pressTheButton => 'বোতামটি চাপুন';

  @override
  String get qBanding => 'রংগুলো কি দাগ ছাড়া মসৃণভাবে মিলিয়ে যাচ্ছে?';

  @override
  String get qBrightness => 'স্ক্রিন কি কম আর বেশি উজ্জ্বল হয়েছে?';

  @override
  String get qBurnIn =>
      'স্ট্যাটাস বার বা কিবোর্ডের মতো হালকা কোনো আকার কি থেকে যাচ্ছে?';

  @override
  String get qDeadPixels => 'কোনো বিন্দু কি কালো, সাদা বা অন্য রঙে আটকে ছিল?';

  @override
  String get qFeltVibration => 'ভাইব্রেশন কি টের পেয়েছেন?';

  @override
  String get qFlashOn => 'ফ্ল্যাশলাইট কি জ্বলছে?';

  @override
  String get qHeardTone => 'শব্দটি কি পরিষ্কার শুনেছেন?';

  @override
  String get qHeardVoice => 'নিজের কণ্ঠ কি পরিষ্কার শুনেছেন?';

  @override
  String get qPhotoClear => 'ছবিটি কি পরিষ্কার আর ফোকাসে আছে?';

  @override
  String get record3s => '৩ সেকেন্ড রেকর্ড করুন';

  @override
  String get recordAgain => 'আবার রেকর্ড করুন';

  @override
  String get recording => 'রেকর্ড হচ্ছে… এখন বলুন';

  @override
  String get reportDisclaimer =>
      'এই ফোনে SystemX দিয়ে তৈরি। ইন্টারেক্টিভ ফলাফলগুলো চেকআপের সময় দেওয়া উত্তরের ওপর নির্ভর করে।';

  @override
  String get reportGreat => 'আপনার ফোন দারুণ অবস্থায় আছে';

  @override
  String get reportNeedsWork => 'কিছু অংশে মনোযোগ দরকার';

  @override
  String get reportNotSaved => 'সেভ হয়নি';

  @override
  String get reportOk => 'মোটামুটি ভালো, কয়েকটি সমস্যা আছে';

  @override
  String get reportPhone => 'ফোন';

  @override
  String get reportResults => 'ফলাফল';

  @override
  String get reportSaved => 'রিপোর্ট সেভ হয়েছে';

  @override
  String get reportShareSubject => 'SystemX চেকআপ রিপোর্ট';

  @override
  String get reportTitle => 'চেকআপ রিপোর্ট';

  @override
  String get retake => 'আবার তুলুন';

  @override
  String get savePdf => 'PDF সেভ করুন';

  @override
  String get sensorNotResponding => 'সেন্সর সাড়া দিচ্ছে না';

  @override
  String get shareReport => 'রিপোর্ট শেয়ার করুন';

  @override
  String get showAgain => 'আবার দেখান';

  @override
  String get skip => 'বাদ দিন';

  @override
  String get skippedByYou => 'বাদ দেওয়া হয়েছে';

  @override
  String get speakAfterTap => 'রেকর্ড চাপুন, তারপর বলুন';

  @override
  String get start => 'শুরু করুন';

  @override
  String get statusFailed => 'ব্যর্থ';

  @override
  String get statusNotRun => 'চালানো হয়নি';

  @override
  String get statusPassed => 'পাস';

  @override
  String get statusSkipped => 'বাদ দেওয়া';

  @override
  String get stop => 'থামান';

  @override
  String get stopCheckupBody => 'এ পর্যন্ত ফলাফল একটি রিপোর্টে সেভ থাকবে।';

  @override
  String get stopCheckupTitle => 'চেকআপ থামাবেন?';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get tapToContinue => 'চালিয়ে যেতে ট্যাপ করুন';

  @override
  String get testAgain => 'আবার পরীক্ষা করুন';

  @override
  String get testingAutomatically => 'পরীক্ষা চলছে…';

  @override
  String get touchEveryZone => 'প্রতিটি ঘর ছুঁয়ে দিন';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get vibrateAgain => 'আবার ভাইব্রেট করুন';

  @override
  String get waitingForCharger => 'চার্জারের অপেক্ষা';

  @override
  String get waitingToConnect => 'সংযুক্ত হওয়ার অপেক্ষা';

  @override
  String gpsSatellites(int seen, int used) {
    return '$seenটি স্যাটেলাইট দেখা গেছে · $usedটি ব্যবহৃত';
  }

  @override
  String maxTouches(int count) {
    return 'একসাথে সর্বোচ্চ: $count';
  }

  @override
  String nAllZones(int total) {
    return '$totalটি ঘরই সাড়া দেয়';
  }

  @override
  String nSomeZones(int hit, int total) {
    return '$totalটির মধ্যে $hitটি ঘর সাড়া দিয়েছে';
  }

  @override
  String nChargingDetected(String source) {
    return 'পাওয়া গেছে · $source';
  }

  @override
  String nChargingPeak(String source, int peak) {
    return 'পাওয়া গেছে · $source · সর্বোচ্চ $peak mA';
  }

  @override
  String nGpsFix(int used, int accuracy) {
    return 'অবস্থান পাওয়া গেছে · $usedটি স্যাটেলাইট · ±$accuracy m';
  }

  @override
  String nGpsNoFix(int seen) {
    return '$seenটি স্যাটেলাইট দেখা গেছে, এখনো অবস্থান পাওয়া যায়নি। বাইরে গিয়ে চেষ্টা করুন।';
  }

  @override
  String nImplausible(String value) {
    return 'অস্বাভাবিক রিডিং: $value';
  }

  @override
  String nLoopOk(int db) {
    return 'শব্দ শোনা গেছে (+$db dB)';
  }

  @override
  String nLuxRange(int min, int max) {
    return '$min–$max lx';
  }

  @override
  String nPeakLevel(int db) {
    return 'সর্বোচ্চ $db dBFS';
  }

  @override
  String nStorageSpeed(int write, int read) {
    return 'লেখা $write MB/s · পড়া $read MB/s';
  }

  @override
  String nTouches(int count) {
    return 'একসাথে সর্বোচ্চ $countটি স্পর্শ';
  }

  @override
  String passedOf(int passed, int total) {
    return '$totalটির মধ্যে $passedটি পাস';
  }

  @override
  String progressOf(int done, int total) {
    return '$totalটির মধ্যে $doneটি';
  }

  @override
  String reportCounts(int passed, int failed, int skipped) {
    return '$passedটি পাস · $failedটি ব্যর্থ · $skippedটি বাদ';
  }

  @override
  String secondsElapsed(int seconds) {
    return '$seconds সে.';
  }

  @override
  String get nDetected => 'পাওয়া গেছে';

  @override
  String get nNoVibrator => 'ভাইব্রেশন মোটর নেই';

  @override
  String get nButtonWorks => 'বোতাম কাজ করে';

  @override
  String get nNoFlash => 'এই ফোনে ফ্ল্যাশলাইট নেই';

  @override
  String get nLocationOff => 'লোকেশন বন্ধ থাকায় বাদ দেওয়া হয়েছে';

  @override
  String get justNow => 'এইমাত্র';

  @override
  String minutesAgo(int n) {
    return '$n মিনিট আগে';
  }

  @override
  String hoursAgo(int n) {
    return '$n ঘণ্টা আগে';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n দিন আগে',
      one: 'গতকাল',
    );
    return '$_temp0';
  }

  @override
  String lastCheckupLine(String ago, int passed, int total) {
    return 'শেষ চেকআপ $ago · $totalটির মধ্যে $passedটি পাস';
  }

  @override
  String get alertsTitle => 'অ্যালার্ট ও লাইভ স্ট্যাটাস';

  @override
  String get alertsRowSub =>
      'চার্জ অ্যালার্ম, ব্যাটারি ও স্টোরেজ অ্যালার্ট, লাইভ নোটিফিকেশন';

  @override
  String get alertsUnavailable => 'এই ফোনে অ্যালার্ট পাওয়া যায় না।';

  @override
  String get alertsIntro =>
      'আপনি চালু না করা পর্যন্ত এখানের সবকিছু বন্ধ থাকে। প্রতিটি ধরনের আলাদা নোটিফিকেশন চ্যানেল আছে, তাই অ্যান্ড্রয়েড সেটিংস থেকেও চুপ করাতে পারবেন।';

  @override
  String get secLiveStatus => 'লাইভ স্ট্যাটাস';

  @override
  String get secBatteryAlerts => 'ব্যাটারি';

  @override
  String get secStorageAlerts => 'স্টোরেজ';

  @override
  String get secSummaries => 'সারাংশ ও রিমাইন্ডার';

  @override
  String get secAlerts => 'অ্যালার্ট';

  @override
  String get liveStatus => 'লাইভ স্ট্যাটাস নোটিফিকেশন';

  @override
  String get liveStatusSub =>
      'ব্যাটারি, তাপমাত্রা, চার্জিং পাওয়ার, নেটওয়ার্ক স্পিড আর RAM, সাথে থামানোর বোতাম। সামান্য ব্যাটারি খরচ হয়।';

  @override
  String get statusBarShows => 'স্ট্যাটাস বারে দেখাবে';

  @override
  String get chargeAlarm => 'চার্জ অ্যালার্ম';

  @override
  String get notifyAt => 'কখন জানাবে';

  @override
  String get chargingDone => 'চার্জ শেষ';

  @override
  String get chargingDoneSub => 'চার্জের সারাংশসহ';

  @override
  String get batteryLowAlert => 'ব্যাটারি কম';

  @override
  String get batteryHotAlert => 'ব্যাটারি গরম';

  @override
  String get storageAlert => 'স্টোরেজ প্রায় পূর্ণ';

  @override
  String get weeklySummary => 'সাপ্তাহিক সারাংশ';

  @override
  String get weeklySummarySub =>
      'প্রতি সপ্তাহে চার্জের সংখ্যা, সর্বোচ্চ তাপমাত্রা আর সর্বনিম্ন লেভেল';

  @override
  String get checkupReminder => 'মাসিক চেকআপ রিমাইন্ডার';

  @override
  String get checkupReminderSub => 'শেষ চেকআপের এক মাস পর';

  @override
  String get alertsFootnote =>
      'লাইভ স্ট্যাটাস ছাড়া SystemX প্রতি ১৫ মিনিটে, আর চার্জের সময় প্রতি ২ মিনিটে দেখে। ইতিহাস এই ফোনে ৮ দিন রাখা হয়।';

  @override
  String get notificationsNeeded =>
      'SystemX-এর নোটিফিকেশন বন্ধ, তাই এটা চালু করা যাচ্ছে না।';

  @override
  String get permNotifTitle => 'নোটিফিকেশনের অনুমতি দিন';

  @override
  String get permNotifReason =>
      'এখানে আপনি যে অ্যালার্ট চালু করবেন শুধু সেগুলোই SystemX জানাবে, আর আপনি চালু করলে লাইভ স্ট্যাটাস দেখাবে।';

  @override
  String get history => 'ইতিহাস';

  @override
  String get range24h => '২৪ ঘণ্টা';

  @override
  String get range7d => '৭ দিন';

  @override
  String get historyEmpty =>
      'ইতিহাস ব্যাকগ্রাউন্ডে তৈরি হয়। এক ঘণ্টা পর আবার দেখুন।';

  @override
  String get chargingSessions => 'চার্জিং সেশন';

  @override
  String get chargingSessionsSub => 'প্রতিটি চার্জের গতি আর তাপমাত্রা';

  @override
  String get sessionsEmpty =>
      'এখনো কোনো চার্জ রেকর্ড হয়নি। শুরু করতে ফোন চার্জে লাগান।';

  @override
  String get clearHistory => 'সব ইতিহাস মুছুন';

  @override
  String get clearHistorySub =>
      'ব্যাটারির ইতিহাস, চার্জিং সেশন আর টেস্টের ফলাফল';

  @override
  String get clearHistoryConfirm =>
      'এতে এই ফোন থেকে ব্যাটারির ইতিহাস, চার্জিং সেশন আর সব টেস্টের ফলাফল মুছে যাবে। সেটিংস থেকে যাবে।';

  @override
  String get clear => 'মুছুন';

  @override
  String get historyCleared => 'ইতিহাস মোছা হয়েছে';

  @override
  String chargeAlarmSub(int level) {
    return 'ব্যাটারি $level% হলে জানাবে';
  }

  @override
  String batteryLowSub(int level) {
    return 'চার্জে না থাকলে $level%-এ জানাবে';
  }

  @override
  String batteryHotSub(String temp) {
    return '$temp-এ জানাবে';
  }

  @override
  String storageAlertSub(int percent) {
    return 'স্টোরেজ $percent% পূর্ণ হলে জানাবে';
  }

  @override
  String historyNote(int count) {
    return '$countটি রিডিং, ব্যাকগ্রাউন্ডে প্রতি ১৫ মিনিটে নেওয়া';
  }

  @override
  String avgCurrent(int ma) {
    return 'গড় $ma mA';
  }

  @override
  String peakCurrent(int ma) {
    return 'সর্বোচ্চ $ma mA';
  }

  @override
  String maxTemp(String temp) {
    return 'সর্বোচ্চ $temp';
  }

  @override
  String get wifiMeter => 'Wi-Fi সিগন্যাল মিটার';

  @override
  String get wifiMeterOff => 'সিগন্যাল মাপতে Wi-Fi-তে সংযুক্ত হন।';

  @override
  String get wifiMeterHint =>
      'ধীরে ধীরে হাঁটুন। সিগন্যাল যত শক্তিশালী হবে রিং তত ভরবে, তাই কাজ করা বা রাউটার রাখার সেরা জায়গা খুঁজে পাবেন।';

  @override
  String get bestHere => 'এখন পর্যন্ত সেরা';

  @override
  String healthScoreSpoken(int score, String word) {
    return 'স্বাস্থ্য স্কোর ১০০-এর মধ্যে $score, $word';
  }

  @override
  String get privacyPolicy => 'প্রাইভেসি পলিসি';

  @override
  String get sendFeedback => 'মতামত পাঠান';

  @override
  String get codeBalance => 'ব্যালেন্স';

  @override
  String get codeInternet => 'ইন্টারনেট';

  @override
  String get codeMinutes => 'মিনিট';

  @override
  String get codeSms => 'SMS';

  @override
  String get codeOwnNumber => 'আমার নম্বর';

  @override
  String get codeMenu => 'মেনু ও অফার';

  @override
  String get codeEmergency => 'ইমার্জেন্সি ব্যালেন্স';

  @override
  String get codeCare => 'কাস্টমার কেয়ার';

  @override
  String codeButton(String label, String code) {
    return '$label · $code';
  }

  @override
  String get specDeviceName => 'ডিভাইসের নাম';

  @override
  String get specOemSkin => 'নির্মাতার ইন্টারফেস';

  @override
  String get specLaunchedWith => 'যে ভার্সনে বাজারে এসেছে';

  @override
  String get specHwRevision => 'হার্ডওয়্যার রিভিশন';

  @override
  String get secSales => 'বিক্রয় অঞ্চল';

  @override
  String get specSalesCode => 'সেলস কোড';

  @override
  String get salesCodeHint => 'অঞ্চলভিত্তিক বিল্ড কোড (স্যামসাং ফোনে CSC)';

  @override
  String get specSalesCountry => 'বিক্রয়ের দেশ';

  @override
  String get specSalesRegion => 'অঞ্চল';

  @override
  String get specProductLocale => 'ডিফল্ট ভাষা';

  @override
  String get secIdentifiers => 'শনাক্তকারী';

  @override
  String get specAndroidId => 'অ্যান্ড্রয়েড আইডি';

  @override
  String get androidIdHint =>
      'এই ফোন ও অ্যাপের জন্য অনন্য। ফ্যাক্টরি রিসেটের পর বদলে যায়।';

  @override
  String get specImei => 'IMEI ও সিরিয়াল নম্বর';

  @override
  String get imeiHint =>
      'অ্যান্ড্রয়েড ১০ থেকে এগুলো শুধু ফোনের নিজস্ব অ্যাপ দেখতে পারে। *#06# ডায়াল করতে ট্যাপ করুন।';

  @override
  String get specWarranty => 'নক্স ওয়ারেন্টি';

  @override
  String get warrantyIntact => 'অক্ষত (0x0)';

  @override
  String get warrantyVoid => 'বাতিল (0x1)';

  @override
  String get warrantyHint =>
      'কখনো অনানুষ্ঠানিক সফটওয়্যার ইনস্টল করা হলে স্থায়ীভাবে সেট হয়';

  @override
  String get specCycleCountTracked => 'চার্জ সাইকেল (আনুমানিক)';

  @override
  String cycleTrackedHint(String date) {
    return '$date থেকে চার্জিং দেখে SystemX গুনেছে। এই ফোন ব্যাটারির নিজস্ব হিসাব জানায় না।';
  }

  @override
  String get specSensorTotal => 'মোট সেন্সর';

  @override
  String get specSensorKinds => 'সেন্সরের ধরন';

  @override
  String get specSensorWakeUp => 'ওয়েক-আপ সেন্সর';

  @override
  String get specSensorVendor => 'নির্মাতার নিজস্ব';

  @override
  String get sensorGroupMotion => 'গতি';

  @override
  String get sensorGroupPosition => 'অবস্থান';

  @override
  String get sensorGroupEnvironment => 'পরিবেশ';

  @override
  String get sensorGroupHealth => 'স্বাস্থ্য';

  @override
  String get sensorGroupOther => 'অন্যান্য';

  @override
  String get appsTitle => 'অ্যাপ';

  @override
  String get appsEntry => 'ইনস্টল করা অ্যাপ';

  @override
  String get appsEntryBody => 'প্রতিটি অ্যাপের সাইজ ও ক্যাশ';

  @override
  String appsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি অ্যাপ',
    );
    return '$_temp0';
  }

  @override
  String get appsTotalSize => 'মোট সাইজ';

  @override
  String get appsCacheTotal => 'ক্যাশ';

  @override
  String get appsUsageTitle => 'অ্যাপের সাইজ দেখুন';

  @override
  String get appsUsageBody =>
      'ইউসেজ অ্যাক্সেস চালু করলে SystemX প্রতিটি অ্যাপ ও তার ক্যাশ কতটা জায়গা নিচ্ছে তা পড়তে পারে। কোনো তথ্য ফোনের বাইরে যায় না।';

  @override
  String get appsUsageButton => 'ইউসেজ অ্যাক্সেস দিন';

  @override
  String get appsCacheTitle => 'ক্যাশ পরিষ্কার';

  @override
  String get appsCacheBody =>
      'অ্যান্ড্রয়েড একটি অ্যাপকে অন্য অ্যাপের ক্যাশ মুছতে দেয় না। একটি অ্যাপে ট্যাপ করুন, তারপর স্টোরেজ, তারপর ক্যাশ মুছুন। ফোনের স্টোরেজ ম্যানেজার থেকেও এক জায়গায় জায়গা খালি করা যায়।';

  @override
  String get appsFreeUp => 'জায়গা খালি করুন';

  @override
  String get appsSortSize => 'সাইজ';

  @override
  String get appsSortCache => 'ক্যাশ';

  @override
  String get appsSortName => 'নাম';

  @override
  String get appsSortRecent => 'আপডেট';

  @override
  String get appsShowSystem => 'সিস্টেম অ্যাপ';

  @override
  String appsSizeLine(String size, String cache) {
    return '$size · ক্যাশ $cache';
  }

  @override
  String get appsSearch => 'অ্যাপ খুঁজুন';

  @override
  String get appsEmpty => 'কোনো অ্যাপ মেলেনি';

  @override
  String get bhTitle => 'ব্যাটারি হেলথ';

  @override
  String get bhEntry => 'ব্যাটারি হেলথ';

  @override
  String get bhEntryBody => 'মাপা ক্যাপাসিটি আর ঘণ্টায় খরচ';

  @override
  String get bhCapacity => 'মাপা ক্যাপাসিটি';

  @override
  String bhOfDesign(int pct, String design) {
    return 'মূল $design mAh-এর প্রায় $pct%';
  }

  @override
  String get bhNoDesign => 'এই ফোন মূল ক্যাপাসিটি জানায় না';

  @override
  String bhBasedOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'শেষ $countটি চার্জের ভিত্তিতে',
    );
    return '$_temp0';
  }

  @override
  String get bhNotYet =>
      'এখনো মাপা হয়নি। SystemX-এর ব্যাকগ্রাউন্ড ফিচার চালু রেখে অন্তত ১৫% চার্জ করুন; প্রতিটি চার্জে একটি করে মাপ যোগ হবে।';

  @override
  String get bhNoCounter =>
      'এই ফোন ব্যাটারির চার্জ কাউন্টার জানায় না, তাই ক্যাপাসিটি মাপা যায় না।';

  @override
  String get bhTrend => 'সময়ের সাথে ক্যাপাসিটি';

  @override
  String get bhDrain => 'ঘণ্টায় খরচ (গত ৭ দিন)';

  @override
  String get bhScreenOn => 'স্ক্রিন চালু';

  @override
  String get bhStandby => 'স্ট্যান্ডবাই';

  @override
  String bhPerHour(String rate) {
    return 'ঘণ্টায় $rate%';
  }

  @override
  String bhHours(String hours) {
    return '$hours ঘণ্টা মাপা হয়েছে';
  }

  @override
  String get bhCollecting => 'তথ্য সংগ্রহ চলছে';

  @override
  String get bhDrainNote =>
      'SystemX ব্যাকগ্রাউন্ডে রিডিং নিলে রেকর্ড হয়। লাইভ স্ট্যাটাস চালু থাকলে রিডিং ঘন ঘন হয় আর হিসাব বেশি নির্ভুল হয়।';

  @override
  String get bhHow =>
      'ক্যাপাসিটি হলো যত চার্জ ঢুকেছে তাকে যত শতাংশ বেড়েছে তা দিয়ে ভাগ, ব্যাটারির নিজস্ব কাউন্টারে মাপা। এটি আনুমানিক: তাপ, ফাস্ট চার্জিং আর ফোনের ক্যালিব্রেশনে কয়েক শতাংশ এদিক-ওদিক হতে পারে।';
}
