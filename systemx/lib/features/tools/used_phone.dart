import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../device/device_data.dart';
import '../tests/test_results.dart';

/// What the seller says about the phone. Every field is optional.
class SellerClaims {
  const SellerClaims({this.model = '', this.storageGb, this.ramGb, this.country = ''});

  final String model;
  final int? storageGb;
  final int? ramGb;
  final String country;

  bool get isEmpty => model.trim().isEmpty && storageGb == null && ramGb == null && country.trim().isEmpty;
}

enum CheckLevel { ok, warn, bad, info }

enum CheckGroup { claims, software, battery, hardware }

class UsedCheck {
  const UsedCheck(this.group, this.title, this.detail, this.level);

  final CheckGroup group;
  final String title;
  final String detail;
  final CheckLevel level;
}

enum UsedVerdict { clean, checkFirst, problems, incomplete }

class UsedPhoneReport {
  const UsedPhoneReport(this.checks, this.verdict, this.checkup);

  final List<UsedCheck> checks;
  final UsedVerdict verdict;

  /// The hardware checkup the verdict used, if a recent one exists.
  final Checkup? checkup;

  Iterable<UsedCheck> get problems => checks.where((c) => c.level == CheckLevel.bad);
  Iterable<UsedCheck> get warnings => checks.where((c) => c.level == CheckLevel.warn);
}

/// Storage sizes phones are sold with, in GB.
const storageSizes = [16, 32, 64, 128, 256, 512, 1024, 2048];

/// RAM sizes phones are sold with, in GB.
const ramSizes = [2, 3, 4, 6, 8, 10, 12, 16, 18, 20, 24];

/// The storage size on the box. Android reports the user partition, which
/// is smaller than the size sold (a 256 GB phone shows about 239 GB), so it
/// rounds up to the next sold size.
int boxStorageGb(StorageInfo s) {
  final bytes = s.advertised ?? s.total;
  final gb = bytes / 1e9;
  return storageSizes.firstWhere((x) => x >= gb * 0.98, orElse: () => gb.ceil());
}

int boxRamGb(MemoryStats m) {
  final gb = (m.advertised ?? m.total) / (1024 * 1024 * 1024);
  return ramSizes.firstWhere((x) => x >= gb * 0.98, orElse: () => gb.ceil());
}

String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

/// True when what the seller typed names this phone: "S24 Ultra" matches
/// "Galaxy S24 Ultra"; "SM-S928B" matches the model number.
bool modelMatches(String claim, DeviceIdentity id) {
  final c = _norm(claim);
  if (c.isEmpty) return true;
  final names = [id.marketName, id.model, '${id.brand} ${id.marketName}', id.codename].map(_norm);
  return names.any((n) => n.isNotEmpty && (n.contains(c) || c.contains(n)));
}

/// Checks done on the phone, with a verdict. A recent checkup (within a
/// day) is needed for the hardware part.
UsedPhoneReport evaluateUsedPhone({
  required AppLocalizations l,
  required DeviceSnapshot snap,
  required SellerClaims claims,
  required TestHistory history,
  int? capacityPercent,
  required DateTime now,
}) {
  final checks = <UsedCheck>[];
  void add(CheckGroup g, String t, String d, CheckLevel lv) => checks.add(UsedCheck(g, t, d, lv));

  // ---- What the seller said ----
  final id = snap.identity;
  if (id != null && claims.model.trim().isNotEmpty) {
    final ok = modelMatches(claims.model, id);
    add(CheckGroup.claims, l.upModel, ok ? l.upMatches(id.marketName) : l.upDiffers(claims.model.trim(), id.marketName),
        ok ? CheckLevel.ok : CheckLevel.bad);
  }
  if (snap.storage case final s? when claims.storageGb != null) {
    final box = boxStorageGb(s);
    final ok = box == claims.storageGb;
    add(CheckGroup.claims, l.upStorage, ok ? l.upMatches('$box GB') : l.upDiffers('${claims.storageGb} GB', '$box GB'),
        ok ? CheckLevel.ok : CheckLevel.bad);
  }
  if (snap.memory case final m? when claims.ramGb != null) {
    final box = boxRamGb(m);
    final ok = box == claims.ramGb;
    add(CheckGroup.claims, l.upRam, ok ? l.upMatches('$box GB') : l.upDiffers('${claims.ramGb} GB', '$box GB'),
        ok ? CheckLevel.ok : CheckLevel.bad);
  }
  final country = claims.country.trim();
  if (id != null && country.isNotEmpty) {
    final known = [id.salesCountry, id.salesCountryIso, id.salesRegion].whereType<String>().toList();
    if (known.isEmpty) {
      add(CheckGroup.claims, l.upRegion, l.upRegionUnknown, CheckLevel.info);
    } else {
      final ok = known.any((k) => _norm(k).contains(_norm(country)) || _norm(country).contains(_norm(k)));
      final shown = id.salesCountry ?? id.salesRegion ?? id.salesCountryIso!;
      add(CheckGroup.claims, l.upRegion, ok ? l.upMatches(shown) : l.upDiffers(country, shown),
          ok ? CheckLevel.ok : CheckLevel.warn);
    }
  }

  // ---- Software: has it been modified? ----
  final sec = snap.security;
  final rooted = (snap.system?.rootDetected ?? false) || (sec?.rootDetected ?? false);
  add(CheckGroup.software, l.upRoot, rooted ? l.upRootBad : l.upRootOk, rooted ? CheckLevel.bad : CheckLevel.ok);
  if (sec?.bootloaderLocked case final locked?) {
    add(CheckGroup.software, l.upBootloader, locked ? l.upBootloaderOk : l.upBootloaderBad,
        locked ? CheckLevel.ok : CheckLevel.bad);
  }
  if (sec?.verifiedBoot case final vb?) {
    add(CheckGroup.software, l.upVerifiedBoot, vb == 'green' ? l.upVerifiedBootOk : l.upVerifiedBootBad(vb),
        vb == 'green' ? CheckLevel.ok : CheckLevel.warn);
  }
  if (id?.warrantyVoid case final tripped?) {
    add(CheckGroup.software, l.specWarranty, tripped ? l.upKnoxBad : l.upKnoxOk,
        tripped ? CheckLevel.warn : CheckLevel.ok);
  }
  if (snap.system?.securityPatch case final patch?) {
    final date = DateTime.tryParse(patch);
    if (date != null) {
      final months = (now.year - date.year) * 12 + now.month - date.month;
      add(CheckGroup.software, l.specSecurityPatch, l.monthsOld(months),
          months > 12 ? CheckLevel.warn : CheckLevel.ok);
    }
  }

  // ---- Battery ----
  if (snap.battery case final b?) {
    final good = b.health == 2 || b.health == 1; // good, or unknown (not a fault)
    add(CheckGroup.battery, l.specHealth, good ? l.upHealthOk : l.upHealthBad,
        good ? CheckLevel.ok : CheckLevel.bad);
    if (capacityPercent != null) {
      add(
        CheckGroup.battery,
        l.bhCapacity,
        l.upCapacity(capacityPercent),
        capacityPercent >= 80
            ? CheckLevel.ok
            : capacityPercent >= 65
                ? CheckLevel.warn
                : CheckLevel.bad,
      );
    }
    if (b.cycleCount case final cycles?) {
      add(CheckGroup.battery, l.specCycleCount, '$cycles', cycles > 800 ? CheckLevel.warn : CheckLevel.ok);
    }
  }

  // ---- Hardware tests from a recent checkup ----
  final last = history.lastCheckup;
  final recent = last != null && now.difference(last.at) < const Duration(hours: 24) ? last : null;
  if (recent != null) {
    for (final r in recent.ordered) {
      if (r.status == TestStatus.failed) {
        add(CheckGroup.hardware, r.test.title(l), r.note ?? l.statusFailed, CheckLevel.bad);
      }
    }
    final passed = recent.count(TestStatus.passed);
    add(CheckGroup.hardware, l.upTests, l.passedOf(passed, recent.results.length),
        recent.count(TestStatus.failed) == 0 ? CheckLevel.ok : CheckLevel.info);
  }

  final verdict = checks.any((c) => c.level == CheckLevel.bad)
      ? UsedVerdict.problems
      : recent == null
          ? UsedVerdict.incomplete
          : checks.any((c) => c.level == CheckLevel.warn)
              ? UsedVerdict.checkFirst
              : UsedVerdict.clean;
  return UsedPhoneReport(checks, verdict, recent);
}
