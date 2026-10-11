import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/widgets/cards.dart';
import 'impl/audio_tests.dart';
import 'impl/camera_tests.dart';
import 'impl/display_tests.dart';
import 'impl/sensor_tests.dart';
import 'impl/system_tests.dart';
import 'test_catalog.dart';
import 'test_frame.dart';
import 'test_results.dart';

/// The screen for an interactive test.
Widget buildInteractiveTest(HwTest t, TestDone done) => switch (t) {
      HwTest.deadPixels => DeadPixelsTest(done: done),
      HwTest.colorBanding => ColorBandingTest(done: done),
      HwTest.burnIn => BurnInTest(done: done),
      HwTest.touchGrid => TouchGridTest(done: done),
      HwTest.multiTouch => MultiTouchTest(done: done),
      HwTest.brightness => BrightnessTest(done: done),
      HwTest.speaker || HwTest.earpiece => ToneTest(test: t, done: done),
      HwTest.microphone => MicrophoneTest(done: done),
      HwTest.headphones || HwTest.usbAudio => AudioOutputTest(test: t, done: done),
      HwTest.vibration => VibrationTest(done: done),
      HwTest.volumeUp || HwTest.volumeDown => VolumeKeyTest(test: t, done: done),
      HwTest.rearCamera || HwTest.frontCamera => CameraTest(test: t, done: done),
      HwTest.flashlight => FlashlightTest(done: done),
      HwTest.accelerometer ||
      HwTest.gyroscope ||
      HwTest.compass ||
      HwTest.proximity ||
      HwTest.light =>
        SensorTest(test: t, done: done),
      HwTest.gps => GpsTest(done: done),
      HwTest.biometrics => BiometricTest(done: done),
      HwTest.charging => ChargingTest(done: done),
      _ => throw ArgumentError('$t is automatic'),
    };

/// Runs an automatic test.
Future<AutoResult> runAutomaticTest(HwTest t, WidgetRef ref, AppLocalizations l) {
  final api = ref.read(deviceApiProvider);
  final hw = ref.read(hardwareTestApiProvider);
  return switch (t) {
    HwTest.speakerMicLoop => runSpeakerMicLoop(hw, l),
    HwTest.barometer => runBarometer(api, ref.read(sensorReadingsProvider), l),
    HwTest.wifi => runWifi(api, l),
    HwTest.bluetooth => runBluetooth(hw, l),
    HwTest.nfc => runNfc(api, l),
    HwTest.mobileSignal => runMobileSignal(api, l),
    HwTest.storageSpeed => runStorageSpeed(l, ref.read(tempDirProvider)),
    _ => throw ArgumentError('$t is interactive'),
  };
}

/// Asks for the test's permission (with an explanation) if it needs one.
/// Returns a skipped result when the user declines.
Future<TestResult?> ensureTestPermission(
    BuildContext context, WidgetRef ref, HwTest t) async {
  final p = t.permission;
  if (p == null) return null;
  final l = AppLocalizations.of(context);
  final granted = await requestPermission(context, ref, p);
  if (granted) return null;
  return TestResult(t, TestStatus.skipped, note: l.nPermissionDenied, at: DateTime.now());
}

/// Runs one test, permission first, and reports its result once.
class TestRunner extends ConsumerStatefulWidget {
  const TestRunner({super.key, required this.test, required this.onResult});

  final HwTest test;
  final void Function(TestResult result) onResult;

  @override
  ConsumerState<TestRunner> createState() => _TestRunnerState();
}

class _TestRunnerState extends ConsumerState<TestRunner> {
  bool _ready = false;
  bool _reported = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
  }

  Future<void> _prepare() async {
    final skipped = await ensureTestPermission(context, ref, widget.test);
    if (!mounted) return;
    if (skipped != null) return _report(skipped);
    if (widget.test.automatic) {
      final l = AppLocalizations.of(context);
      final (s, note) = await runAutomaticTest(widget.test, ref, l);
      if (mounted) _done(s, note);
      return;
    }
    setState(() => _ready = true);
  }

  void _done(TestStatus s, [String? note]) =>
      _report(TestResult(widget.test, s, note: note, at: DateTime.now()));

  void _report(TestResult r) {
    if (_reported) return;
    _reported = true;
    widget.onResult(r);
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return buildInteractiveTest(widget.test, _done);
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.test.title(l))),
      body: WaitingFor(
        icon: widget.test.icon,
        color: widget.test.color(context.sx),
        text: widget.test.automatic ? l.testingAutomatically : '',
      ),
    );
  }
}

/// Outcome of a single test, with options to retry or finish.
class ResultView extends StatelessWidget {
  const ResultView({super.key, required this.result, required this.onDone, required this.onRetry});

  final TestResult result;
  final VoidCallback onDone;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final (icon, color, word) = statusLook(context, result.status);
    return Scaffold(
      appBar: AppBar(title: Text(result.test.title(l))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            Icon(icon, size: 88, color: color),
            const SizedBox(height: 16),
            Text(word, style: context.text.headlineMedium),
            if (result.note != null) ...[
              const SizedBox(height: 8),
              Text(result.note!,
                  textAlign: TextAlign.center,
                  style: context.text.bodyLarge?.copyWith(color: sx.muted)),
            ],
            if (result.status == TestStatus.failed && fixHint(l, result.test) != null) ...[
              const SizedBox(height: 16),
              SxCard(
                color: sx.cardAlt,
                child: Text(fixHint(l, result.test)!, style: context.text.bodyMedium),
              ),
            ],
            const Spacer(),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: onRetry, child: Text(l.testAgain))),
              const SizedBox(width: 12),
              Expanded(child: FilledButton(onPressed: onDone, child: Text(l.done))),
            ]),
          ]),
        ),
      ),
    );
  }
}

/// Icon, color and word for a status. Never color alone.
(IconData, Color, String) statusLook(BuildContext context, TestStatus s) {
  final l = AppLocalizations.of(context);
  final sx = context.sx;
  return switch (s) {
    TestStatus.passed => (Icons.check_circle_rounded, sx.good, l.statusPassed),
    TestStatus.failed => (Icons.cancel_rounded, sx.bad, l.statusFailed),
    TestStatus.skipped => (Icons.remove_circle_rounded, sx.muted, l.statusSkipped),
    TestStatus.notRun => (Icons.circle_outlined, sx.muted, l.statusNotRun),
  };
}

/// What to try when a test fails.
String? fixHint(AppLocalizations l, HwTest t) => switch (t.group) {
      TestGroup.display => l.fixDisplay,
      TestGroup.audio => t == HwTest.headphones || t == HwTest.usbAudio
          ? l.fixConnector
          : l.fixAudio,
      TestGroup.haptics => l.fixHaptics,
      TestGroup.cameras => l.fixCamera,
      TestGroup.sensors => l.fixSensor,
      TestGroup.connectivity => l.fixConnectivity,
      TestGroup.biometrics => l.fixBiometrics,
      TestGroup.power => t == HwTest.charging ? l.fixCharging : l.fixStorage,
    };
