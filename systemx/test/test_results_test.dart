import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/features/tests/test_catalog.dart';
import 'package:systemx/features/tests/test_results.dart';

void main() {
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
    final store = MemoryResultsStore();
    ProviderContainer make() => ProviderContainer(
        overrides: [resultsStoreProvider.overrideWithValue(store)]);

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

  test('a damaged file starts a fresh history instead of crashing', () async {
    final store = MemoryResultsStore()..data = '{not json';
    final c = ProviderContainer(
        overrides: [resultsStoreProvider.overrideWithValue(store)]);
    addTearDown(c.dispose);
    final h = await c.read(testHistoryProvider.future);
    expect(h.checkups, isEmpty);
  });
}
