import '../../platform/platform.dart';

/// Battery temperature above which charging is called warm, and hot.
const warmChargeC = 40.0;
const hotChargeC = 45.0;

/// Percent gained per hour; null for charges too short to say.
double? chargeRate(ChargeSession s, DateTime now) {
  final end = s.endMs ?? now.millisecondsSinceEpoch;
  final hours = (end - s.startMs) / 3600000;
  final added = s.endLevel - s.startLevel;
  if (hours < 5 / 60 || added <= 0) return null;
  return added / hours;
}

/// Something about the user's charging worth telling them.
enum ChargeInsight { toFull, deepDrain, hot, overnight, good }

/// Summary of finished charges in the last [days] days.
class ChargeStats {
  const ChargeStats({
    required this.count,
    this.avgDuration,
    this.avgAdded,
    this.avgRate,
    this.hottestC,
    this.toFull = 0,
    this.deepDrain = 0,
    this.hot = 0,
    this.overnight = 0,
    this.insights = const [],
  });

  final int count;
  final Duration? avgDuration;
  final double? avgAdded;

  /// Average percent per hour.
  final double? avgRate;
  final double? hottestC;

  /// Charges that ended at 98% or more.
  final int toFull;

  /// Charges that started below 15%.
  final int deepDrain;

  /// Charges where the battery reached [warmChargeC].
  final int hot;

  /// Long charges that started at night.
  final int overnight;

  /// Most important first; [ChargeInsight.good] when nothing stands out.
  final List<ChargeInsight> insights;
}

ChargeStats chargeStats(List<ChargeSession> sessions, DateTime now, {int days = 30}) {
  final since = now.subtract(Duration(days: days)).millisecondsSinceEpoch;
  final done = sessions.where((s) => s.endMs != null && s.startMs >= since).toList();
  if (done.isEmpty) return const ChargeStats(count: 0);

  double avg(Iterable<num> xs) => xs.fold<double>(0, (a, b) => a + b) / xs.length;
  final durations = [for (final s in done) s.endMs! - s.startMs];
  final rates = [for (final s in done) ?chargeRate(s, now)];
  final toFull = done.where((s) => s.endLevel >= 98).length;
  final deep = done.where((s) => s.startLevel < 15).length;
  final hot = done.where((s) => s.maxTempC >= warmChargeC).length;
  final overnight = done.where((s) {
    final start = DateTime.fromMillisecondsSinceEpoch(s.startMs);
    final long = s.endMs! - s.startMs >= 4 * 3600000;
    return long && (start.hour >= 22 || start.hour < 5);
  }).length;

  final insights = <ChargeInsight>[
    if (hot > 0) ChargeInsight.hot,
    if (toFull * 2 > done.length) ChargeInsight.toFull,
    if (deep >= 2) ChargeInsight.deepDrain,
    if (overnight >= 3) ChargeInsight.overnight,
  ];

  return ChargeStats(
    count: done.length,
    avgDuration: Duration(milliseconds: avg(durations).round()),
    avgAdded: avg(done.map((s) => s.endLevel - s.startLevel)),
    avgRate: rates.isEmpty ? null : avg(rates),
    hottestC: done.map((s) => s.maxTempC).reduce((a, b) => a > b ? a : b),
    toFull: toFull,
    deepDrain: deep,
    hot: hot,
    overnight: overnight,
    insights: insights.isEmpty ? const [ChargeInsight.good] : insights,
  );
}
