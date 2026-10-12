import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../device/device_data.dart';

/// Events per second from timestamps, using the median gap so a pause or a
/// late frame doesn't drag the number down. Duplicate timestamps (events
/// delivered together) are dropped. Null with fewer than 10 gaps.
double? rateFromTimestamps(List<Duration> times) {
  final t = times.map((d) => d.inMicroseconds).toSet().toList()..sort();
  if (t.length < 11) return null;
  final gaps = [for (var i = 1; i < t.length; i++) t[i] - t[i - 1]]..sort();
  final median = gaps[gaps.length ~/ 2];
  return median <= 0 ? null : 1e6 / median;
}

/// Measures how often the screen actually redraws while something moves.
/// Asks Android for the display's fastest mode first; some phones still
/// lower it (battery saver, adaptive refresh, a heat limit).
class RefreshRateScreen extends ConsumerStatefulWidget {
  const RefreshRateScreen({super.key});

  @override
  ConsumerState<RefreshRateScreen> createState() => _RefreshRateScreenState();
}

class _RefreshRateScreenState extends ConsumerState<RefreshRateScreen>
    with SingleTickerProviderStateMixin {
  static const _measure = Duration(seconds: 3);
  static const _warmUp = Duration(milliseconds: 500);

  late final HardwareTestApi _api;
  late final Ticker _ticker;
  final _frames = <Duration>[];
  Duration _now = Duration.zero;
  bool _running = false;
  double? _hz;

  @override
  void initState() {
    super.initState();
    _api = ref.read(hardwareTestApiProvider);
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _api.preferHighRefresh(false);
    _api.keepScreenOn(false);
    super.dispose();
  }

  Future<void> _start() async {
    await _api.preferHighRefresh(true);
    await _api.keepScreenOn(true);
    _frames.clear();
    setState(() {
      _hz = null;
      _running = true;
    });
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    setState(() => _now = elapsed);
    if (elapsed > _warmUp) _frames.add(elapsed);
    if (elapsed >= _warmUp + _measure) {
      _ticker.stop();
      _api.keepScreenOn(false);
      setState(() {
        _running = false;
        _hz = rateFromTimestamps(_frames);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final display = ref.watch(categorySnapshotProvider(DeviceCategory.display)).value?.display;
    final maxHz = display == null || display.refreshRates.isEmpty
        ? display?.refreshRate
        : display.refreshRates.reduce(math.max);
    final hz = _hz;

    return PageScaffold(
      title: l.rrTitle,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.rrIntro, style: context.text.bodyMedium),
            const SizedBox(height: 16),
            // Something moving every frame, so the display has to redraw.
            SizedBox(
              height: 56,
              child: LayoutBuilder(builder: (context, c) {
                final period = const Duration(milliseconds: 900).inMicroseconds;
                final phase = (_now.inMicroseconds % period) / period;
                final x = (c.maxWidth - 48) * (0.5 - 0.5 * math.cos(phase * 2 * math.pi));
                return Stack(children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: sx.cardAlt,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  Positioned(
                    left: x,
                    top: 4,
                    bottom: 4,
                    width: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: sx.display,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ]);
              }),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _running ? null : _start,
                child: Text(_running ? l.rrMeasuring : (hz == null ? l.rrStart : l.stAgain)),
              ),
            ),
          ]),
        )),
        if (hz != null || maxHz != null)
          Box(SxCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (hz != null) ...[
                Eyebrow(l.rrMeasured, color: sx.display),
                const SizedBox(height: 6),
                Text('${formatDouble(hz, decimals: 0)} Hz', style: context.text.displaySmall),
                const SizedBox(height: 6),
                Text(
                  maxHz != null && hz < maxHz * 0.9 ? l.rrLower(formatDouble(maxHz, decimals: 0)) : l.rrMatches,
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: 12),
              ],
              if (maxHz != null)
                InfoRow(label: l.rrReported, value: '${formatDouble(maxHz, decimals: 0)} Hz'),
            ]),
          ), bottom: 0),
      ],
    );
  }
}

/// Measures how often touch positions reach apps while a finger moves.
class TouchRateScreen extends StatefulWidget {
  const TouchRateScreen({super.key});

  @override
  State<TouchRateScreen> createState() => _TouchRateScreenState();
}

class _TouchRateScreenState extends State<TouchRateScreen> {
  final _times = <Duration>[];
  final _points = <Offset>[];
  double? _rate;
  double? _best;

  void _down(PointerDownEvent e) {
    _times.clear();
    setState(() {
      _points
        ..clear()
        ..add(e.localPosition);
    });
  }

  void _move(PointerMoveEvent e) {
    _times.add(e.timeStamp);
    setState(() {
      _points.add(e.localPosition);
      if (_points.length > 400) _points.removeAt(0);
      final r = rateFromTimestamps(_times);
      if (r != null) {
        _rate = r;
        _best = math.max(_best ?? 0, r);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return Scaffold(
      appBar: AppBar(title: Text(l.trTitle)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.trIntro, style: context.text.bodyMedium),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _Stat(label: l.trNow, value: _rate == null ? '–' : '${_rate!.round()} Hz'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Stat(label: l.trBest, value: _best == null ? '–' : '${_best!.round()} Hz'),
              ),
            ]),
            const SizedBox(height: 8),
            Text(l.trNote, style: context.text.bodySmall?.copyWith(color: sx.muted)),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Listener(
              onPointerDown: _down,
              onPointerMove: _move,
              // Keeps the system back gesture and scrolling from taking the finger.
              child: RawGestureDetector(
                gestures: {
                  PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                    PanGestureRecognizer.new,
                    (r) => r.onUpdate = (_) {},
                  ),
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: sx.cardAlt,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomPaint(
                    painter: _TrailPainter(_points, sx.accent),
                    child: Center(
                      child: _points.isEmpty
                          ? Text(l.trDraw, style: context.text.titleMedium?.copyWith(color: sx.muted))
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SxCard(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Eyebrow(label),
          const SizedBox(height: 4),
          Text(value, style: context.text.headlineSmall),
        ]),
      );
}

class _TrailPainter extends CustomPainter {
  _TrailPainter(this.points, this.color);

  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final dot = Paint()..color = color;
    for (final p in points) {
      canvas.drawCircle(p, 2.5, dot);
    }
  }

  @override
  bool shouldRepaint(_TrailPainter old) => true;
}
