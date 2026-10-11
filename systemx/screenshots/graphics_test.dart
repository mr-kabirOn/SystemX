// Renders the Play Store icon (512×512) and feature graphic (1024×500).
// Run:  flutter test screenshots --update-goldens
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _ink = Color(0xFF0B0E17);
const _signal = Color(0xFF8E99FF);
const _signalDeep = Color(0xFF4553E0);
const _white = Color(0xFFECEEF8);

/// The SystemX mark: a 270° gauge ring around an X (same as the launcher
/// icon vector, drawn at any size).
class MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide / 52; // mark spans 52 units in the vector
    final c = size.center(Offset.zero);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * s
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: c, radius: 23 * s);
    canvas.drawCircle(c, 23 * s, stroke..color = _signal.withValues(alpha: 0.22));
    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.5, false, stroke..color = _signal);
    final x = Paint()
      ..strokeWidth = 6 * s
      ..strokeCap = StrokeCap.round
      ..color = _white;
    canvas.drawLine(c + Offset(-8 * s, -8 * s), c + Offset(8 * s, 8 * s), x);
    canvas.drawLine(c + Offset(8 * s, -8 * s), c + Offset(-8 * s, 8 * s), x);
  }

  @override
  bool shouldRepaint(MarkPainter old) => false;
}

Future<void> _font(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(family)..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

Future<void> _render(WidgetTester tester, Size size, String name, Widget child) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(Directionality(
    textDirection: TextDirection.ltr,
    child: RepaintBoundary(child: SizedBox.fromSize(size: size, child: child)),
  ));
  await expectLater(find.byType(RepaintBoundary).first, matchesGoldenFile('store/$name.png'));
}

void main() {
  setUpAll(() async {
    await _font('Sora', 'assets/fonts/Sora.ttf');
    await _font('Figtree', 'assets/fonts/Figtree.ttf');
  });

  testWidgets('play icon and feature graphic', (tester) async {
    await _render(
      tester,
      const Size(512, 512),
      'icon_512',
      Container(
        color: _ink,
        padding: const EdgeInsets.all(96),
        child: CustomPaint(painter: MarkPainter()),
      ),
    );

    await _render(
      tester,
      const Size(1024, 500),
      'feature_1024x500',
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B2150), _ink],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 72),
        child: Row(children: [
          SizedBox(width: 220, height: 220, child: CustomPaint(painter: MarkPainter())),
          const SizedBox(width: 56),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SystemX',
                    style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 72,
                        fontWeight: FontWeight.w700,
                        fontVariations: [FontVariation('wght', 700)],
                        color: _white)),
                const SizedBox(height: 12),
                const Text('Device info & phone test',
                    style: TextStyle(fontFamily: 'Figtree', fontSize: 34, color: Color(0xFFC5CBF0))),
                const SizedBox(height: 28),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  for (final t in const ['Live stats', '32 hardware tests', 'Private by design'])
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: _signalDeep.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(t,
                          style: const TextStyle(fontFamily: 'Figtree', fontSize: 22, color: _white)),
                    ),
                ]),
              ],
            ),
          ),
        ]),
      ),
    );
    addTearDown(tester.view.reset);
  });
}
