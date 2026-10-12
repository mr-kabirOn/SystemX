import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../platform/platform.dart';
import '../../../ui/sx_icons.dart';
import '../test_catalog.dart';
import '../test_frame.dart';
import '../test_results.dart';

/// Plays a tone (speaker or earpiece), then asks whether it was heard.
class ToneTest extends ConsumerStatefulWidget {
  const ToneTest({super.key, required this.test, required this.done})
      : assert(test == HwTest.speaker || test == HwTest.earpiece);
  final HwTest test;
  final TestDone done;

  @override
  ConsumerState<ToneTest> createState() => _ToneTestState();
}

class _ToneTestState extends ConsumerState<ToneTest> {
  bool _playing = false;
  bool _played = false;
  bool get _earpiece => widget.test == HwTest.earpiece;

  Future<void> _play() async {
    setState(() => _playing = true);
    try {
      await ref.read(hardwareTestApiProvider).playTone(_earpiece ? 440 : 1000, 1500, _earpiece);
    } catch (_) {}
    if (mounted) {
      setState(() {
        _playing = false;
        _played = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_earpiece) WidgetsBinding.instance.addPostFrameCallback((_) => _play());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TestFrame(
      test: widget.test,
      done: widget.done,
      instructions: _earpiece ? l.iEarpiece : l.iSpeaker,
      bottom: _played
          ? AskResult(
              question: l.qHeardTone,
              done: widget.done,
              passNote: l.nToneHeard,
              failNote: l.nToneNotHeard,
              extra: TextButton(onPressed: _playing ? null : _play, child: Text(l.playAgain)),
            )
          : FilledButton.icon(
              onPressed: _playing ? null : _play,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l.playTone),
            ),
      child: WaitingFor(
        icon: _earpiece ? SxIcons.earpiece : SxIcons.speaker,
        text: _playing ? l.playing : (_earpiece ? l.holdToEar : l.listen),
      ),
    );
  }
}

class MicrophoneTest extends ConsumerStatefulWidget {
  const MicrophoneTest({super.key, required this.done});
  final TestDone done;

  @override
  ConsumerState<MicrophoneTest> createState() => _MicrophoneTestState();
}

enum _MicStep { ready, recording, playing, ask }

class _MicrophoneTestState extends ConsumerState<MicrophoneTest> {
  _MicStep _step = _MicStep.ready;
  double? _peak;

  Future<void> _record() async {
    final hw = ref.read(hardwareTestApiProvider);
    setState(() => _step = _MicStep.recording);
    try {
      _peak = await hw.recordClip(3000);
      if (!mounted) return;
      setState(() => _step = _MicStep.playing);
      await hw.playClip();
    } catch (_) {
      if (mounted) {
        widget.done(TestStatus.failed, AppLocalizations.of(context).nMicError);
      }
      return;
    }
    if (mounted) setState(() => _step = _MicStep.ask);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final peak = _peak;
    final quiet = peak != null && peak < -50;
    final note = peak == null ? null : l.nPeakLevel(peak.round());
    return TestFrame(
      test: HwTest.microphone,
      done: widget.done,
      instructions: l.iMicrophone,
      bottom: switch (_step) {
        _MicStep.ready => FilledButton.icon(
            onPressed: _record,
            icon: const Icon(Icons.mic_rounded),
            label: Text(l.record3s),
          ),
        _MicStep.ask => AskResult(
            question: l.qHeardVoice,
            done: widget.done,
            passNote: note,
            failNote: quiet ? '${l.nVeryQuiet} · $note' : note,
            extra: TextButton(onPressed: _record, child: Text(l.recordAgain)),
          ),
        _ => const SizedBox(height: 48),
      },
      child: WaitingFor(
        icon: SxIcons.mic,
        text: switch (_step) {
          _MicStep.ready => l.speakAfterTap,
          _MicStep.recording => l.recording,
          _MicStep.playing => l.playingBack,
          _MicStep.ask => quiet ? l.nVeryQuiet : l.listen,
        },
        detail: note,
      ),
    );
  }
}

/// Automatic: plays a tone and checks the microphone hears it.
Future<(TestStatus, String?)> runSpeakerMicLoop(
    HardwareTestApi hw, AppLocalizations l) async {
  try {
    final gain = await hw.loopback(1000);
    if (gain >= 10) return (TestStatus.passed, l.nLoopOk(gain.round()));
    return (TestStatus.failed, l.nLoopFail);
  } catch (_) {
    return (TestStatus.skipped, l.nMicError);
  }
}

/// Waits for an audio output (wired headphones or USB audio) to appear.
class AudioOutputTest extends ConsumerStatefulWidget {
  const AudioOutputTest({super.key, required this.test, required this.done})
      : assert(test == HwTest.headphones || test == HwTest.usbAudio);
  final HwTest test;
  final TestDone done;

  @override
  ConsumerState<AudioOutputTest> createState() => _AudioOutputTestState();
}

class _AudioOutputTestState extends ConsumerState<AudioOutputTest> {
  Timer? _timer;
  bool _finished = false;

  String get _wanted => widget.test == HwTest.headphones ? 'Wired headphones' : 'USB audio';

  @override
  void initState() {
    super.initState();
    _check();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _check());
  }

  Future<void> _check() async {
    try {
      final media = await ref.read(deviceApiProvider).media();
      if (!mounted || _finished) return;
      if (media.audioOutputs.contains(_wanted)) {
        _finished = true;
        _timer?.cancel();
        widget.done(TestStatus.passed, AppLocalizations.of(context).nDetected);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final headphones = widget.test == HwTest.headphones;
    return TestFrame(
      test: widget.test,
      done: widget.done,
      instructions: headphones ? l.iHeadphones : l.iUsbAudio,
      bottom: OutlinedButton(
        onPressed: () => widget.done(TestStatus.skipped,
            headphones ? l.nNoHeadphones : l.nNoUsbAudio),
        child: Text(headphones ? l.noHeadphonesAtHand : l.noUsbAudioAtHand),
      ),
      child: WaitingFor(
        icon: widget.test.icon,
        text: l.waitingToConnect,
      ),
    );
  }
}

class VibrationTest extends ConsumerStatefulWidget {
  const VibrationTest({super.key, required this.done});
  final TestDone done;

  @override
  ConsumerState<VibrationTest> createState() => _VibrationTestState();
}

class _VibrationTestState extends ConsumerState<VibrationTest> {
  void _buzz() => ref.read(hardwareTestApiProvider).vibrate([400, 200, 400, 200, 800]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final has = await ref.read(hardwareTestApiProvider).hasVibrator();
      if (!mounted) return;
      if (!has) {
        widget.done(TestStatus.skipped, AppLocalizations.of(context).nNoVibrator);
      } else {
        _buzz();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TestFrame(
      test: HwTest.vibration,
      done: widget.done,
      instructions: l.iVibration,
      bottom: AskResult(
        question: l.qFeltVibration,
        done: widget.done,
        passNote: l.nVibrationOk,
        failNote: l.nVibrationBad,
        extra: TextButton(onPressed: _buzz, child: Text(l.vibrateAgain)),
      ),
      child: WaitingFor(icon: SxIcons.vibration, text: l.holdPhone),
    );
  }
}

/// Passes when the volume button is pressed. Presses are captured natively
/// (Android hands volume keys to the system first) and don't change the
/// volume while the test runs; Flutter key events are a fallback.
class VolumeKeyTest extends ConsumerStatefulWidget {
  const VolumeKeyTest({super.key, required this.test, required this.done})
      : assert(test == HwTest.volumeUp || test == HwTest.volumeDown);
  final HwTest test;
  final TestDone done;

  @override
  ConsumerState<VolumeKeyTest> createState() => _VolumeKeyTestState();
}

class _VolumeKeyTestState extends ConsumerState<VolumeKeyTest> {
  bool _finished = false;
  StreamSubscription<String>? _sub;

  bool get _up => widget.test == HwTest.volumeUp;

  LogicalKeyboardKey get _key =>
      _up ? LogicalKeyboardKey.audioVolumeUp : LogicalKeyboardKey.audioVolumeDown;

  void _pressed() {
    if (_finished || !mounted) return;
    _finished = true;
    HapticFeedback.mediumImpact();
    widget.done(TestStatus.passed, AppLocalizations.of(context).nButtonWorks);
  }

  bool _onKey(KeyEvent e) {
    if (e.logicalKey != _key) return false;
    if (e is KeyDownEvent) _pressed();
    return true;
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
    _sub = ref.read(volumeKeysProvider)().listen((k) {
      if (k == (_up ? 'up' : 'down')) _pressed();
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _sub?.cancel();
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final up = widget.test == HwTest.volumeUp;
    return TestFrame(
      test: widget.test,
      done: widget.done,
      instructions: up ? l.iVolumeUp : l.iVolumeDown,
      bottom: OutlinedButton(
        onPressed: () => widget.done(TestStatus.failed, l.nButtonNoResponse),
        child: Text(l.buttonDoesNothing),
      ),
      child: WaitingFor(icon: widget.test.icon, text: l.pressTheButton),
    );
  }
}
