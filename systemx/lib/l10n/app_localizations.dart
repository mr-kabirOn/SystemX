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

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get notAvailable;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @supported.
  ///
  /// In en, this message translates to:
  /// **'Supported'**
  String get supported;

  /// No description provided for @notSupported.
  ///
  /// In en, this message translates to:
  /// **'Not supported'**
  String get notSupported;

  /// No description provided for @detected.
  ///
  /// In en, this message translates to:
  /// **'Detected'**
  String get detected;

  /// No description provided for @notDetected.
  ///
  /// In en, this message translates to:
  /// **'Not detected'**
  String get notDetected;

  /// No description provided for @encrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get encrypted;

  /// No description provided for @notEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Not encrypted'**
  String get notEncrypted;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @secGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get secGooglePlay;

  /// No description provided for @secPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get secPlatform;

  /// No description provided for @secSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get secSession;

  /// No description provided for @secCores.
  ///
  /// In en, this message translates to:
  /// **'Cores'**
  String get secCores;

  /// No description provided for @secCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get secCharging;

  /// No description provided for @secCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get secCapacity;

  /// No description provided for @secSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get secSettings;

  /// No description provided for @secMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile network'**
  String get secMobile;

  /// No description provided for @secVolume.
  ///
  /// In en, this message translates to:
  /// **'Storage volume'**
  String get secVolume;

  /// No description provided for @secDrm.
  ///
  /// In en, this message translates to:
  /// **'Video protection (DRM)'**
  String get secDrm;

  /// No description provided for @secAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get secAudio;

  /// No description provided for @secVideoCodecs.
  ///
  /// In en, this message translates to:
  /// **'Video codecs'**
  String get secVideoCodecs;

  /// No description provided for @secAudioCodecs.
  ///
  /// In en, this message translates to:
  /// **'Audio codecs'**
  String get secAudioCodecs;

  /// No description provided for @secHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get secHardware;

  /// No description provided for @specModelName.
  ///
  /// In en, this message translates to:
  /// **'Model name'**
  String get specModelName;

  /// No description provided for @specManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get specManufacturer;

  /// No description provided for @specBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get specBrand;

  /// No description provided for @specModel.
  ///
  /// In en, this message translates to:
  /// **'Model number'**
  String get specModel;

  /// No description provided for @specCodename.
  ///
  /// In en, this message translates to:
  /// **'Codename'**
  String get specCodename;

  /// No description provided for @specProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get specProduct;

  /// No description provided for @specBoard.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get specBoard;

  /// No description provided for @specHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get specHardware;

  /// No description provided for @specDeviceType.
  ///
  /// In en, this message translates to:
  /// **'Device type'**
  String get specDeviceType;

  /// No description provided for @devicePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get devicePhone;

  /// No description provided for @deviceTablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get deviceTablet;

  /// No description provided for @specAndroidVersion.
  ///
  /// In en, this message translates to:
  /// **'Android version'**
  String get specAndroidVersion;

  /// No description provided for @specApiLevel.
  ///
  /// In en, this message translates to:
  /// **'API level'**
  String get specApiLevel;

  /// No description provided for @specSecurityPatch.
  ///
  /// In en, this message translates to:
  /// **'Security patch'**
  String get specSecurityPatch;

  /// No description provided for @specBuildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get specBuildNumber;

  /// No description provided for @specBuildDate.
  ///
  /// In en, this message translates to:
  /// **'Build date'**
  String get specBuildDate;

  /// No description provided for @specBuildType.
  ///
  /// In en, this message translates to:
  /// **'Build type'**
  String get specBuildType;

  /// No description provided for @specIncremental.
  ///
  /// In en, this message translates to:
  /// **'Incremental version'**
  String get specIncremental;

  /// No description provided for @specFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Build fingerprint'**
  String get specFingerprint;

  /// No description provided for @specPlayServices.
  ///
  /// In en, this message translates to:
  /// **'Google Play services'**
  String get specPlayServices;

  /// No description provided for @specPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Play Store'**
  String get specPlayStore;

  /// No description provided for @specPlaySystemUpdate.
  ///
  /// In en, this message translates to:
  /// **'Google Play system update'**
  String get specPlaySystemUpdate;

  /// No description provided for @specKernel.
  ///
  /// In en, this message translates to:
  /// **'Kernel'**
  String get specKernel;

  /// No description provided for @specBootloader.
  ///
  /// In en, this message translates to:
  /// **'Bootloader'**
  String get specBootloader;

  /// No description provided for @specBaseband.
  ///
  /// In en, this message translates to:
  /// **'Baseband (modem)'**
  String get specBaseband;

  /// No description provided for @specRuntime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get specRuntime;

  /// No description provided for @specTreble.
  ///
  /// In en, this message translates to:
  /// **'Project Treble'**
  String get specTreble;

  /// No description provided for @specSeamlessUpdates.
  ///
  /// In en, this message translates to:
  /// **'Seamless (A/B) updates'**
  String get specSeamlessUpdates;

  /// No description provided for @specDynamicPartitions.
  ///
  /// In en, this message translates to:
  /// **'Dynamic partitions'**
  String get specDynamicPartitions;

  /// No description provided for @specEncryption.
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get specEncryption;

  /// No description provided for @specRoot.
  ///
  /// In en, this message translates to:
  /// **'Root access'**
  String get specRoot;

  /// No description provided for @specUptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get specUptime;

  /// No description provided for @specLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get specLanguage;

  /// No description provided for @specTimezone.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get specTimezone;

  /// No description provided for @specChip.
  ///
  /// In en, this message translates to:
  /// **'Chip'**
  String get specChip;

  /// No description provided for @specProcess.
  ///
  /// In en, this message translates to:
  /// **'Process node'**
  String get specProcess;

  /// No description provided for @specSocMaker.
  ///
  /// In en, this message translates to:
  /// **'Chip maker'**
  String get specSocMaker;

  /// No description provided for @specSocModel.
  ///
  /// In en, this message translates to:
  /// **'Chip model code'**
  String get specSocModel;

  /// No description provided for @specCores.
  ///
  /// In en, this message translates to:
  /// **'Cores'**
  String get specCores;

  /// No description provided for @specClusters.
  ///
  /// In en, this message translates to:
  /// **'Clusters'**
  String get specClusters;

  /// No description provided for @specCoreTypes.
  ///
  /// In en, this message translates to:
  /// **'Core types'**
  String get specCoreTypes;

  /// No description provided for @specGovernor.
  ///
  /// In en, this message translates to:
  /// **'Governor'**
  String get specGovernor;

  /// No description provided for @specArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get specArchitecture;

  /// No description provided for @specAbis.
  ///
  /// In en, this message translates to:
  /// **'Supported ABIs'**
  String get specAbis;

  /// No description provided for @specInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instruction features'**
  String get specInstructions;

  /// No description provided for @coreOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline (sleeping)'**
  String get coreOffline;

  /// No description provided for @specRenderer.
  ///
  /// In en, this message translates to:
  /// **'GPU'**
  String get specRenderer;

  /// No description provided for @specVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get specVendor;

  /// No description provided for @specOpenGlEs.
  ///
  /// In en, this message translates to:
  /// **'OpenGL ES'**
  String get specOpenGlEs;

  /// No description provided for @specGlDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver version'**
  String get specGlDriver;

  /// No description provided for @specVulkan.
  ///
  /// In en, this message translates to:
  /// **'Vulkan'**
  String get specVulkan;

  /// No description provided for @specGlExtensions.
  ///
  /// In en, this message translates to:
  /// **'OpenGL extensions'**
  String get specGlExtensions;

  /// No description provided for @specInstalled.
  ///
  /// In en, this message translates to:
  /// **'Installed RAM'**
  String get specInstalled;

  /// No description provided for @specUsable.
  ///
  /// In en, this message translates to:
  /// **'Usable by Android'**
  String get specUsable;

  /// No description provided for @usableHint.
  ///
  /// In en, this message translates to:
  /// **'Part of the RAM is reserved for the modem and GPU'**
  String get usableHint;

  /// No description provided for @specInUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get specInUse;

  /// No description provided for @specAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get specAvailable;

  /// No description provided for @specLowMemoryAt.
  ///
  /// In en, this message translates to:
  /// **'Low-memory point'**
  String get specLowMemoryAt;

  /// No description provided for @lowMemoryHint.
  ///
  /// In en, this message translates to:
  /// **'Android starts closing background apps below this'**
  String get lowMemoryHint;

  /// No description provided for @specLowMemoryNow.
  ///
  /// In en, this message translates to:
  /// **'Low on memory now'**
  String get specLowMemoryNow;

  /// No description provided for @specSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap (zRAM)'**
  String get specSwap;

  /// No description provided for @specSwapUsed.
  ///
  /// In en, this message translates to:
  /// **'Swap in use'**
  String get specSwapUsed;

  /// No description provided for @specTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get specTotal;

  /// No description provided for @specUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get specUsed;

  /// No description provided for @specFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get specFree;

  /// No description provided for @specFileSystem.
  ///
  /// In en, this message translates to:
  /// **'File system'**
  String get specFileSystem;

  /// No description provided for @specVolumeType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get specVolumeType;

  /// No description provided for @specState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get specState;

  /// No description provided for @volumeInternal.
  ///
  /// In en, this message translates to:
  /// **'Internal'**
  String get volumeInternal;

  /// No description provided for @volumeRemovable.
  ///
  /// In en, this message translates to:
  /// **'Removable (SD card or USB)'**
  String get volumeRemovable;

  /// No description provided for @volumeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get volumeOther;

  /// No description provided for @specLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get specLevel;

  /// No description provided for @specStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get specStatus;

  /// No description provided for @specPowerSource.
  ///
  /// In en, this message translates to:
  /// **'Power source'**
  String get specPowerSource;

  /// No description provided for @specHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get specHealth;

  /// No description provided for @specTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get specTemperature;

  /// No description provided for @specVoltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get specVoltage;

  /// No description provided for @specTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get specTechnology;

  /// No description provided for @specCurrentNow.
  ///
  /// In en, this message translates to:
  /// **'Current now'**
  String get specCurrentNow;

  /// No description provided for @specCurrentAvg.
  ///
  /// In en, this message translates to:
  /// **'Average current'**
  String get specCurrentAvg;

  /// No description provided for @specTimeToFull.
  ///
  /// In en, this message translates to:
  /// **'Time to full'**
  String get specTimeToFull;

  /// No description provided for @specCycleCount.
  ///
  /// In en, this message translates to:
  /// **'Charge cycles'**
  String get specCycleCount;

  /// No description provided for @cycleHint.
  ///
  /// In en, this message translates to:
  /// **'Reported on Android 14 and later, when the maker exposes it'**
  String get cycleHint;

  /// No description provided for @specChargeCounter.
  ///
  /// In en, this message translates to:
  /// **'Charge left'**
  String get specChargeCounter;

  /// No description provided for @specEstCapacity.
  ///
  /// In en, this message translates to:
  /// **'Estimated full capacity'**
  String get specEstCapacity;

  /// No description provided for @estCapacityHint.
  ///
  /// In en, this message translates to:
  /// **'Estimate, from the charge counter'**
  String get estCapacityHint;

  /// No description provided for @specDesignCapacity.
  ///
  /// In en, this message translates to:
  /// **'Design capacity'**
  String get specDesignCapacity;

  /// No description provided for @designCapacityHint.
  ///
  /// In en, this message translates to:
  /// **'From the system power profile; some makers leave it wrong'**
  String get designCapacityHint;

  /// No description provided for @batCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get batCharging;

  /// No description provided for @batDischarging.
  ///
  /// In en, this message translates to:
  /// **'Discharging'**
  String get batDischarging;

  /// No description provided for @batNotCharging.
  ///
  /// In en, this message translates to:
  /// **'Plugged in, not charging'**
  String get batNotCharging;

  /// No description provided for @batFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get batFull;

  /// No description provided for @healthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get healthGood;

  /// No description provided for @healthOverheat.
  ///
  /// In en, this message translates to:
  /// **'Overheating'**
  String get healthOverheat;

  /// No description provided for @healthDead.
  ///
  /// In en, this message translates to:
  /// **'Dead'**
  String get healthDead;

  /// No description provided for @healthOverVoltage.
  ///
  /// In en, this message translates to:
  /// **'Over voltage'**
  String get healthOverVoltage;

  /// No description provided for @healthFailure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get healthFailure;

  /// No description provided for @healthCold.
  ///
  /// In en, this message translates to:
  /// **'Too cold'**
  String get healthCold;

  /// No description provided for @plugBattery.
  ///
  /// In en, this message translates to:
  /// **'On battery'**
  String get plugBattery;

  /// No description provided for @plugAc.
  ///
  /// In en, this message translates to:
  /// **'Charger'**
  String get plugAc;

  /// No description provided for @plugUsb.
  ///
  /// In en, this message translates to:
  /// **'USB'**
  String get plugUsb;

  /// No description provided for @plugWireless.
  ///
  /// In en, this message translates to:
  /// **'Wireless'**
  String get plugWireless;

  /// No description provided for @plugDock.
  ///
  /// In en, this message translates to:
  /// **'Dock'**
  String get plugDock;

  /// No description provided for @specResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get specResolution;

  /// No description provided for @specSize.
  ///
  /// In en, this message translates to:
  /// **'Screen size'**
  String get specSize;

  /// No description provided for @sizeHint.
  ///
  /// In en, this message translates to:
  /// **'Calculated from the pixel density the screen reports'**
  String get sizeHint;

  /// No description provided for @specAspect.
  ///
  /// In en, this message translates to:
  /// **'Aspect ratio'**
  String get specAspect;

  /// No description provided for @specDensity.
  ///
  /// In en, this message translates to:
  /// **'Pixel density'**
  String get specDensity;

  /// No description provided for @specRefreshRate.
  ///
  /// In en, this message translates to:
  /// **'Refresh rate now'**
  String get specRefreshRate;

  /// No description provided for @specRefreshRates.
  ///
  /// In en, this message translates to:
  /// **'Supported refresh rates'**
  String get specRefreshRates;

  /// No description provided for @specHdr.
  ///
  /// In en, this message translates to:
  /// **'HDR'**
  String get specHdr;

  /// No description provided for @specWideColor.
  ///
  /// In en, this message translates to:
  /// **'Wide color'**
  String get specWideColor;

  /// No description provided for @specCutout.
  ///
  /// In en, this message translates to:
  /// **'Camera cutout'**
  String get specCutout;

  /// No description provided for @specBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness level'**
  String get specBrightness;

  /// No description provided for @brightnessHint.
  ///
  /// In en, this message translates to:
  /// **'Raw value; the range depends on the maker'**
  String get brightnessHint;

  /// No description provided for @specTimeout.
  ///
  /// In en, this message translates to:
  /// **'Screen timeout'**
  String get specTimeout;

  /// No description provided for @specFontScale.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get specFontScale;

  /// No description provided for @specConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get specConnection;

  /// No description provided for @specInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get specInternet;

  /// No description provided for @netWorking.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get netWorking;

  /// No description provided for @netNoInternet.
  ///
  /// In en, this message translates to:
  /// **'Connected, no internet'**
  String get netNoInternet;

  /// No description provided for @netMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile data'**
  String get netMobile;

  /// No description provided for @netNone.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get netNone;

  /// No description provided for @netOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get netOther;

  /// No description provided for @specMetered.
  ///
  /// In en, this message translates to:
  /// **'Metered'**
  String get specMetered;

  /// No description provided for @specVpn.
  ///
  /// In en, this message translates to:
  /// **'VPN'**
  String get specVpn;

  /// No description provided for @specInterface.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get specInterface;

  /// No description provided for @specIpv4.
  ///
  /// In en, this message translates to:
  /// **'IPv4 address'**
  String get specIpv4;

  /// No description provided for @specIpv6.
  ///
  /// In en, this message translates to:
  /// **'IPv6 address'**
  String get specIpv6;

  /// No description provided for @specGateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get specGateway;

  /// No description provided for @specDns.
  ///
  /// In en, this message translates to:
  /// **'DNS servers'**
  String get specDns;

  /// No description provided for @specPrivateDns.
  ///
  /// In en, this message translates to:
  /// **'Private DNS'**
  String get specPrivateDns;

  /// No description provided for @specBandwidth.
  ///
  /// In en, this message translates to:
  /// **'Link capacity'**
  String get specBandwidth;

  /// No description provided for @bandwidthHint.
  ///
  /// In en, this message translates to:
  /// **'Android\'s estimate of the connection\'s top speed, not a speed test'**
  String get bandwidthHint;

  /// No description provided for @specWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get specWifi;

  /// No description provided for @specWifiName.
  ///
  /// In en, this message translates to:
  /// **'Network name'**
  String get specWifiName;

  /// No description provided for @wifiNameHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden by Android'**
  String get wifiNameHidden;

  /// No description provided for @wifiNameHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to allow Location and show it'**
  String get wifiNameHint;

  /// No description provided for @specSignal.
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get specSignal;

  /// No description provided for @signalExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get signalExcellent;

  /// No description provided for @signalGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get signalGood;

  /// No description provided for @signalFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get signalFair;

  /// No description provided for @signalWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get signalWeak;

  /// No description provided for @specWifiStandard.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi standard'**
  String get specWifiStandard;

  /// No description provided for @specFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get specFrequency;

  /// No description provided for @specLinkSpeed.
  ///
  /// In en, this message translates to:
  /// **'Link speed'**
  String get specLinkSpeed;

  /// No description provided for @specTxRx.
  ///
  /// In en, this message translates to:
  /// **'Send / receive'**
  String get specTxRx;

  /// No description provided for @specOperator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get specOperator;

  /// No description provided for @specCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get specCountry;

  /// No description provided for @specRoaming.
  ///
  /// In en, this message translates to:
  /// **'Roaming'**
  String get specRoaming;

  /// No description provided for @specNetworkType.
  ///
  /// In en, this message translates to:
  /// **'Network type'**
  String get specNetworkType;

  /// No description provided for @needsPhone.
  ///
  /// In en, this message translates to:
  /// **'Needs Phone permission'**
  String get needsPhone;

  /// No description provided for @needsPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to allow it and show SIM details'**
  String get needsPhoneHint;

  /// No description provided for @specSlots.
  ///
  /// In en, this message translates to:
  /// **'SIM slots'**
  String get specSlots;

  /// No description provided for @specSimState.
  ///
  /// In en, this message translates to:
  /// **'SIM status'**
  String get specSimState;

  /// No description provided for @specMccMnc.
  ///
  /// In en, this message translates to:
  /// **'MCC / MNC'**
  String get specMccMnc;

  /// No description provided for @specSimDetails.
  ///
  /// In en, this message translates to:
  /// **'SIM details'**
  String get specSimDetails;

  /// No description provided for @specCarrier.
  ///
  /// In en, this message translates to:
  /// **'Carrier'**
  String get specCarrier;

  /// No description provided for @specSimName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get specSimName;

  /// No description provided for @specSimType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get specSimType;

  /// No description provided for @simPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical SIM'**
  String get simPhysical;

  /// No description provided for @specDataSim.
  ///
  /// In en, this message translates to:
  /// **'Used for mobile data'**
  String get specDataSim;

  /// No description provided for @simAbsent.
  ///
  /// In en, this message translates to:
  /// **'No SIM'**
  String get simAbsent;

  /// No description provided for @simPin.
  ///
  /// In en, this message translates to:
  /// **'PIN required'**
  String get simPin;

  /// No description provided for @simPuk.
  ///
  /// In en, this message translates to:
  /// **'PUK required'**
  String get simPuk;

  /// No description provided for @simLocked.
  ///
  /// In en, this message translates to:
  /// **'Network locked'**
  String get simLocked;

  /// No description provided for @simReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get simReady;

  /// No description provided for @simNotReady.
  ///
  /// In en, this message translates to:
  /// **'Not ready'**
  String get simNotReady;

  /// No description provided for @simDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get simDisabled;

  /// No description provided for @simError.
  ///
  /// In en, this message translates to:
  /// **'Card error'**
  String get simError;

  /// No description provided for @cameraRear.
  ///
  /// In en, this message translates to:
  /// **'Rear camera'**
  String get cameraRear;

  /// No description provided for @cameraFront.
  ///
  /// In en, this message translates to:
  /// **'Front camera'**
  String get cameraFront;

  /// No description provided for @cameraExternal.
  ///
  /// In en, this message translates to:
  /// **'External camera'**
  String get cameraExternal;

  /// No description provided for @specSensorSize.
  ///
  /// In en, this message translates to:
  /// **'Sensor size'**
  String get specSensorSize;

  /// No description provided for @specAperture.
  ///
  /// In en, this message translates to:
  /// **'Aperture'**
  String get specAperture;

  /// No description provided for @specFocalLength.
  ///
  /// In en, this message translates to:
  /// **'Focal length'**
  String get specFocalLength;

  /// No description provided for @specOis.
  ///
  /// In en, this message translates to:
  /// **'Optical stabilization (OIS)'**
  String get specOis;

  /// No description provided for @specFlash.
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get specFlash;

  /// No description provided for @specMaxVideo.
  ///
  /// In en, this message translates to:
  /// **'Best video'**
  String get specMaxVideo;

  /// No description provided for @specRaw.
  ///
  /// In en, this message translates to:
  /// **'RAW photos'**
  String get specRaw;

  /// No description provided for @specCamera2Level.
  ///
  /// In en, this message translates to:
  /// **'Camera2 API level'**
  String get specCamera2Level;

  /// No description provided for @specMultiCamera.
  ///
  /// In en, this message translates to:
  /// **'Combines several lenses'**
  String get specMultiCamera;

  /// No description provided for @specCameraId.
  ///
  /// In en, this message translates to:
  /// **'Camera ID'**
  String get specCameraId;

  /// No description provided for @specWidevine.
  ///
  /// In en, this message translates to:
  /// **'Widevine level'**
  String get specWidevine;

  /// No description provided for @widevineL1Hint.
  ///
  /// In en, this message translates to:
  /// **'L1 allows HD and 4K streaming'**
  String get widevineL1Hint;

  /// No description provided for @specWidevineVersion.
  ///
  /// In en, this message translates to:
  /// **'Widevine version'**
  String get specWidevineVersion;

  /// No description provided for @specHdcp.
  ///
  /// In en, this message translates to:
  /// **'Max HDCP'**
  String get specHdcp;

  /// No description provided for @specAudioOutputs.
  ///
  /// In en, this message translates to:
  /// **'Audio outputs'**
  String get specAudioOutputs;

  /// No description provided for @specLowLatency.
  ///
  /// In en, this message translates to:
  /// **'Low-latency audio'**
  String get specLowLatency;

  /// No description provided for @specProAudio.
  ///
  /// In en, this message translates to:
  /// **'Pro audio'**
  String get specProAudio;

  /// No description provided for @specSpatial.
  ///
  /// In en, this message translates to:
  /// **'Spatial audio'**
  String get specSpatial;

  /// No description provided for @codecDecode.
  ///
  /// In en, this message translates to:
  /// **'Decode'**
  String get codecDecode;

  /// No description provided for @codecDecodeHw.
  ///
  /// In en, this message translates to:
  /// **'Decode (hardware)'**
  String get codecDecodeHw;

  /// No description provided for @codecDecodeSw.
  ///
  /// In en, this message translates to:
  /// **'Decode (software)'**
  String get codecDecodeSw;

  /// No description provided for @codecEncode.
  ///
  /// In en, this message translates to:
  /// **'Encode'**
  String get codecEncode;

  /// No description provided for @codecEncodeHw.
  ///
  /// In en, this message translates to:
  /// **'Encode (hardware)'**
  String get codecEncodeHw;

  /// No description provided for @codecEncodeSw.
  ///
  /// In en, this message translates to:
  /// **'Encode (software)'**
  String get codecEncodeSw;

  /// No description provided for @featUwb.
  ///
  /// In en, this message translates to:
  /// **'Ultra-wideband (UWB)'**
  String get featUwb;

  /// No description provided for @featIr.
  ///
  /// In en, this message translates to:
  /// **'IR blaster'**
  String get featIr;

  /// No description provided for @featUsbHost.
  ///
  /// In en, this message translates to:
  /// **'USB host (OTG)'**
  String get featUsbHost;

  /// No description provided for @featFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get featFingerprint;

  /// No description provided for @featFace.
  ///
  /// In en, this message translates to:
  /// **'Face unlock hardware'**
  String get featFace;

  /// No description provided for @featTelephony.
  ///
  /// In en, this message translates to:
  /// **'Mobile network'**
  String get featTelephony;

  /// No description provided for @featWifiRtt.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi RTT (indoor location)'**
  String get featWifiRtt;

  /// No description provided for @featLe2m.
  ///
  /// In en, this message translates to:
  /// **'LE 2M PHY (faster)'**
  String get featLe2m;

  /// No description provided for @featLeCoded.
  ///
  /// In en, this message translates to:
  /// **'LE Coded PHY (long range)'**
  String get featLeCoded;

  /// No description provided for @featLeExtAdv.
  ///
  /// In en, this message translates to:
  /// **'LE extended advertising'**
  String get featLeExtAdv;

  /// No description provided for @specScreenLock.
  ///
  /// In en, this message translates to:
  /// **'Screen lock'**
  String get specScreenLock;

  /// No description provided for @lockSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get lockSet;

  /// No description provided for @lockNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get lockNotSet;

  /// No description provided for @lockHint.
  ///
  /// In en, this message translates to:
  /// **'Anyone who picks up the phone can open it'**
  String get lockHint;

  /// No description provided for @specBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get specBiometrics;

  /// No description provided for @bioEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get bioEnrolled;

  /// No description provided for @bioNone.
  ///
  /// In en, this message translates to:
  /// **'Not set up'**
  String get bioNone;

  /// No description provided for @bioNoHardware.
  ///
  /// In en, this message translates to:
  /// **'No hardware'**
  String get bioNoHardware;

  /// No description provided for @specDevOptions.
  ///
  /// In en, this message translates to:
  /// **'Developer options'**
  String get specDevOptions;

  /// No description provided for @specUsbDebugging.
  ///
  /// In en, this message translates to:
  /// **'USB debugging'**
  String get specUsbDebugging;

  /// No description provided for @adbHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off when you are not developing'**
  String get adbHint;

  /// No description provided for @specVerifiedBoot.
  ///
  /// In en, this message translates to:
  /// **'Verified boot'**
  String get specVerifiedBoot;

  /// No description provided for @monthsOld.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =0{This month} =1{1 month old} other{{months} months old}}'**
  String monthsOld(int months);

  /// No description provided for @coreN.
  ///
  /// In en, this message translates to:
  /// **'Core {index}'**
  String coreN(int index);

  /// No description provided for @maxFreq.
  ///
  /// In en, this message translates to:
  /// **'max {freq}'**
  String maxFreq(String freq);

  /// No description provided for @channelN.
  ///
  /// In en, this message translates to:
  /// **'channel {channel}'**
  String channelN(int channel);

  /// No description provided for @signalBars.
  ///
  /// In en, this message translates to:
  /// **'{level} of 4 bars'**
  String signalBars(int level);

  /// No description provided for @simN.
  ///
  /// In en, this message translates to:
  /// **'SIM {slot}'**
  String simN(int slot);

  /// No description provided for @sensorCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sensor} other{{count} sensors}}'**
  String sensorCount(int count);

  /// No description provided for @coresCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 core} other{{count} cores}}'**
  String coresCount(int count);

  /// No description provided for @cyclesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 cycle} other{{count} cycles}}'**
  String cyclesCount(int count);

  /// No description provided for @slotsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 slot} other{{count} slots}}'**
  String slotsCount(int count);

  /// No description provided for @camerasCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 camera} other{{count} cameras}}'**
  String camerasCount(int count);

  /// No description provided for @mainCamera.
  ///
  /// In en, this message translates to:
  /// **'{mp} main'**
  String mainCamera(String mp);

  /// No description provided for @codecsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 codec} other{{count} codecs}}'**
  String codecsCount(int count);

  /// No description provided for @checksPassed.
  ///
  /// In en, this message translates to:
  /// **'{passed} of {total} checks passed'**
  String checksPassed(int passed, int total);

  /// No description provided for @secAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'All system features ({count})'**
  String secAllFeatures(int count);
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
