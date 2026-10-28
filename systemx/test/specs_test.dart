import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:systemx/core/format.dart';
import 'package:systemx/core/settings/settings.dart';
import 'package:systemx/features/device/carriers.dart';
import 'package:systemx/features/device/device_data.dart';
import 'package:systemx/features/device/sensor_sheet.dart';
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
      expect(opticalFormat(9.8, 7.4), '1/1.3"');
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
      final clusters = find(DeviceCategory.processor, 'Clusters');
      expect(clusters.items, ['1 × 2.91 GHz', '4 × 2.37 GHz', '4 × 1.70 GHz']);
      expect(clusters.value, '1 × 2.91 GHz + 4 × 2.37 GHz + 4 × 1.70 GHz');
      final features = find(DeviceCategory.processor, 'Instruction features');
      expect(features.items!.take(3), ['fp', 'asimd', 'evtstrm']);
      expect(features.hint, '16 features');
      expect(find(DeviceCategory.processor, 'Supported ABIs').items,
          ['arm64-v8a', 'armeabi-v7a', 'armeabi']);
      expect(find(DeviceCategory.system, 'Baseband (modem)').value, 'g5300i-250605');
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
      // No count and nothing tracked yet: no row rather than a fake 0.
      final labels = builder()
          .build(DeviceCategory.battery, s)
          .expand((x) => x.specs)
          .map((x) => x.label);
      expect(labels.where((x) => x.startsWith('Charge cycles')), isEmpty);
      expect(
        find(DeviceCategory.battery, 'Power source', s).value,
        'On battery',
      );
    });

    test('cycles fall back to the count SystemX tracked', () {
      final b = BatteryInfo(
        level: 50,
        status: 3,
        plugged: 0,
        health: 2,
        tempC: 30,
        voltageMv: 3900,
        present: true,
        trackedCycles: 2.35,
        trackedSinceMs: DateTime(2026, 10, 1).millisecondsSinceEpoch,
      );
      final row = find(DeviceCategory.battery, 'Charge cycles (estimated)',
          DeviceSnapshot(battery: b));
      expect(row.value, '2.4');
      expect(row.hint, contains('Oct 1, 2026'));
      expect(find(DeviceCategory.battery, 'Charge cycles').value, '212');
    });

    test('device sheet shows region and identifiers', () {
      expect(
        find(DeviceCategory.device, 'Sales country').value,
        'United States (US)',
      );
      expect(find(DeviceCategory.device, 'Launched with').value,
          'Android 14');
      expect(find(DeviceCategory.device, 'Android ID').value,
          'a3f1c29e7b6d4e08');
      final imei = find(DeviceCategory.device, 'IMEI and serial number');
      expect((imei.action! as Dial).code, '*#06#');
      final samsung = DeviceSnapshot(
        identity: DeviceIdentity(
          manufacturer: 'Samsung',
          brand: 'Samsung',
          model: 'SM-S928N',
          marketName: 'Galaxy S24 Ultra',
          codename: 'e3q',
          product: 'e3qksx',
          board: 'pineapple',
          hardware: 'qcom',
          isTablet: false,
          salesCode: 'KOO',
          salesRegion: 'KOREA',
          oemSkin: 'One UI 8.0',
          warrantyVoid: false,
        ),
      );
      expect(find(DeviceCategory.device, 'Sales code', samsung).value, 'KOO');
      expect(find(DeviceCategory.device, 'Region', samsung).value, 'Korea');
      expect(find(DeviceCategory.device, 'Manufacturer UI', samsung).value,
          'One UI 8.0');
      expect(find(DeviceCategory.device, 'Knox warranty', samsung).tone,
          SpecTone.good);
    });

    test('sensors show totals and Android\'s groups', () {
      expect(find(DeviceCategory.sensors, 'Total sensors').value, '2');
      expect(sensorGroup(1), SensorGroup.motion);
      expect(sensorGroup(8), SensorGroup.position);
      expect(sensorGroup(6), SensorGroup.environment);
      expect(sensorGroup(21), SensorGroup.health);
      expect(sensorGroup(65538), SensorGroup.other);
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
        '6.2" · 1080×2400 · 120 Hz',
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

  test('search matches every word, across label, value and section', () {
    final b = builder();
    final sheets = {for (final c in DeviceCategory.values) c: b.build(c, snap)};
    final vulkan = searchSpecs(sheets, 'VULKAN');
    expect(vulkan.map((r) => r.$1), contains(DeviceCategory.gpu));
    final chip = searchSpecs(sheets, 'tensor g3');
    expect(chip.map((r) => r.$2.label), contains('Chip'));
    expect(searchSpecs(sheets, 'tensor g9'), isEmpty);
    expect(searchSpecs(sheets, '   '), isEmpty);
  });

  test('sensor readings show axes and units', () {
    expect(sensorUnit(1), 'm/s²');
    expect(sensorUnit(5), 'lx');
    expect(sensorValues(1, [1, 2, 3]), [('X', 1.0), ('Y', 2.0), ('Z', 3.0)]);
    expect(sensorValues(5, [120]), [('', 120.0)]);
  });

  test('carriers resolve from MCC+MNC or the SIM name', () {
    expect(carrierFor(mccMnc: '47001')?.balanceCode, '*566#');
    expect(carrierFor(mccMnc: '47003')?.balanceCode, '*124#');
    expect(carrierFor(mccMnc: '47004')?.balanceCode, '*152#');
    expect(carrierFor(mccMnc: '47007')?.balanceCode, '*778#');
    // Every carrier has a balance and own-number code, and each is unique.
    for (final mccMnc in ['47001', '47002', '47003', '47004', '47007']) {
      final c = carrierFor(mccMnc: mccMnc)!;
      final kinds = c.codes.map((x) => x.kind).toList();
      expect(kinds, containsAll([CodeKind.balance, CodeKind.ownNumber]), reason: c.name);
      expect(kinds.toSet().length, kinds.length, reason: c.name);
    }
    expect(carrierFor(name: 'Robi Axiata')?.name, 'Robi');
    expect(carrierFor(name: 'GP')?.name, 'Grameenphone');
    expect(carrierFor(mccMnc: '31026', name: 'T-Mobile'), isNull);
  });

  test('long technical values are tidied for display', () {
    expect(cleanGpuName('Adreno (TM) 650'), 'Adreno 650');
    expect(cleanGpuName('Mali-G710®  MC10'), 'Mali-G710 MC10');
    final (v, built) = parseGlDriver(
        'OpenGL ES 3.2 V@0502.0 (GIT@db3d445dbc, Ia06b22fa1a, 1633355031) (Date:10/04/21)');
    expect(v, '0502.0');
    expect(built, DateTime(2021, 10, 4));
    final (mali, none) = parseGlDriver('OpenGL ES 3.2 v1.r38p1-01eac0.c1a71ccca2acf211eb87c5db5322f569');
    expect(mali, 'v1.r38p1-01eac0.c1a71ccca2acf211eb87c5db5322f569');
    expect(none, isNull);
    expect(distinctParts('2.5.c1-gl-1,2.5.c1-gl-1'), ['2.5.c1-gl-1']);
    expect(distinctParts('a, b,'), ['a', 'b']);
    expect(clusterItems([1800000, 3187000, 2419000, 2419000]),
        ['1 × 3.19 GHz', '2 × 2.42 GHz', '1 × 1.80 GHz']);
  });
}
