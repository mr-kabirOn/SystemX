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
