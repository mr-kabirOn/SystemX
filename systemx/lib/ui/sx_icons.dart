import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// One icon per concept, so the same thing looks the same on every screen.
/// Phosphor (MIT): filled icons for section badges and tests.
abstract final class SxIcons {
  static const IconData device = PhosphorIconsFill.deviceMobile;
  static const IconData system = PhosphorIconsFill.androidLogo;
  static const IconData cpu = PhosphorIconsFill.cpu;
  static const IconData gpu = PhosphorIconsFill.graphicsCard;
  static const IconData ram = PhosphorIconsFill.memory;
  static const IconData storage = PhosphorIconsFill.hardDrives;
  static const IconData battery = PhosphorIconsFill.batteryHigh;
  static const IconData display = PhosphorIconsFill.frameCorners;
  static const IconData network = PhosphorIconsFill.wifiHigh;
  static const IconData sim = PhosphorIconsFill.simCard;
  static const IconData camera = PhosphorIconsFill.camera;
  static const IconData sensors = PhosphorIconsFill.compass;
  static const IconData media = PhosphorIconsFill.musicNotes;
  static const IconData features = PhosphorIconsFill.puzzlePiece;
  static const IconData security = PhosphorIconsFill.shieldCheck;
  static const IconData thermal = PhosphorIconsFill.thermometer;
  static const IconData apps = PhosphorIconsFill.squaresFour;
  static const IconData cache = PhosphorIconsFill.broom;

  static const IconData brightness = PhosphorIconsFill.sun;
  static const IconData touch = PhosphorIconsFill.handTap;
  static const IconData speaker = PhosphorIconsFill.speakerHigh;
  static const IconData earpiece = PhosphorIconsFill.ear;
  static const IconData mic = PhosphorIconsFill.microphone;
  static const IconData vibration = PhosphorIconsFill.vibrate;
  static const IconData flashlight = PhosphorIconsFill.flashlight;
  static const IconData buttons = PhosphorIconsFill.speakerSimpleHigh;
  static const IconData bluetooth = PhosphorIconsFill.bluetooth;
  static const IconData gps = PhosphorIconsFill.gpsFix;
  static const IconData fingerprint = PhosphorIconsFill.fingerprint;
  static const IconData charging = PhosphorIconsFill.lightning;
  static const IconData speed = PhosphorIconsFill.speedometer;
  static const IconData notifications = PhosphorIconsFill.bell;

  // Test status: never color alone, each has its own shape.
  static const IconData passed = PhosphorIconsFill.sealCheck;
  static const IconData failed = PhosphorIconsFill.xCircle;
  static const IconData skipped = PhosphorIconsFill.minusCircle;
  static const IconData notTested = PhosphorIconsFill.question;

  // Bottom tabs.
  static const IconData tabHome = PhosphorIconsRegular.houseSimple;
  static const IconData tabHomeOn = PhosphorIconsFill.houseSimple;
  static const IconData tabDevice = PhosphorIconsRegular.deviceMobile;
  static const IconData tabDeviceOn = PhosphorIconsFill.deviceMobile;
  static const IconData tabTests = PhosphorIconsRegular.listChecks;
  static const IconData tabTestsOn = PhosphorIconsFill.listChecks;
  static const IconData tabMonitor = PhosphorIconsRegular.chartLineUp;
  static const IconData tabMonitorOn = PhosphorIconsFill.chartLineUp;
}
