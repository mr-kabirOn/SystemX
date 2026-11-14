import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../../ui/widgets/page_scaffold.dart';

// Android Sensor.TYPE_* constants.
const _accelerometer = 1;
const _magnetic = 2;
const _light = 5;
const _rotationVector = 11;

// ---- Pure helpers (unit tested) ----

/// Tilt in degrees around the phone's x and y axes from gravity; 0, 0 when
/// lying flat.
(double, double) tiltDegrees(double ax, double ay, double az) {
  const toDeg = 180 / math.pi;
  return (math.atan2(ax, az) * toDeg, math.atan2(ay, az) * toDeg);
}

/// Heading in degrees from magnetic north (0–360) from a rotation vector
/// sensor event [x, y, z, (w)], as SensorManager.getOrientation computes it.
double azimuthFromRotationVector(List<double> v) {
  final x = v[0], y = v[1], z = v[2];
  final w = v.length > 3 ? v[3] : math.sqrt(math.max(0, 1 - x * x - y * y - z * z));
  final r1 = 2 * x * y - 2 * z * w;
  final r4 = 1 - 2 * x * x - 2 * z * z;
  final deg = math.atan2(r1, r4) * 180 / math.pi;
  return (deg + 360) % 360;
}

/// Eight-point compass name for [deg].
String compassPoint(double deg) =>
    const ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'][((deg + 22.5) % 360 ~/ 45)];

/// Phone microphones typically clip around 90–100 dB SPL, so full scale is
/// taken as 94 dB. Uncalibrated: a guide, not a measurement.
int approxSpl(double dbfs) => (dbfs + 94).clamp(20, 130).round();

String lightBand(AppLocalizations l, double lux) => lux < 10
    ? l.lightDark
    : lux < 100
        ? l.lightDim
        : lux < 1000
            ? l.lightIndoor
            : lux < 20000
                ? l.lightBright
                : l.lightSun;

String soundBand(AppLocalizations l, int db) => db < 45
    ? l.soundQuiet
    : db < 70
        ? l.soundModerate
        : db < 85
            ? l.soundLoud
            : l.soundVeryLoud;

double fieldStrength(List<double> v) => math.sqrt(v.take(3).fold(0.0, (s, x) => s + x * x));

// ---- Sensor plumbing ----

/// Listens to one sensor while the tool is open. [values] is null until the
/// first reading; [missing] when the phone has no such sensor.
mixin _SensorTool<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  int get sensorType;
  StreamSubscription<List<double>>? _sub;
  List<double>? values;
  bool missing = false;

  @override
  void initState() {
    super.initState();
    _sub = ref.read(sensorReadingsProvider)(sensorType).listen(
      (v) {
        if (mounted && v.isNotEmpty) setState(() => values = v);
      },
      onDone: () {
        if (mounted && values == null) setState(() => missing = true);
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Page frame shared by the tools: title, a hint and the content.
class _ToolPage extends StatelessWidget {
  const _ToolPage({required this.title, required this.hint, required this.child, this.missing = false});

  final String title;
  final String hint;
  final Widget child;
  final bool missing;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return PageScaffold(
      title: title,
      leading: const BackButton(),
      slivers: [
        Box(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(hint, style: context.text.bodyMedium?.copyWith(color: sx.muted)),
        )),
        Box(missing
            ? SxCard(child: Text(l.mtNoSensor, style: context.text.bodyLarge))
            : child),
      ],
    );
  }
}

Widget _readout(BuildContext context, String value, String unit, {String? caption, Color? color}) {
  final sx = context.sx;
  return Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic, children: [
      Text(value, style: SxText.readout(56, color ?? sx.ink, weight: FontWeight.w600)),
      const SizedBox(width: 6),
      Text(unit, style: SxText.readout(18, sx.muted)),
    ]),
    if (caption != null) ...[
      const SizedBox(height: 4),
      Text(caption, style: context.text.titleMedium?.copyWith(color: color ?? sx.ink)),
    ],
  ]);
}

// ---- Bubble level ----

class LevelScreen extends ConsumerStatefulWidget {
  const LevelScreen({super.key});

  @override
  ConsumerState<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends ConsumerState<LevelScreen> with _SensorTool {
  @override
  int get sensorType => _accelerometer;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final v = values;
    final (x, y) = v == null || v.length < 3 ? (0.0, 0.0) : tiltDegrees(v[0], v[1], v[2]);
    final level = v != null && x.abs() < 1 && y.abs() < 1;
    final color = level ? sx.good : sx.accent;
    return _ToolPage(
      title: l.mtLevel,
      hint: l.mtLevelHint,
      missing: missing,
      child: SxCard(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(builder: (context, c) {
              final r = c.maxWidth / 2;
              // 20° of tilt moves the bubble to the edge. It floats to the
              // higher side: +x means the left edge is lower, +y the bottom.
              final dx = (x / 20).clamp(-1.0, 1.0) * (r - 28);
              final dy = (-y / 20).clamp(-1.0, 1.0) * (r - 28);
              return Stack(alignment: Alignment.center, children: [
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sx.line, width: 2)),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sx.muted, width: 1.5)),
                ),
                Transform.translate(
                  offset: Offset(dx, dy),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.85)),
                  ),
                ),
              ]);
            }),
          ),
          const SizedBox(height: 16),
          Text(
            level ? l.mtLevelOk : 'X ${x.toStringAsFixed(1)}°   Y ${y.toStringAsFixed(1)}°',
            style: SxText.readout(22, level ? sx.good : sx.ink, weight: FontWeight.w600),
          ),
        ]),
      ),
    );
  }
}

// ---- Compass ----

class CompassScreen extends ConsumerStatefulWidget {
  const CompassScreen({super.key});

  @override
  ConsumerState<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends ConsumerState<CompassScreen> with _SensorTool {
  @override
  int get sensorType => _rotationVector;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final v = values;
    final heading = v == null || v.length < 3 ? null : azimuthFromRotationVector(v);
    return _ToolPage(
      title: l.mtCompass,
      hint: l.mtCompassHint,
      missing: missing,
      child: SxCard(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(alignment: Alignment.center, children: [
              Transform.rotate(
                angle: -(heading ?? 0) * math.pi / 180,
                child: CustomPaint(size: Size.infinite, painter: _DialPainter(sx)),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Icon(Icons.arrow_drop_down_rounded, size: 44, color: sx.accent),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          _readout(context, heading == null ? '–' : '${heading.round()}', '°',
              caption: heading == null ? null : compassPoint(heading)),
          const SizedBox(height: 12),
          Text(l.mtCompassCalibrate, textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(color: sx.muted)),
        ]),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter(this.sx);
  final SxColors sx;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 8;
    canvas.drawCircle(c, r, Paint()..color = sx.line..style = PaintingStyle.stroke..strokeWidth = 2);
    for (var i = 0; i < 72; i++) {
      final a = i * 5 * math.pi / 180;
      final major = i % 6 == 0;
      final inner = r - (major ? 16 : 8);
      final dir = Offset(math.sin(a), -math.cos(a));
      canvas.drawLine(c + dir * inner, c + dir * r,
          Paint()..color = major ? sx.ink : sx.muted..strokeWidth = major ? 2.5 : 1.2);
    }
    for (final (i, label) in ['N', 'E', 'S', 'W'].indexed) {
      final a = i * math.pi / 2;
      final dir = Offset(math.sin(a), -math.cos(a));
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
              fontFamily: SxFonts.body, color: i == 0 ? sx.bad : sx.ink, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c + dir * (r - 36) - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_DialPainter old) => old.sx != sx;
}

// ---- Light meter ----

class LightMeterScreen extends ConsumerStatefulWidget {
  const LightMeterScreen({super.key});

  @override
  ConsumerState<LightMeterScreen> createState() => _LightMeterScreenState();
}

class _LightMeterScreenState extends ConsumerState<LightMeterScreen> with _SensorTool {
  @override
  int get sensorType => _light;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final lux = values?.first;
    return _ToolPage(
      title: l.mtLight,
      hint: l.mtLightHint,
      missing: missing,
      child: SxCard(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          _readout(context, lux == null ? '–' : '${lux.round()}', 'lx',
              caption: lux == null ? null : lightBand(l, lux), color: sx.display),
          const SizedBox(height: 18),
          // Log scale: 1 lx to 100,000 lx.
          MeterBar(value: lux == null ? 0 : (math.log(lux + 1) / math.log(100001)).clamp(0.0, 1.0), color: sx.display),
        ]),
      ),
    );
  }
}

// ---- Magnetic field ----

class MagnetScreen extends ConsumerStatefulWidget {
  const MagnetScreen({super.key});

  @override
  ConsumerState<MagnetScreen> createState() => _MagnetScreenState();
}

class _MagnetScreenState extends ConsumerState<MagnetScreen> with _SensorTool {
  @override
  int get sensorType => _magnetic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final v = values;
    final ut = v == null || v.length < 3 ? null : fieldStrength(v);
    final high = ut != null && ut > 100;
    return _ToolPage(
      title: l.mtMagnet,
      hint: l.mtMagnetHint,
      missing: missing,
      child: SxCard(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          _readout(context, ut == null ? '–' : '${ut.round()}', 'µT',
              caption: ut == null ? null : (high ? l.mtMagnetHigh : l.mtMagnetNormal),
              color: high ? sx.warn : sx.ink),
          const SizedBox(height: 18),
          MeterBar(value: ut == null ? 0 : (ut / 300).clamp(0.0, 1.0), color: high ? sx.warn : sx.accent),
        ]),
      ),
    );
  }
}

// ---- Sound meter ----

class SoundMeterScreen extends ConsumerStatefulWidget {
  const SoundMeterScreen({super.key});

  @override
  ConsumerState<SoundMeterScreen> createState() => _SoundMeterScreenState();
}

class _SoundMeterScreenState extends ConsumerState<SoundMeterScreen> {
  StreamSubscription<double>? _sub;
  int? _now;
  int? _max;
  double _sum = 0;
  int _count = 0;
  bool _needsMic = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    if (!mounted) return;
    if (!await requestPermission(context, ref, AppPermission.microphone)) {
      if (mounted) setState(() => _needsMic = true);
      return;
    }
    if (!mounted) return;
    setState(() => _needsMic = false);
    await _sub?.cancel();
    _sub = ref.read(soundLevelsProvider)().listen((dbfs) {
      if (!mounted) return;
      final db = approxSpl(dbfs);
      setState(() {
        _now = db;
        _max = math.max(_max ?? db, db);
        _sum += db;
        _count++;
      });
    });
  }

  void _reset() => setState(() {
        _max = _now;
        _sum = 0;
        _count = 0;
      });

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final now = _now;
    final color = now == null
        ? sx.ink
        : now >= 85
            ? sx.bad
            : now >= 70
                ? sx.warn
                : sx.good;
    return _ToolPage(
      title: l.mtSound,
      hint: l.mtSoundHint,
      child: _needsMic
          ? SxCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.mtNoMic, style: context.text.bodyLarge),
                const SizedBox(height: 12),
                FilledButton(onPressed: _start, child: Text(l.mtStart)),
              ]),
            )
          : SxCard(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                _readout(context, now == null ? '–' : '$now', 'dB',
                    caption: now == null ? null : soundBand(l, now), color: color),
                const SizedBox(height: 18),
                MeterBar(value: now == null ? 0 : ((now - 20) / 100).clamp(0.0, 1.0), color: color),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: Text(_max == null ? '' : l.mtSoundMax(_max!), style: context.text.bodyMedium)),
                  Expanded(
                    child: Text(_count == 0 ? '' : l.mtSoundAvg((_sum / _count).round()),
                        textAlign: TextAlign.end, style: context.text.bodyMedium),
                  ),
                ]),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _reset, child: Text(l.mtReset))),
              ]),
            ),
    );
  }
}
