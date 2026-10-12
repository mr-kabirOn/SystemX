import 'package:flutter/material.dart';

/// The SystemX mark: a phone with a live pulse running through it, for
/// device health and monitoring. Same geometry as the launcher icon vector
/// (android/.../drawable/ic_launcher_foreground.xml), drawn at any size.
class LogoMark extends StatelessWidget {
  const LogoMark({
    super.key,
    this.size = 48,
    this.background = const Color(0xFF0B0E17),
    this.glow = true,
    this.ink = LogoPainter.phone,
  });

  final double size;

  /// Color of the phone outline; dark ink on light backgrounds.
  final Color ink;

  /// Color behind the mark; the pulse cuts the outline with it.
  final Color background;
  final bool glow;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: LogoPainter(background: background, glow: glow, ink: ink),
    ),
  );
}

class LogoPainter extends CustomPainter {
  LogoPainter({required this.background, this.glow = true, this.ink = phone});

  final Color background;
  final bool glow;
  final Color ink;

  static const phone = Color(0xFFECEEF8);
  static const pulse = Color(0xFF33D1E5);

  /// The vector's 108-unit viewport; the mark sits in its 25..83 square.
  static const _from = 23.0, _span = 62.0;

  static Path _pulsePath() => Path()
    ..moveTo(25, 58)
    ..lineTo(44, 58)
    ..lineTo(48, 51)
    ..lineTo(52.5, 66)
    ..lineTo(56.5, 41)
    ..lineTo(60.5, 62)
    ..lineTo(63.5, 58)
    ..lineTo(83, 58);

  /// Gaps in the outline where the flat line crosses it.
  static Path _cutPath() => Path()
    ..moveTo(25, 58)
    ..lineTo(44, 58)
    ..moveTo(63.5, 58)
    ..lineTo(83, 58);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide / _span;
    canvas.save();
    canvas.translate(
      (size.width - _span * s) / 2,
      (size.height - _span * s) / 2,
    );
    canvas.scale(s);
    canvas.translate(-_from, -_from);

    Paint stroke(Color c, double w) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = c;

    canvas.drawRRect(
      RRect.fromLTRBR(39, 27, 69, 81, const Radius.circular(8)),
      stroke(ink, 5),
    );
    canvas.drawLine(
      const Offset(51, 33.5),
      const Offset(57, 33.5),
      stroke(ink, 3),
    );

    final p = _pulsePath();
    canvas.drawPath(_cutPath(), stroke(background, 12));
    if (glow) {
      canvas.drawPath(
        p,
        stroke(pulse.withValues(alpha: 0.55), 7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
    canvas.drawPath(p, stroke(pulse, 5));
    canvas.restore();
  }

  @override
  bool shouldRepaint(LogoPainter old) =>
      old.background != background || old.glow != glow || old.ink != ink;
}
