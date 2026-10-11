import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';

/// The 15 spec categories on the Device tab, in display order.
enum DeviceCategory {
  device,
  system,
  processor,
  gpu,
  memory,
  storage,
  battery,
  display,
  network,
  sim,
  cameras,
  sensors,
  media,
  features,
  security;

  static DeviceCategory? byName(String name) {
    for (final c in values) {
      if (c.name == name) return c;
    }
    return null;
  }

  IconData get icon => switch (this) {
        device => SxIcons.device,
        system => SxIcons.system,
        processor => SxIcons.cpu,
        gpu => SxIcons.gpu,
        memory => SxIcons.ram,
        storage => SxIcons.storage,
        battery => SxIcons.battery,
        display => SxIcons.display,
        network => SxIcons.network,
        sim => SxIcons.sim,
        cameras => SxIcons.camera,
        sensors => SxIcons.sensors,
        media => SxIcons.media,
        features => SxIcons.features,
        security => SxIcons.security,
      };

  Color color(SxColors sx) => switch (this) {
        device => sx.accent,
        system => sx.good,
        processor || gpu => sx.cpu,
        memory || media => sx.ram,
        storage || features => sx.storage,
        battery => sx.battery,
        display => sx.display,
        network || sim => sx.network,
        cameras => sx.camera,
        sensors => sx.sensors,
        security => sx.good,
      };

  String title(AppLocalizations l) => switch (this) {
        device => l.catDevice,
        system => l.catSystem,
        processor => l.catProcessor,
        gpu => l.catGpu,
        memory => l.catMemory,
        storage => l.catStorage,
        battery => l.catBattery,
        display => l.catDisplay,
        network => l.catNetwork,
        sim => l.catSim,
        cameras => l.catCameras,
        sensors => l.catSensors,
        media => l.catMedia,
        features => l.catFeatures,
        security => l.catSecurity,
      };

  /// Static description, shown until real values have loaded.
  String subtitle(AppLocalizations l) => switch (this) {
        device => l.catDeviceSub,
        system => l.catSystemSub,
        processor => l.catProcessorSub,
        gpu => l.catGpuSub,
        memory => l.catMemorySub,
        storage => l.catStorageSub,
        battery => l.catBatterySub,
        display => l.catDisplaySub,
        network => l.catNetworkSub,
        sim => l.catSimSub,
        cameras => l.catCamerasSub,
        sensors => l.catSensorsSub,
        media => l.catMediaSub,
        features => l.catFeaturesSub,
        security => l.catSecuritySub,
      };

  /// Probes this category reads. SIM also shows the mobile network.
  Set<Probe> get probes => switch (this) {
        device => {Probe.identity},
        system => {Probe.system},
        processor => {Probe.cpu},
        gpu => {Probe.gpu},
        memory => {Probe.memory},
        storage => {Probe.storage},
        battery => {Probe.battery},
        display => {Probe.display},
        network => {Probe.network},
        sim => {Probe.sim, Probe.network},
        cameras => {Probe.cameras},
        sensors => {Probe.sensors},
        media => {Probe.media},
        features => {Probe.features},
        security => {Probe.security},
      };
}

/// One call into the Kotlin layer.
enum Probe {
  identity,
  system,
  cpu,
  gpu,
  memory,
  storage,
  battery,
  display,
  network,
  sim,
  cameras,
  sensors,
  media,
  features,
  security,
}

/// Results of the probes that were asked for. A probe that failed or was not
/// requested is null, so one broken reading never hides the rest.
@immutable
class DeviceSnapshot {
  const DeviceSnapshot({
    this.identity,
    this.system,
    this.cpu,
    this.gpu,
    this.memory,
    this.storage,
    this.battery,
    this.display,
    this.network,
    this.sim,
    this.cameras,
    this.sensors,
    this.media,
    this.features,
    this.security,
  });

  final DeviceIdentity? identity;
  final SystemInfo? system;
  final CpuInfo? cpu;
  final GpuInfo? gpu;
  final MemoryStats? memory;
  final StorageInfo? storage;
  final BatteryInfo? battery;
  final DisplayInfo? display;
  final NetworkInfo? network;
  final SimInfo? sim;
  final List<CameraInfo>? cameras;
  final List<SensorInfo>? sensors;
  final MediaInfo? media;
  final FeaturesInfo? features;
  final SecurityInfo? security;
}

/// Runs the requested probes in parallel. Errors become nulls.
Future<DeviceSnapshot> loadSnapshot(DeviceInfoApi api, Set<Probe> probes) async {
  Future<T?> run<T>(Probe p, Future<T> Function() call) async {
    if (!probes.contains(p)) return null;
    try {
      return await call();
    } catch (e) {
      debugPrint('SystemX: ${p.name} probe failed: $e');
      return null;
    }
  }

  final identity = run(Probe.identity, api.identity);
  final system = run(Probe.system, api.system);
  final cpu = run(Probe.cpu, api.cpu);
  final gpu = run(Probe.gpu, api.gpu);
  final memory = run(Probe.memory, api.memory);
  final storage = run(Probe.storage, api.storage);
  final battery = run(Probe.battery, api.battery);
  final display = run(Probe.display, api.display);
  final network = run(Probe.network, api.network);
  final sim = run(Probe.sim, api.sim);
  final cameras = run(Probe.cameras, api.cameras);
  final sensors = run(Probe.sensors, api.sensors);
  final media = run(Probe.media, api.media);
  final features = run(Probe.features, api.features);
  final security = run(Probe.security, api.security);

  return DeviceSnapshot(
    identity: await identity,
    system: await system,
    cpu: await cpu,
    gpu: await gpu,
    memory: await memory,
    storage: await storage,
    battery: await battery,
    display: await display,
    network: await network,
    sim: await sim,
    cameras: await cameras,
    sensors: await sensors,
    media: await media,
    features: await features,
    security: await security,
  );
}

/// Data for one category screen. Disposed when the screen closes, so values
/// are fresh each time it opens; refresh with `ref.invalidate`.
final categorySnapshotProvider = FutureProvider.autoDispose
    .family<DeviceSnapshot, DeviceCategory>((ref, category) {
  return loadSnapshot(ref.watch(deviceApiProvider), category.probes);
});

/// What the Home screen needs. Leaves out slow probes (codecs, cameras,
/// sensors) so the dashboard is ready quickly at launch.
final homeSnapshotProvider = FutureProvider.autoDispose<DeviceSnapshot>((ref) {
  return loadSnapshot(ref.watch(deviceApiProvider),
      const {Probe.identity, Probe.battery, Probe.storage, Probe.security});
});

/// Every probe at once, for the Device tab summaries, search and sharing.
final fullSnapshotProvider = FutureProvider.autoDispose<DeviceSnapshot>((ref) {
  return loadSnapshot(ref.watch(deviceApiProvider), Probe.values.toSet());
});
