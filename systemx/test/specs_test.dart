import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:systemx/core/format.dart';
import 'package:systemx/core/settings/settings.dart';
import 'package:systemx/features/device/carriers.dart';
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/device/spec_sheets.dart';
import 'package:systemx/features/device/specs.dart';
import 'package:systemx/l10n/app_localizations.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('en'));
  final now = DateTime(2026, 10, 12);
  late DeviceSnapshot snap;

  setUpAll(() async {
    await initializeDateFormatting('en');
    snap = await loadSnapshot(FakeDeviceApi(), Probe.values.toSet());
  });

  SpecBuilder builder({TempUnit unit = TempUnit.celsius}) =>
      SpecBuilder(l, tempUnit: unit, now: now);

  Spec find(DeviceCategory c, String label, [DeviceSnapshot? s]) => builder()
      .build(c, s ?? snap)
      .expand((x) => x.specs)
      .firstWhere(
        (x) => x.label == label,
        orElse: () => throw StateError('no "$label" in ${c.name}'),
      );

  group('format helpers', () {
    test('Wi-Fi band, channel and standard', () {
      expect(wifiBand(2437), '2.4 GHz');
      expect(wifiChannel(2437), 6);
      expect(wifiChannel(2484), 14);
      expect(wifiBand(5180), '5 GHz');
      expect(wifiChannel(5180), 36);
      expect(wifiBand(6115), '6 GHz');
      expect(wifiChannel(6115), 33);
      expect(wifiStandardName(6), 'Wi-Fi 6 (802.11ax)');
      expect(wifiStandardName(0), isNull);
    });

    test('aspect ratio reads like a spec sheet', () {
      expect(aspectRatio(1080, 2400), '20:9');
      expect(aspectRatio(1080, 1920), '16:9');
      expect(aspectRatio(1080, 2340), '19.5:9');
      expect(aspectRatio(1536, 2048), '4:3');
      expect(aspectRatio(1600, 2560), '16:10');
      expect(aspectRatio(2000, 3000), '3:2');
    });

    test('display size, density and camera formats', () {
      expect(displayInches(1080, 2400, 428, 428), closeTo(6.15, 0.01));
      expect(densityBucket(420), 'xxhdpi');
      expect(densityBucket(160), 'mdpi');
      expect(megapixels(8160, 6144), '50 MP');
      expect(megapixels(4032, 3024), '12.2 MP');
      expect(opticalFormat(9.8, 7.4), '1/1.3″');
    });

    test('clusters group cores by top speed, fastest first', () {
      expect(
        clusterSummary([1704000, 1704000, 2367000, 2914000, null]),
        '1×2.91 + 1×2.37 + 2×1.7 GHz',
      );
      expect(clusterSummary([null]), '');
    });

    test('identifiers become readable', () {
      expect(
        prettyIdentifier('magnetic_field_uncalibrated'),
        'Magnetic field uncalibrated',
      );
    });
  });

  group('spec sheets', () {
    test('every category builds rows from real data', () {
      for (final c in DeviceCategory.values) {
        expect(builder().build(c, snap), isNotEmpty, reason: c.name);
      }
    });

    test('a failed probe gives an empty sheet, not a crash', () {
      expect(
        builder().build(DeviceCategory.battery, const DeviceSnapshot()),
        isEmpty,
      );
    });

    test('processor shows the marketing chip name and process', () {
      expect(find(DeviceCategory.processor, 'Chip').value, 'Google Tensor G3');
      expect(find(DeviceCategory.processor, 'Process node').value, '4 nm');
      expect(
        find(DeviceCategory.processor, 'Clusters').value,
        '1×2.91 + 4×2.37 + 4×1.7 GHz',
      );
      expect(find(DeviceCategory.processor, 'Core 8').value, '1.46 GHz');
    });

    test('memory keeps decimals and shows the size on the box', () {
      expect(find(DeviceCategory.memory, 'Installed RAM').value, '8 GB');
      expect(find(DeviceCategory.memory, 'Usable by Android').value, '7.6 GB');
    });

    test('battery power, capacity estimate and temperature unit', () {
      expect(
        find(DeviceCategory.battery, 'Current now').value,
        '+2140 mA · 9 W',
      );
      // 3284 mAh left at 78% -> about 4210 mAh, 92% of 4575.
      expect(
        find(DeviceCategory.battery, 'Estimated full capacity').value,
        '4210 mAh · 92%',
      );
      final f = SpecBuilder(l, tempUnit: TempUnit.fahrenheit, now: now)
          .build(DeviceCategory.battery, snap)
          .expand((x) => x.specs)
          .firstWhere((x) => x.label == 'Temperature');
      expect(f.value, '91.6 °F');
    });

    test('missing values say so instead of guessing', () {
      final b = BatteryInfo(
        level: 50,
        status: 3,
        plugged: 0,
        health: 2,
        tempC: 30,
        voltageMv: 3900,
        present: true,
      );
      final s = DeviceSnapshot(battery: b);
      final cycles = find(DeviceCategory.battery, 'Charge cycles', s);
      expect(cycles.value, 'Not available on this device');
      expect(cycles.available, isFalse);
      expect(
        find(DeviceCategory.battery, 'Power source', s).value,
        'On battery',
      );
    });

    test('Wi-Fi name links to the Location permission when hidden', () {
      final row = find(DeviceCategory.network, 'Network name');
      expect(row.value, 'Hidden by Android');
      expect(row.action, isA<AskPermission>());
      expect(
        find(DeviceCategory.network, 'Frequency').value,
        '5180 MHz · 5 GHz · channel 36',
      );
    });

    test('SIM details ask for the Phone permission until granted', () async {
      final row = find(DeviceCategory.sim, 'SIM details');
      expect((row.action! as AskPermission).kind, 'phone');

      final api = FakeDeviceApi()..phoneGranted = true;
      final granted = await loadSnapshot(api, DeviceCategory.sim.probes);
      final sections = builder().build(DeviceCategory.sim, granted);
      expect(sections.map((s) => s.title), containsAll(['SIM 1', 'SIM 2']));
    });

    test('security check rates items and links to settings', () {
      final patch = find(DeviceCategory.security, 'Security patch');
      expect(patch.value, '1 month old');
      expect(patch.tone, SpecTone.good);
      final dev = find(DeviceCategory.security, 'Developer options');
      expect(dev.tone, SpecTone.warn);
      expect((dev.action! as OpenSettings).action, SettingsActions.developer);
      expect(
        builder().summary(DeviceCategory.security, snap),
        '8 of 9 checks passed',
      );
    });

    test('codecs collapse to one row per format', () {
      final avc = find(DeviceCategory.media, 'H.264 (AVC)');
      expect(avc.value, 'Decode (hardware) · Encode (software)');
    });

    test('summaries match the design mockup', () {
      final b = builder();
      expect(b.summary(DeviceCategory.system, snap), 'Android 16 · API 36');
      expect(
        b.summary(DeviceCategory.processor, snap),
        'Google Tensor G3 · 9 cores · 4 nm',
      );
      expect(b.summary(DeviceCategory.memory, snap), '8 GB · 2.9 GB free');
      expect(b.summary(DeviceCategory.storage, snap), '128 GB · 41 GB free');
      expect(
        b.summary(DeviceCategory.display, snap),
        '6.2″ · 1080×2400 · 120 Hz',
      );
      expect(
        b.summary(DeviceCategory.network, snap),
        'Wi-Fi 6 · 5 GHz · -52 dBm',
      );
      expect(b.summary(DeviceCategory.cameras, snap), '2 cameras · 50 MP main');
      expect(b.summary(DeviceCategory.device, const DeviceSnapshot()), isNull);
    });

    test('share text lists every row', () {
      final text = specsToText(
        'Device',
        builder().build(DeviceCategory.device, snap),
      );
      expect(text, contains('Model name: Pixel 8'));
      expect(text, contains('Codename: shiba'));
    });
  });

  test('carriers resolve from MCC+MNC or the SIM name', () {
    expect(carrierFor(mccMnc: '47001')?.balanceCode, '*121#');
    expect(carrierFor(name: 'Robi Axiata')?.name, 'Robi');
    expect(carrierFor(name: 'GP')?.name, 'Grameenphone');
    expect(carrierFor(mccMnc: '31026', name: 'T-Mobile'), isNull);
  });
}
