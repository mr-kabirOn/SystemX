import 'package:flutter/material.dart';

import '../../core/permissions.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';

enum TestGroup { display, audio, haptics, cameras, sensors, connectivity, biometrics, power }

/// The 32 hardware tests, in checkup order within each group.
enum HwTest {
  deadPixels(TestGroup.display),
  colorBanding(TestGroup.display),
  burnIn(TestGroup.display),
  touchGrid(TestGroup.display),
  multiTouch(TestGroup.display),
  brightness(TestGroup.display),
  speaker(TestGroup.audio),
  earpiece(TestGroup.audio),
  microphone(TestGroup.audio, permission: AppPermission.microphone),
  speakerMicLoop(TestGroup.audio, automatic: true, permission: AppPermission.microphone),
  headphones(TestGroup.audio),
  usbAudio(TestGroup.audio),
  vibration(TestGroup.haptics),
  volumeUp(TestGroup.haptics),
  volumeDown(TestGroup.haptics),
  rearCamera(TestGroup.cameras, permission: AppPermission.camera),
  frontCamera(TestGroup.cameras, permission: AppPermission.camera),
  flashlight(TestGroup.cameras),
  accelerometer(TestGroup.sensors),
  gyroscope(TestGroup.sensors),
  compass(TestGroup.sensors),
  proximity(TestGroup.sensors),
  light(TestGroup.sensors),
  barometer(TestGroup.sensors, automatic: true),
  wifi(TestGroup.connectivity, automatic: true),
  bluetooth(TestGroup.connectivity, automatic: true),
  gps(TestGroup.connectivity, permission: AppPermission.location),
  nfc(TestGroup.connectivity, automatic: true),
  mobileSignal(TestGroup.connectivity, automatic: true),
  biometrics(TestGroup.biometrics),
  charging(TestGroup.power),
  storageSpeed(TestGroup.power, automatic: true);

  const HwTest(this.group, {this.automatic = false, this.permission});

  final TestGroup group;

  /// Runs without any input from the user.
  final bool automatic;

  /// Asked for (with an explanation) just before the test starts.
  final AppPermission? permission;

  static HwTest? byName(String name) {
    for (final t in values) {
      if (t.name == name) return t;
    }
    return null;
  }

  IconData get icon => switch (this) {
        deadPixels || colorBanding || burnIn => SxIcons.display,
        touchGrid || multiTouch => SxIcons.touch,
        brightness => SxIcons.brightness,
        speaker || speakerMicLoop => SxIcons.speaker,
        earpiece => SxIcons.earpiece,
        microphone => SxIcons.mic,
        headphones => Icons.headphones_rounded,
        usbAudio => Icons.usb_rounded,
        vibration => SxIcons.vibration,
        volumeUp => Icons.volume_up_rounded,
        volumeDown => Icons.volume_down_rounded,
        rearCamera || frontCamera => SxIcons.camera,
        flashlight => SxIcons.flashlight,
        accelerometer || gyroscope => Icons.screen_rotation_rounded,
        compass => Icons.explore_rounded,
        proximity => Icons.sensor_occupied_rounded,
        light => Icons.light_mode_rounded,
        barometer => Icons.speed_rounded,
        wifi => SxIcons.network,
        bluetooth => SxIcons.bluetooth,
        gps => SxIcons.gps,
        nfc => Icons.nfc_rounded,
        mobileSignal => Icons.signal_cellular_alt_rounded,
        biometrics => SxIcons.fingerprint,
        charging => SxIcons.charging,
        storageSpeed => SxIcons.storage,
      };

  Color color(SxColors sx) => switch (group) {
        TestGroup.display => sx.display,
        TestGroup.audio => sx.ram,
        TestGroup.haptics => sx.accent,
        TestGroup.cameras => sx.camera,
        TestGroup.sensors => sx.sensors,
        TestGroup.connectivity => sx.network,
        TestGroup.biometrics => sx.good,
        TestGroup.power => sx.battery,
      };

  String title(AppLocalizations l) => switch (this) {
        deadPixels => l.tDeadPixels,
        colorBanding => l.tColorBanding,
        burnIn => l.tBurnIn,
        touchGrid => l.testTouch,
        multiTouch => l.tMultiTouch,
        brightness => l.tBrightness,
        speaker => l.testSpeaker,
        earpiece => l.testEarpiece,
        microphone => l.testMicrophone,
        speakerMicLoop => l.tSpeakerMic,
        headphones => l.tHeadphones,
        usbAudio => l.tUsbAudio,
        vibration => l.testVibration,
        volumeUp => l.tVolumeUp,
        volumeDown => l.tVolumeDown,
        rearCamera => l.tRearCamera,
        frontCamera => l.tFrontCamera,
        flashlight => l.testFlashlight,
        accelerometer => l.tAccelerometer,
        gyroscope => l.tGyroscope,
        compass => l.tCompass,
        proximity => l.tProximity,
        light => l.tLight,
        barometer => l.tBarometer,
        wifi => l.testWifi,
        bluetooth => l.testBluetooth,
        gps => l.testGps,
        nfc => 'NFC',
        mobileSignal => l.tMobileSignal,
        biometrics => l.testFingerprint,
        charging => l.testCharging,
        storageSpeed => l.testStorage,
      };
}

String groupTitle(AppLocalizations l, TestGroup g) => switch (g) {
      TestGroup.display => l.testDisplay,
      TestGroup.audio => l.gAudio,
      TestGroup.haptics => l.gHaptics,
      TestGroup.cameras => l.testCameras,
      TestGroup.sensors => l.testSensors,
      TestGroup.connectivity => l.gConnectivity,
      TestGroup.biometrics => l.gBiometrics,
      TestGroup.power => l.gPower,
    };
