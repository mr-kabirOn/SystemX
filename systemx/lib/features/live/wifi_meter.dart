import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../../ui/widgets/live_chart.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../device/spec_sheets.dart';

/// Signal strength as 0–1 for the gauge (-90 dBm empty, -30 dBm full).
double signalFraction(int rssi) => ((rssi + 90) / 60).clamp(0.0, 1.0);

/// Live Wi-Fi signal: walk around to find the best spot.
class WifiMeterScreen extends ConsumerStatefulWidget {
  const WifiMeterScreen({super.key});

  @override
  ConsumerState<WifiMeterScreen> createState() => _WifiMeterScreenState();
}

class _WifiMeterScreenState extends ConsumerState<WifiMeterScreen> {
  Timer? _timer;
  NetworkInfo? _net;
  final _history = <double>[];
  int? _best;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _poll();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _poll());
  }

  Future<void> _poll() async {
    if (_busy) return;
    _busy = true;
    try {
      final n = await ref.read(deviceApiProvider).network();
      if (!mounted) return;
      setState(() {
        _net = n;
        final rssi = n.rssi;
        if (n.transport == 'wifi' && rssi != null) {
          _history.add(rssi.toDouble());
          if (_history.length > 120) _history.removeAt(0);
          _best = _best == null ? rssi : math.max(_best!, rssi);
        }
      });
    } catch (_) {
    } finally {
      _busy = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final n = _net;
    final b = SpecBuilder(l);
    final onWifi = n != null && n.transport == 'wifi' && n.rssi != null;

    return PageScaffold(
      title: l.wifiMeter,
      leading: const BackButton(),
      slivers: [
        if (n == null)
          const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
        else if (!onWifi)
          Box(SxCard(child: Text(l.wifiMeterOff, style: context.text.bodyLarge)))
        else ...[
          Box(SxCard(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Semantics(
                label: '${l.specSignal} ${n.rssi} dBm, ${b.wifiQuality(n.rssi!)}',
                excludeSemantics: true,
                child: GaugeRing(
                  value: signalFraction(n.rssi!),
                  color: sx.network,
                  size: 190,
                  stroke: 16,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('${n.rssi}', style: SxText.readout(40, sx.ink)),
                    Text('dBm', style: SxText.readout(13, sx.muted)),
                    const SizedBox(height: 4),
                    Text(b.wifiQuality(n.rssi!), style: context.text.titleSmall),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.wifiMeterHint,
                  textAlign: TextAlign.center, style: context.text.bodyMedium),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _Fact(l.bestHere, _best == null ? '–' : '$_best dBm')),
                Expanded(child: _Fact(l.specLinkSpeed, n.linkMbps == null ? '–' : '${n.linkMbps} Mbps')),
                Expanded(
                  child: _Fact(
                    l.specFrequency,
                    n.freqMhz == null ? '–' : (wifiBand(n.freqMhz!) ?? '${n.freqMhz} MHz'),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              LiveChart(
                series: [ChartSeries(_history, sx.network)],
                format: (v) => '${v.round()} dBm',
                minY: -95,
                maxY: -25,
                height: 110,
                semanticLabel: l.specSignal,
              ),
            ]),
          )),
          if (n.ssid != null) Box(Text(n.ssid!, style: context.text.bodySmall), bottom: 0),
        ],
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value, style: SxText.readout(15, context.sx.ink)),
        Text(label, style: context.text.bodySmall, textAlign: TextAlign.center),
      ]);
}
