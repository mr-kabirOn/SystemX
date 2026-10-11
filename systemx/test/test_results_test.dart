import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:systemx/core/settings/settings.dart';
import 'package:systemx/features/play/play.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/features/tests/test_catalog.dart';
import 'package:systemx/features/tests/test_results.dart';

import 'fakes.dart';

Future<SharedPreferencesWithCache> _prefs() {
  SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  return SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(allowList: SettingsNotifier.keys),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final at = DateTime(2026, 10, 12, 21, 38);
  TestResult r(HwTest t, TestStatus s, [String? note]) =>
      TestResult(t, s, note: note, at: at);

  test('there are 32 tests and every group has some', () {
    expect(HwTest.values, hasLength(32));
    for (final g in TestGroup.values) {
      expect(HwTest.values.where((t) => t.group == g), isNotEmpty, reason: g.name);
    }
  });

  test('score counts only tests that ran; failures come first', () {
    final c = Checkup(at, [
      r(HwTest.speaker, TestStatus.passed),
      r(HwTest.gps, TestStatus.skipped, 'Location is off'),
      r(HwTest.earpiece, TestStatus.failed, 'Very quiet'),
      r(HwTest.deadPixels, TestStatus.passed),
    ]);
    expect(c.score, 67);
    expect(c.ordered.map((x) => x.test),
        [HwTest.earpiece, HwTest.gps, HwTest.deadPixels, HwTest.speaker]);
    expect(Checkup(at, const []).score, 0);
  });

  test('history survives a restart and keeps the latest of each test',
      () async {
    final prefs = await _prefs();
    final store = MemoryResultsStore();
    ProviderContainer make() => ProviderContainer(overrides: [
          resultsStoreProvider.overrideWithValue(store),
          prefsProvider.overrideWithValue(prefs),
          playApiProvider.overrideWithValue(FakePlayApi()),
        ]);

    final c1 = make();
    final n = c1.read(testHistoryProvider.notifier);
    await n.record(r(HwTest.speaker, TestStatus.failed, 'quiet'));
    await n.saveCheckup(Checkup(at, [
      r(HwTest.speaker, TestStatus.passed),
      r(HwTest.gps, TestStatus.skipped),
    ]));
    c1.dispose();

    final c2 = make();
    final h = await c2.read(testHistoryProvider.future);
    expect(h.latest[HwTest.speaker]?.status, TestStatus.passed);
    expect(h.latest[HwTest.gps]?.status, TestStatus.skipped);
    expect(h.checkups.single.results, hasLength(2));
    expect(h.lastCheckup?.at, at);

    await c2.read(testHistoryProvider.notifier).clear();
    expect(store.data, isNull);
    c2.dispose();
  });

  test('a great checkup asks for a review at most every 90 days', () async {
    final prefs = await _prefs();
    final play = FakePlayApi();
    final c = ProviderContainer(overrides: [
      resultsStoreProvider.overrideWithValue(MemoryResultsStore()),
      prefsProvider.overrideWithValue(prefs),
      playApiProvider.overrideWithValue(play),
    ]);
    addTearDown(c.dispose);
    final great = Checkup(at, [for (final t in HwTest.values) r(t, TestStatus.passed)]);
    final poor = Checkup(at, [
      for (final t in HwTest.values) r(t, t.index.isEven ? TestStatus.passed : TestStatus.failed),
    ]);
    final n = c.read(testHistoryProvider.notifier);
    await n.saveCheckup(poor);
    expect(play.reviews, 0);
    await n.saveCheckup(great);
    expect(play.reviews, 1);
    await n.saveCheckup(great);
    expect(play.reviews, 1);
  });

  test('a damaged file starts a fresh history instead of crashing', () async {
    final store = MemoryResultsStore()..data = '{not json';
    final c = ProviderContainer(
        overrides: [resultsStoreProvider.overrideWithValue(store)]);
    addTearDown(c.dispose);
    final h = await c.read(testHistoryProvider.future);
    expect(h.checkups, isEmpty);
  });
}
