import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import 'test_catalog.dart';
import 'test_results.dart';
import 'test_runner.dart';

/// Automatic tests first, then the ones that need the user, in catalog order.
List<HwTest> checkupOrder() => [
      ...HwTest.values.where((t) => t.automatic),
      ...HwTest.values.where((t) => !t.automatic),
    ];

/// Rough length of a full checkup, for the hub card.
const checkupMinutes = 6;

/// Runs one test from the hub and saves its result.
class SingleTestScreen extends ConsumerStatefulWidget {
  const SingleTestScreen({super.key, required this.test});
  final HwTest test;

  @override
  ConsumerState<SingleTestScreen> createState() => _SingleTestScreenState();
}

class _SingleTestScreenState extends ConsumerState<SingleTestScreen> {
  TestResult? _result;
  int _run = 0;

  @override
  Widget build(BuildContext context) {
    final r = _result;
    if (r != null) {
      return ResultView(
        result: r,
        onDone: () => context.pop(),
        onRetry: () => setState(() {
          _result = null;
          _run++;
        }),
      );
    }
    return TestRunner(
      key: ValueKey(_run),
      test: widget.test,
      onResult: (r) {
        ref.read(testHistoryProvider.notifier).record(r);
        setState(() => _result = r);
      },
    );
  }
}

enum _Phase { intro, automatic, interactive }

/// The guided checkup: automatic tests run on their own, then each
/// interactive test in turn. Results are saved as one checkup.
class CheckupScreen extends ConsumerStatefulWidget {
  const CheckupScreen({super.key});

  @override
  ConsumerState<CheckupScreen> createState() => _CheckupScreenState();
}

class _CheckupScreenState extends ConsumerState<CheckupScreen> {
  final _order = checkupOrder();
  final _results = <HwTest, TestResult>{};
  _Phase _phase = _Phase.intro;
  int _index = 0;
  HwTest? _running;
  bool _saving = false;

  List<HwTest> get _auto => _order.where((t) => t.automatic).toList();
  List<HwTest> get _manual => _order.where((t) => !t.automatic).toList();

  Future<void> _runAutomatic() async {
    setState(() => _phase = _Phase.automatic);
    final l = AppLocalizations.of(context);
    for (final t in _auto) {
      if (!mounted) return;
      setState(() => _running = t);
      final skipped = await ensureTestPermission(context, ref, t);
      if (!mounted) return;
      if (skipped != null) {
        _results[t] = skipped;
        continue;
      }
      final (s, note) = await runAutomaticTest(t, ref, l);
      _results[t] = TestResult(t, s, note: note, at: DateTime.now());
    }
    if (!mounted) return;
    setState(() {
      _running = null;
      _phase = _Phase.interactive;
      _index = 0;
    });
  }

  void _onResult(TestResult r) {
    _results[r.test] = r;
    if (_index + 1 >= _manual.length) {
      _finish();
    } else {
      setState(() => _index++);
    }
  }

  Future<void> _finish() async {
    if (_saving) return;
    _saving = true;
    final results = [
      for (final t in _order)
        if (_results[t] != null) _results[t]!,
    ];
    if (results.isEmpty) {
      if (mounted) context.pop();
      return;
    }
    await ref
        .read(testHistoryProvider.notifier)
        .saveCheckup(Checkup(DateTime.now(), results));
    if (mounted) context.pushReplacement(Routes.report(0));
  }

  Future<void> _confirmStop() async {
    final l = AppLocalizations.of(context);
    final stop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.stopCheckupTitle),
        content: Text(l.stopCheckupBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.keepGoing)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.stop)),
        ],
      ),
    );
    if (stop == true) _finish();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final total = _order.length;
    final doneCount = _results.length;

    final Widget body = switch (_phase) {
      _Phase.intro => Scaffold(
          appBar: AppBar(title: Text(l.checkupTitle)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(l.checkupMeta(total, checkupMinutes), style: context.text.titleMedium),
                const SizedBox(height: 8),
                Text(l.checkupIntro, style: context.text.bodyLarge),
                const SizedBox(height: 16),
                SxCard(
                  color: sx.cardAlt,
                  child: Text(l.checkupPrep, style: context.text.bodyMedium),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _runAutomatic,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l.startCheckup),
                ),
              ]),
            ),
          ),
        ),
      _Phase.automatic => Scaffold(
          appBar: AppBar(title: Text(l.automaticTests)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.automaticTestsBody, style: context.text.bodyMedium),
              const SizedBox(height: 12),
              SxCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(children: [
                  for (final t in _auto)
                    ListTile(
                      leading: Icon(t.icon, color: t.color(sx)),
                      title: Text(t.title(l)),
                      subtitle: _results[t]?.note == null ? null : Text(_results[t]!.note!),
                      trailing: _running == t
                          ? const SizedBox(
                              width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                          : _results[t] == null
                              ? null
                              : Icon(statusLook(context, _results[t]!.status).$1,
                                  color: statusLook(context, _results[t]!.status).$2),
                    ),
                ]),
              ),
            ],
          ),
        ),
      _Phase.interactive => TestRunner(
          key: ValueKey(_manual[_index]),
          test: _manual[_index],
          onResult: _onResult,
        ),
    };

    return PopScope(
      canPop: _phase == _Phase.intro,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmStop();
      },
      child: Column(children: [
        if (_phase != _Phase.intro)
          Material(
            color: sx.bg,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(children: [
                  Expanded(child: MeterBar(value: doneCount / total, color: sx.accent)),
                  const SizedBox(width: 12),
                  Text(l.progressOf(doneCount, total), style: context.text.labelMedium),
                ]),
              ),
            ),
          ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: _phase != _Phase.intro,
            child: body,
          ),
        ),
      ]),
    );
  }
}
