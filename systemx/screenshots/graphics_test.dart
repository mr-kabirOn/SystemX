// Renders the Play Store icon (512×512) and feature graphic (1024×500).
// Run:  flutter test screenshots --update-goldens
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/ui/widgets/logo_mark.dart';

const _ink = Color(0xFF0B0E17);
const _signalDeep = Color(0xFF4553E0);
const _white = Color(0xFFECEEF8);

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
    await _font('Inter', 'assets/fonts/Inter.ttf');
  });

  testWidgets('play icon and feature graphic', (tester) async {
    await _render(
      tester,
      const Size(512, 512),
      'icon_512',
      Container(
        color: _ink,
        padding: const EdgeInsets.all(72),
        child: const LogoMark(size: 368),
      ),
    );

    await _render(
      tester,
      const Size(1024, 500),
      'feature_1024x500',
      Container(
        color: _ink,
        padding: const EdgeInsets.symmetric(horizontal: 72),
        child: Row(children: [
          const LogoMark(size: 240),
          const SizedBox(width: 56),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SystemX',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 72,
                        fontWeight: FontWeight.w700,
                        fontVariations: [FontVariation('wght', 700)],
                        color: _white)),
                const SizedBox(height: 12),
                const Text('Device info & phone test',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 34, color: Color(0xFFC5CBF0))),
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
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 22, color: _white)),
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
