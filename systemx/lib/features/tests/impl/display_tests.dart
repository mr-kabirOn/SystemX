import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/sx_colors.dart';
import '../../../core/theme/sx_type.dart';
import '../../../l10n/app_localizations.dart';
import '../../../platform/platform.dart';
import '../test_catalog.dart';
import '../test_frame.dart';
import '../test_results.dart';

/// Shows full-screen slides (tap to advance), then asks a question.
class _SlidesTest extends StatefulWidget {
  const _SlidesTest({
    required this.slides,
    required this.question,
    required this.done,
    required this.yesPasses,
    this.passNote,
    this.failNote,
  });

  final List<Widget> slides;
  final String question;
  final TestDone done;
  final bool yesPasses;
  final String? passNote;
  final String? failNote;

  @override
  State<_SlidesTest> createState() => _SlidesTestState();
}

class _SlidesTestState extends State<_SlidesTest> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_i < widget.slides.length) {
      return Immersive(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _i++),
          child: Stack(fit: StackFit.expand, children: [
            widget.slides[_i],
            if (_i == 0)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(l.tapToContinue,
                      style: const TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
          ]),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                onPressed: () => setState(() => _i = 0),
                child: Text(l.showAgain),
              ),
              TextButton(
                onPressed: () => widget.done(TestStatus.skipped, l.skippedByYou),
                child: Text(l.skip),
              ),
            ]),
            const SizedBox(height: 12),
            AskResult(
              question: widget.question,
              done: widget.done,
              yesPasses: widget.yesPasses,
              passNote: widget.passNote,
              failNote: widget.failNote,
            ),
          ]),
        ),
      ),
    );
  }
}

class DeadPixelsTest extends StatelessWidget {
  const DeadPixelsTest({super.key, required this.done});
  final TestDone done;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SlidesTest(
      slides: [
        for (final c in const [
          Colors.black,
          Colors.white,
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFF808080),
        ])
          ColoredBox(color: c),
      ],
      question: l.qDeadPixels,
      yesPasses: false,
      done: done,
      passNote: l.nNoDeadPixels,
      failNote: l.nDeadPixels,
    );
  }
}

class ColorBandingTest extends StatelessWidget {
  const ColorBandingTest({super.key, required this.done});
  final TestDone done;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget ramp(Color c) => DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black, c]),
          ),
        );
    return _SlidesTest(
      slides: [
        Column(children: [
          for (final c in const [Colors.white, Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF)])
            Expanded(child: ramp(c)),
        ]),
      ],
      question: l.qBanding,
      yesPasses: true,
      done: done,
      passNote: l.nSmooth,
      failNote: l.nBanding,
    );
  }
}

class BurnInTest extends StatelessWidget {
  const BurnInTest({super.key, required this.done});
  final TestDone done;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SlidesTest(
      slides: const [
        ColoredBox(color: Color(0xFF7F7F7F)),
        ColoredBox(color: Color(0xFFBFBFBF)),
      ],
      question: l.qBurnIn,
      yesPasses: false,
      done: done,
      passNote: l.nNoBurnIn,
      failNote: l.nBurnIn,
    );
  }
}

/// Columns × rows of touch zones.
const touchCols = 8, touchRows = 12;

class TouchGridTest extends StatefulWidget {
  const TouchGridTest({super.key, required this.done});
  final TestDone done;

  @override
  State<TouchGridTest> createState() => _TouchGridTestState();
}

class _TouchGridTestState extends State<TouchGridTest> {
  final _hit = <int>{};
  bool _finished = false;

  void _mark(Offset p, Size size) {
    final c = (p.dx / size.width * touchCols).floor();
    final r = (p.dy / size.height * touchRows).floor();
    if (c < 0 || r < 0 || c >= touchCols || r >= touchRows) return;
    if (_hit.add(r * touchCols + c)) {
      setState(() {});
      if (_hit.length == touchCols * touchRows) _finish();
    }
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    final l = AppLocalizations.of(context);
    const total = touchCols * touchRows;
    if (_hit.length == total) {
      widget.done(TestStatus.passed, l.nAllZones(total));
    } else {
      widget.done(TestStatus.failed, l.nSomeZones(_hit.length, total));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return Immersive(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(builder: (context, box) {
          final size = box.biggest;
          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (e) => _mark(e.localPosition, size),
            onPointerMove: (e) => _mark(e.localPosition, size),
            child: Stack(children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: touchCols,
                childAspectRatio:
                    (size.width / touchCols) / (size.height / touchRows),
                children: [
                  for (var i = 0; i < touchCols * touchRows; i++)
                    Container(
                      decoration: BoxDecoration(
                        color: _hit.contains(i) ? sx.good : Colors.black,
                        border: Border.all(color: Colors.white24, width: 0.5),
                      ),
                    ),
                ],
              ),
              Center(
                child: _TouchControls(
                  title: l.touchEveryZone,
                  done: _hit.length,
                  total: touchCols * touchRows,
                  doneLabel: l.done,
                  skipLabel: l.skip,
                  onDone: _finish,
                  onSkip: () {
                    _finished = true;
                    widget.done(TestStatus.skipped, l.skippedByYou);
                  },
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }
}

/// Progress and buttons for the touch grid, in one compact dark card so
/// they read clearly over both lit and unlit squares.
class _TouchControls extends StatelessWidget {
  const _TouchControls({
    required this.title,
    required this.done,
    required this.total,
    required this.doneLabel,
    required this.skipLabel,
    required this.onDone,
    required this.onSkip,
  });

  final String title;
  final int done;
  final int total;
  final String doneLabel;
  final String skipLabel;
  final VoidCallback onDone;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return Container(
      width: 272,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        color: const Color(0xF0101420),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 24)],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(title, style: context.text.titleSmall?.copyWith(color: Colors.white)),
          ),
          Text('$done / $total',
              style: SxText.readout(13, Colors.white70, weight: FontWeight.w500)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : done / total,
            minHeight: 6,
            color: sx.good,
            backgroundColor: Colors.white12,
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
              onPressed: onSkip,
              child: Text(skipLabel),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(onPressed: onDone, child: Text(doneLabel)),
          ),
        ]),
      ]),
    );
  }
}

class MultiTouchTest extends StatefulWidget {
  const MultiTouchTest({super.key, required this.done});
  final TestDone done;

  @override
  State<MultiTouchTest> createState() => _MultiTouchTestState();
}

class _MultiTouchTestState extends State<MultiTouchTest> {
  final _points = <int, Offset>{};
  int _max = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return TestFrame(
      test: HwTest.multiTouch,
      done: widget.done,
      instructions: l.iMultiTouch,
      bottom: FilledButton(
        onPressed: () => _max >= 2
            ? widget.done(TestStatus.passed, l.nTouches(_max))
            : widget.done(TestStatus.failed, l.nTouches(_max)),
        child: Text(l.done),
      ),
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (e) => setState(() {
          _points[e.pointer] = e.localPosition;
          if (_points.length > _max) _max = _points.length;
        }),
        onPointerMove: (e) => setState(() => _points[e.pointer] = e.localPosition),
        onPointerUp: (e) => setState(() => _points.remove(e.pointer)),
        onPointerCancel: (e) => setState(() => _points.remove(e.pointer)),
        child: Container(
          decoration: BoxDecoration(
            color: sx.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(children: [
            Center(
              child: Text(l.maxTouches(_max),
                  style: context.text.headlineSmall?.copyWith(color: sx.muted)),
            ),
            for (final p in _points.values)
              Positioned(
                left: p.dx - 36,
                top: p.dy - 36,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sx.accent.withValues(alpha: 0.35),
                    border: Border.all(color: sx.accent, width: 2),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class BrightnessTest extends ConsumerStatefulWidget {
  const BrightnessTest({super.key, required this.done});
  final TestDone done;

  @override
  ConsumerState<BrightnessTest> createState() => _BrightnessTestState();
}

class _BrightnessTestState extends ConsumerState<BrightnessTest> {
  Timer? _timer;
  double _level = 1;
  bool _sweeping = false;

  // Read up front: dispose() needs it and may run before first use.
  late final HardwareTestApi _hw;

  void _sweep() {
    _timer?.cancel();
    var step = 0;
    setState(() => _sweeping = true);
    // Dim to 5%, brighten to 100%, then hand back to the system.
    _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      step++;
      final p = step / 40;
      _level = p <= 1 ? 1 - 0.95 * p : 0.05 + 0.95 * (p - 1);
      _hw.setBrightness(_level.clamp(0.05, 1.0));
      if (step >= 80) {
        t.cancel();
        _hw.setBrightness(-1);
        if (mounted) setState(() => _sweeping = false);
      } else if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _hw = ref.read(hardwareTestApiProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sweep());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hw.setBrightness(-1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TestFrame(
      test: HwTest.brightness,
      done: widget.done,
      instructions: l.iBrightness,
      bottom: AskResult(
        question: l.qBrightness,
        done: widget.done,
        passNote: l.nBrightnessOk,
        failNote: l.nBrightnessBad,
        extra: TextButton(
          onPressed: _sweeping ? null : _sweep,
          child: Text(l.showAgain),
        ),
      ),
      child: Center(
        child: Text('${(_level * 100).round()}%',
            style: context.text.displayMedium),
      ),
    );
  }
}
