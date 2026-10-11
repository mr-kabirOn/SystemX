import 'package:flutter/foundation.dart';

import '../../platform/platform.dart';
import 'device_data.dart';

/// Status shown next to a value. Never conveyed by color alone: the value
/// text always says it too.
enum SpecTone { neutral, good, warn, bad }

/// What tapping a spec row does.
sealed class SpecAction {
  const SpecAction();
}

/// Opens a system settings screen (an Intent action string).
class OpenSettings extends SpecAction {
  const OpenSettings(this.action);
  final String action;
}

/// Asks for a runtime permission ("location" or "phone") so a hidden value
/// can be shown.
class AskPermission extends SpecAction {
  const AskPermission(this.kind);
  final String kind;
}

/// Shows a sensor's details and live reading.
class ShowSensor extends SpecAction {
  const ShowSensor(this.sensor);
  final SensorInfo sensor;
}

@immutable
class Spec {
  const Spec(
    this.label,
    this.value, {
    this.hint,
    this.tone = SpecTone.neutral,
    this.action,
    this.available = true,
  });

  final String label;
  final String value;
  final String? hint;
  final SpecTone tone;
  final SpecAction? action;

  /// False when Android doesn't expose this value; it is shown muted.
  final bool available;
}

@immutable
class SpecSection {
  const SpecSection(this.title, this.specs);

  /// null for the first, untitled block.
  final String? title;
  final List<Spec> specs;
}

/// Plain-text version of a category, for sharing. [compact] leaves out
/// rows without a value (the long raw feature-flag list).
String specsToText(String title, List<SpecSection> sections,
    {bool compact = false}) {
  final b = StringBuffer('== $title ==\n');
  for (final s in sections) {
    final specs = compact ? s.specs.where((x) => x.value.isNotEmpty) : s.specs;
    if (specs.isEmpty) continue;
    if (s.title != null) b.write('\n-- ${s.title} --\n');
    for (final spec in specs) {
      b.write(spec.value.isEmpty ? spec.label : '${spec.label}: ${spec.value}');
      b.write('\n');
    }
  }
  return b.toString();
}

/// Rows whose label, value or hint contains every word of [query].
List<(DeviceCategory, Spec)> searchSpecs(
    Map<DeviceCategory, List<SpecSection>> sheets, String query) {
  final words = query.toLowerCase().split(RegExp(r'\s+'))
    ..removeWhere((w) => w.isEmpty);
  if (words.isEmpty) return const [];
  final results = <(DeviceCategory, Spec)>[];
  for (final MapEntry(key: category, value: sections) in sheets.entries) {
    for (final section in sections) {
      for (final spec in section.specs) {
        final haystack = [spec.label, spec.value, spec.hint ?? '', section.title ?? '']
            .join(' ')
            .toLowerCase();
        if (words.every(haystack.contains)) results.add((category, spec));
      }
    }
  }
  return results;
}
