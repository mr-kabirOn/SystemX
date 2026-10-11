import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/sx_colors.dart';

/// Circular gauge used for the health score, battery and storage.
/// Animates from the previous value whenever [value] changes.
class GaugeRing extends StatelessWidget {
  const GaugeRing({
    super.key,
    required this.value,
    required this.color,
    this.size = 92,
    this.stroke = 10,
    this.child,
    this.semanticLabel,
  });

  /// 0.0 – 1.0
  final double value;
  final Color color;
  final double size;
  final double stroke;
  final Widget? child;

  /// Spoken instead of the ring's contents.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final track = context.sx.line;
    final ring = TweenAnimationBuilder<double>(
      tween: Tween(end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => CustomPaint(
        size: Size.square(size),
        painter: _RingPainter(v, color, track, stroke),
        child: SizedBox.square(
          dimension: size,
          // Scales down with large font sizes instead of overflowing.
          child: Padding(
            padding: EdgeInsets.all(stroke + 4),
            child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: child)),
          ),
        ),
      ),
      child: child,
    );
    if (semanticLabel == null) return ring;
    return Semantics(label: semanticLabel, excludeSemantics: true, child: ring);
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.track, this.stroke);

  final double value;
  final Color color;
  final Color track;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, 0, math.pi * 2, false, base..color = track);
    if (value <= 0) return;
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2 * value, false,
        base..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// Thin horizontal meter (memory, storage, battery level).
class MeterBar extends StatelessWidget {
  const MeterBar({super.key, required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 6,
        width: double.infinity,
        child: Stack(children: [
          Positioned.fill(child: ColoredBox(color: context.sx.line)),
          TweenAnimationBuilder<double>(
            tween: Tween(end: value.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (_, v, _) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              heightFactor: 1,
              widthFactor: v,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Small line chart with an area fill and a highlighted latest point.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    required this.color,
    this.height = 28,
    this.showGrid = false,
    this.showDot = true,
  });

  final List<double> values;
  final Color color;
  final double height;
  final bool showGrid;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparkPainter(
            values, color, showGrid ? context.sx.line : null, showDot),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter(this.values, this.color, this.grid, this.dot);

  final List<double> values;
  final Color color;
  final Color? grid;
  final bool dot;

  @override
  void paint(Canvas canvas, Size size) {
    if (grid != null) {
      final g = Paint()
        ..color = grid!
        ..strokeWidth = 1;
      for (var i = 1; i <= 3; i++) {
        final y = size.height * i / 4;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), g);
      }
    }
    if (values.length < 2) return;

    final lo = values.reduce(math.min);
    final hi = values.reduce(math.max);
    final span = (hi - lo).abs() < 1e-9 ? 1.0 : hi - lo;
    const pad = 3.0;
    Offset at(int i) => Offset(
          size.width * i / (values.length - 1),
          pad + (size.height - pad * 2) * (1 - (values[i] - lo) / span),
        );

    final line = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      final p0 = at(i - 1), p1 = at(i);
      final mx = (p0.dx + p1.dx) / 2;
      line.cubicTo(mx, p0.dy, mx, p1.dy, p1.dx, p1.dy);
    }
    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
    if (dot) {
      final end = at(values.length - 1);
      canvas.drawCircle(end, 4, Paint()..color = color.withValues(alpha: .25));
      canvas.drawCircle(end, 2.4, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_SparkPainter old) =>
      old.values != values || old.color != color || old.grid != grid;
}
