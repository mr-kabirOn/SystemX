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
