import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/sx_colors.dart';
import '../../../core/theme/sx_type.dart';
import '../../../l10n/app_localizations.dart';
import '../../../platform/platform.dart';
import '../../../ui/widgets/gauges.dart';
import '../test_catalog.dart';
import '../test_frame.dart';
import '../test_results.dart';

/// Sensor.TYPE_* used by the tests.
abstract final class SensorType {
  static const accelerometer = 1;
  static const magnetic = 2;
  static const gyroscope = 4;
  static const light = 5;
  static const pressure = 6;
  static const proximity = 8;
}

int sensorTypeFor(HwTest t) => switch (t) {
      HwTest.accelerometer => SensorType.accelerometer,
      HwTest.gyroscope => SensorType.gyroscope,
      HwTest.compass => SensorType.magnetic,
      HwTest.proximity => SensorType.proximity,
      HwTest.light => SensorType.light,
      HwTest.barometer => SensorType.pressure,
      _ => throw ArgumentError(t),
    };

/// Whether the phone has a sensor of [type].
Future<SensorInfo?> findSensor(DeviceInfoApi api, int type) async {
  try {
    final list = await api.sensors();
    return list.where((s) => s.type == type).firstOrNull;
  } catch (_) {
    return null;
  }
}

/// Tracks progress through a sensor challenge. Pure, so it is unit tested.
class SensorChallenge {
  SensorChallenge(this.test);
  final HwTest test;

  double progress = 0;
  bool get done => progress >= 1;

  // Accelerometer: the ball and the corners it has reached.
  double ballX = 0, ballY = 0;
  final corners = <int>{};

  // Gyroscope: total rotation in radians.
  double rotated = 0;
  int? _lastMs;

  // Compass: headings seen, in 30° buckets.
  final headings = <int>{};
  double? heading;

  // Proximity: covered, then uncovered.
  bool covered = false;
  double? maxRange;

  // Light: lowest and highest lux.
  double? minLux, maxLux;

  /// Feeds one reading taken at [ms].
  void add(List<double> v, int ms) {
    if (v.isEmpty) return;
    switch (test) {
      case HwTest.accelerometer when v.length >= 2:
        // Tilt moves the ball; screen x is opposite the sensor's x.
        ballX = (ballX - v[0] / 9.81 * 0.08).clamp(-1.0, 1.0);
        ballY = (ballY + v[1] / 9.81 * 0.08).clamp(-1.0, 1.0);
        if (ballX.abs() > 0.85 && ballY.abs() > 0.85) {
          corners.add((ballX > 0 ? 1 : 0) + (ballY > 0 ? 2 : 0));
        }
        progress = corners.length / 4;
      case HwTest.gyroscope when v.length >= 3:
        final last = _lastMs;
        _lastMs = ms;
        if (last != null) {
          final dt = ((ms - last) / 1000).clamp(0.0, 0.5);
          final speed = math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
          if (speed > 0.3) rotated += speed * dt; // ignore drift
        }
        progress = (rotated / (2 * math.pi)).clamp(0.0, 1.0);
      case HwTest.compass when v.length >= 2:
        final strength = math.sqrt(v.take(3).fold(0.0, (s, x) => s + x * x));
        if (strength < 10 || strength > 200) return;
        final h = (math.atan2(v[1], v[0]) * 180 / math.pi + 360) % 360;
        heading = h;
        headings.add(h ~/ 30);
        progress = (headings.length / 8).clamp(0.0, 1.0);
      case HwTest.proximity:
        final range = maxRange ?? 5;
        final near = v[0] < range * 0.5;
        if (near) covered = true;
        progress = covered ? (near ? 0.5 : 1) : 0;
      case HwTest.light:
        final lux = v[0];
        minLux = minLux == null ? lux : math.min(minLux!, lux);
        maxLux = maxLux == null ? lux : math.max(maxLux!, lux);
        final lo = math.max(minLux!, 1), hi = maxLux!;
        progress = ((hi / lo) / 4).clamp(0.0, 1.0);
        if (hi - minLux! < 5) progress = math.min(progress, 0.5);
      default:
    }
  }
}

class SensorTest extends ConsumerStatefulWidget {
  const SensorTest({super.key, required this.test, required this.done});
  final HwTest test;
  final TestDone done;

  @override
  ConsumerState<SensorTest> createState() => _SensorTestState();
}

class _SensorTestState extends ConsumerState<SensorTest> {
  late final SensorChallenge _c = SensorChallenge(widget.test);
  StreamSubscription<List<double>>? _sub;
  final _clock = Stopwatch()..start();
  bool _finished = false;
  List<double>? _last;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final type = sensorTypeFor(widget.test);
    final info = await findSensor(ref.read(deviceApiProvider), type);
    if (!mounted) return;
    if (info == null) {
      _finish(TestStatus.skipped, AppLocalizations.of(context).nNoSensor);
      return;
    }
    _c.maxRange = info.maxRange;
    _sub = ref.read(sensorReadingsProvider)(type).listen((v) {
      if (!mounted || _finished) return;
      setState(() {
        _last = v;
        _c.add(v, _clock.elapsedMilliseconds);
      });
      if (_c.done) _finish(TestStatus.passed, _passNote());
    });
  }

  String _passNote() {
    final l = AppLocalizations.of(context);
    return switch (widget.test) {
      HwTest.light => l.nLuxRange(_c.minLux!.round(), _c.maxLux!.round()),
      _ => l.nSensorResponds,
    };
  }

  void _finish(TestStatus s, [String? note]) {
    if (_finished) return;
    _finished = true;
    _sub?.cancel();
    widget.done(s, note);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final instructions = switch (widget.test) {
      HwTest.accelerometer => l.iAccelerometer,
      HwTest.gyroscope => l.iGyroscope,
      HwTest.compass => l.iCompass,
      HwTest.proximity => l.iProximity,
      HwTest.light => l.iLight,
      _ => '',
    };

    final Widget visual = switch (widget.test) {
      HwTest.accelerometer => _BallBoard(c: _c),
      HwTest.compass => Center(
          child: Transform.rotate(
            angle: -(_c.heading ?? 0) * math.pi / 180,
            child: Icon(Icons.navigation_rounded, size: 140, color: sx.sensors),
          ),
        ),
      _ => Center(
          child: GaugeRing(
            value: _c.progress,
            color: sx.sensors,
            size: 180,
            stroke: 14,
            child: Text(
              _last == null ? '–' : _last!.first.toStringAsFixed(1),
              style: SxText.readout(28, sx.ink),
            ),
          ),
        ),
    };

    return TestFrame(
      test: widget.test,
      done: _finish,
      instructions: instructions,
      bottom: Column(mainAxisSize: MainAxisSize.min, children: [
        MeterBar(value: _c.progress, color: sx.sensors),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _finish(TestStatus.failed, l.nSensorNoResponse),
          child: Text(l.sensorNotResponding),
        ),
      ]),
      child: visual,
    );
  }
}

class _BallBoard extends StatelessWidget {
  const _BallBoard({required this.c});
  final SensorChallenge c;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return LayoutBuilder(builder: (context, box) {
      final w = box.maxWidth, h = box.maxHeight;
      Widget corner(int i, Alignment a) => Align(
            alignment: a,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.corners.contains(i) ? sx.good : sx.cardAlt,
              ),
            ),
          );
      return Container(
        decoration: BoxDecoration(color: sx.card, borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(12),
        child: Stack(children: [
          corner(0, Alignment.topLeft),
          corner(1, Alignment.topRight),
          corner(2, Alignment.bottomLeft),
          corner(3, Alignment.bottomRight),
          Positioned(
            left: (c.ballX + 1) / 2 * (w - 24 - 36),
            top: (c.ballY + 1) / 2 * (h - 24 - 36),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(shape: BoxShape.circle, color: sx.sensors),
            ),
          ),
        ]),
      );
    });
  }
}

/// Automatic: one plausible air pressure reading within 5 seconds.
Future<(TestStatus, String?)> runBarometer(
    DeviceInfoApi api, Stream<List<double>> Function(int) readings, AppLocalizations l) async {
  if (await findSensor(api, SensorType.pressure) == null) {
    return (TestStatus.skipped, l.nNoSensor);
  }
  try {
    final v = await readings(SensorType.pressure)
        .firstWhere((v) => v.isNotEmpty)
        .timeout(const Duration(seconds: 5));
    final hpa = v.first;
    if (hpa >= 300 && hpa <= 1100) return (TestStatus.passed, '${hpa.round()} hPa');
    return (TestStatus.failed, l.nImplausible('${hpa.round()} hPa'));
  } on TimeoutException {
    return (TestStatus.failed, l.nSensorNoResponse);
  } catch (_) {
    return (TestStatus.failed, l.nSensorNoResponse);
  }
}
