import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SystemX'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get navDevice;

  /// No description provided for @navTests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get navTests;

  /// No description provided for @navMonitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get navMonitor;

  /// No description provided for @onb1Title.
  ///
  /// In en, this message translates to:
  /// **'Know your phone, inside out'**
  String get onb1Title;

  /// No description provided for @onb1Body.
  ///
  /// In en, this message translates to:
  /// **'Live stats and every spec your phone exposes, in one clear place.'**
  String get onb1Body;

  /// No description provided for @onb2Title.
  ///
  /// In en, this message translates to:
  /// **'Test every part'**
  String get onb2Title;

  /// No description provided for @onb2Body.
  ///
  /// In en, this message translates to:
  /// **'A guided checkup tests the screen, speakers, cameras, sensors and more, then gives you a report.'**
  String get onb2Body;

  /// No description provided for @onb3Title.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get onb3Title;

  /// No description provided for @onb3Body.
  ///
  /// In en, this message translates to:
  /// **'No account, no tracking. Your data never leaves this phone.'**
  String get onb3Body;

  /// No description provided for @onbSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onbSkip;

  /// No description provided for @onbNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onbNext;

  /// No description provided for @onbStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onbStart;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @homeYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone'**
  String get homeYourPhone;

  /// No description provided for @previewBanner.
  ///
  /// In en, this message translates to:
  /// **'Preview build: the values on this screen are samples.'**
  String get previewBanner;

  /// No description provided for @healthExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent health'**
  String get healthExcellent;

  /// No description provided for @healthSample.
  ///
  /// In en, this message translates to:
  /// **'Sample: {passed} of {total} tests passed'**
  String healthSample(int passed, int total);

  /// No description provided for @healthScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get healthScoreLabel;

  /// No description provided for @runCheckup.
  ///
  /// In en, this message translates to:
  /// **'Run checkup'**
  String get runCheckup;

  /// No description provided for @metricCpu.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get metricCpu;

  /// No description provided for @metricMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get metricMemory;

  /// No description provided for @metricBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get metricBattery;

  /// No description provided for @metricStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get metricStorage;

  /// No description provided for @metricNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get metricNetwork;

  /// No description provided for @metricThermal.
  ///
  /// In en, this message translates to:
  /// **'Thermal'**
  String get metricThermal;

  /// No description provided for @freeAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} free'**
  String freeAmount(String amount);

  /// No description provided for @thermalNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get thermalNormal;

  /// No description provided for @headroom.
  ///
  /// In en, this message translates to:
  /// **'Headroom {percent}%'**
  String headroom(int percent);

  /// No description provided for @tipChargeLimit.
  ///
  /// In en, this message translates to:
  /// **'Unplug at 80% to slow battery wear.'**
  String get tipChargeLimit;

  /// No description provided for @tipSetAlarm.
  ///
  /// In en, this message translates to:
  /// **'Set alarm'**
  String get tipSetAlarm;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming in the next update'**
  String get comingSoon;

  /// No description provided for @sample.
  ///
  /// In en, this message translates to:
  /// **'Sample'**
  String get sample;

  /// No description provided for @deviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get deviceTitle;

  /// No description provided for @deviceSearch.
  ///
  /// In en, this message translates to:
  /// **'Search specs'**
  String get deviceSearch;

  /// No description provided for @deviceHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get deviceHeroTitle;

  /// No description provided for @deviceHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Full specs arrive in the next update'**
  String get deviceHeroSub;

  /// No description provided for @catDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get catDevice;

  /// No description provided for @catDeviceSub.
  ///
  /// In en, this message translates to:
  /// **'Model, maker, codename'**
  String get catDeviceSub;

  /// No description provided for @catSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get catSystem;

  /// No description provided for @catSystemSub.
  ///
  /// In en, this message translates to:
  /// **'Android version, security patch, kernel'**
  String get catSystemSub;

  /// No description provided for @catProcessor.
  ///
  /// In en, this message translates to:
  /// **'Processor'**
  String get catProcessor;

  /// No description provided for @catProcessorSub.
  ///
  /// In en, this message translates to:
  /// **'Chip, cores, live clock speeds'**
  String get catProcessorSub;

  /// No description provided for @catGpu.
  ///
  /// In en, this message translates to:
  /// **'Graphics'**
  String get catGpu;

  /// No description provided for @catGpuSub.
  ///
  /// In en, this message translates to:
  /// **'GPU, OpenGL ES, Vulkan'**
  String get catGpuSub;

  /// No description provided for @catMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get catMemory;

  /// No description provided for @catMemorySub.
  ///
  /// In en, this message translates to:
  /// **'RAM in use and available'**
  String get catMemorySub;

  /// No description provided for @catStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get catStorage;

  /// No description provided for @catStorageSub.
  ///
  /// In en, this message translates to:
  /// **'Internal space, SD card, USB'**
  String get catStorageSub;

  /// No description provided for @catBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get catBattery;

  /// No description provided for @catBatterySub.
  ///
  /// In en, this message translates to:
  /// **'Health, temperature, charging speed'**
  String get catBatterySub;

  /// No description provided for @catDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get catDisplay;

  /// No description provided for @catDisplaySub.
  ///
  /// In en, this message translates to:
  /// **'Resolution, refresh rate, HDR'**
  String get catDisplaySub;

  /// No description provided for @catNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get catNetwork;

  /// No description provided for @catNetworkSub.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi, mobile data, IP addresses'**
  String get catNetworkSub;

  /// No description provided for @catSim.
  ///
  /// In en, this message translates to:
  /// **'SIM & mobile'**
  String get catSim;

  /// No description provided for @catSimSub.
  ///
  /// In en, this message translates to:
  /// **'Carrier, signal, balance check'**
  String get catSimSub;

  /// No description provided for @catCameras.
  ///
  /// In en, this message translates to:
  /// **'Cameras'**
  String get catCameras;

  /// No description provided for @catCamerasSub.
  ///
  /// In en, this message translates to:
  /// **'Megapixels, aperture, video'**
  String get catCamerasSub;

  /// No description provided for @catSensors.
  ///
  /// In en, this message translates to:
  /// **'Sensors'**
  String get catSensors;

  /// No description provided for @catSensorsSub.
  ///
  /// In en, this message translates to:
  /// **'Every sensor with live readings'**
  String get catSensorsSub;

  /// No description provided for @catMedia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get catMedia;

  /// No description provided for @catMediaSub.
  ///
  /// In en, this message translates to:
  /// **'Codecs, DRM, audio outputs'**
  String get catMediaSub;

  /// No description provided for @catFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get catFeatures;

  /// No description provided for @catFeaturesSub.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth, NFC, 5G, fingerprint'**
  String get catFeaturesSub;

  /// No description provided for @catSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security check'**
  String get catSecurity;

  /// No description provided for @catSecuritySub.
  ///
  /// In en, this message translates to:
  /// **'Screen lock, encryption, updates'**
  String get catSecuritySub;

  /// No description provided for @testsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get testsTitle;

  /// No description provided for @checkupTitle.
  ///
  /// In en, this message translates to:
  /// **'Full checkup'**
  String get checkupTitle;

  /// No description provided for @checkupMeta.
  ///
  /// In en, this message translates to:
  /// **'{count} tests · about {minutes} minutes'**
  String checkupMeta(int count, int minutes);

  /// No description provided for @checkupBody.
  ///
  /// In en, this message translates to:
  /// **'Automatic tests run on their own. We\'ll ask you about the rest.'**
  String get checkupBody;

  /// No description provided for @startCheckup.
  ///
  /// In en, this message translates to:
  /// **'Start checkup'**
  String get startCheckup;

  /// No description provided for @singleTests.
  ///
  /// In en, this message translates to:
  /// **'Single tests'**
  String get singleTests;

  /// No description provided for @testDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get testDisplay;

  /// No description provided for @testTouch.
  ///
  /// In en, this message translates to:
  /// **'Touch'**
  String get testTouch;

  /// No description provided for @testSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get testSpeaker;

  /// No description provided for @testEarpiece.
  ///
  /// In en, this message translates to:
  /// **'Earpiece'**
  String get testEarpiece;

  /// No description provided for @testMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get testMicrophone;

  /// No description provided for @testVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get testVibration;

  /// No description provided for @testCameras.
  ///
  /// In en, this message translates to:
  /// **'Cameras'**
  String get testCameras;

  /// No description provided for @testFlashlight.
  ///
  /// In en, this message translates to:
  /// **'Flashlight'**
  String get testFlashlight;

  /// No description provided for @testSensors.
  ///
  /// In en, this message translates to:
  /// **'Sensors'**
  String get testSensors;

  /// No description provided for @testButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get testButtons;

  /// No description provided for @testWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get testWifi;

  /// No description provided for @testBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get testBluetooth;

  /// No description provided for @testGps.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get testGps;

  /// No description provided for @testFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get testFingerprint;

  /// No description provided for @testCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get testCharging;

  /// No description provided for @testStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage speed'**
  String get testStorage;

  /// No description provided for @monitorTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get monitorTitle;

  /// No description provided for @monitorBody.
  ///
  /// In en, this message translates to:
  /// **'Live charts for every part of your phone. In this preview the charts show sample data.'**
  String get monitorBody;

  /// No description provided for @monitorCpu.
  ///
  /// In en, this message translates to:
  /// **'Processor clock'**
  String get monitorCpu;

  /// No description provided for @monitorRam.
  ///
  /// In en, this message translates to:
  /// **'Memory use'**
  String get monitorRam;

  /// No description provided for @monitorBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery current'**
  String get monitorBattery;

  /// No description provided for @monitorNet.
  ///
  /// In en, this message translates to:
  /// **'Network speed'**
  String get monitorNet;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @secAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get secAppearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @pureBlack.
  ///
  /// In en, this message translates to:
  /// **'Pure black'**
  String get pureBlack;

  /// No description provided for @pureBlackSub.
  ///
  /// In en, this message translates to:
  /// **'Saves power on AMOLED screens'**
  String get pureBlackSub;

  /// No description provided for @wallpaperColors.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper colors'**
  String get wallpaperColors;

  /// No description provided for @wallpaperColorsSub.
  ///
  /// In en, this message translates to:
  /// **'Match the accent to your wallpaper (Android 12+)'**
  String get wallpaperColorsSub;

  /// No description provided for @secUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get secUnits;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @secLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get secLanguage;

  /// No description provided for @langSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get langSystem;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get langBangla;

  /// No description provided for @secLive.
  ///
  /// In en, this message translates to:
  /// **'Live data'**
  String get secLive;

  /// No description provided for @refreshRate.
  ///
  /// In en, this message translates to:
  /// **'Refresh rate'**
  String get refreshRate;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'{value} s'**
  String seconds(String value);

  /// No description provided for @secPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get secPrivacy;

  /// No description provided for @privacyPermissions.
  ///
  /// In en, this message translates to:
  /// **'Privacy & permissions'**
  String get privacyPermissions;

  /// No description provided for @privacyPermissionsSub.
  ///
  /// In en, this message translates to:
  /// **'See what SystemX can access and why'**
  String get privacyPermissionsSub;

  /// No description provided for @secAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get secAbout;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licenses;

  /// No description provided for @replayIntro.
  ///
  /// In en, this message translates to:
  /// **'Show intro again'**
  String get replayIntro;

  /// No description provided for @privacyBanner.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this phone. No account, no ads tracking, nothing uploaded.'**
  String get privacyBanner;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'SystemX works without any of these. Turn on only what you need.'**
  String get privacyIntro;

  /// No description provided for @permNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permNotifications;

  /// No description provided for @permNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Live status and battery alerts'**
  String get permNotificationsSub;

  /// No description provided for @permLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get permLocation;

  /// No description provided for @permLocationSub.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi name and GPS test'**
  String get permLocationSub;

  /// No description provided for @permPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get permPhone;

  /// No description provided for @permPhoneSub.
  ///
  /// In en, this message translates to:
  /// **'SIM slots and signal details'**
  String get permPhoneSub;

  /// No description provided for @permCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permCamera;

  /// No description provided for @permCameraSub.
  ///
  /// In en, this message translates to:
  /// **'Only during the camera test'**
  String get permCameraSub;

  /// No description provided for @permMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get permMicrophone;

  /// No description provided for @permMicrophoneSub.
  ///
  /// In en, this message translates to:
  /// **'Only during the microphone test'**
  String get permMicrophoneSub;

  /// No description provided for @permNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby devices'**
  String get permNearby;

  /// No description provided for @permNearbySub.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth test'**
  String get permNearbySub;

  /// No description provided for @askWhenNeeded.
  ///
  /// In en, this message translates to:
  /// **'Ask when needed'**
  String get askWhenNeeded;

  /// No description provided for @permAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get permAllow;

  /// No description provided for @permNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get permNotNow;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied {label}'**
  String copied(String label);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
