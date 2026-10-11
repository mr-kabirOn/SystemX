import 'dart:math' as math;

import 'package:intl/intl.dart';

import 'settings/settings.dart';

/// Formats a Celsius reading in the user's chosen unit.
String formatTemp(double celsius, TempUnit unit) {
  return switch (unit) {
    TempUnit.celsius => '${celsius.toStringAsFixed(1)} °C',
    TempUnit.fahrenheit => '${(celsius * 9 / 5 + 32).toStringAsFixed(1)} °F',
  };
}

/// Formats bytes with one decimal, base 1024 (how Android shows RAM).
String formatBytes(num bytes, {int decimals = 1}) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var i = 0;
  while (value >= 1024 && i < units.length - 1) {
    value /= 1024;
    i++;
  }
  final digits = i == 0 ? 0 : decimals;
  return '${value.toStringAsFixed(digits)} ${units[i]}';
}

/// Storage sizes, base 1000 (how Android Settings and phone boxes show them).
String formatStorage(num bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var i = 0;
  while (value >= 1000 && i < units.length - 1) {
    value /= 1000;
    i++;
  }
  final digits = i == 0 || value >= 100 ? 0 : 1;
  return '${_trim(value.toStringAsFixed(digits))} ${units[i]}';
}

/// Rounds RAM up to the size printed on the box (e.g. 7.6 GB -> 8 GB).
String formatAdvertisedRam(int totalBytes) {
  const sizes = [1, 2, 3, 4, 6, 8, 10, 12, 16, 18, 20, 24, 32];
  final gb = totalBytes / (1024 * 1024 * 1024);
  final size = sizes.firstWhere((s) => s >= gb, orElse: () => gb.ceil());
  return '$size GB';
}

String formatFreqKhz(int khz) {
  if (khz >= 1000000) return '${(khz / 1000000).toStringAsFixed(2)} GHz';
  return '${(khz / 1000).round()} MHz';
}

String formatDuration(Duration d) {
  final days = d.inDays;
  final hours = d.inHours % 24;
  final minutes = d.inMinutes % 60;
  if (days > 0) return '${days}d ${hours}h ${minutes}m';
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}

String formatDate(DateTime date, String locale) =>
    DateFormat.yMMMd(locale).format(date);

String formatDouble(double v, {int decimals = 1}) =>
    _trim(v.toStringAsFixed(decimals));

String _trim(String s) =>
    s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;

/// Marketing name for an Android API level.
String androidName(int sdk) => switch (sdk) {
      26 => 'Android 8.0 Oreo',
      27 => 'Android 8.1 Oreo',
      28 => 'Android 9 Pie',
      29 => 'Android 10',
      30 => 'Android 11',
      31 => 'Android 12',
      32 => 'Android 12L',
      33 => 'Android 13',
      34 => 'Android 14',
      35 => 'Android 15',
      36 => 'Android 16',
      _ => 'Android (API $sdk)',
    };

/// Parses "2026-09-05" style security patch dates.
DateTime? parsePatch(String? patch) =>
    patch == null ? null : DateTime.tryParse(patch);

int monthsSince(DateTime date, [DateTime? now]) {
  final n = now ?? DateTime.now();
  return math.max(0, (n.year - date.year) * 12 + n.month - date.month);
}

/// Wi-Fi generation from ScanResult.WIFI_STANDARD_* (Android 11+).
String? wifiStandardName(int? standard) => switch (standard) {
  1 => '802.11a/b/g',
  4 => 'Wi-Fi 4 (802.11n)',
  5 => 'Wi-Fi 5 (802.11ac)',
  6 => 'Wi-Fi 6 (802.11ax)',
  7 => 'WiGig (802.11ad)',
  8 => 'Wi-Fi 7 (802.11be)',
  _ => null,
};

/// Wi-Fi band label for a frequency in MHz.
String? wifiBand(int mhz) {
  if (mhz >= 2400 && mhz < 2500) return '2.4 GHz';
  if (mhz >= 4900 && mhz < 5900) return '5 GHz';
  if (mhz >= 5925 && mhz < 7125) return '6 GHz';
  if (mhz >= 57000) return '60 GHz';
  return null;
}

/// Wi-Fi channel number for a frequency in MHz.
int? wifiChannel(int mhz) {
  if (mhz == 2484) return 14;
  if (mhz >= 2412 && mhz < 2484) return (mhz - 2407) ~/ 5;
  if (mhz >= 4900 && mhz < 5900) return (mhz - 5000) ~/ 5;
  if (mhz >= 5955 && mhz < 7125) return (mhz - 5950) ~/ 5;
  if (mhz == 5935) return 2;
  return null;
}

/// Screen aspect ratio as phones advertise it ("20:9", "19.5:9", "4:3").
String aspectRatio(int width, int height) {
  final long = math.max(width, height), short = math.min(width, height);
  if (short == 0) return '';
  final r = long / short;
  if (r >= 1.7) {
    final n = (r * 9 * 2).round() / 2;
    return '${formatDouble(n)}:9';
  }
  for (final d in const [2, 3, 10]) {
    final n = r * d;
    if ((n - n.round()).abs() < 0.04) return '${n.round()}:$d';
  }
  return '${r.toStringAsFixed(2)}:1';
}

/// Diagonal size in inches from the physical pixels and pixel density.
double displayInches(int width, int height, double xdpi, double ydpi) {
  if (xdpi <= 0 || ydpi <= 0) return 0;
  final w = width / xdpi, h = height / ydpi;
  return math.sqrt(w * w + h * h);
}

/// Android density bucket closest to [dpi].
String densityBucket(int dpi) {
  const buckets = {
    'ldpi': 120,
    'mdpi': 160,
    'hdpi': 240,
    'xhdpi': 320,
    'xxhdpi': 480,
    'xxxhdpi': 640,
  };
  var best = 'mdpi';
  var diff = 1 << 30;
  buckets.forEach((name, value) {
    final d = (dpi - value).abs();
    if (d < diff) {
      diff = d;
      best = name;
    }
  });
  return best;
}

/// Megapixels from a sensor's pixel array ("50 MP", "12.2 MP").
String megapixels(int width, int height) {
  final mp = width * height / 1e6;
  return '${formatDouble(mp, decimals: mp >= 20 ? 0 : 1)} MP';
}

/// Camera sensor size in the "1/x inch" format phone makers use. The optical
/// inch is about 16 mm of sensor diagonal.
String opticalFormat(double widthMm, double heightMm) {
  final diag = math.sqrt(widthMm * widthMm + heightMm * heightMm);
  if (diag <= 0) return '';
  final inches = diag / 16;
  if (inches >= 1) return '${formatDouble(inches)}″';
  return '1/${formatDouble(1 / inches)}″';
}

/// Groups cores by top speed, fastest first: "1×2.91 + 4×2.37 + 4×1.7 GHz".
String clusterSummary(Iterable<int?> maxKhz) {
  final counts = <int, int>{};
  for (final max in maxKhz) {
    if (max == null || max <= 0) continue;
    counts[max] = (counts[max] ?? 0) + 1;
  }
  if (counts.isEmpty) return '';
  final keys = counts.keys.toList()..sort((a, b) => b.compareTo(a));
  final parts = [
    for (final k in keys) '${counts[k]}×${formatDouble(k / 1e6, decimals: 2)}',
  ];
  return '${parts.join(' + ')} GHz';
}

/// "sensor_type_name" -> "Sensor type name".
String prettyIdentifier(String id) {
  final s = id.replaceAll(RegExp(r'[_.]+'), ' ').trim();
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
