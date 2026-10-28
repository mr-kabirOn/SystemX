import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/live_chart.dart';
import '../../ui/widgets/page_scaffold.dart';

enum StressVerdict { steady, slight, throttles }

/// What a stress run showed. Performance is relative to the phone's own
/// start, so it never compares phones or gives a score.
class StressResult {
  const StressResult({
    required this.verdict,
    required this.retainedPercent,
    required this.startTempC,
    required this.peakTempC,
    this.peakCpuC,
    required this.seconds,
  });

  final StressVerdict verdict;

  /// Work per second at the end as a share of the start.
  final int retainedPercent;
  final double startTempC;
  final double peakTempC;
  final double? peakCpuC;
  final int seconds;
}

/// Needs at least 30 s of readings; null otherwise. The start is the
/// average of seconds 3–12 (the first seconds ramp up), the end the
/// average of the last 10.
StressResult? evaluateStress(List<StressSample> samples) {
  final s = samples.where((x) => x.workPerSec > 0).toList();
  if (s.isEmpty || s.last.elapsedMs < 30000) return null;
  double avg(Iterable<StressSample> xs) =>
      xs.map((x) => x.workPerSec).fold(0.0, (a, b) => a + b) / xs.length;
  final head = s.where((x) => x.elapsedMs >= 3000 && x.elapsedMs <= 12000);
  final tail = s.where((x) => x.elapsedMs > s.last.elapsedMs - 10000);
  if (head.isEmpty || tail.isEmpty) return null;
  final start = avg(head);
  if (start <= 0) return null;
  final retained = (avg(tail) * 100 / start).round().clamp(0, 150);
  final cpu = [for (final x in s) ?x.cpuTempC];
  return StressResult(
    verdict: retained >= 90
        ? StressVerdict.steady
        : retained >= 75
            ? StressVerdict.slight
            : StressVerdict.throttles,
    retainedPercent: retained,
    startTempC: s.first.batteryTempC,
    peakTempC: s.map((x) => x.batteryTempC).reduce((a, b) => a > b ? a : b),
    peakCpuC: cpu.isEmpty ? null : cpu.reduce((a, b) => a > b ? a : b),
    seconds: (s.last.elapsedMs / 1000).round(),
  );
}

/// CPU stress test: loads every core for one or two minutes and shows
/// whether performance holds as the phone warms up. Limits are enforced on
/// the Android side (see StressRules.kt): it stops at 45 °C battery, severe
/// thermal status, under 15% battery, after 3 minutes at most, or when this
/// screen goes away.
class StressTestScreen extends ConsumerStatefulWidget {
  const StressTestScreen({super.key});

  @override
  ConsumerState<StressTestScreen> createState() => _StressTestScreenState();
}

class _StressTestScreenState extends ConsumerState<StressTestScreen> {
  static const durations = [60, 120];

  late final HardwareTestApi _api;
  late final AppLifecycleListener _lifecycle;
  Timer? _poll;
  int _seconds = 60;
  bool _running = false;
  String? _refused;
  String? _stopReason;
  final _samples = <StressSample>[];

  @override
  void initState() {
    super.initState();
    _api = ref.read(hardwareTestApiProvider);
    // Leaving the app stops the test (the runner also stops on its own
    // once nothing polls it).
    _lifecycle = AppLifecycleListener(onPause: () {
      if (_running) _stop();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _lifecycle.dispose();
    if (_running) {
      _api.stopStress();
      _api.keepScreenOn(false);
    }
    super.dispose();
  }

  /// Set while a start is in flight, so a double tap starts only one run.
  bool _starting = false;

  Future<void> _start() async {
    if (_starting || _running) return;
    _starting = true;
    try {
      await _startRun();
    } finally {
      _starting = false;
    }
  }

  Future<void> _startRun() async {
    final refused = await _api.startStress(_seconds * 1000);
    if (!mounted) return;
    if (refused != null) {
      setState(() => _refused = refused);
      return;
    }
    await _api.keepScreenOn(true);
    if (!mounted) return;
    setState(() {
      _refused = null;
      _stopReason = null;
      _samples.clear();
      _running = true;
    });
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _tick() async {
    final s = await _api.stressSample();
    if (!mounted) return;
    setState(() {
      _samples.add(s);
      if (!s.running) _finish(s.stopReason ?? 'done');
    });
  }

  Future<void> _stop() async {
    await _api.stopStress();
    if (!mounted) return;
    setState(() => _finish('user'));
  }

  void _finish(String reason) {
    _poll?.cancel();
    _poll = null;
    _running = false;
    _stopReason = reason;
    _api.keepScreenOn(false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final result = _running ? null : evaluateStress(_samples);
    final start = _samples.isEmpty
        ? 0.0
        : _samples
            .where((x) => x.elapsedMs >= 3000 && x.elapsedMs <= 12000)
            .map((x) => x.workPerSec)
            .fold<double>(0, (a, b) => a > b ? a : b);
    final perf = [
      for (final x in _samples)
        if (start > 0) (x.workPerSec * 100 / start).clamp(0, 150).toDouble(),
    ];
    final last = _samples.isEmpty ? null : _samples.last;

    return PageScaffold(
      title: l.stTitle,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              IconBadge(SxIcons.speed, color: sx.cpu),
              const SizedBox(width: 14),
              Expanded(child: Text(l.stIntro, style: context.text.bodyMedium)),
            ]),
            const SizedBox(height: 12),
            Text(l.stSafety, style: context.text.bodySmall?.copyWith(color: sx.muted)),
            const SizedBox(height: 14),
            if (!_running) ...[
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (final d in durations)
                    ButtonSegment(value: d, label: Text(l.stMinutes(d ~/ 60))),
                ],
                selected: {_seconds},
                onSelectionChanged: (v) => setState(() => _seconds = v.first),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(_samples.isEmpty ? l.stStart : l.stAgain),
                ),
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _stop,
                  icon: const Icon(Icons.stop_rounded),
                  label: Text(l.stStop),
                ),
              ),
            if (_refused != null) ...[
              const SizedBox(height: 10),
              Text(
                _refused == 'hot' ? l.stRefusedHot : l.stRefusedBattery,
                style: context.text.bodySmall?.copyWith(color: sx.warn),
              ),
            ],
          ]),
        )),
        if (_samples.isNotEmpty)
          Box(SxCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(
                    _running ? l.stRunning(_seconds - (last!.elapsedMs ~/ 1000)) : l.stPerformance,
                    style: context.text.titleMedium,
                  ),
                ),
                if (last != null)
                  Text(formatTemp(last.batteryTempC, unit),
                      style: context.text.titleSmall?.copyWith(color: sx.thermal)),
              ]),
              const SizedBox(height: 10),
              Eyebrow(l.stPerfAxis, color: sx.cpu),
              const SizedBox(height: 6),
              LiveChart(
                series: [ChartSeries(perf, sx.cpu)],
                format: (v) => '${v.round()}%',
                height: 110,
                minY: 0,
                maxY: 110,
              ),
              const SizedBox(height: 12),
              Eyebrow(l.stTempAxis, color: sx.thermal),
              const SizedBox(height: 6),
              LiveChart(
                series: [ChartSeries([for (final x in _samples) x.batteryTempC], sx.thermal)],
                format: (v) => formatTemp(v, unit),
                height: 80,
              ),
            ]),
          )),
        if (!_running && _stopReason != null)
          Box(_ResultCard(result: result, stopReason: _stopReason!, unit: unit), bottom: 0),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.stopReason, required this.unit});

  final StressResult? result;
  final String stopReason;
  final TempUnit unit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final r = result;
    final (title, body, color) = switch (r?.verdict) {
      StressVerdict.steady => (l.stSteady, l.stSteadyBody, sx.good),
      StressVerdict.slight => (l.stSlight, l.stSlightBody, sx.warn),
      StressVerdict.throttles => (l.stThrottles, l.stThrottlesBody, sx.bad),
      null => (l.stTooShort, l.stTooShortBody, sx.muted),
    };
    final reason = switch (stopReason) {
      'hot' => l.stStoppedHot,
      'battery' => l.stStoppedBattery,
      'left' => l.stStoppedLeft,
      'error' => l.stStoppedError,
      _ => null,
    };
    return SxCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: context.text.titleLarge?.copyWith(color: color)),
        const SizedBox(height: 6),
        Text(body, style: context.text.bodyMedium),
        if (reason != null) ...[
          const SizedBox(height: 8),
          Text(reason, style: context.text.bodySmall?.copyWith(color: sx.warn)),
        ],
        if (r != null) ...[
          const SizedBox(height: 12),
          InfoRow(label: l.stRetained, value: '${r.retainedPercent}%'),
          InfoRow(
            label: l.stBatteryTemp,
            value: '${formatTemp(r.startTempC, unit)} → ${formatTemp(r.peakTempC, unit)}',
          ),
          if (r.peakCpuC != null)
            InfoRow(label: l.stCpuPeak, value: formatTemp(r.peakCpuC!, unit)),
          InfoRow(label: l.stDuration, value: l.stSeconds(r.seconds)),
        ],
      ]),
    );
  }
}
