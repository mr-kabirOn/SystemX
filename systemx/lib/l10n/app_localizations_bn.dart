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
  String get deviceHeroSub => 'সম্পূর্ণ স্পেসিফিকেশন পরবর্তী আপডেটে আসছে';

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
}
