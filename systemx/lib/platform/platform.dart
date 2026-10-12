import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_api.g.dart';

export 'device_api.g.dart';

final deviceApiProvider = Provider<DeviceInfoApi>((ref) => DeviceInfoApi());
final permissionApiProvider = Provider<PermissionApi>((ref) => PermissionApi());

const _sensorChannel = EventChannel('systemx/sensor');

/// Live values from one sensor type, while listened to.
Stream<List<double>> sensorReadings(int type) => _sensorChannel
    .receiveBroadcastStream(type)
    .map((e) => (e as List).cast<num>().map((n) => n.toDouble()).toList());

/// [sensorReadings], swappable in tests.
final sensorReadingsProvider =
    Provider<Stream<List<double>> Function(int type)>((ref) => sensorReadings);

final hardwareTestApiProvider =
    Provider<HardwareTestApi>((ref) => HardwareTestApi());

/// GNSS status while listened to; ends at once without Location permission
/// or with Location off.
typedef GnssStatus = ({int seen, int used, double? accuracy});

const _gnssChannel = EventChannel('systemx/gnss');

Stream<GnssStatus> gnssStatus() =>
    _gnssChannel.receiveBroadcastStream().map((e) {
      final m = (e as Map).cast<String, Object?>();
      return (
        seen: (m['seen'] as num?)?.toInt() ?? 0,
        used: (m['used'] as num?)?.toInt() ?? 0,
        accuracy: (m['accuracy'] as num?)?.toDouble(),
      );
    });

/// [gnssStatus], swappable in tests.
final gnssStatusProvider =
    Provider<Stream<GnssStatus> Function()>((ref) => gnssStatus);

const _volumeChannel = EventChannel('systemx/volume_keys');

/// "up" or "down" for each volume button press while listened to. The
/// presses don't change the volume during that time.
Stream<String> volumeKeyPresses() =>
    _volumeChannel.receiveBroadcastStream().map((e) => e as String);

/// [volumeKeyPresses], swappable in tests.
final volumeKeysProvider =
    Provider<Stream<String> Function()>((ref) => volumeKeyPresses);
