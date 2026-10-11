import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/features/device/device_data.dart';

import 'fakes.dart';

void main() {
  test('loads only the probes a category needs', () async {
    final snap = await loadSnapshot(FakeDeviceApi(), DeviceCategory.sim.probes);
    expect(snap.sim, isNotNull);
    expect(snap.network, isNotNull);
    expect(snap.identity, isNull);
    expect(snap.battery, isNull);
  });

  test('one failing probe does not hide the others', () async {
    final snap = await loadSnapshot(
        FakeDeviceApi(failing: {'media', 'cpu'}), Probe.values.toSet());
    expect(snap.media, isNull);
    expect(snap.cpu, isNull);
    expect(snap.identity?.marketName, 'Pixel 8');
    expect(snap.sensors, hasLength(2));
  });

  test('categories round-trip through their route name', () {
    for (final c in DeviceCategory.values) {
      expect(DeviceCategory.byName(c.name), c);
    }
    expect(DeviceCategory.byName('nope'), isNull);
  });
}
