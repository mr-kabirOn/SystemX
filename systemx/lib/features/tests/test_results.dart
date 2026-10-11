import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'test_catalog.dart';

enum TestStatus { notRun, passed, failed, skipped }

@immutable
class TestResult {
  const TestResult(this.test, this.status, {this.note, required this.at});

  final HwTest test;
  final TestStatus status;

  /// What was measured or why it failed, in the language used at the time.
  final String? note;
  final DateTime at;

  Map<String, Object?> toJson() => {
        'test': test.name,
        'status': status.name,
        'note': note,
        'at': at.toIso8601String(),
      };

  static TestResult? fromJson(Map<String, Object?> j) {
    final test = HwTest.byName(j['test'] as String? ?? '');
    final status = TestStatus.values.asNameMap()[j['status']];
    final at = DateTime.tryParse(j['at'] as String? ?? '');
    if (test == null || status == null || at == null) return null;
    return TestResult(test, status, note: j['note'] as String?, at: at);
  }
}

/// One guided checkup.
@immutable
class Checkup {
  const Checkup(this.at, this.results);

  final DateTime at;
  final List<TestResult> results;

  int count(TestStatus s) => results.where((r) => r.status == s).length;

  /// Share of the tests that ran which passed, 0–100. Skipped tests are left
  /// out: a test skipped because, say, no headphones were at hand says
  /// nothing about the phone.
  int get score {
    final ran = count(TestStatus.passed) + count(TestStatus.failed);
    return ran == 0 ? 0 : (count(TestStatus.passed) * 100 / ran).round();
  }

  /// Failures first, then skipped, then passed, each in catalog order.
  List<TestResult> get ordered {
    int rank(TestStatus s) => switch (s) {
          TestStatus.failed => 0,
          TestStatus.skipped => 1,
          TestStatus.passed => 2,
          TestStatus.notRun => 3,
        };
    return [...results]
      ..sort((a, b) {
        final r = rank(a.status).compareTo(rank(b.status));
        return r != 0 ? r : a.test.index.compareTo(b.test.index);
      });
  }

  Map<String, Object?> toJson() => {
        'at': at.toIso8601String(),
        'results': [for (final r in results) r.toJson()],
      };

  static Checkup? fromJson(Map<String, Object?> j) {
    final at = DateTime.tryParse(j['at'] as String? ?? '');
    if (at == null) return null;
    final results = [
      for (final r in (j['results'] as List? ?? const []))
        ?TestResult.fromJson((r as Map).cast<String, Object?>()),
    ];
    return Checkup(at, results);
  }
}

/// Last result of every test plus past checkups, newest first.
@immutable
class TestHistory {
  const TestHistory({this.latest = const {}, this.checkups = const []});

  final Map<HwTest, TestResult> latest;
  final List<Checkup> checkups;

  Checkup? get lastCheckup => checkups.isEmpty ? null : checkups.first;

  Map<String, Object?> toJson() => {
        'version': 1,
        'latest': [for (final r in latest.values) r.toJson()],
        'checkups': [for (final c in checkups) c.toJson()],
      };

  static TestHistory fromJson(Map<String, Object?> j) {
    final latest = <HwTest, TestResult>{};
    for (final r in (j['latest'] as List? ?? const [])) {
      final result = TestResult.fromJson((r as Map).cast<String, Object?>());
      if (result != null) latest[result.test] = result;
    }
    final checkups = [
      for (final c in (j['checkups'] as List? ?? const []))
        ?Checkup.fromJson((c as Map).cast<String, Object?>()),
    ];
    return TestHistory(latest: latest, checkups: checkups);
  }
}

/// Where results are kept: a JSON file in the app's private storage.
abstract class ResultsStore {
  Future<String?> read();
  Future<void> write(String json);
  Future<void> clear();
}

class FileResultsStore implements ResultsStore {
  Future<File> get _file async =>
      File('${(await getApplicationSupportDirectory()).path}/test_results.json');

  @override
  Future<String?> read() async {
    final f = await _file;
    return await f.exists() ? f.readAsString() : null;
  }

  @override
  Future<void> write(String json) async {
    final f = await _file;
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(json, flush: true);
    await tmp.rename(f.path);
  }

  @override
  Future<void> clear() async {
    final f = await _file;
    if (await f.exists()) await f.delete();
  }
}

class MemoryResultsStore implements ResultsStore {
  String? data;

  @override
  Future<String?> read() async => data;

  @override
  Future<void> write(String json) async => data = json;

  @override
  Future<void> clear() async => data = null;
}

final resultsStoreProvider = Provider<ResultsStore>((ref) => FileResultsStore());

/// How many past checkups are kept.
const maxCheckups = 30;

class TestHistoryNotifier extends AsyncNotifier<TestHistory> {
  ResultsStore get _store => ref.read(resultsStoreProvider);

  @override
  Future<TestHistory> build() async {
    try {
      final raw = await ref.watch(resultsStoreProvider).read();
      if (raw == null) return const TestHistory();
      return TestHistory.fromJson((jsonDecode(raw) as Map).cast<String, Object?>());
    } catch (e) {
      debugPrint('SystemX: could not read test results: $e');
      return const TestHistory();
    }
  }

  Future<void> _save(TestHistory h) async {
    state = AsyncData(h);
    await _store.write(jsonEncode(h.toJson()));
  }

  /// Saves a single test's result.
  Future<void> record(TestResult r) async {
    final h = await future;
    await _save(TestHistory(latest: {...h.latest, r.test: r}, checkups: h.checkups));
  }

  /// Saves a finished checkup and updates each test's latest result.
  Future<void> saveCheckup(Checkup c) async {
    final h = await future;
    final latest = {...h.latest};
    for (final r in c.results) {
      if (r.status != TestStatus.notRun) latest[r.test] = r;
    }
    await _save(TestHistory(
      latest: latest,
      checkups: [c, ...h.checkups].take(maxCheckups).toList(),
    ));
  }

  Future<void> clear() async {
    state = const AsyncData(TestHistory());
    await _store.clear();
  }
}

final testHistoryProvider =
    AsyncNotifierProvider<TestHistoryNotifier, TestHistory>(TestHistoryNotifier.new);
