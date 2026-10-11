import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/format.dart';
import '../../../core/theme/sx_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../platform/platform.dart';
import '../../../ui/sx_icons.dart';
import '../../device/spec_sheets.dart';
import '../../live/live_data.dart';
import '../test_catalog.dart';
import '../test_frame.dart';
import '../test_results.dart';

typedef AutoResult = (TestStatus, String?);

Future<AutoResult> runWifi(DeviceInfoApi api, AppLocalizations l) async {
  try {
    final n = await api.network();
    if (!n.wifiEnabled) return (TestStatus.skipped, l.nWifiOff);
    if (n.transport == 'wifi') {
      return (TestStatus.passed,
          [l.nConnected, if (n.rssi != null) '${n.rssi} dBm'].join(' · '));
    }
    return (TestStatus.passed, l.nOnNotConnected);
  } catch (_) {
    return (TestStatus.failed, l.nCouldNotRead);
  }
}

Future<AutoResult> runBluetooth(HardwareTestApi hw, AppLocalizations l) async {
  try {
    return switch (await hw.bluetoothState()) {
      'on' => (TestStatus.passed, l.on),
      'off' => (TestStatus.skipped, l.nBluetoothOff),
      _ => (TestStatus.skipped, l.nNoBluetooth),
    };
  } catch (_) {
    return (TestStatus.failed, l.nCouldNotRead);
  }
}

Future<AutoResult> runNfc(DeviceInfoApi api, AppLocalizations l) async {
  try {
    final f = await api.features();
    if (!f.systemFeatures.contains('android.hardware.nfc')) {
      return (TestStatus.skipped, l.nNoNfc);
    }
    if (f.nfcEnabled == false) return (TestStatus.skipped, l.nNfcOff);
    return (TestStatus.passed, l.on);
  } catch (_) {
    return (TestStatus.failed, l.nCouldNotRead);
  }
}

Future<AutoResult> runMobileSignal(DeviceInfoApi api, AppLocalizations l) async {
  try {
    final sim = await api.sim();
    if (sim.simState == 1) return (TestStatus.skipped, l.nNoSim);
    final n = await api.network();
    final level = n.signalLevel;
    if (level == null) return (TestStatus.skipped, l.nNoSignalInfo);
    final note = [?n.operatorName, l.signalBars(level)].join(' · ');
    return (level > 0 ? TestStatus.passed : TestStatus.failed, level > 0 ? note : l.nNoSignal);
  } catch (_) {
    return (TestStatus.failed, l.nCouldNotRead);
  }
}

/// Directory for the storage speed test file. Overridden in tests.
final tempDirProvider =
    Provider<Future<Directory> Function()>((ref) => getTemporaryDirectory);

/// Writes and reads back a 64 MB file in the app's cache, then deletes it.
/// Reads may be served from memory, so the read speed is an upper bound.
Future<AutoResult> runStorageSpeed(AppLocalizations l, Future<Directory> Function() tempDir,
    {int mb = 64}) async {
  final Directory base;
  try {
    base = await tempDir();
  } catch (_) {
    return (TestStatus.failed, l.nStorageError);
  }
  final file = File('${base.path}/systemx_speed_test.bin');
  try {
    final chunk = Uint8List(1 << 20);
    for (var i = 0; i < chunk.length; i += 4096) {
      chunk[i] = i & 0xff;
    }
    final w = Stopwatch()..start();
    final raf = await file.open(mode: FileMode.write);
    for (var i = 0; i < mb; i++) {
      await raf.writeFrom(chunk);
    }
    await raf.flush();
    await raf.close();
    w.stop();

    final r = Stopwatch()..start();
    final read = await file.open();
    final buf = Uint8List(1 << 20);
    var total = 0;
    while (true) {
      final n = await read.readInto(buf);
      if (n == 0) break;
      total += n;
    }
    await read.close();
    r.stop();
    if (total != mb << 20) return (TestStatus.failed, l.nStorageMismatch);

    double rate(Stopwatch s) => mb / (s.elapsedMicroseconds / 1e6).clamp(1e-6, 1e9);
    return (TestStatus.passed, l.nStorageSpeed(rate(w).round(), rate(r).round()));
  } catch (_) {
    return (TestStatus.failed, l.nStorageError);
  } finally {
    try {
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}

class GpsTest extends ConsumerStatefulWidget {
  const GpsTest({super.key, required this.done});
  final TestDone done;

  @override
  ConsumerState<GpsTest> createState() => _GpsTestState();
}

class _GpsTestState extends ConsumerState<GpsTest> {
  StreamSubscription<GnssStatus>? _sub;
  GnssStatus? _status;
  Timer? _timeout;
  bool _finished = false;
  final _clock = Stopwatch()..start();
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    var gotAny = false;
    _sub = ref.read(gnssStatusProvider)().listen(
      (s) {
        gotAny = true;
        if (!mounted) return;
        setState(() => _status = s);
        if (s.accuracy != null && s.used >= 3) {
          _finish(TestStatus.passed,
              AppLocalizations.of(context).nGpsFix(s.used, s.accuracy!.round()));
        }
      },
      onDone: () {
        if (!gotAny && mounted) {
          _finish(TestStatus.skipped, AppLocalizations.of(context).nLocationOff);
        }
      },
      onError: (_) {},
    );
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    _timeout = Timer(const Duration(seconds: 90), () {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      final seen = _status?.seen ?? 0;
      seen > 0
          ? _finish(TestStatus.passed, l.nGpsNoFix(seen))
          : _finish(TestStatus.failed, l.nGpsNone);
    });
  }

  void _finish(TestStatus s, [String? note]) {
    if (_finished) return;
    _finished = true;
    _sub?.cancel();
    _timeout?.cancel();
    _tick?.cancel();
    widget.done(s, note);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timeout?.cancel();
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = _status;
    return TestFrame(
      test: HwTest.gps,
      done: _finish,
      instructions: l.iGps,
      child: WaitingFor(
        icon: SxIcons.gps,
        text: s == null ? l.gpsStarting : l.gpsSatellites(s.seen, s.used),
        detail: [
          if (s?.accuracy != null) '±${s!.accuracy!.round()} m',
          l.secondsElapsed(_clock.elapsed.inSeconds),
        ].join(' · '),
      ),
    );
  }
}

class BiometricTest extends ConsumerStatefulWidget {
  const BiometricTest({super.key, required this.done});
  final TestDone done;

  @override
  ConsumerState<BiometricTest> createState() => _BiometricTestState();
}

class _BiometricTestState extends ConsumerState<BiometricTest> {
  String? _last;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final sec = await ref.read(deviceApiProvider).security();
        if (!mounted) return;
        final l = AppLocalizations.of(context);
        if (sec.biometricStatus == 'no_hardware') {
          widget.done(TestStatus.skipped, l.nNoBiometrics);
        } else if (sec.biometricStatus == 'none_enrolled') {
          widget.done(TestStatus.skipped, l.nNoneEnrolled);
        }
      } catch (_) {}
    });
  }

  Future<void> _start() async {
    final l = AppLocalizations.of(context);
    final r = await ref
        .read(hardwareTestApiProvider)
        .authenticate(l.bioPromptTitle, l.bioPromptSubtitle, l.cancel);
    if (!mounted) return;
    switch (r) {
      case 'success':
        widget.done(TestStatus.passed, l.nRecognised);
      case 'unavailable':
        widget.done(TestStatus.skipped, l.nNoBiometrics);
      case 'none_enrolled':
        widget.done(TestStatus.skipped, l.nNoneEnrolled);
      default:
        setState(() => _last = r);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TestFrame(
      test: HwTest.biometrics,
      done: widget.done,
      instructions: l.iBiometrics,
      bottom: Column(mainAxisSize: MainAxisSize.min, children: [
        FilledButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.fingerprint_rounded),
          label: Text(_last == null ? l.start : l.tryAgain),
        ),
        if (_last != null) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => widget.done(TestStatus.failed, l.nNotRecognised),
            child: Text(l.itDoesntWork),
          ),
        ],
      ]),
      child: WaitingFor(
        icon: SxIcons.fingerprint,
        text: l.bioNoDataNote,
      ),
    );
  }
}

/// Waits for a charger, then measures the charge current for a few seconds.
class ChargingTest extends ConsumerStatefulWidget {
  const ChargingTest({super.key, required this.done});
  final TestDone done;

  @override
  ConsumerState<ChargingTest> createState() => _ChargingTestState();
}

class _ChargingTestState extends ConsumerState<ChargingTest> {
  DateTime? _pluggedAt;
  int _peak = 0;
  bool _finished = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // The live monitor's timer may be off (tests), so poll here too.
    _timer = Timer.periodic(const Duration(seconds: 1),
        (_) => ref.read(liveProvider.notifier).tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onLive(LiveStats? s) {
    if (s == null || _finished) return;
    final l = AppLocalizations.of(context);
    if (s.plugged == 0) {
      _pluggedAt = null;
      return;
    }
    _pluggedAt ??= DateTime.now();
    final ma = s.currentNowMa;
    if (ma != null && ma > _peak) _peak = ma;
    if (DateTime.now().difference(_pluggedAt!) >= const Duration(seconds: 5)) {
      _finished = true;
      _timer?.cancel();
      final source = SpecBuilder(l).powerSource(s.plugged);
      widget.done(
        TestStatus.passed,
        _peak > 0 ? l.nChargingPeak(source, _peak) : l.nChargingDetected(source),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(liveProvider.select((x) => x.latest));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onLive(s);
    });
    final plugged = s != null && s.plugged != 0;
    return TestFrame(
      test: HwTest.charging,
      done: widget.done,
      instructions: l.iCharging,
      bottom: OutlinedButton(
        onPressed: () => widget.done(TestStatus.skipped, l.nNoCharger),
        child: Text(l.noChargerAtHand),
      ),
      child: WaitingFor(
        icon: SxIcons.charging,
        color: plugged ? context.sx.battery : null,
        text: plugged ? l.measuring : l.waitingForCharger,
        detail: plugged && s.currentNowMa != null
            ? '${s.currentNowMa} mA · ${formatDouble(s.currentNowMa!.abs() * s.voltageMv / 1e6)} W'
            : null,
      ),
    );
  }
}
