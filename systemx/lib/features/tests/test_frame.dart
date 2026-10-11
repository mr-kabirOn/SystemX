import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import 'test_catalog.dart';
import 'test_results.dart';

/// Reports a test's outcome. Called once per run.
typedef TestDone = void Function(TestStatus status, [String? note]);

/// Standard layout for an interactive test: instructions, the test itself,
/// and answer buttons. Skip is always available in the top bar.
class TestFrame extends StatelessWidget {
  const TestFrame({
    super.key,
    required this.test,
    required this.done,
    required this.instructions,
    required this.child,
    this.bottom,
  });

  final HwTest test;
  final TestDone done;
  final String instructions;
  final Widget child;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return Scaffold(
      appBar: AppBar(
        title: Text(test.title(l)),
        actions: [
          TextButton(
            onPressed: () => done(TestStatus.skipped, l.skippedByYou),
            child: Text(l.skip),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                IconBadge(test.icon, color: test.color(sx), size: 44),
                const SizedBox(width: 14),
                Expanded(child: Text(instructions, style: context.text.bodyLarge)),
              ]),
              const SizedBox(height: 16),
              Expanded(child: child),
              if (bottom != null) ...[const SizedBox(height: 12), bottom!],
            ],
          ),
        ),
      ),
    );
  }
}

/// A yes/no question that finishes the test. [yesPasses] is false for
/// questions like "Did you see any dots?" where yes means a problem.
class AskResult extends StatelessWidget {
  const AskResult({
    super.key,
    required this.question,
    required this.done,
    this.yesPasses = true,
    this.passNote,
    this.failNote,
    this.extra,
  });

  final String question;
  final TestDone done;
  final bool yesPasses;
  final String? passNote;
  final String? failNote;

  /// Optional button above the answers, such as "Play again".
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    void answer(bool yes) {
      HapticFeedback.selectionClick();
      final pass = yes == yesPasses;
      done(pass ? TestStatus.passed : TestStatus.failed, pass ? passNote : failNote);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(question, style: context.text.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        if (extra != null) ...[extra!, const SizedBox(height: 8)],
        Row(children: [
          Expanded(
            child: OutlinedButton(onPressed: () => answer(false), child: Text(l.no)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(onPressed: () => answer(true), child: Text(l.yes)),
          ),
        ]),
      ],
    );
  }
}

/// Big centered status used by tests that wait for something to happen.
class WaitingFor extends StatelessWidget {
  const WaitingFor({super.key, required this.icon, required this.text, this.detail, this.color});

  final IconData icon;
  final String text;
  final String? detail;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 72, color: color ?? sx.accent),
        const SizedBox(height: 16),
        Text(text, style: context.text.titleLarge, textAlign: TextAlign.center),
        if (detail != null) ...[
          const SizedBox(height: 8),
          Text(detail!,
              style: context.text.bodyMedium?.copyWith(color: sx.muted),
              textAlign: TextAlign.center),
        ],
      ]),
    );
  }
}

/// Hides the system bars while a full-screen display test runs.
class Immersive extends StatefulWidget {
  const Immersive({super.key, required this.child});

  final Widget child;

  @override
  State<Immersive> createState() => _ImmersiveState();
}

class _ImmersiveState extends State<Immersive> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
