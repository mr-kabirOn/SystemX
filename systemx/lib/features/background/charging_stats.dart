import '../../platform/platform.dart';

/// Battery temperature levels while charging. Phones commonly reach the
/// high 30s when fast charging; a brief peak isn't a problem.
const warmChargeC = 42.0;
const hotChargeC = 45.0;

enum TempLevel { normal, warm, hot }

TempLevel tempLevel(double c) => c >= hotChargeC
    ? TempLevel.hot
    : c >= warmChargeC
        ? TempLevel.warm
        : TempLevel.normal;

/// A charge counts in statistics when it lasted at least this long and
/// added at least [minChargeGain] percentage points. Shorter connections
/// (a quick plug-in, a loose cable) are listed but not averaged.
const minChargeMinutes = 10;
const minChargeGain = 5;

bool isValidCharge(ChargeSession s) {
  final end = s.endMs;
  if (end == null) return false;
  return end - s.startMs >= minChargeMinutes * 60000 && s.endLevel - s.startLevel >= minChargeGain;
}

/// Percentage points gained per hour for one charge; null when the charge
/// is too short or added too little to give a meaningful rate.
double? chargeRate(ChargeSession s, DateTime now) {
  final end = s.endMs ?? now.millisecondsSinceEpoch;
  final ms = end - s.startMs;
  final added = s.endLevel - s.startLevel;
  if (ms < minChargeMinutes * 60000 || added < minChargeGain) return null;
  return added / (ms / 3600000);
}

/// Something about the user's charging worth telling them.
enum ChargeInsight { toFull, deepDrain, hot, warmOften, overnight, good }

/// Summary of valid charges (see [isValidCharge]) in the last [days] days.
///
/// Definitions:
/// - avgDuration: mean duration of valid charges.
/// - avgAdded: mean percentage points gained per valid charge.
/// - overallRate: total points gained ÷ total charging hours, so a long
///   charge counts for more than a short one (time-weighted).
class ChargeStats {
  const ChargeStats({
    required this.count,
    this.excluded = 0,
    this.avgDuration,
    this.avgAdded,
    this.overallRate,
    this.hottestC,
    this.toFull = 0,
    this.deepDrain = 0,
    this.warm = 0,
    this.hot = 0,
    this.overnight = 0,
    this.insights = const [],
  });

  /// Valid charges in the period.
  final int count;

  /// Finished connections left out as too short.
  final int excluded;
  final Duration? avgDuration;
  final double? avgAdded;
  final double? overallRate;
  final double? hottestC;

  /// Charges that ended at 98% or more.
  final int toFull;

  /// Charges that started below 15%.
  final int deepDrain;

  /// Charges that reached [warmChargeC] / [hotChargeC].
  final int warm;
  final int hot;

  /// Long charges that started at night.
  final int overnight;

  /// Most important first; [ChargeInsight.good] when nothing stands out.
  final List<ChargeInsight> insights;
}

ChargeStats chargeStats(List<ChargeSession> sessions, DateTime now, {int days = 30}) {
  final since = now.subtract(Duration(days: days)).millisecondsSinceEpoch;
  final finished = sessions.where((s) => s.endMs != null && s.startMs >= since).toList();
  final done = finished.where(isValidCharge).toList();
  final excluded = finished.length - done.length;
  if (done.isEmpty) return ChargeStats(count: 0, excluded: excluded);

  final durations = [for (final s in done) s.endMs! - s.startMs];
  final gains = [for (final s in done) s.endLevel - s.startLevel];
  final totalMs = durations.fold<int>(0, (a, b) => a + b);
  final totalGain = gains.fold<int>(0, (a, b) => a + b);
  final toFull = done.where((s) => s.endLevel >= 98).length;
  final deep = done.where((s) => s.startLevel < 15).length;
  final hot = done.where((s) => tempLevel(s.maxTempC) == TempLevel.hot).length;
  final warm = done.where((s) => tempLevel(s.maxTempC) == TempLevel.warm).length;
  final overnight = done.where((s) {
    final start = DateTime.fromMillisecondsSinceEpoch(s.startMs);
    final long = s.endMs! - s.startMs >= 4 * 3600000;
    return long && (start.hour >= 22 || start.hour < 5);
  }).length;

  // A single warm peak is common and not worth a warning; repeated warm
  // charges or any hot one are.
  final insights = <ChargeInsight>[
    if (hot > 0) ChargeInsight.hot else if (warm >= 2) ChargeInsight.warmOften,
    if (toFull * 2 > done.length) ChargeInsight.toFull,
    if (deep >= 2) ChargeInsight.deepDrain,
    if (overnight >= 3) ChargeInsight.overnight,
  ];

  return ChargeStats(
    count: done.length,
    excluded: excluded,
    avgDuration: Duration(milliseconds: (totalMs / done.length).round()),
    avgAdded: totalGain / done.length,
    overallRate: totalGain / (totalMs / 3600000),
    hottestC: done.map((s) => s.maxTempC).reduce((a, b) => a > b ? a : b),
    toFull: toFull,
    deepDrain: deep,
    warm: warm,
    hot: hot,
    overnight: overnight,
    insights: insights.isEmpty ? const [ChargeInsight.good] : insights,
  );
}

/// "52 min", "1 h 35 min".
String formatChargeTime(Duration d, {required String h, required String min}) {
  final hours = d.inHours, minutes = d.inMinutes % 60;
  if (hours == 0) return '${d.inMinutes} $min';
  return minutes == 0 ? '$hours $h' : '$hours $h $minutes $min';
}
