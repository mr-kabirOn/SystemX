import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:systemx/core/settings/settings.dart';
import 'package:systemx/features/live/live_data.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('average clock ignores offline cores', () {
    expect(avgGhz([1000000, 2000000, 0]), 1.5);
    expect(avgGhz([0, 0]), 0);
  });

  test('load estimate compares clocks with their maximum', () {
    expect(loadEstimate([1000000, 0], [2000000, 3000000]), 0.5);
    expect(loadEstimate([], []), 0);
  });

  test('byte rate handles counter resets and missing support', () {
    expect(byteRate(1000, 3000, 0, 1000), 2000);
    expect(byteRate(5000, 1000, 0, 1000), 0);
    expect(byteRate(-1, -1, 0, 1000), 0);
  });

  test('monitor builds histories and network rates', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: SettingsNotifier.keys),
    );
    final c = ProviderContainer(overrides: [
      prefsProvider.overrideWithValue(prefs),
      deviceApiProvider.overrideWithValue(FakeDeviceApi()),
    ]);
    addTearDown(c.dispose);
    final sub = c.listen(liveProvider, (_, _) {});
    addTearDown(sub.close);
    final monitor = c.read(liveProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await monitor.tick();
    await monitor.tick();

    final s = c.read(liveProvider);
    expect(s.latest, isNotNull);
    expect(s.downBps, 2500000);
    expect(s.upBps, 200000);
    expect(s.cpuGhz.length, greaterThanOrEqualTo(2));
    expect(s.memUsed.last, closeTo(0.62, 0.01));
    expect(s.headroom, 0.36);

    monitor.setPaused(true);
    final frozen = c.read(liveProvider).cpuGhz.length;
    await monitor.tick();
    expect(c.read(liveProvider).cpuGhz.length, frozen);
  });
}
