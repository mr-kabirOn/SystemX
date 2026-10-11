import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';

/// One line on a [LiveChart].
class ChartSeries {
  const ChartSeries(this.values, this.color, {this.label});
  final List<double> values;
  final Color color;
  final String? label;
}

/// Area chart with a faint grid and a highlighted latest point. Drag across
/// it to read any earlier value.
class LiveChart extends StatefulWidget {
  const LiveChart({
    super.key,
    required this.series,
    required this.format,
    this.height = 140,
    this.minY,
    this.maxY,
    this.semanticLabel,
  });

  final List<ChartSeries> series;

  /// Formats a value for the scrub label.
  final String Function(double value) format;
  final double height;

  /// Fixed bounds; by default the chart fits the data.
  final double? minY;
  final double? maxY;
  final String? semanticLabel;

  @override
  State<LiveChart> createState() => _LiveChartState();
}

class _LiveChartState extends State<LiveChart> {
  int? _scrub;

  int get _length =>
      widget.series.fold(0, (m, s) => math.max(m, s.values.length));

  void _scrubAt(double dx, double width) {
    final n = _length;
    if (n < 2 || width <= 0) return;
    setState(() => _scrub = (dx / width * (n - 1)).round().clamp(0, n - 1));
  }

  /// Value of [s] at scrub index [i]; shorter series align to the right.
  double? _valueAt(ChartSeries s, int i) {
    final j = i - (_length - s.values.length);
    return j >= 0 && j < s.values.length ? s.values[j] : null;
  }

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    final i = _scrub;
    final latest = [
      for (final s in widget.series)
        if (s.values.isNotEmpty) '${s.label ?? ''} ${widget.format(s.values.last)}'.trim(),
    ].join(', ');
    return Semantics(
      label: widget.semanticLabel,
      value: latest,
      child: LayoutBuilder(builder: (context, box) {
        return GestureDetector(
          onHorizontalDragStart: (d) => _scrubAt(d.localPosition.dx, box.maxWidth),
          onHorizontalDragUpdate: (d) => _scrubAt(d.localPosition.dx, box.maxWidth),
          onHorizontalDragEnd: (_) => setState(() => _scrub = null),
          onTapDown: (d) => _scrubAt(d.localPosition.dx, box.maxWidth),
          onTapUp: (_) => setState(() => _scrub = null),
          child: Stack(children: [
            SizedBox(
              height: widget.height,
              width: double.infinity,
              child: CustomPaint(
                painter: _ChartPainter(
                  widget.series,
                  sx.line,
                  i,
                  widget.minY,
                  widget.maxY,
                ),
              ),
            ),
            if (i != null)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: sx.cardAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    for (final s in widget.series)
                      if (_valueAt(s, i) case final v?)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            '${s.label == null ? '' : '${s.label} '}${widget.format(v)}',
                            style: SxText.readout(11.5, s.color),
                          ),
                        ),
                  ]),
                ),
              ),
          ]),
        );
      }),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.series, this.grid, this.scrub, this.minY, this.maxY);

  final List<ChartSeries> series;
  final Color grid;
  final int? scrub;
  final double? minY;
  final double? maxY;

  @override
  void paint(Canvas canvas, Size size) {
    final g = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), g);
    }

    final all = [for (final s in series) ...s.values];
    if (all.isEmpty) return;
    final n = series.fold(0, (m, s) => math.max(m, s.values.length));
    if (n < 2) return;
    final lo = minY ?? all.reduce(math.min);
    var hi = maxY ?? all.reduce(math.max);
    if ((hi - lo).abs() < 1e-9) hi = lo + 1;
    const pad = 4.0;

    Offset at(List<double> v, int i) {
      // Series shorter than the longest one are aligned to the right edge.
      final x = size.width * (i + n - v.length) / (n - 1);
      final y = pad + (size.height - pad * 2) * (1 - ((v[i] - lo) / (hi - lo)).clamp(0.0, 1.0));
      return Offset(x, y);
    }

    for (final (si, s) in series.indexed) {
      final v = s.values;
      if (v.length < 2) continue;
      final line = Path()..moveTo(at(v, 0).dx, at(v, 0).dy);
      for (var i = 1; i < v.length; i++) {
        final p0 = at(v, i - 1), p1 = at(v, i);
        final mx = (p0.dx + p1.dx) / 2;
        line.cubicTo(mx, p0.dy, mx, p1.dy, p1.dx, p1.dy);
      }
      if (si == 0) {
        final area = Path.from(line)
          ..lineTo(at(v, v.length - 1).dx, size.height)
          ..lineTo(at(v, 0).dx, size.height)
          ..close();
        canvas.drawPath(
          area,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [s.color.withValues(alpha: 0.26), s.color.withValues(alpha: 0)],
            ).createShader(Offset.zero & size),
        );
      }
      canvas.drawPath(
        line,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = s.color,
      );
      final end = at(v, v.length - 1);
      canvas.drawCircle(end, 4.5, Paint()..color = s.color.withValues(alpha: .25));
      canvas.drawCircle(end, 2.6, Paint()..color = s.color);
    }

    final i = scrub;
    if (i != null) {
      final x = size.width * i / (n - 1);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height),
          Paint()
            ..color = grid.withValues(alpha: 1)
            ..strokeWidth = 1.5);
      for (final s in series) {
        final j = i - (n - s.values.length);
        if (j >= 0 && j < s.values.length) {
          canvas.drawCircle(at(s.values, j), 3.5, Paint()..color = s.color);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) => true;
}
