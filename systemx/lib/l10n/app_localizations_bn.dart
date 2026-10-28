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
  String get navTests => 'পরীক্ষা';

  @override
  String get navMonitor => 'পর্যবেক্ষণ';

  @override
  String get onb1Title => 'আপনার ফোনকে ভেতর থেকে জানুন';

  @override
  String get onb1Body =>
      'তাৎক্ষণিক তথ্য এবং ফোনের প্রতিটি স্পেসিফিকেশন, এক জায়গায় সুস্পষ্টভাবে।';

  @override
  String get onb2Title => 'প্রতিটি অংশ পরীক্ষা করুন';

  @override
  String get onb2Body =>
      'নির্দেশিত পরীক্ষায় স্ক্রিন, স্পিকার, ক্যামেরা, সেন্সরসহ আরও অনেক কিছু যাচাই করা হয়, শেষে একটি প্রতিবেদন দেওয়া হয়।';

  @override
  String get onb3Title => 'গোপনীয়তা সুরক্ষিত';

  @override
  String get onb3Body =>
      'কোনো অ্যাকাউন্টের প্রয়োজন নেই, কোনো নজরদারি নেই। আপনার তথ্য এই ফোনের বাইরে যায় না।';

  @override
  String get onbSkip => 'এড়িয়ে যান';

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
  String get runCheckup => 'পরীক্ষা শুরু করুন';

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
    return 'অবশিষ্ট সীমা $percent%';
  }

  @override
  String get tipChargeLimit =>
      'ব্যাটারির আয়ু বাড়াতে ৮০% চার্জ হলে চার্জার খুলে ফেলুন।';

  @override
  String get tipSetAlarm => 'অ্যালার্ম সেট করুন';

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
  String get catDeviceSub => 'মডেল, নির্মাতা, কোডনাম';

  @override
  String get catSystem => 'সিস্টেম';

  @override
  String get catSystemSub => 'অ্যান্ড্রয়েড সংস্করণ, নিরাপত্তা প্যাচ, কার্নেল';

  @override
  String get catProcessor => 'প্রসেসর';

  @override
  String get catProcessorSub => 'চিপ, কোর, তাৎক্ষণিক ক্লক স্পিড';

  @override
  String get catGpu => 'গ্রাফিক্স';

  @override
  String get catGpuSub => 'জিপিইউ, OpenGL ES, Vulkan';

  @override
  String get catMemory => 'মেমরি';

  @override
  String get catMemorySub => 'ব্যবহৃত ও অবশিষ্ট র‍্যাম';

  @override
  String get catStorage => 'স্টোরেজ';

  @override
  String get catStorageSub => 'অভ্যন্তরীণ স্টোরেজ, এসডি কার্ড, ইউএসবি';

  @override
  String get catBattery => 'ব্যাটারি';

  @override
  String get catBatterySub => 'স্বাস্থ্য, তাপমাত্রা, চার্জিংয়ের গতি';

  @override
  String get catDisplay => 'ডিসপ্লে';

  @override
  String get catDisplaySub => 'রেজোলিউশন, রিফ্রেশ রেট, এইচডিআর';

  @override
  String get catNetwork => 'নেটওয়ার্ক';

  @override
  String get catNetworkSub => 'ওয়াই-ফাই, মোবাইল ডেটা, আইপি ঠিকানা';

  @override
  String get catSim => 'সিম ও মোবাইল';

  @override
  String get catSimSub => 'অপারেটর, সিগন্যাল, ব্যালেন্স যাচাই';

  @override
  String get catCameras => 'ক্যামেরা';

  @override
  String get catCamerasSub => 'মেগাপিক্সেল, অ্যাপারচার, ভিডিও';

  @override
  String get catSensors => 'সেন্সর';

  @override
  String get catSensorsSub => 'প্রতিটি সেন্সর ও তার তাৎক্ষণিক মান';

  @override
  String get catMedia => 'মিডিয়া';

  @override
  String get catMediaSub => 'কোডেক, DRM, অডিও আউটপুট';

  @override
  String get catFeatures => 'বৈশিষ্ট্য';

  @override
  String get catFeaturesSub => 'ব্লুটুথ, NFC, 5G, ফিঙ্গারপ্রিন্ট';

  @override
  String get catSecurity => 'নিরাপত্তা যাচাই';

  @override
  String get catSecuritySub => 'স্ক্রিন লক, এনক্রিপশন, আপডেট';

  @override
  String get testsTitle => 'পরীক্ষা';

  @override
  String get checkupTitle => 'পূর্ণাঙ্গ পরীক্ষা';

  @override
  String checkupMeta(int count, int minutes) {
    return '$countটি পরীক্ষা · প্রায় $minutes মিনিট';
  }

  @override
  String get checkupBody =>
      'স্বয়ংক্রিয় পরীক্ষাগুলো নিজে থেকেই চলবে। বাকিগুলোর ফলাফল আপনাকে জানাতে বলা হবে।';

  @override
  String get startCheckup => 'পরীক্ষা শুরু করুন';

  @override
  String get singleTests => 'আলাদা পরীক্ষা';

  @override
  String get testDisplay => 'ডিসপ্লে';

  @override
  String get testTouch => 'স্পর্শ';

  @override
  String get testSpeaker => 'স্পিকার';

  @override
  String get testEarpiece => 'ইয়ারপিস';

  @override
  String get testMicrophone => 'মাইক্রোফোন';

  @override
  String get testVibration => 'কম্পন';

  @override
  String get testCameras => 'ক্যামেরা';

  @override
  String get testFlashlight => 'ফ্ল্যাশলাইট';

  @override
  String get testSensors => 'সেন্সর';

  @override
  String get testButtons => 'বোতাম';

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
  String get testStorage => 'স্টোরেজের গতি';

  @override
  String get monitorTitle => 'পর্যবেক্ষণ';

  @override
  String get monitorBody =>
      'ফোনের প্রতিটি অংশের তাৎক্ষণিক চার্ট। আগের মান দেখতে চার্টের ওপর আঙুল টেনে নিন।';

  @override
  String get monitorCpu => 'প্রসেসর ক্লক';

  @override
  String get monitorRam => 'মেমরির ব্যবহার';

  @override
  String get monitorBattery => 'ব্যাটারির বিদ্যুৎপ্রবাহ';

  @override
  String get monitorNet => 'নেটওয়ার্কের গতি';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get secAppearance => 'থিম ও রং';

  @override
  String get theme => 'থিম';

  @override
  String get themeSystem => 'সিস্টেম অনুযায়ী';

  @override
  String get themeLight => 'হালকা';

  @override
  String get themeDark => 'গাঢ়';

  @override
  String get pureBlack => 'সম্পূর্ণ কালো';

  @override
  String get pureBlackSub => 'AMOLED স্ক্রিনে বিদ্যুৎ সাশ্রয় করে';

  @override
  String get wallpaperColors => 'ওয়ালপেপারের রং';

  @override
  String get wallpaperColorsSub =>
      'ওয়ালপেপারের সাথে মিল রেখে প্রধান রং নির্ধারণ করুন (অ্যান্ড্রয়েড ১২+)';

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
  String get secLive => 'তাৎক্ষণিক তথ্য';

  @override
  String get refreshRate => 'হালনাগাদের ব্যবধান';

  @override
  String seconds(String value) {
    return '$value সে.';
  }

  @override
  String get secPrivacy => 'গোপনীয়তা';

  @override
  String get privacyPermissions => 'গোপনীয়তা ও অনুমতি';

  @override
  String get privacyPermissionsSub =>
      'SystemX কোন তথ্যে প্রবেশ করতে পারে এবং কেন';

  @override
  String get secAbout => 'সম্পর্কে';

  @override
  String get version => 'সংস্করণ';

  @override
  String get licenses => 'ওপেন-সোর্স লাইসেন্স';

  @override
  String get replayIntro => 'পরিচিতি আবার দেখুন';

  @override
  String get privacyBanner =>
      'আপনার তথ্য এই ফোনেই থাকে। কোনো অ্যাকাউন্ট নেই, বিজ্ঞাপনী নজরদারি নেই, কিছুই আপলোড হয় না।';

  @override
  String get privacyIntro =>
      'এগুলোর কোনোটি ছাড়াই SystemX চলে। শুধু প্রয়োজনীয়গুলো চালু করুন।';

  @override
  String get permNotifications => 'বিজ্ঞপ্তি';

  @override
  String get permNotificationsSub => 'তাৎক্ষণিক অবস্থা ও ব্যাটারির সতর্কবার্তা';

  @override
  String get permLocation => 'লোকেশন';

  @override
  String get permLocationSub => 'ওয়াই-ফাইয়ের নাম ও জিপিএস পরীক্ষা';

  @override
  String get permPhone => 'ফোন';

  @override
  String get permPhoneSub => 'সিম স্লট ও সিগন্যালের তথ্য';

  @override
  String get permCamera => 'ক্যামেরা';

  @override
  String get permCameraSub => 'শুধু ক্যামেরা পরীক্ষার সময়';

  @override
  String get permMicrophone => 'মাইক্রোফোন';

  @override
  String get permMicrophoneSub => 'শুধু মাইক্রোফোন পরীক্ষার সময়';

  @override
  String get permAllow => 'অনুমতি দিন';

  @override
  String get permNotNow => 'এখন নয়';

  @override
  String copied(String label) {
    return '$label কপি করা হয়েছে';
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
  String get secCapacity => 'ধারণক্ষমতা';

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
  String get specCodename => 'কোডনাম';

  @override
  String get specProduct => 'পণ্য';

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
  String get specAndroidVersion => 'অ্যান্ড্রয়েড সংস্করণ';

  @override
  String get specApiLevel => 'API লেভেল';

  @override
  String get specSecurityPatch => 'নিরাপত্তা প্যাচ';

  @override
  String get specBuildNumber => 'বিল্ড নম্বর';

  @override
  String get specBuildDate => 'বিল্ডের তারিখ';

  @override
  String get specBuildType => 'বিল্ডের ধরন';

  @override
  String get specIncremental => 'ইনক্রিমেন্টাল সংস্করণ';

  @override
  String get specFingerprint => 'বিল্ড ফিঙ্গারপ্রিন্ট';

  @override
  String get specPlayServices => 'Google Play পরিষেবা';

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
  String get specSeamlessUpdates => 'নিরবচ্ছিন্ন (A/B) আপডেট';

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
  String get specInstructions => 'ইনস্ট্রাকশন সেট';

  @override
  String get coreOffline => 'অফলাইন (নিষ্ক্রিয়)';

  @override
  String get specRenderer => 'GPU';

  @override
  String get specVendor => 'নির্মাতা';

  @override
  String get specOpenGlEs => 'OpenGL ES';

  @override
  String get specGlDriver => 'ড্রাইভার সংস্করণ';

  @override
  String get specVulkan => 'Vulkan';

  @override
  String get specGlExtensions => 'OpenGL এক্সটেনশন';

  @override
  String get specInstalled => 'ইনস্টল করা র‍্যাম';

  @override
  String get specUsable => 'অ্যান্ড্রয়েডের ব্যবহারযোগ্য';

  @override
  String get usableHint =>
      'র‍্যামের একটি অংশ মডেম ও জিপিইউর জন্য সংরক্ষিত থাকে';

  @override
  String get specInUse => 'ব্যবহৃত';

  @override
  String get specAvailable => 'অবশিষ্ট';

  @override
  String get specLowMemoryAt => 'স্বল্প মেমরির সীমা';

  @override
  String get lowMemoryHint =>
      'এর নিচে নামলে অ্যান্ড্রয়েড ব্যাকগ্রাউন্ডের অ্যাপ বন্ধ করতে শুরু করে';

  @override
  String get specLowMemoryNow => 'এখন মেমরি স্বল্প';

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
  String get volumeInternal => 'অভ্যন্তরীণ';

  @override
  String get volumeRemovable => 'অপসারণযোগ্য (এসডি কার্ড বা ইউএসবি)';

  @override
  String get volumeOther => 'অন্যান্য';

  @override
  String get specLevel => 'চার্জের মাত্রা';

  @override
  String get specStatus => 'অবস্থা';

  @override
  String get specPowerSource => 'বিদ্যুতের উৎস';

  @override
  String get specHealth => 'স্বাস্থ্য';

  @override
  String get specTemperature => 'তাপমাত্রা';

  @override
  String get specVoltage => 'ভোল্টেজ';

  @override
  String get specTechnology => 'প্রযুক্তি';

  @override
  String get specCurrentNow => 'বর্তমান বিদ্যুৎপ্রবাহ';

  @override
  String get specCurrentAvg => 'গড় বিদ্যুৎপ্রবাহ';

  @override
  String get specTimeToFull => 'পূর্ণ হতে বাকি';

  @override
  String get specCycleCount => 'চার্জ চক্র';

  @override
  String get cycleHint => 'ব্যাটারি থেকে প্রাপ্ত তথ্য';

  @override
  String get specChargeCounter => 'অবশিষ্ট চার্জ';

  @override
  String get specEstCapacity => 'আনুমানিক পূর্ণ ধারণক্ষমতা';

  @override
  String get estCapacityHint => 'চার্জ কাউন্টার থেকে আনুমানিক হিসাব';

  @override
  String get specDesignCapacity => 'মূল (ডিজাইন) ধারণক্ষমতা';

  @override
  String get designCapacityHint =>
      'সিস্টেমের পাওয়ার প্রোফাইল থেকে নেওয়া; কিছু নির্মাতার ক্ষেত্রে মানটি সঠিক নাও হতে পারে';

  @override
  String get batCharging => 'চার্জ হচ্ছে';

  @override
  String get batDischarging => 'চার্জ কমছে';

  @override
  String get batNotCharging => 'চার্জার সংযুক্ত, চার্জ হচ্ছে না';

  @override
  String get batFull => 'পূর্ণ';

  @override
  String get healthGood => 'ভালো';

  @override
  String get healthOverheat => 'অতিরিক্ত গরম';

  @override
  String get healthDead => 'অকেজো';

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
  String get plugWireless => 'তারবিহীন';

  @override
  String get plugDock => 'ডক';

  @override
  String get specResolution => 'রেজোলিউশন';

  @override
  String get specSize => 'স্ক্রিনের আকার';

  @override
  String get sizeHint => 'স্ক্রিনের পিক্সেল ঘনত্ব থেকে হিসাব করা';

  @override
  String get specAspect => 'দৈর্ঘ্য-প্রস্থ অনুপাত';

  @override
  String get specDensity => 'পিক্সেল ঘনত্ব';

  @override
  String get specRefreshRate => 'বর্তমান রিফ্রেশ রেট';

  @override
  String get specRefreshRates => 'সমর্থিত রিফ্রেশ রেট';

  @override
  String get specHdr => 'HDR';

  @override
  String get specWideColor => 'প্রশস্ত রঙের পরিসর';

  @override
  String get specCutout => 'ক্যামেরা কাটআউট';

  @override
  String get specBrightness => 'উজ্জ্বলতার মান';

  @override
  String get brightnessHint => 'মূল মান; পরিসর নির্মাতাভেদে ভিন্ন';

  @override
  String get specTimeout => 'স্ক্রিন বন্ধ হওয়ার সময়';

  @override
  String get specFontScale => 'ফন্টের আকার';

  @override
  String get specConnection => 'সংযোগ';

  @override
  String get specInternet => 'ইন্টারনেট';

  @override
  String get netWorking => 'সক্রিয়';

  @override
  String get netNoInternet => 'সংযুক্ত, ইন্টারনেট নেই';

  @override
  String get netMobile => 'মোবাইল ডেটা';

  @override
  String get netNone => 'সংযুক্ত নয়';

  @override
  String get netOther => 'অন্যান্য';

  @override
  String get specMetered => 'সীমিত ডেটা (মিটারড)';

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
  String get specBandwidth => 'সংযোগের সক্ষমতা';

  @override
  String get bandwidthHint =>
      'সংযোগের সর্বোচ্চ গতি সম্পর্কে অ্যান্ড্রয়েডের অনুমান; এটি গতি পরীক্ষা নয়';

  @override
  String get specWifi => 'Wi-Fi';

  @override
  String get specWifiName => 'নেটওয়ার্কের নাম';

  @override
  String get wifiNameHidden => 'অ্যান্ড্রয়েড গোপন রেখেছে';

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
  String get specWifiStandard => 'Wi-Fi মান';

  @override
  String get specFrequency => 'ফ্রিকোয়েন্সি';

  @override
  String get specLinkSpeed => 'সংযোগের গতি';

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
  String get needsPhone => 'ফোনের অনুমতি প্রয়োজন';

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
  String get simPhysical => 'প্রথাগত সিম';

  @override
  String get specDataSim => 'মোবাইল ডেটার জন্য ব্যবহৃত';

  @override
  String get simAbsent => 'সিম নেই';

  @override
  String get simPin => 'PIN প্রয়োজন';

  @override
  String get simPuk => 'PUK প্রয়োজন';

  @override
  String get simLocked => 'নেটওয়ার্ক লক করা';

  @override
  String get simReady => 'প্রস্তুত';

  @override
  String get simNotReady => 'প্রস্তুত নয়';

  @override
  String get simDisabled => 'নিষ্ক্রিয়';

  @override
  String get simError => 'কার্ডে ত্রুটি';

  @override
  String get cameraRear => 'পেছনের ক্যামেরা';

  @override
  String get cameraFront => 'সামনের ক্যামেরা';

  @override
  String get cameraExternal => 'বাহ্যিক ক্যামেরা';

  @override
  String get specSensorSize => 'সেন্সরের আকার';

  @override
  String get specAperture => 'অ্যাপারচার';

  @override
  String get specFocalLength => 'ফোকাল দৈর্ঘ্য';

  @override
  String get specOis => 'অপটিক্যাল স্থিতিশীলতা (OIS)';

  @override
  String get specFlash => 'ফ্ল্যাশ';

  @override
  String get specMaxVideo => 'সর্বোচ্চ ভিডিও মান';

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
  String get widevineL1Hint => 'L1 থাকলে HD ও 4K স্ট্রিমিং করা যায়';

  @override
  String get specWidevineVersion => 'Widevine সংস্করণ';

  @override
  String get specHdcp => 'সর্বোচ্চ HDCP';

  @override
  String get specAudioOutputs => 'অডিও আউটপুট';

  @override
  String get specLowLatency => 'স্বল্প বিলম্বের অডিও';

  @override
  String get specProAudio => 'পেশাদার অডিও';

  @override
  String get specSpatial => 'স্থানিক অডিও (স্প্যাশিয়াল)';

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
  String get featFace => 'মুখমণ্ডল শনাক্তকরণ হার্ডওয়্যার';

  @override
  String get featTelephony => 'মোবাইল নেটওয়ার্ক';

  @override
  String get featWifiRtt => 'Wi-Fi RTT (ভবনের ভেতরে অবস্থান নির্ণয়)';

  @override
  String get featLe2m => 'LE 2M PHY (দ্রুততর)';

  @override
  String get featLeCoded => 'LE Coded PHY (দীর্ঘ পরিসর)';

  @override
  String get featLeExtAdv => 'LE বর্ধিত অ্যাডভার্টাইজিং';

  @override
  String get specScreenLock => 'স্ক্রিন লক';

  @override
  String get lockSet => 'নির্ধারিত';

  @override
  String get lockNotSet => 'নির্ধারিত নয়';

  @override
  String get lockHint => 'যে কেউ ফোনটি হাতে নিয়ে খুলতে পারবে';

  @override
  String get specBiometrics => 'বায়োমেট্রিক্স';

  @override
  String get bioEnrolled => 'নিবন্ধিত';

  @override
  String get bioNone => 'নির্ধারিত নয়';

  @override
  String get bioNoHardware => 'হার্ডওয়্যার নেই';

  @override
  String get specDevOptions => 'ডেভেলপার অপশন';

  @override
  String get specUsbDebugging => 'USB ডিবাগিং';

  @override
  String get adbHint => 'প্রয়োজন না হলে বন্ধ রাখুন';

  @override
  String get specVerifiedBoot => 'যাচাইকৃত বুট (Verified boot)';

  @override
  String monthsOld(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months মাস পুরোনো',
      zero: 'চলতি মাসের',
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
    return '৪টির মধ্যে $levelটি বার';
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
      other: '$countটি চক্র',
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
    return '$totalটির মধ্যে $passedটি যাচাইয়ে উত্তীর্ণ';
  }

  @override
  String secAllFeatures(int count) {
    return 'সকল সিস্টেম বৈশিষ্ট্য ($count)';
  }

  @override
  String get live => 'তাৎক্ষণিক';

  @override
  String securityPatchOn(String date) {
    return 'নিরাপত্তা প্যাচ $date';
  }

  @override
  String get specsUnavailable =>
      'আপনার ফোনে অ্যান্ড্রয়েড এই তথ্য প্রকাশ করেনি।';

  @override
  String get settingsUnavailable => 'আপনার ফোনে এই সেটিংস স্ক্রিন নেই।';

  @override
  String get shareSpecs => 'স্পেসিফিকেশন শেয়ার করুন';

  @override
  String get clearSearch => 'মুছুন';

  @override
  String get searchHint =>
      'এই ফোনের যেকোনো স্পেসিফিকেশন খুঁজুন, যেমন \"Vulkan\", \"5 GHz\" বা \"patch\"।';

  @override
  String searchNoResults(String query) {
    return '\"$query\"-এর সাথে মিলে এমন কিছু পাওয়া যায়নি।';
  }

  @override
  String specSheetHeader(String device, String date) {
    return '$device স্পেসিফিকেশন · $date';
  }

  @override
  String specSheetSubject(String device) {
    return '$device-এর স্পেসিফিকেশন';
  }

  @override
  String get specSheetFooter => 'SystemX দিয়ে তৈরি';

  @override
  String get permLocationTitle => 'Wi-Fi-এর নাম দেখান';

  @override
  String get permLocationReason =>
      'লোকেশনের অনুমতি থাকা অ্যাপকেই শুধু অ্যান্ড্রয়েড Wi-Fi নেটওয়ার্কের নাম জানায়। SystemX এটি কেবল এই তথ্য ও জিপিএস পরীক্ষার জন্য ব্যবহার করে; আপনার অবস্থান কখনো অনুসরণ করে না।';

  @override
  String get permPhoneTitle => 'সিমের তথ্য দেখান';

  @override
  String get permPhoneReason =>
      'ফোনের অনুমতি দিলে SystemX আপনার সিম স্লট, অপারেটরের নাম ও মোবাইল নেটওয়ার্কের ধরন জানতে পারে। এটি দিয়ে কল করা বা আপনার ফোন নম্বর জানা সম্ভব নয়।';

  @override
  String get permBlocked =>
      'আপনি আগে এটি বন্ধ করেছেন, তাই অ্যান্ড্রয়েড আর জানতে চাইবে না। অনুমতি দিতে সেটিংস › অনুমতি খুলুন।';

  @override
  String get permOpenSettings => 'সেটিংস খুলুন';

  @override
  String get statusAllowed => 'অনুমতি আছে';

  @override
  String get statusNotAllowed => 'অনুমতি নেই';

  @override
  String get statusBlocked => 'সেটিংসে বন্ধ';

  @override
  String get balanceTitle => 'ব্যালেন্স ও প্রয়োজনীয় কোড';

  @override
  String get balanceBody =>
      'কোডে ট্যাপ করলে তা বসানো অবস্থায় ডায়ালার খুলবে। আপনি কল বোতাম না চাপা পর্যন্ত কিছুই ডায়াল হবে না।';

  @override
  String get liveReading => 'তাৎক্ষণিক মান';

  @override
  String get sensorWaiting =>
      'মানের জন্য অপেক্ষা করা হচ্ছে। কিছু সেন্সর শুধু পরিবর্তন হলে মান জানায়, যেমন প্রক্সিমিটি সেন্সর ঢেকে দিলে।';

  @override
  String get sensorOnChange => 'মান বদলালে';

  @override
  String get sensorRange => 'সর্বোচ্চ পরিসর';

  @override
  String get sensorResolution => 'সূক্ষ্মতা';

  @override
  String get sensorPower => 'বিদ্যুৎ খরচ';

  @override
  String get sensorRate => 'সর্বোচ্চ হার';

  @override
  String get sensorWakeUp => 'জাগ্রতকারী সেন্সর';

  @override
  String get sensorWakeUpHint =>
      'মান জানাতে ফোনকে নিষ্ক্রিয় অবস্থা থেকে সক্রিয় করতে পারে';

  @override
  String get sensorVersion => 'ড্রাইভার সংস্করণ';

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
  String get pause => 'বিরতি';

  @override
  String get resume => 'পুনরায় চালু';

  @override
  String get paused => 'বিরতিতে';

  @override
  String get avgClock => 'গড় ক্লক';

  @override
  String get loadEstimate => 'লোড (আনুমানিক)';

  @override
  String get chartClockLast60 => 'গড় ক্লক · সর্বশেষ ৬০টি মান';

  @override
  String get loadEstimateHint =>
      'অ্যান্ড্রয়েড ৮ ও পরবর্তী সংস্করণে অ্যাপ প্রকৃত CPU ব্যবহার দেখতে পারে না, তাই ক্লক স্পিড থেকে লোড অনুমান করা হয়।';

  @override
  String get chartCurrent => 'চার্জিং বিদ্যুৎপ্রবাহ';

  @override
  String get currentUnavailable =>
      'আপনার ফোন চার্জিং বিদ্যুৎপ্রবাহের তথ্য দেয় না।';

  @override
  String get chartTemperature => 'ব্যাটারির তাপমাত্রা';

  @override
  String get download => 'ডাউনলোড';

  @override
  String get upload => 'আপলোড';

  @override
  String get chartNetwork => 'নেটওয়ার্কের গতি';

  @override
  String get networkSpeedHint =>
      'এই ফোনের সকল অ্যাপের মোট ডেটা আদান-প্রদান। এটি গতি পরীক্ষা নয়।';

  @override
  String get thermalStatus => 'তাপের অবস্থা';

  @override
  String get thermalHeadroom => 'গতি কমার আগে অবশিষ্ট সীমা';

  @override
  String get chartBatteryTemp => 'ব্যাটারির তাপমাত্রা';

  @override
  String get chartCpuTemp => 'CPU-র তাপমাত্রা';

  @override
  String get cpuTempUnavailable =>
      'আপনার ফোন অ্যাপকে CPU-র তাপমাত্রা জানতে দেয় না। এর পরিবর্তে ব্যাটারির তাপমাত্রা ও তাপের অবস্থা দেখানো হচ্ছে।';

  @override
  String get thermalHint =>
      'ফোন গরম হলে অ্যান্ড্রয়েড প্রসেসরের গতি কমিয়ে তাপ নিয়ন্ত্রণ করে। অবশিষ্ট সীমা দেখায় ফোনটি সেই অবস্থা থেকে কত দূরে।';

  @override
  String get details => 'বিস্তারিত';

  @override
  String get scoreGood => 'ভালো অবস্থা';

  @override
  String get scoreFair => 'মোটামুটি অবস্থা';

  @override
  String get scorePoor => 'মনোযোগ দরকার';

  @override
  String get noCheckupYet =>
      'এখনো কোনো পরীক্ষা করা হয়নি। স্কোরে অন্তর্ভুক্ত করতে একটি পরীক্ষা চালান।';

  @override
  String get scoreHow => 'স্কোর যেভাবে নির্ধারিত হয়';

  @override
  String get scoreExplain =>
      'এই মুহূর্তে আপনার ফোন যে তথ্য দেয়, তার ভিত্তিতে স্কোর নির্ধারিত হয়। অ্যান্ড্রয়েড যা প্রকাশ করে না, তা অনুমান না করে বাদ দেওয়া হয়।';

  @override
  String get factorBattery => 'ব্যাটারির স্বাস্থ্য';

  @override
  String get factorTemperature => 'তাপমাত্রা';

  @override
  String get factorStorage => 'খালি স্টোরেজ';

  @override
  String get factorMemory => 'খালি মেমরি';

  @override
  String get factorCheckup => 'সর্বশেষ পরীক্ষা';

  @override
  String get tipNoScreenLock =>
      'কোনো স্ক্রিন লক নির্ধারণ করা নেই। যে কেউ আপনার ফোন খুলতে পারবে।';

  @override
  String get tipMemoryLow =>
      'মেমরি প্রায় পূর্ণ, তাই অ্যান্ড্রয়েড ব্যাকগ্রাউন্ডের অ্যাপ বন্ধ করছে।';

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
    return 'ফোন গরম ($temp)। ভারী অ্যাপ বন্ধ করুন অথবা কিছুক্ষণ কভার খুলে রাখুন।';
  }

  @override
  String tipStorageLow(int percent) {
    return 'স্টোরেজ $percent% পূর্ণ। অ্যাপ দ্রুত রাখতে জায়গা খালি করুন।';
  }

  @override
  String tipPatchOld(int months) {
    return 'নিরাপত্তা প্যাচ $months মাস পুরোনো। সিস্টেম আপডেট আছে কি না দেখুন।';
  }

  @override
  String tipUnplug(int level) {
    return '$level% চার্জ হয়েছে। ৮০%-এর কাছাকাছি চার্জার খুলে ফেললে ব্যাটারির ক্ষয় কমে।';
  }

  @override
  String get permCameraTitle => 'ক্যামেরা পরীক্ষা করুন';

  @override
  String get permCameraReason =>
      'SystemX শুধু ক্যামেরা পরীক্ষার সময় ক্যামেরা চালু করে। ছবি কেবল স্ক্রিনে দেখানো হয়; কখনো সংরক্ষণ বা আপলোড করা হয় না।';

  @override
  String get permMicTitle => 'মাইক্রোফোন পরীক্ষা করুন';

  @override
  String get permMicReason =>
      'SystemX শুধু মাইক্রোফোন পরীক্ষার সময় কয়েক সেকেন্ড রেকর্ড করে, একবার শুনিয়ে মুছে ফেলে। কিছুই সংরক্ষণ বা আপলোড করা হয় না।';

  @override
  String get tDeadPixels => 'অকেজো পিক্সেল';

  @override
  String get tColorBanding => 'রঙের স্তরভেদ (ব্যান্ডিং)';

  @override
  String get tBurnIn => 'স্ক্রিনে স্থায়ী ছাপ (বার্ন-ইন)';

  @override
  String get tMultiTouch => 'একাধিক স্পর্শ';

  @override
  String get tBrightness => 'উজ্জ্বলতার পরিসর';

  @override
  String get tSpeakerMic => 'স্পিকার থেকে মাইক্রোফোন';

  @override
  String get tHeadphones => 'তারযুক্ত হেডফোন';

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
  String get gHaptics => 'কম্পন ও বোতাম';

  @override
  String get gConnectivity => 'সংযোগ';

  @override
  String get gBiometrics => 'বায়োমেট্রিক্স';

  @override
  String get gPower => 'চার্জিং ও স্টোরেজ';

  @override
  String get automaticTests => 'স্বয়ংক্রিয় পরীক্ষা';

  @override
  String get automaticTestsBody =>
      'এগুলো নিজে থেকেই চলে। স্পিকার পরীক্ষার সময় ফোন স্থির ও পরিবেশ নীরব রাখুন।';

  @override
  String get bioNoDataNote =>
      'অ্যান্ড্রয়েড আপনার ফিঙ্গারপ্রিন্ট বা মুখ যাচাই করে। SystemX শুধু জানতে পারে মিলেছে কি না।';

  @override
  String get bioPromptTitle => 'বায়োমেট্রিক্স পরীক্ষা';

  @override
  String get bioPromptSubtitle =>
      'সেন্সর স্পর্শ করুন অথবা স্ক্রিনের দিকে তাকান';

  @override
  String get buttonDoesNothing => 'বোতাম চাপলে কোনো সাড়া নেই';

  @override
  String get cancel => 'বাতিল';

  @override
  String get checkupIntro =>
      'প্রথমে স্বয়ংক্রিয় পরীক্ষাগুলো চলবে। এরপর প্রতিটি পরীক্ষায় করণীয় জানিয়ে দেওয়া হবে; যেকোনো পরীক্ষা বাদ দিতে পারবেন।';

  @override
  String get checkupPrep =>
      'সম্ভব হলে তারযুক্ত হেডফোন, একটি ইউএসবি অডিও ডিভাইস ও চার্জার কাছে রাখুন। লোকেশন চালু থাকলে জিপিএস পরীক্ষা সহজ হয়।';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get fixAudio =>
      'নরম ও শুকনো ব্রাশ দিয়ে গ্রিল পরিষ্কার করুন, একে ঢেকে রাখা কভার বা স্ক্রিন প্রটেক্টর সরিয়ে আবার পরীক্ষা করুন।';

  @override
  String get fixBiometrics =>
      'সেন্সর ও আঙুল পরিষ্কার করুন, সেটিংস › নিরাপত্তা থেকে পুনরায় নিবন্ধন করে আবার পরীক্ষা করুন।';

  @override
  String get fixCamera =>
      'লেন্স পরিষ্কার করুন এবং কিছু ঢেকে রেখেছে কি না দেখুন। এরপরও ছবি ঝাপসা থাকলে ক্যামেরা মেরামতের প্রয়োজন হতে পারে।';

  @override
  String get fixCharging =>
      'অন্য কেবল ও চার্জার দিয়ে চেষ্টা করুন এবং কাঠের খিলাল দিয়ে আলতোভাবে পোর্ট পরিষ্কার করুন।';

  @override
  String get fixConnectivity =>
      'কুইক সেটিংস থেকে বন্ধ করে আবার চালু করুন, ফোন রিস্টার্ট করে আবার পরীক্ষা করুন।';

  @override
  String get fixConnector =>
      'পোর্ট পরিষ্কার করে অন্য ডিভাইস দিয়ে চেষ্টা করুন।';

  @override
  String get fixDisplay =>
      'ফোন রিস্টার্ট করে আবার পরীক্ষা করুন। দাগ থেকে গেলে সাধারণত স্ক্রিন মেরামতের প্রয়োজন হয়।';

  @override
  String get fixHaptics =>
      'ফোন রিস্টার্ট করে আবার পরীক্ষা করুন। তবুও ব্যর্থ হলে যন্ত্রাংশটি মেরামতের প্রয়োজন হতে পারে।';

  @override
  String get fixSensor =>
      'কভার খুলে ফোন রিস্টার্ট করুন, তারপর আবার পরীক্ষা করুন।';

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
  String get holdToEar => 'ফোন কানে ধরুন, তারপর বাজান চাপুন';

  @override
  String get iAccelerometer => 'ফোন কাত করে বলটিকে চারটি কোণে নিয়ে যান।';

  @override
  String get iBiometrics =>
      'শুরু চাপুন এবং আনলক করার মতো করে ফিঙ্গারপ্রিন্ট বা মুখ ব্যবহার করুন।';

  @override
  String get iBrightness => 'স্ক্রিনের উজ্জ্বলতা কমা ও বাড়া লক্ষ করুন।';

  @override
  String get iCharging =>
      'চার্জার সংযুক্ত করুন। SystemX কয়েক সেকেন্ড চার্জিং বিদ্যুৎপ্রবাহ পরিমাপ করবে।';

  @override
  String get iCompass => 'ফোন সমতলভাবে ধরে ধীরে ধীরে সম্পূর্ণ এক পাক ঘুরুন।';

  @override
  String get iEarpiece => 'কলের সময় কানে ধরা ছোট স্পিকারে এই শব্দটি বাজবে।';

  @override
  String get iFlashlight => 'ফোনের পেছনে তাকান।';

  @override
  String get iFrontCamera =>
      'সামনের ক্যামেরা মুখের দিকে ধরুন, ফোকাস করতে ট্যাপ করুন, তারপর ছবি তুলুন।';

  @override
  String get iGps =>
      'জানালার কাছে দাঁড়ান অথবা বাইরে যান। স্যাটেলাইট খুঁজে পেতে এক মিনিট পর্যন্ত লাগতে পারে।';

  @override
  String get iGyroscope =>
      'স্টিয়ারিং ঘোরানোর মতো করে ফোনটি যেকোনো দিকে ঘোরান।';

  @override
  String get iHeadphones =>
      'তারযুক্ত হেডফোন সংযুক্ত করুন: ৩.৫ মিমি জ্যাকে, USB-C হেডফোন হিসেবে, অথবা USB-C অ্যাডাপ্টারের মাধ্যমে।';

  @override
  String get iLight =>
      'হাত দিয়ে স্ক্রিনের ওপরের অংশ ঢেকে দিন, তারপর হাত সরিয়ে নিন অথবা আলোর নিচে ধরুন।';

  @override
  String get iMicrophone =>
      'রেকর্ড চেপে কয়েকটি কথা বলুন। SystemX সঙ্গে সঙ্গে তা শুনিয়ে দেবে।';

  @override
  String get iMultiTouch => 'যত বেশি সম্ভব আঙুল স্ক্রিনে রাখুন।';

  @override
  String get iProximity =>
      'ইয়ারপিসের কাছে স্ক্রিনের ওপরের অংশ হাত দিয়ে ঢাকুন, তারপর সরিয়ে নিন।';

  @override
  String get iRearCamera =>
      'পেছনের ক্যামেরা সূক্ষ্ম বিবরণযুক্ত কোনো বস্তুর দিকে ধরুন, ফোকাস করতে ট্যাপ করুন, তারপর ছবি তুলুন।';

  @override
  String get iSpeaker => 'লাউডস্পিকারে একটি শব্দ বাজবে।';

  @override
  String get iUsbAudio =>
      'USB-C হেডফোন অথবা USB অডিও অ্যাডাপ্টার সংযুক্ত করুন।';

  @override
  String get iVibration => 'ফোনটি একটি নির্দিষ্ট ছন্দে অল্প সময় কাঁপবে।';

  @override
  String get iVolumeDown => 'ভলিউম কমানোর বোতাম চাপুন।';

  @override
  String get iVolumeUp => 'ভলিউম বাড়ানোর বোতাম চাপুন।';

  @override
  String get itDoesntWork => 'শনাক্ত করতে পারছে না';

  @override
  String get keepGoing => 'চালিয়ে যান';

  @override
  String get lastCheckup => 'সর্বশেষ পরীক্ষা';

  @override
  String get listen => 'শুনুন';

  @override
  String get measuring => 'পরিমাপ করা হচ্ছে…';

  @override
  String get nBanding => 'রঙের স্তর বা ডোরা দেখা যায়';

  @override
  String get nBluetoothOff => 'ব্লুটুথ বন্ধ';

  @override
  String get nBrightnessBad => 'উজ্জ্বলতা মসৃণভাবে বদলায়নি';

  @override
  String get nBrightnessOk => 'পুরো পরিসর কাজ করে';

  @override
  String get nBurnIn => 'ছায়ার মতো ছাপ দেখা যায়';

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
  String get nNoBiometrics =>
      'ফিঙ্গারপ্রিন্ট বা মুখমণ্ডল শনাক্তকরণের হার্ডওয়্যার নেই';

  @override
  String get nNoBluetooth => 'এই ফোনে ব্লুটুথ নেই';

  @override
  String get nNoBurnIn => 'ছায়ার মতো কোনো ছাপ নেই';

  @override
  String get nNoCharger => 'হাতের কাছে চার্জার নেই';

  @override
  String get nNoDeadPixels => 'কোনো অকেজো পিক্সেল নেই';

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
  String get nNoSignalInfo => 'ফোনটি সিগন্যালের শক্তি জানায় না';

  @override
  String get nNoSim => 'সিম কার্ড নেই';

  @override
  String get nNoUsbAudio => 'হাতের কাছে USB অডিও ডিভাইস নেই';

  @override
  String get nNoneEnrolled => 'কোনো ফিঙ্গারপ্রিন্ট বা মুখ নিবন্ধিত নেই';

  @override
  String get nNotRecognised => 'শনাক্ত হয়নি';

  @override
  String get nOnNotConnected => 'চালু, সংযুক্ত নয়';

  @override
  String get nPermissionDenied => 'অনুমতি দেওয়া হয়নি';

  @override
  String get nPhotoBad => 'ঝাপসা বা ত্রুটিপূর্ণ ছবি';

  @override
  String get nPhotoOk => 'প্রিভিউ ও ছবি সঠিকভাবে কাজ করে';

  @override
  String get nRecognised => 'শনাক্ত হয়েছে';

  @override
  String get nSensorNoResponse => 'সেন্সর সাড়া দেয়নি';

  @override
  String get nSensorResponds => 'নড়াচড়ায় সাড়া দেয়';

  @override
  String get nSmooth => 'রঙের পরিবর্তন মসৃণ';

  @override
  String get nStorageError => 'পরীক্ষামূলক ফাইল লেখা যায়নি';

  @override
  String get nStorageMismatch => 'পড়া ডেটা লেখা ডেটার সাথে মেলেনি';

  @override
  String get nToneHeard => 'শব্দ শোনা গেছে';

  @override
  String get nToneNotHeard => 'শব্দ শোনা যায়নি';

  @override
  String get nVeryQuiet => 'শব্দ খুবই ক্ষীণ';

  @override
  String get nVibrationBad => 'কোনো কম্পন অনুভূত হয়নি';

  @override
  String get nVibrationOk => 'কম্পন অনুভূত হয়েছে';

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
  String get pastCheckups => 'আগের পরীক্ষাসমূহ';

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
  String get qBanding => 'রংগুলো কি ডোরা ছাড়াই মসৃণভাবে পরিবর্তিত হচ্ছে?';

  @override
  String get qBrightness => 'স্ক্রিনের উজ্জ্বলতা কি কমেছে ও বেড়েছে?';

  @override
  String get qBurnIn =>
      'স্ট্যাটাস বার বা কিবোর্ডের মতো কোনো হালকা আকৃতি কি স্থায়ীভাবে দেখা যাচ্ছে?';

  @override
  String get qDeadPixels => 'কোনো বিন্দু কি কালো, সাদা বা ভিন্ন রঙে স্থির ছিল?';

  @override
  String get qFeltVibration => 'কম্পন কি অনুভব করেছেন?';

  @override
  String get qFlashOn => 'ফ্ল্যাশলাইট কি জ্বলছে?';

  @override
  String get qHeardTone => 'শব্দটি কি পরিষ্কার শুনেছেন?';

  @override
  String get qHeardVoice => 'নিজের কণ্ঠ কি পরিষ্কার শুনেছেন?';

  @override
  String get qPhotoClear => 'ছবিটি কি স্পষ্ট ও সঠিকভাবে ফোকাস করা?';

  @override
  String get record3s => '৩ সেকেন্ড রেকর্ড করুন';

  @override
  String get recordAgain => 'আবার রেকর্ড করুন';

  @override
  String get recording => 'রেকর্ড হচ্ছে… এখন কথা বলুন';

  @override
  String get reportDisclaimer =>
      'এই ফোনে SystemX দ্বারা প্রস্তুত। ইন্টারেক্টিভ পরীক্ষার ফলাফল পরীক্ষার সময় দেওয়া উত্তরের ওপর ভিত্তি করে।';

  @override
  String get reportGreat => 'আপনার ফোন চমৎকার অবস্থায় আছে';

  @override
  String get reportNeedsWork => 'কিছু অংশে মনোযোগ প্রয়োজন';

  @override
  String get reportNotSaved => 'সংরক্ষিত হয়নি';

  @override
  String get reportOk => 'সামগ্রিকভাবে ভালো, তবে কিছু সমস্যা আছে';

  @override
  String get reportPhone => 'ফোন';

  @override
  String get reportResults => 'ফলাফল';

  @override
  String get reportSaved => 'প্রতিবেদন সংরক্ষিত হয়েছে';

  @override
  String get reportShareSubject => 'SystemX পরীক্ষার প্রতিবেদন';

  @override
  String get reportTitle => 'পরীক্ষার প্রতিবেদন';

  @override
  String get retake => 'আবার তুলুন';

  @override
  String get savePdf => 'PDF সংরক্ষণ করুন';

  @override
  String get sensorNotResponding => 'সেন্সর সাড়া দিচ্ছে না';

  @override
  String get shareReport => 'প্রতিবেদন শেয়ার করুন';

  @override
  String get showAgain => 'আবার দেখান';

  @override
  String get skip => 'এড়িয়ে যান';

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
  String get statusPassed => 'উত্তীর্ণ';

  @override
  String get statusSkipped => 'বাদ দেওয়া হয়েছে';

  @override
  String get stop => 'থামান';

  @override
  String get stopCheckupBody =>
      'এ পর্যন্ত পাওয়া ফলাফল একটি প্রতিবেদনে সংরক্ষিত থাকবে।';

  @override
  String get stopCheckupTitle => 'পরীক্ষা বন্ধ করবেন?';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get tapToContinue => 'চালিয়ে যেতে ট্যাপ করুন';

  @override
  String get testAgain => 'আবার পরীক্ষা করুন';

  @override
  String get testingAutomatically => 'পরীক্ষা চলছে…';

  @override
  String get touchEveryZone => 'প্রতিটি ঘর স্পর্শ করুন';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get vibrateAgain => 'আবার কম্পন দিন';

  @override
  String get waitingForCharger => 'চার্জারের জন্য অপেক্ষা করা হচ্ছে';

  @override
  String get waitingToConnect => 'সংযোগের জন্য অপেক্ষা করা হচ্ছে';

  @override
  String gpsSatellites(int seen, int used) {
    return '$seenটি স্যাটেলাইট শনাক্ত · $usedটি ব্যবহৃত';
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
    return 'অবস্থান নির্ণীত · $usedটি স্যাটেলাইট · ±$accuracy মি';
  }

  @override
  String nGpsNoFix(int seen) {
    return '$seenটি স্যাটেলাইট শনাক্ত হয়েছে, তবে এখনো অবস্থান নির্ণয় হয়নি। খোলা জায়গায় চেষ্টা করুন।';
  }

  @override
  String nImplausible(String value) {
    return 'অস্বাভাবিক মান: $value';
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
    return 'লেখার গতি $write MB/s · পড়ার গতি $read MB/s';
  }

  @override
  String nTouches(int count) {
    return 'একসাথে সর্বোচ্চ $countটি স্পর্শ';
  }

  @override
  String passedOf(int passed, int total) {
    return '$totalটির মধ্যে $passedটি উত্তীর্ণ';
  }

  @override
  String progressOf(int done, int total) {
    return '$totalটির মধ্যে $doneটি';
  }

  @override
  String reportCounts(int passed, int failed, int skipped) {
    return '$passedটি উত্তীর্ণ · $failedটি ব্যর্থ · $skippedটি বাদ';
  }

  @override
  String secondsElapsed(int seconds) {
    return '$seconds সে.';
  }

  @override
  String get nDetected => 'পাওয়া গেছে';

  @override
  String get nNoVibrator => 'কম্পন মোটর নেই';

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
    return 'সর্বশেষ পরীক্ষা $ago · $totalটির মধ্যে $passedটি উত্তীর্ণ';
  }

  @override
  String get alertsTitle => 'সতর্কবার্তা ও তাৎক্ষণিক অবস্থা';

  @override
  String get alertsRowSub =>
      'চার্জ অ্যালার্ম, ব্যাটারি ও স্টোরেজের সতর্কবার্তা, তাৎক্ষণিক বিজ্ঞপ্তি';

  @override
  String get alertsUnavailable => 'এই ফোনে সতর্কবার্তা সুবিধা উপলব্ধ নয়।';

  @override
  String get alertsIntro =>
      'আপনি চালু না করা পর্যন্ত এখানকার সবকিছু বন্ধ থাকবে। প্রতিটি ধরনের জন্য আলাদা বিজ্ঞপ্তি চ্যানেল রয়েছে, তাই অ্যান্ড্রয়েড সেটিংস থেকেও এগুলো নীরব করতে পারবেন।';

  @override
  String get secLiveStatus => 'তাৎক্ষণিক অবস্থা';

  @override
  String get secBatteryAlerts => 'ব্যাটারি';

  @override
  String get secStorageAlerts => 'স্টোরেজ';

  @override
  String get secSummaries => 'সারাংশ ও অনুস্মারক';

  @override
  String get secAlerts => 'সতর্কবার্তা';

  @override
  String get liveStatus => 'তাৎক্ষণিক অবস্থার বিজ্ঞপ্তি';

  @override
  String get liveStatusSub =>
      'ব্যাটারি, তাপমাত্রা, বিদ্যুৎ, নেটওয়ার্ক ও র‍্যামের তাৎক্ষণিক তথ্যসহ একটি স্থায়ী বিজ্ঞপ্তি।';

  @override
  String get statusBarShows => 'স্ট্যাটাস বারের আইকন';

  @override
  String get chargeAlarm => 'চার্জ অ্যালার্ম';

  @override
  String get notifyAt => 'কখন জানানো হবে';

  @override
  String get chargingDone => 'চার্জ সম্পন্ন';

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
      'প্রতি সপ্তাহে চার্জের সংখ্যা, সর্বোচ্চ তাপমাত্রা ও সর্বনিম্ন চার্জের মাত্রা';

  @override
  String get checkupReminder => 'মাসিক পরীক্ষার অনুস্মারক';

  @override
  String get checkupReminderSub => 'সর্বশেষ পরীক্ষার এক মাস পূর্ণ হলে';

  @override
  String get alertsFootnote =>
      'তাৎক্ষণিক অবস্থা বন্ধ থাকলে SystemX প্রতি ১৫ মিনিটে এবং চার্জের সময় প্রতি ২ মিনিটে তথ্য যাচাই করে। ইতিহাস এই ফোনে ৮ দিন সংরক্ষিত থাকে।';

  @override
  String get notificationsNeeded =>
      'SystemX-এর বিজ্ঞপ্তি বন্ধ রয়েছে, তাই এটি চালু করা যাচ্ছে না।';

  @override
  String get permNotifTitle => 'বিজ্ঞপ্তির অনুমতি দিন';

  @override
  String get permNotifReason =>
      'এখানে আপনি যে সতর্কবার্তাগুলো চালু করবেন, SystemX শুধু সেগুলোই জানাবে এবং আপনি চালু করলে তাৎক্ষণিক অবস্থা দেখাবে।';

  @override
  String get history => 'ইতিহাস';

  @override
  String get range24h => '২৪ ঘণ্টা';

  @override
  String get range7d => '৭ দিন';

  @override
  String get historyEmpty =>
      'ইতিহাস ব্যাকগ্রাউন্ডে সংগৃহীত হয়। এক ঘণ্টা পর আবার দেখুন।';

  @override
  String get chargingSessions => 'চার্জিংয়ের বিবরণ';

  @override
  String get chargingSessionsSub => 'প্রতিটি চার্জের গতি ও তাপমাত্রা';

  @override
  String get sessionsEmpty =>
      'এখনো কোনো চার্জ রেকর্ড করা হয়নি। শুরু করতে ফোন চার্জে দিন।';

  @override
  String get clearHistory => 'সব ইতিহাস মুছুন';

  @override
  String get clearHistorySub =>
      'ব্যাটারির ইতিহাস, চার্জিংয়ের বিবরণ ও পরীক্ষার ফলাফল';

  @override
  String get clearHistoryConfirm =>
      'এতে এই ফোন থেকে ব্যাটারির ইতিহাস, চার্জিংয়ের বিবরণ ও সকল পরীক্ষার ফলাফল মুছে যাবে। সেটিংস অপরিবর্তিত থাকবে।';

  @override
  String get clear => 'মুছুন';

  @override
  String get historyCleared => 'ইতিহাস মোছা হয়েছে';

  @override
  String chargeAlarmSub(int level) {
    return 'ব্যাটারি $level% হলে জানানো হবে';
  }

  @override
  String batteryLowSub(int level) {
    return 'চার্জে না থাকলে $level%-এ জানানো হবে';
  }

  @override
  String batteryHotSub(String temp) {
    return '$temp-এ জানানো হবে';
  }

  @override
  String storageAlertSub(int percent) {
    return 'স্টোরেজ $percent% পূর্ণ হলে জানানো হবে';
  }

  @override
  String historyNote(int count) {
    return '$countটি মান, ব্যাকগ্রাউন্ডে প্রতি ১৫ মিনিটে সংগৃহীত';
  }

  @override
  String get wifiMeter => 'Wi-Fi সিগন্যাল মিটার';

  @override
  String get wifiMeterOff => 'সিগন্যাল পরিমাপ করতে Wi-Fi-তে সংযুক্ত হন।';

  @override
  String get wifiMeterHint =>
      'ধীরে ধীরে হাঁটুন। সিগন্যাল যত শক্তিশালী হবে, বৃত্তটি তত পূর্ণ হবে; এভাবে কাজের বা রাউটার রাখার সবচেয়ে উপযুক্ত জায়গা খুঁজে পাবেন।';

  @override
  String get bestHere => 'এখন পর্যন্ত সেরা';

  @override
  String healthScoreSpoken(int score, String word) {
    return 'স্বাস্থ্য স্কোর ১০০-এর মধ্যে $score, $word';
  }

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

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
  String get codeEmergency => 'জরুরি ব্যালেন্স';

  @override
  String get codeCare => 'গ্রাহকসেবা';

  @override
  String codeButton(String label, String code) {
    return '$label · $code';
  }

  @override
  String get specDeviceName => 'ডিভাইসের নাম';

  @override
  String get specOemSkin => 'নির্মাতার ইন্টারফেস';

  @override
  String get specLaunchedWith => 'বাজারে আসার সময়ের সংস্করণ';

  @override
  String get specHwRevision => 'হার্ডওয়্যার সংস্করণ';

  @override
  String get secSales => 'বিক্রয় অঞ্চল';

  @override
  String get specSalesCode => 'বিক্রয় কোড';

  @override
  String get salesCodeHint => 'অঞ্চলভিত্তিক বিল্ড কোড (Samsung ফোনে CSC)';

  @override
  String get specSalesCountry => 'বিক্রয়ের দেশ';

  @override
  String get specSalesRegion => 'অঞ্চল';

  @override
  String get specProductLocale => 'পূর্বনির্ধারিত ভাষা';

  @override
  String get secIdentifiers => 'শনাক্তকারী';

  @override
  String get specAndroidId => 'অ্যান্ড্রয়েড আইডি';

  @override
  String get androidIdHint =>
      'এই ফোন ও অ্যাপের জন্য স্বতন্ত্র। ফ্যাক্টরি রিসেটের পর পরিবর্তিত হয়।';

  @override
  String get specImei => 'IMEI ও সিরিয়াল নম্বর';

  @override
  String get imeiHint =>
      'অ্যান্ড্রয়েড ১০ ও পরবর্তী সংস্করণে এগুলো শুধু ফোনের নিজস্ব অ্যাপ দেখতে পারে। *#06# ডায়াল করতে ট্যাপ করুন।';

  @override
  String get specWarranty => 'Knox ওয়ারেন্টি';

  @override
  String get warrantyIntact => 'অক্ষত (0x0)';

  @override
  String get warrantyVoid => 'বাতিল (0x1)';

  @override
  String get warrantyHint =>
      'কখনো অনানুষ্ঠানিক সফটওয়্যার ইনস্টল করা হলে এটি স্থায়ীভাবে চিহ্নিত হয়ে যায়';

  @override
  String get specCycleCountTracked => 'চার্জ চক্র (আনুমানিক)';

  @override
  String cycleTrackedHint(String date) {
    return '$date থেকে চার্জিং পর্যবেক্ষণ করে SystemX গণনা করেছে। এই ফোন ব্যাটারির নিজস্ব হিসাব জানায় না।';
  }

  @override
  String get specSensorTotal => 'মোট সেন্সর';

  @override
  String get specSensorKinds => 'সেন্সরের ধরন';

  @override
  String get specSensorWakeUp => 'জাগ্রতকারী সেন্সর';

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
  String get appsEntryBody => 'প্রতিটি অ্যাপের আকার ও ক্যাশ';

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
  String get appsTotalSize => 'মোট আকার';

  @override
  String get appsCacheTotal => 'ক্যাশ';

  @override
  String get appsUsageTitle => 'অ্যাপের আকার দেখুন';

  @override
  String get appsUsageBody =>
      'ব্যবহারের তথ্যে প্রবেশাধিকার (Usage access) দিলে SystemX জানতে পারবে প্রতিটি অ্যাপ ও তার ক্যাশ কতটুকু জায়গা ব্যবহার করছে। কোনো তথ্য ফোনের বাইরে যায় না।';

  @override
  String get appsUsageButton => 'ব্যবহারের তথ্যে প্রবেশাধিকার দিন';

  @override
  String get appsCacheTitle => 'ক্যাশ পরিষ্কার করা';

  @override
  String get appsCacheBody =>
      'অ্যান্ড্রয়েড কোনো অ্যাপকে অন্য অ্যাপের ক্যাশ মুছতে দেয় না। একটি অ্যাপে ট্যাপ করুন, এরপর স্টোরেজ, তারপর ক্যাশ মুছুন। ফোনের স্টোরেজ ম্যানেজার থেকেও এক জায়গায় জায়গা খালি করা যায়।';

  @override
  String get appsFreeUp => 'জায়গা খালি করুন';

  @override
  String get appsSortSize => 'আকার';

  @override
  String get appsSortCache => 'ক্যাশ';

  @override
  String get appsSortName => 'নাম';

  @override
  String get appsSortRecent => 'হালনাগাদ';

  @override
  String get appsShowSystem => 'সিস্টেম অ্যাপ';

  @override
  String appsSizeLine(String size, String cache) {
    return '$size · ক্যাশ $cache';
  }

  @override
  String get appsSearch => 'অ্যাপ খুঁজুন';

  @override
  String get appsEmpty => 'কোনো অ্যাপ পাওয়া যায়নি';

  @override
  String get bhTitle => 'ব্যাটারির স্বাস্থ্য';

  @override
  String get bhEntry => 'ব্যাটারির স্বাস্থ্য';

  @override
  String get bhEntryBody => 'পরিমাপকৃত ধারণক্ষমতা ও ঘণ্টাপ্রতি খরচ';

  @override
  String bhBasedOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পরিমাপকৃত চার্জের ভিত্তিতে',
    );
    return '$_temp0';
  }

  @override
  String get bhNotYet =>
      'এখনো পরিমাপ করা হয়নি। SystemX-এর ব্যাকগ্রাউন্ড সুবিধা চালু থাকা অবস্থায় প্রতিবার ১৫% বা তার বেশি চার্জ দিলে একটি পরিমাপ নেওয়া হয়।';

  @override
  String get bhNoCounter =>
      'এই ফোন ব্যাটারির চার্জ কাউন্টারের তথ্য দেয় না, তাই ধারণক্ষমতা পরিমাপ করা সম্ভব নয়।';

  @override
  String get bhTrend => 'প্রতি চার্জে পরিমাপকৃত ধারণক্ষমতা';

  @override
  String get bhDrain => 'ঘণ্টাপ্রতি খরচ (গত ৭ দিন)';

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
    return '$hours ঘণ্টা পরিমাপ করা হয়েছে';
  }

  @override
  String get bhCollecting => 'তথ্য সংগ্রহ করা হচ্ছে';

  @override
  String get bhDrainNote =>
      'SystemX-এর ব্যাকগ্রাউন্ড পরিমাপ থেকে প্রাপ্ত অনুমান; অবশিষ্ট ব্যাটারি কতক্ষণ চলবে তার পূর্বাভাস নয়। প্রতিটির ক্ষেত্রে ৩ ঘণ্টার বেশি তথ্য থাকলে অধিক নির্ভরযোগ্য হয়; তাৎক্ষণিক অবস্থা চালু থাকলে পরিমাপ আরও ঘন ঘন নেওয়া হয়।';

  @override
  String get bhHow =>
      'যেভাবে কাজ করে: ১৫% বা তার বেশি প্রতিটি চার্জ ব্যাটারির নিজস্ব চার্জ কাউন্টার দিয়ে পরিমাপ করা হয় (প্রবেশ করা চার্জ ÷ বৃদ্ধি পাওয়া শতাংশ)। সর্বশেষ ৫টি পরিমাপের মধ্যমানই হলো অনুমিত মান। এটি একটি অনুমান, হার্ডওয়্যার পরীক্ষা নয়: তাপ, দ্রুত চার্জিং ও ফোনের ক্যালিব্রেশনের কারণে কয়েক শতাংশ কমবেশি হতে পারে।';

  @override
  String get toolsTitle => 'সরঞ্জাম';

  @override
  String get stTitle => 'সিপিইউ চাপ পরীক্ষা';

  @override
  String get stEntryBody => 'গরম হলে কি গতি কমে যায়?';

  @override
  String get stIntro =>
      'প্রসেসরের সব কোর পূর্ণ গতিতে চালিয়ে দেখা হয়, ফোন গরম হওয়ার সাথে সাথে কার্যক্ষমতা বজায় থাকে কি না।';

  @override
  String get stSafety =>
      'ফোনটি গরম হবে। ব্যাটারি ৪৫ °C-এ পৌঁছালে, অ্যান্ড্রয়েড তীব্র তাপ শনাক্ত করলে, ব্যাটারি ১৫%-এর নিচে নামলে অথবা আপনি এই স্ক্রিন ছেড়ে গেলে পরীক্ষাটি স্বয়ংক্রিয়ভাবে বন্ধ হবে। যেকোনো সময় আপনি নিজেও বন্ধ করতে পারবেন।';

  @override
  String stMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট',
    );
    return '$_temp0';
  }

  @override
  String get stStart => 'পরীক্ষা শুরু করুন';

  @override
  String get stAgain => 'আবার চালান';

  @override
  String get stStop => 'থামান';

  @override
  String get stRefusedHot =>
      'ফোনটি ইতোমধ্যে গরম। কয়েক মিনিট ঠান্ডা হতে দিন, তারপর আবার চেষ্টা করুন।';

  @override
  String get stRefusedBattery =>
      'ব্যাটারি ২০%-এর নিচে। চার্জার সংযুক্ত করুন অথবা আগে চার্জ দিন।';

  @override
  String stRunning(int seconds) {
    return 'চলছে · আর $seconds সেকেন্ড বাকি';
  }

  @override
  String get stPerformance => 'কার্যক্ষমতা';

  @override
  String get stPerfAxis => 'কার্যক্ষমতা (শুরু = ১০০%)';

  @override
  String get stTempAxis => 'ব্যাটারির তাপমাত্রা';

  @override
  String get stSteady => 'চাপের মধ্যেও গতি বজায় থাকে';

  @override
  String get stSteadyBody => 'ফোন গরম হওয়ার সময়ও কার্যক্ষমতা স্থির ছিল।';

  @override
  String get stSlight => 'গরম হলে গতি সামান্য কমে';

  @override
  String get stSlightBody =>
      'তাপ নিয়ন্ত্রণে রাখতে ফোনটি গতি কিছুটা কমিয়েছে। অধিকাংশ ফোনে এটি স্বাভাবিক।';

  @override
  String get stThrottles => 'গরম হলে গতি অনেক কমে যায়';

  @override
  String get stThrottlesBody =>
      'গরম হওয়ার সাথে সাথে কার্যক্ষমতা উল্লেখযোগ্যভাবে কমে গেছে। দীর্ঘ সময় গেম খেলা বা ভিডিও কলে ধীরগতি দেখা দিতে পারে, বিশেষত কভার লাগানো থাকলে বা চার্জের সময়।';

  @override
  String get stTooShort => 'যথেষ্ট তথ্য নেই';

  @override
  String get stTooShortBody =>
      'ফলাফল দিতে পরীক্ষাটি অন্তত ৩০ সেকেন্ড চলা প্রয়োজন।';

  @override
  String get stStoppedHot =>
      'ফোনের সুরক্ষায় আগেই বন্ধ করা হয়েছে: অতিরিক্ত গরম হয়ে গিয়েছিল।';

  @override
  String get stStoppedBattery => 'আগেই বন্ধ করা হয়েছে: ব্যাটারি কম।';

  @override
  String get stStoppedLeft => 'অ্যাপটি ব্যাকগ্রাউন্ডে যাওয়ায় বন্ধ হয়েছে।';

  @override
  String get stStoppedError => 'বন্ধ হয়েছে: পরিমাপ পাওয়া যায়নি।';

  @override
  String get stRetained => 'শেষে কার্যক্ষমতা';

  @override
  String get stBatteryTemp => 'ব্যাটারির তাপমাত্রা';

  @override
  String get stCpuPeak => 'প্রসেসরের সর্বোচ্চ তাপমাত্রা';

  @override
  String get stDuration => 'সময়কাল';

  @override
  String stSeconds(int seconds) {
    return '$seconds সেকেন্ড';
  }

  @override
  String get rrTitle => 'রিফ্রেশ রেট পরীক্ষা';

  @override
  String get rrEntryBody => 'স্ক্রিন প্রকৃতপক্ষে কতটা মসৃণভাবে হালনাগাদ হয়';

  @override
  String get rrIntro =>
      'বারটি চলার সময় স্ক্রিন প্রতি সেকেন্ডে কতবার হালনাগাদ হয় তা গণনা করে। SystemX প্রথমে ডিসপ্লের সর্বোচ্চ গতির মোড চালু করার অনুরোধ করে।';

  @override
  String get rrStart => 'পরিমাপ করুন';

  @override
  String get rrMeasuring => 'পরিমাপ করা হচ্ছে…';

  @override
  String get rrMeasured => 'পরিমাপকৃত রিফ্রেশ রেট';

  @override
  String get rrMatches => 'ডিসপ্লের সমর্থিত মানের সাথে মিলেছে।';

  @override
  String rrLower(String max) {
    return 'ডিসপ্লের সমর্থিত $max Hz-এর চেয়ে কম। ব্যাটারি সেভার, অ্যাডাপ্টিভ রিফ্রেশ বা ফোনের সেটিংস এটি সীমিত করে থাকতে পারে।';
  }

  @override
  String get rrReported => 'ডিসপ্লের জানানো সর্বোচ্চ রেট';

  @override
  String get trTitle => 'স্পর্শ সাড়ার পরীক্ষা';

  @override
  String get trEntryBody => 'স্পর্শের অবস্থান কত ঘন ঘন অ্যাপে পৌঁছায়';

  @override
  String get trIntro => 'আঙুল না তুলে নিচের ঘরের মধ্যে আঙুল ঘোরান।';

  @override
  String get trDraw => 'এখানে আঁকুন';

  @override
  String get trNow => 'স্পর্শের হার';

  @override
  String get trBest => 'সর্বোচ্চ';

  @override
  String get trNote =>
      'এটি সেই হার, যে হারে অ্যাপ স্পর্শের অবস্থান পায়। ফোনের বিজ্ঞাপনে উল্লিখিত \"টাচ স্যাম্পলিং রেট\" এর চেয়ে বেশি হতে পারে, কারণ এর একটি অংশ অ্যান্ড্রয়েডের ভেতরেই ব্যবহৃত হয়।';

  @override
  String get upTitle => 'ব্যবহৃত ফোন যাচাই';

  @override
  String get upEntryBody => 'কেনার আগে ফোন যাচাই করুন';

  @override
  String get upIntro =>
      'কেনার আগে ব্যবহৃত ফোন মূল্যায়নে এই যাচাই সহায়তা করে। এটি সফটওয়্যারের অখণ্ডতা ও ব্যাটারির অবস্থা পর্যালোচনা করে, হার্ডওয়্যার পরীক্ষায় ধাপে ধাপে নির্দেশনা দেয় এবং বিক্রেতার সাথে যে বিষয়গুলো নিশ্চিত করা প্রয়োজন তার তালিকা দেয়।';

  @override
  String get upHardwareTitle => 'হার্ডওয়্যার পরীক্ষা';

  @override
  String get upHardwareNone =>
      'স্ক্রিন, স্পর্শ, স্পিকার, মাইক্রোফোন, ক্যামেরা, সেন্সর, সংযোগ ও চার্জিং পরীক্ষা করে। প্রায় ৬ মিনিট সময় লাগে; প্রতিটি ধাপ ব্যাখ্যা করা হয়।';

  @override
  String get upRunCheckup => 'হার্ডওয়্যার পরীক্ষা শুরু করুন';

  @override
  String get upRunAgain => 'আবার চালান';

  @override
  String get upResults => 'ফলাফল';

  @override
  String get upGroupSoftware => 'সফটওয়্যার';

  @override
  String get upGroupBattery => 'ব্যাটারি';

  @override
  String get upGroupHardware => 'হার্ডওয়্যার';

  @override
  String get upClean => 'কোনো সমস্যা পাওয়া যায়নি';

  @override
  String get upCleanBody =>
      'সকল যাচাইয়ে উত্তীর্ণ। মূল্য পরিশোধের আগে ক্রেতার যাচাই-তালিকা সম্পূর্ণ করুন।';

  @override
  String get upCheckFirst => 'কেনার আগে এগুলো যাচাই করুন';

  @override
  String get upCheckFirstBody =>
      'কোনো ত্রুটি পাওয়া যায়নি, তবে কেনার আগে কয়েকটি বিষয় আরও ভালোভাবে দেখে নেওয়া উচিত।';

  @override
  String get upProblems => 'সমস্যা পাওয়া গেছে';

  @override
  String get upProblemsBody =>
      'এক বা একাধিক যাচাইয়ে ত্রুটি পাওয়া গেছে। নিচের প্রতিটি বিষয় পর্যালোচনা করুন এবং বিক্রেতার সাথে আলোচনা করুন।';

  @override
  String get upIncomplete => 'সম্পূর্ণ করতে হার্ডওয়্যার পরীক্ষা চালান';

  @override
  String get upIncompleteBody =>
      'সফটওয়্যার ও ব্যাটারি যাচাই সম্পন্ন হয়েছে। স্ক্রিন, স্পিকার, ক্যামেরা, সেন্সরসহ অন্যান্য অংশ পরীক্ষা করতে হার্ডওয়্যার পরীক্ষা চালান।';

  @override
  String get upStorage => 'স্টোরেজ';

  @override
  String get upRam => 'র‍্যাম';

  @override
  String get upRegion => 'বিক্রয় অঞ্চল';

  @override
  String get upRoot => 'রুট অ্যাক্সেস';

  @override
  String get upRootOk => 'শনাক্ত হয়নি';

  @override
  String get upRootBad =>
      'শনাক্ত হয়েছে: সিস্টেম পরিবর্তন করা হয়েছে। ব্যাংকিং অ্যাপ কাজ না-ও করতে পারে এবং আপডেট ব্যর্থ হতে পারে।';

  @override
  String get upBootloader => 'বুটলোডার';

  @override
  String get upBootloaderOk => 'লক করা (কারখানা থেকে যেমন এসেছে)';

  @override
  String get upBootloaderBad =>
      'আনলক করা: অনানুষ্ঠানিক সফটওয়্যার ইনস্টল করা সম্ভব। কারণ জানতে চান।';

  @override
  String get upVerifiedBoot => 'যাচাইকৃত বুট (Verified boot)';

  @override
  String get upVerifiedBootOk => 'সবুজ: সফটওয়্যারটি নির্মাতার নিজস্ব';

  @override
  String upVerifiedBootBad(String state) {
    return '$state: সফটওয়্যার পুরোপুরি নির্মাতার নিজস্ব নয়';
  }

  @override
  String get upKnoxOk => 'অক্ষত (0x0)';

  @override
  String get upKnoxBad =>
      'চিহ্নিত (0x1): কোনো এক সময় অনানুষ্ঠানিক সফটওয়্যার ইনস্টল করা হয়েছিল। Samsung Pay ও Secure Folder কাজ করবে না।';

  @override
  String get upHealthOk => 'ভালো';

  @override
  String get upHealthBad => 'অ্যান্ড্রয়েড ব্যাটারিতে ত্রুটি জানাচ্ছে';

  @override
  String upCapacity(int pct) {
    return 'মূল ধারণক্ষমতার প্রায় $pct%';
  }

  @override
  String get upTests => 'হার্ডওয়্যার পরীক্ষা';

  @override
  String get upCertificate => 'প্রতিবেদন তৈরি করুন (PDF)';

  @override
  String get upCertTitle => 'Used phone report';

  @override
  String get upCertNote =>
      'This report was generated on the device by SystemX and reflects its condition at the time shown. Results are based on information reported by the phone\'s software and on tests performed by the user. SystemX cannot detect every fault or verify ownership, network lock, IMEI blacklist status, water damage, internal repairs or replaced parts, and accepts no responsibility for purchase decisions.';

  @override
  String get copyAll => 'সকল স্পেসিফিকেশন কপি করুন';

  @override
  String get copiedAll => 'সকল স্পেসিফিকেশন কপি করা হয়েছে';

  @override
  String get upDisclaimerTitle => 'এই মূল্যায়ন সম্পর্কে';

  @override
  String get upDisclaimer =>
      'ফলাফল ফোনের সফটওয়্যার থেকে প্রাপ্ত তথ্য এবং আপনার সম্পন্ন করা পরীক্ষার ওপর ভিত্তি করে তৈরি। SystemX সকল ত্রুটি শনাক্ত করতে পারে না এবং মালিকানা, নেটওয়ার্ক লক, IMEI কালো তালিকাভুক্তি, পানিতে ক্ষতি, অভ্যন্তরীণ মেরামত বা পরিবর্তিত যন্ত্রাংশ যাচাই করতে পারে না। সরাসরি পরিদর্শনের পাশাপাশি এটি ব্যবহার করুন। ক্রয়ের সিদ্ধান্তের জন্য SystemX দায়ী নয়।';

  @override
  String get upStepDevice => 'ডিভাইস যাচাই';

  @override
  String get upStepHardware => 'হার্ডওয়্যার পরীক্ষা';

  @override
  String get upStepChecklist => 'ক্রেতার যাচাই-তালিকা';

  @override
  String upChecksPassed(int passed, int total) {
    return '$totalটির মধ্যে $passedটি যাচাইয়ে উত্তীর্ণ';
  }

  @override
  String get upAllClear => 'সব ঠিক আছে';

  @override
  String upIssues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সমস্যা',
    );
    return '$_temp0';
  }

  @override
  String upToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পর্যালোচনা প্রয়োজন',
    );
    return '$_temp0';
  }

  @override
  String get upNotRun => 'এখনো চালানো হয়নি';

  @override
  String upHardwareDoneAt(String time, int passed, int total) {
    return '$time-এ সম্পন্ন · $totalটির মধ্যে $passedটি উত্তীর্ণ';
  }

  @override
  String get upIdentityTitle => 'ডিভাইসের পরিচয়';

  @override
  String get upIdentityBody =>
      'এই তথ্যগুলো বিজ্ঞাপন ও বাক্সের তথ্যের সাথে মিলিয়ে নিন। এগুলো সরাসরি ফোন থেকে নেওয়া।';

  @override
  String get upChecklistTitle => 'ক্রেতার যাচাই-তালিকা';

  @override
  String get upChecklistBody =>
      'মূল্য পরিশোধের আগে এই বিষয়গুলো সরাসরি নিশ্চিত করুন। টিক দেওয়া বিষয়গুলো প্রতিবেদনে অন্তর্ভুক্ত হবে।';

  @override
  String upChecklistProgress(int done, int total) {
    return '$totalটির মধ্যে $doneটি নিশ্চিত';
  }

  @override
  String get bcImei => 'IMEI বাক্সের সাথে মেলে';

  @override
  String get bcImeiBody =>
      '*#06# ডায়াল করে নম্বরটি বাক্স ও রসিদের সাথে মিলিয়ে দেখুন।';

  @override
  String get bcAccounts => 'বিক্রেতার অ্যাকাউন্ট সরানো হয়েছে';

  @override
  String get bcAccountsBody =>
      'Google ও Samsung অ্যাকাউন্ট থেকে সাইন আউট করা হয়েছে এবং Find My Device বন্ধ আছে; অন্যথায় রিসেটের পর ফোনটি লক হয়ে যেতে পারে।';

  @override
  String get bcBody => 'কোনো বাহ্যিক ক্ষতি নেই';

  @override
  String get bcBodyBody =>
      'ফ্রেম, স্ক্রিন, পেছনের কাচ, ক্যামেরার লেন্স, বোতাম, পোর্ট ও সিম ট্রেতে ফাটল, টোল বা খোলার চিহ্ন আছে কি না দেখুন।';

  @override
  String get bcSim => 'আপনার সিমে কাজ করে';

  @override
  String get bcSimBody =>
      'আপনার সিম কার্ড প্রবেশ করিয়ে একটি সংক্ষিপ্ত কল করুন এবং মোবাইল ডেটা সংযুক্ত হয় কি না দেখুন।';

  @override
  String get bcCharger => 'আপনার চার্জারে চার্জ হয়';

  @override
  String get bcChargerBody =>
      'নিজের চার্জার ও কেবল সংযুক্ত করুন; কয়েক সেকেন্ডের মধ্যে ফোনে চার্জ হচ্ছে দেখানোর কথা।';

  @override
  String get bcPaperwork => 'বাক্স ও রসিদ প্রদান করা হয়েছে';

  @override
  String get bcPaperworkBody =>
      'আসল বাক্স ও রসিদ ফোনটির বৈধ মালিকানা প্রমাণে সহায়তা করে এবং ওয়ারেন্টির আওতায় মেরামতের জন্য প্রয়োজন হতে পারে।';

  @override
  String get bcReset => 'কেনার পর ফ্যাক্টরি রিসেট';

  @override
  String get bcResetBody =>
      'মূল্য পরিশোধের পর নিজে ফোনটি রিসেট করুন, যাতে আগের কোনো তথ্য বা অ্যাকাউন্ট না থাকে।';

  @override
  String get bcActionImei => 'IMEI দেখুন';

  @override
  String get bcActionAccounts => 'অ্যাকাউন্ট খুলুন';

  @override
  String get upCertChecklist => 'Buyer\'s checklist';

  @override
  String get upCertConfirmed => 'Confirmed by buyer';

  @override
  String get upCertNotConfirmed => 'Not confirmed';

  @override
  String get csSummary => 'গত ৩০ দিন';

  @override
  String get csCharges => 'চার্জ';

  @override
  String get csAvgTime => 'গড় সময়কাল';

  @override
  String get csAvgAdded => 'গড়ে যুক্ত চার্জ';

  @override
  String get csAvgSpeed => 'গড় চার্জিং গতি';

  @override
  String get csHottest => 'সর্বোচ্চ তাপমাত্রা';

  @override
  String get csInsights => 'চার্জিংয়ের অভ্যাস';

  @override
  String get csInsightToFull => 'অধিকাংশ চার্জ ১০০% পর্যন্ত দেওয়া হয়';

  @override
  String get csInsightToFullBody =>
      'ব্যাটারি পূর্ণ চার্জ অবস্থায় রাখলে দ্রুত ক্ষয় হয়। ৮০–৮৫%-এ চার্জ বন্ধ করলে ব্যাটারি দীর্ঘস্থায়ী হয়; চার্জ অ্যালার্ম আপনাকে মনে করিয়ে দিতে পারে।';

  @override
  String get csInsightDeep => 'প্রায়ই ১৫%-এর নিচ থেকে চার্জ দেওয়া হয়';

  @override
  String get csInsightDeepBody =>
      'ব্যাটারি প্রায় শূন্যে নামানো ব্যাটারির জন্য ক্ষতিকর। ২০–৩০%-এর মধ্যে চার্জে দেওয়া অধিক উপযোগী।';

  @override
  String get csInsightHot => 'চার্জের সময় ব্যাটারি অতিরিক্ত গরম হয়েছিল';

  @override
  String get csInsightOvernight => 'প্রায়ই সারারাত চার্জ দেওয়া হয়';

  @override
  String get csInsightOvernightBody =>
      'সারারাত চার্জে রাখলে ব্যাটারি দীর্ঘ সময় পূর্ণ অবস্থায় থাকে। ফোনে ব্যাটারি সুরক্ষা বা অ্যাডাপ্টিভ চার্জিং সুবিধা থাকলে তা চালু করুন।';

  @override
  String get csInsightGood => 'আপনার চার্জিংয়ের অভ্যাস ব্যাটারির জন্য উপযোগী';

  @override
  String get csInsightGoodBody =>
      'গত ৩০ দিনে দীর্ঘ সময় পূর্ণ চার্জ, ব্যাটারি প্রায় শূন্যে নামা বা অতিরিক্ত তাপের ঘটনা নেই।';

  @override
  String get csSetAlarm => 'চার্জ অ্যালার্ম সেট করুন';

  @override
  String get csChart => 'প্রতি চার্জে যুক্ত চার্জ';

  @override
  String get csChartLegend =>
      'কোনো বারে ট্যাপ করে সেই চার্জের বিবরণ দেখুন। হলুদ: ব্যাটারি ৪২ °C ছুঁয়েছিল; লাল: ৪৫ °C বা তার বেশি।';

  @override
  String get csToday => 'আজ';

  @override
  String get csYesterday => 'গতকাল';

  @override
  String get csSpeed => 'গতি';

  @override
  String get csPeak => 'সর্বোচ্চ';

  @override
  String get csMaxTemp => 'সর্বোচ্চ তাপমাত্রা';

  @override
  String csMeasured(String mah) {
    return 'পরিমাপকৃত ধারণক্ষমতা $mah mAh';
  }

  @override
  String get csNow => 'এখন';

  @override
  String get csEmptyTitle => 'এখনো কোনো চার্জ রেকর্ড করা হয়নি';

  @override
  String get csEmptyBody =>
      'SystemX-এর ব্যাকগ্রাউন্ড সুবিধা চালু থাকলে চার্জ রেকর্ড করা হয়। ফোন চার্জে দিলে প্রতিটি চার্জ তার গতি ও তাপমাত্রাসহ এখানে দেখা যাবে।';

  @override
  String get csToFull => 'পূর্ণ চার্জ';

  @override
  String get gpsPermissionTitle => 'লোকেশনের অনুমতি প্রয়োজন';

  @override
  String get gpsNeedsPermission =>
      'স্যাটেলাইটের সংকেত গ্রহণ করতে জিপিএস পরীক্ষার জন্য সুনির্দিষ্ট লোকেশনের অনুমতি প্রয়োজন। SystemX আপনার অবস্থান রেকর্ড বা সংরক্ষণ করে না।';

  @override
  String get gpsLocationOffTitle => 'লোকেশন বন্ধ আছে';

  @override
  String get gpsNeedsLocation =>
      'লোকেশন চালু করে ফিরে আসুন। পরীক্ষাটি স্বয়ংক্রিয়ভাবে আবার শুরু হবে।';

  @override
  String get gpsTurnOn => 'লোকেশন চালু করুন';

  @override
  String get onbWelcomeTitle => 'SystemX-এ স্বাগতম';

  @override
  String get onbWelcomeBody =>
      'আপনার পছন্দের ভাষা ও থিম নির্বাচন করুন। দুটোই পরে যেকোনো সময় সেটিংস থেকে পরিবর্তন করতে পারবেন।';

  @override
  String get onbLanguage => 'ভাষা';

  @override
  String get onbAppearance => 'থিম';

  @override
  String get onbUsedTitle => 'আত্মবিশ্বাসের সাথে ব্যবহৃত ফোন কিনুন';

  @override
  String get onbUsedBody =>
      'মূল্য পরিশোধের আগে যেকোনো ব্যবহৃত ফোন যাচাই করুন: হার্ডওয়্যার, ব্যাটারির স্বাস্থ্য ও সফটওয়্যার পরিবর্তনের চিহ্ন, সঙ্গে শেয়ারযোগ্য প্রতিবেদন। আপনি ঠিক কী কিনছেন, তা নিশ্চিতভাবে জানুন।';

  @override
  String get onbAlertsTitle => 'ব্যাটারির প্রতি সজাগ থাকুন';

  @override
  String get onbAlertsBody =>
      'চার্জের সীমা, অতিরিক্ত তাপ ও স্বল্প ব্যাটারির সতর্কবার্তা পান এবং বিজ্ঞপ্তি প্যানেলে তাৎক্ষণিক তথ্য দেখুন। দুটোই ঐচ্ছিক।';

  @override
  String get onbChargeAlarm => '৮০%-এ চার্জ অ্যালার্ম';

  @override
  String get onbLiveStatus => 'বিজ্ঞপ্তি প্যানেলে তাৎক্ষণিক অবস্থা';

  @override
  String get onbArtCharged =>
      '৮০% চার্জ হয়েছে। ব্যাটারির সুরক্ষায় চার্জার খুলে ফেলুন।';

  @override
  String get onbArtWarm => 'ফোন গরম (৪২ °C)। কিছুক্ষণ ভারী অ্যাপ বন্ধ রাখুন।';

  @override
  String get bhEstimatedCapacity => 'আনুমানিক ধারণক্ষমতা';

  @override
  String bhRange(String min, String max) {
    return 'পরিমাপকৃত পরিসর $min থেকে $max mAh';
  }

  @override
  String get bhGood => 'ভালো';

  @override
  String get bhFair => 'মোটামুটি';

  @override
  String get bhPoor => 'ক্ষয়প্রাপ্ত';

  @override
  String get bhInsufficient => 'এখনো যথেষ্ট তথ্য নেই';

  @override
  String get bhConfHigh => 'উচ্চ';

  @override
  String get bhConfMedium => 'মাঝারি';

  @override
  String get bhConfLow => 'কম (পরিমাপে তারতম্য আছে)';

  @override
  String bhCollectingCharges(int count, int needed) {
    return 'তথ্য সংগ্রহ: $neededটির মধ্যে $countটি চার্জ';
  }

  @override
  String get bhDesignCapacity => 'মূল (ডিজাইন) ধারণক্ষমতা';

  @override
  String get bhOfOriginal => 'মূল ধারণক্ষমতার তুলনায়';

  @override
  String get bhOver100 =>
      'স্বাস্থ্য সর্বোচ্চ ১০০% দেখানো হয়। স্বাভাবিক পরিমাপগত তারতম্যের কারণে পরিমাপকৃত ধারণক্ষমতা মূল মানের চেয়ে সামান্য বেশি দেখাতে পারে; এর অর্থ ব্যাটারিটি প্রায় নতুনের মতো।';

  @override
  String get bhConfidence => 'নির্ভরযোগ্যতা';

  @override
  String get bhTrendSub =>
      'প্রতিটি বিন্দু একটি পরিমাপকৃত চার্জ নির্দেশ করে। ড্যাশযুক্ত রেখাটি মূল ধারণক্ষমতা।';

  @override
  String get bhDesignLine => 'মূল';

  @override
  String get bhAndroidHealth => 'অ্যান্ড্রয়েডের জানানো অবস্থা';

  @override
  String get bhAndroidHealthHint =>
      'ব্যাটারির একটি সাধারণ অবস্থা (ভালো, অতিরিক্ত গরম, অকেজো…), শতাংশ নয়';

  @override
  String get bhCyclesCounted => 'SystemX-এর গণনাকৃত চক্র';

  @override
  String bhCyclesCountedHint(String date) {
    return '$date থেকে পূর্ণ চার্জের সমষ্টি। এটি ব্যাটারির আজীবন হিসাব নয়; এই ফোন সেই তথ্য দেয় না।';
  }

  @override
  String get csHourShort => 'ঘ';

  @override
  String get csMinShort => 'মি';

  @override
  String csPerHourLong(int pct) {
    return 'ঘণ্টায় $pct%';
  }

  @override
  String csOfCount(int count, int total) {
    return '$totalটির মধ্যে $countটি';
  }

  @override
  String csBasedOnValid(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি চার্জের',
    );
    return '$minutes মিনিট বা তার বেশি সময়ের $_temp0 ভিত্তিতে।';
  }

  @override
  String csExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি স্বল্পস্থায়ী সংযোগ গণনায় নেওয়া হয়নি।',
    );
    return '$_temp0';
  }

  @override
  String get csSpeedDefinition =>
      'চার্জিংয়ের গতি = মোট যুক্ত চার্জ ÷ মোট চার্জিং সময়।';

  @override
  String csInsightHotBody(String temp, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি চার্জের সময়',
    );
    return '$_temp0 তাপমাত্রা $temp পর্যন্ত উঠেছিল। চার্জের সময় ভারী ব্যবহার এড়িয়ে চলুন, কভার খুলে রাখুন এবং ফোন রোদ থেকে দূরে রাখুন। বারবার এমন হলে অন্য চার্জার ব্যবহার করে দেখুন।';
  }

  @override
  String get csInsightWarm => 'কিছু চার্জের সময় ব্যাটারি গরম হয়েছিল';

  @override
  String csInsightWarmBody(int count, String temp) {
    return '$countটি চার্জে তাপমাত্রা ৪২ °C বা তার বেশি হয়েছিল (সর্বোচ্চ $temp)। দ্রুত চার্জিংয়ে অল্প সময়ের জন্য গরম হওয়া স্বাভাবিক; কভার ছাড়া চার্জ দেওয়া উপকারী।';
  }

  @override
  String get csTempSource =>
      'তাপমাত্রা হলো প্রতিটি চার্জের সময় ব্যাটারি সেন্সরের সর্বোচ্চ মান।';

  @override
  String csChartSub(int count) {
    return 'সর্বশেষ $countটি চার্জ · ব্যাটারিতে যুক্ত শতাংশ';
  }

  @override
  String csShort(int from, int to) {
    return 'স্বল্পস্থায়ী সংযোগ ($from% → $to%), পরিমাপের জন্য যথেষ্ট নয়। সারাংশে গণনা করা হয়নি।';
  }

  @override
  String get csAddedLabel => 'যুক্ত হয়েছে';

  @override
  String get csAvgCurrent => 'গড় বিদ্যুৎপ্রবাহ';

  @override
  String get statusBarShowsNote =>
      'ঘড়ির পাশে প্রদর্শিত মান। বিজ্ঞপ্তিতে সবসময় সব মান দেখা যায়।';

  @override
  String get bhLowConfidence => 'নির্ভরযোগ্যতা কম';

  @override
  String get nBluetoothOn => 'ব্লুটুথ চালু আছে এবং সাড়া দিচ্ছে';

  @override
  String get bhAtOriginal => 'মূলের সমান বা বেশি';

  @override
  String bhEstimatedPct(int pct) {
    return '$pct% (আনুমানিক)';
  }

  @override
  String get stmTitle => 'স্ক্রিন টাইম';

  @override
  String get stmEntryBody =>
      'দৈনিক স্ক্রিন টাইম এবং অ্যাপভিত্তিক সময় ও ব্যাটারি খরচ';

  @override
  String stmHm(int h, int m) {
    return '$h ঘণ্টা $m মিনিট';
  }

  @override
  String stmH(int h) {
    return '$h ঘণ্টা';
  }

  @override
  String stmM(int m) {
    return '$m মিনিট';
  }

  @override
  String get stmUnderMin => '১ মিনিটের কম';

  @override
  String get stmScreenBattery => 'স্ক্রিন চালু অবস্থায় ব্যাটারি খরচ';

  @override
  String get stmWeek => 'গত ৭ দিন';

  @override
  String stmAverage(String time) {
    return 'দৈনিক গড় $time';
  }

  @override
  String get stmApps => 'ব্যবহৃত অ্যাপ';

  @override
  String stmOpens(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বার খোলা হয়েছে',
      zero: 'খোলা হয়নি',
    );
    return '$_temp0';
  }

  @override
  String stmAppBattery(String pct) {
    return '≈$pct% ব্যাটারি';
  }

  @override
  String stmShowAll(int count) {
    return 'সব দেখুন ($count)';
  }

  @override
  String get stmShowLess => 'কম দেখুন';

  @override
  String get stmNoUse => 'এই দিনের কোনো স্ক্রিন টাইম রেকর্ড করা হয়নি।';

  @override
  String get stmAccessTitle => 'ব্যবহারের তথ্যে প্রবেশাধিকার দিন';

  @override
  String get stmAccessBody =>
      'স্ক্রিন টাইম অ্যান্ড্রয়েডের ব্যবহারের রেকর্ড থেকে নেওয়া হয়, যার জন্য ব্যবহারের তথ্যে প্রবেশাধিকার (Usage access) প্রয়োজন। তথ্য এই ফোনেই থাকে।';

  @override
  String get stmBatteryNote =>
      'অ্যাপভিত্তিক ব্যাটারি খরচ একটি অনুমান। SystemX প্রতিবার পরিমাপকৃত ব্যাটারি হ্রাস সেই সময়ে স্ক্রিনে থাকা অ্যাপগুলোর মধ্যে ভাগ করে; ব্যাকগ্রাউন্ডের ব্যবহার এতে অন্তর্ভুক্ত নয়। অ্যান্ড্রয়েড অ্যাপভিত্তিক সুনির্দিষ্ট ব্যাটারি তথ্য অন্য অ্যাপকে দেয় না।';

  @override
  String get stmNoBattery =>
      'ব্যাটারি খরচের অনুমানের জন্য SystemX-এর ব্যাটারি ইতিহাস প্রয়োজন। রেকর্ড শুরু করতে তাৎক্ষণিক অবস্থা অথবা যেকোনো ব্যাটারি সতর্কবার্তা চালু করুন।';

  @override
  String get stmTimeNote =>
      'সময়ের হিসাব অ্যান্ড্রয়েডের ব্যবহারের রেকর্ড থেকে নেওয়া। হোম স্ক্রিন ও লক স্ক্রিনের সময় স্ক্রিন টাইমে গণনা হয়, তবে অ্যাপ হিসেবে দেখানো হয় না।';

  @override
  String get stmUnlocksLabel => 'আনলকের সংখ্যা';

  @override
  String featureCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি বৈশিষ্ট্য',
    );
    return '$_temp0';
  }

  @override
  String builtOn(String date) {
    return 'তৈরির তারিখ $date';
  }
}
