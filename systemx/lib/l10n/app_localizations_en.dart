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
}
