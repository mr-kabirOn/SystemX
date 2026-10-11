import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';

/// Unit of a sensor's values, by Sensor.TYPE_* constant.
String sensorUnit(int type) => switch (type) {
      1 || 9 || 10 || 35 => 'm/s²',
      2 || 14 => 'µT',
      4 || 16 => 'rad/s',
      5 => 'lx',
      6 => 'hPa',
      8 => 'cm',
      12 => '%',
      13 => '°C',
      _ => '',
    };

/// Readings worth showing: three axes for motion and field sensors, one
/// value for the rest.
List<(String, double)> sensorValues(int type, List<double> values) {
  const axes = {1, 2, 4, 9, 10, 14, 16, 35};
  if (axes.contains(type) && values.length >= 3) {
    return [('X', values[0]), ('Y', values[1]), ('Z', values[2])];
  }
  return [for (final (i, v) in values.indexed.take(4)) (values.length == 1 ? '' : '${i + 1}', v)];
}

/// Details and a live reading for one sensor.
Future<void> showSensorSheet(BuildContext context, SensorInfo sensor) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => _SensorSheet(sensor: sensor),
  );
}

class _SensorSheet extends ConsumerStatefulWidget {
  const _SensorSheet({required this.sensor});

  final SensorInfo sensor;

  @override
  ConsumerState<_SensorSheet> createState() => _SensorSheetState();
}

class _SensorSheetState extends ConsumerState<_SensorSheet> {
  // Created once so rebuilds don't re-register the sensor listener.
  late final Stream<List<double>> _readings =
      ref.read(sensorReadingsProvider)(widget.sensor.type);

  @override
  Widget build(BuildContext context) {
    final sensor = widget.sensor;
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = sensorUnit(sensor.type);
    final u = unit.isEmpty ? '' : ' $unit';
    final rate = sensor.minDelayUs > 0
        ? '${formatDouble(1e6 / sensor.minDelayUs, decimals: 0)} Hz'
        : l.sensorOnChange;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              IconBadge(SxIcons.sensors, color: sx.sensors, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sensor.name, style: context.text.titleMedium),
                    Text(prettyIdentifier(sensor.typeName),
                        style: context.text.bodySmall),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 16),
            SxCard(
              color: sx.cardAlt,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow(l.liveReading, color: sx.sensors),
                  const SizedBox(height: 10),
                  StreamBuilder<List<double>>(
                    stream: _readings,
                    builder: (context, snap) {
                      final values = snap.data;
                      if (values == null || values.isEmpty) {
                        return Text(l.sensorWaiting,
                            style: context.text.bodyMedium
                                ?.copyWith(color: sx.muted));
                      }
                      return Wrap(spacing: 20, runSpacing: 8, children: [
                        for (final (axis, v) in sensorValues(sensor.type, values))
                          Text.rich(TextSpan(children: [
                            if (axis.isNotEmpty)
                              TextSpan(
                                  text: '$axis ',
                                  style: SxText.readout(13, sx.muted)),
                            TextSpan(
                                text: v.toStringAsFixed(2),
                                style: SxText.readout(20, sx.ink)),
                            if (unit.isNotEmpty)
                              TextSpan(
                                  text: ' $unit',
                                  style: SxText.readout(12, sx.muted)),
                          ])),
                      ]);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            InfoRow(label: l.specVendor, value: sensor.vendor),
            InfoRow(
                label: l.sensorRange,
                value: '${formatDouble(sensor.maxRange, decimals: 2)}$u'),
            InfoRow(
                label: l.sensorResolution,
                value: '${_small(sensor.resolution)}$u'),
            InfoRow(
                label: l.sensorPower,
                value: '${formatDouble(sensor.power, decimals: 2)} mA'),
            InfoRow(label: l.sensorRate, value: rate),
            InfoRow(
                label: l.sensorWakeUp,
                value: sensor.wakeUp ? l.yes : l.no,
                hint: l.sensorWakeUpHint),
            InfoRow(label: l.sensorVersion, value: '${sensor.version}'),
          ],
        ),
      ),
    );
  }

  /// Resolutions can be tiny (0.0024), so keep significant digits.
  static String _small(double v) =>
      v != 0 && v.abs() < 0.01 ? v.toStringAsPrecision(2) : formatDouble(v, decimals: 2);
}
