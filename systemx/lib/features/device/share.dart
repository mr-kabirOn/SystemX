import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/format.dart';
import '../../l10n/app_localizations.dart';
import 'device_data.dart';
import 'spec_sheets.dart';
import 'specs.dart';

/// Opens the Android share sheet. Overridden in tests.
final shareTextProvider =
    Provider<Future<void> Function(String text, String subject)>(
  (ref) => (text, subject) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  },
);

/// The whole spec sheet as plain text, one block per category.
String fullSpecSheet(SpecBuilder b, DeviceSnapshot snap, DateTime now) {
  final l = b.l;
  final name = snap.identity?.marketName ?? l.deviceHeroTitle;
  final out = StringBuffer(
      '${l.specSheetHeader(name, formatDate(now, l.localeName))}\n\n');
  for (final c in DeviceCategory.values) {
    final sections = b.build(c, snap);
    if (sections.isEmpty) continue;
    out.write(specsToText(c.title(l), sections, compact: true));
    out.write('\n');
  }
  out.write(l.specSheetFooter);
  return out.toString();
}

String shareSubject(AppLocalizations l, DeviceSnapshot? snap) =>
    l.specSheetSubject(snap?.identity?.marketName ?? l.deviceHeroTitle);
