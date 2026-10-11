import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/log.dart';
import '../../core/settings/settings.dart';
import '../../platform/platform.dart';

/// How many samples each live chart keeps (60 s at the default rate).
const liveHistory = 60;

/// Average clock of the online cores in GHz.
double avgGhz(List<int> khz) {
  final online = khz.where((k) => k > 0);
  if (online.isEmpty) return 0;
  return online.reduce((a, b) => a + b) / online.length / 1e6;
}

/// CPU load estimated from clock speeds: current over maximum, for online
/// cores. Android 8+ hides real usage, so this is always labelled an estimate.
double loadEstimate(List<int> cur, List<int> max) {
  var c = 0, m = 0;
  for (var i = 0; i < cur.length && i < max.length; i++) {
    if (cur[i] > 0 && max[i] > 0) {
      c += cur[i];
      m += max[i];
    }
  }
  return m == 0 ? 0 : (c / m).clamp(0.0, 1.0);
}

/// Bytes per second between two counter readings; 0 when the counter reset
/// or is unsupported.
double byteRate(int prevBytes, int bytes, int prevMs, int ms) {
  if (prevBytes < 0 || bytes < prevBytes || ms <= prevMs) return 0;
  return (bytes - prevBytes) * 1000 / (ms - prevMs);
}

@immutable
class LiveState {
  const LiveState({
    this.latest,
    this.paused = false,
    this.downBps = 0,
    this.upBps = 0,
    this.cpuGhz = const [],
    this.cpuLoad = const [],
    this.memUsed = const [],
    this.batteryMa = const [],
    this.batteryTemp = const [],
    this.cpuTemp = const [],
    this.down = const [],
    this.up = const [],
    this.headroom,
  });

  final LiveStats? latest;
  final bool paused;
  final double downBps;
  final double upBps;

  /// Last known headroom; the API returns nothing when polled too often, so
  /// the previous value is kept.
  final double? headroom;

  final List<double> cpuGhz;
  final List<double> cpuLoad;

  /// Fraction of RAM in use.
  final List<double> memUsed;
  final List<double> batteryMa;
  final List<double> batteryTemp;
  final List<double> cpuTemp;

  /// Bytes per second.
  final List<double> down;
  final List<double> up;
}

List<double> _push(List<double> list, double? v) {
  if (v == null) return list;
  final out = [...list, v];
  return out.length > liveHistory ? out.sublist(out.length - liveHistory) : out;
}

/// Whether [LiveMonitor] polls on a timer. Tests and screenshot renders turn
/// it off and call [LiveMonitor.tick] themselves.
final livePollingProvider = Provider<bool>((ref) => true);

/// Polls [DeviceInfoApi.live] at the chosen refresh rate while anything
/// watches it, and pauses while the app is in the background.
class LiveMonitor extends Notifier<LiveState> {
  Timer? _timer;
  AppLifecycleListener? _lifecycle;
  bool _busy = false;
  bool _background = false;

  @override
  LiveState build() {
    final rate = ref.watch(settingsProvider.select((s) => s.refreshRate));
    _lifecycle ??= AppLifecycleListener(
      onPause: () {
        _background = true;
        _timer?.cancel();
      },
      onResume: () {
        _background = false;
        _schedule(rate);
      },
    );
    ref.onDispose(() {
      _timer?.cancel();
      _lifecycle?.dispose();
      _lifecycle = null;
    });
    _schedule(rate);
    Future.microtask(tick);
    return stateOrNull ?? const LiveState();
  }

  void _schedule(RefreshRate rate) {
    _timer?.cancel();
    if (_background || !ref.read(livePollingProvider)) return;
    _timer = Timer.periodic(Duration(milliseconds: rate.millis), (_) => tick());
  }

  /// Freezes the charts (readings keep their last values) or resumes them.
  void setPaused(bool paused) => state = LiveState(
        latest: state.latest,
        paused: paused,
        downBps: state.downBps,
        upBps: state.upBps,
        headroom: state.headroom,
        cpuGhz: state.cpuGhz,
        cpuLoad: state.cpuLoad,
        memUsed: state.memUsed,
        batteryMa: state.batteryMa,
        batteryTemp: state.batteryTemp,
        cpuTemp: state.cpuTemp,
        down: state.down,
        up: state.up,
      );

  /// Takes one reading. Called by the timer; tests call it directly.
  Future<void> tick() async {
    if (_busy || state.paused) return;
    _busy = true;
    try {
      final s = await ref.read(deviceApiProvider).live();
      if (!ref.mounted) return;
      final prev = state.latest;
      final down = prev == null
          ? 0.0
          : byteRate(prev.rxBytes, s.rxBytes, prev.timeMs, s.timeMs);
      final up = prev == null
          ? 0.0
          : byteRate(prev.txBytes, s.txBytes, prev.timeMs, s.timeMs);
      final st = state;
      state = LiveState(
        latest: s,
        paused: st.paused,
        downBps: down,
        upBps: up,
        headroom: s.thermalHeadroom ?? st.headroom,
        cpuGhz: _push(st.cpuGhz, avgGhz(s.cpuKhz)),
        cpuLoad: _push(st.cpuLoad, loadEstimate(s.cpuKhz, s.cpuMaxKhz)),
        memUsed: _push(st.memUsed,
            s.memTotal > 0 ? 1 - s.memAvailable / s.memTotal : null),
        batteryMa: _push(st.batteryMa, s.currentNowMa?.toDouble()),
        batteryTemp: _push(st.batteryTemp, s.batteryTempC),
        cpuTemp: _push(st.cpuTemp, s.cpuTempC),
        down: prev == null ? st.down : _push(st.down, down),
        up: prev == null ? st.up : _push(st.up, up),
      );
    } catch (e) {
      logDebug('live probe failed: $e');
    } finally {
      _busy = false;
    }
  }
}

final liveProvider =
    NotifierProvider.autoDispose<LiveMonitor, LiveState>(LiveMonitor.new);

/// Highest value in [values], or [fallback] for an empty list.
double maxOf(List<double> values, [double fallback = 0]) =>
    values.isEmpty ? fallback : values.reduce(math.max);
