import 'package:flutter/material.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;

    final categories = <(IconData, Color, String, String)>[
      (SxIcons.device, sx.accent, l.catDevice, l.catDeviceSub),
      (SxIcons.system, sx.good, l.catSystem, l.catSystemSub),
      (SxIcons.cpu, sx.cpu, l.catProcessor, l.catProcessorSub),
      (SxIcons.gpu, sx.cpu, l.catGpu, l.catGpuSub),
      (SxIcons.ram, sx.ram, l.catMemory, l.catMemorySub),
      (SxIcons.storage, sx.storage, l.catStorage, l.catStorageSub),
      (SxIcons.battery, sx.battery, l.catBattery, l.catBatterySub),
      (SxIcons.display, sx.display, l.catDisplay, l.catDisplaySub),
      (SxIcons.network, sx.network, l.catNetwork, l.catNetworkSub),
      (SxIcons.sim, sx.network, l.catSim, l.catSimSub),
      (SxIcons.camera, sx.camera, l.catCameras, l.catCamerasSub),
      (SxIcons.sensors, sx.sensors, l.catSensors, l.catSensorsSub),
      (SxIcons.media, sx.ram, l.catMedia, l.catMediaSub),
      (SxIcons.features, sx.storage, l.catFeatures, l.catFeaturesSub),
      (SxIcons.security, sx.good, l.catSecurity, l.catSecuritySub),
    ];

    return PageScaffold(
      title: l.deviceTitle,
      slivers: [
        Box(TextField(
          readOnly: true,
          onTap: () => showComingSoon(context),
          decoration: InputDecoration(
            hintText: l.deviceSearch,
            prefixIcon: Icon(Icons.search_rounded, color: sx.muted),
          ),
        )),
        Box(SxCard(
          gradient: heroGradient(sx),
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Eyebrow('Android', color: sx.onHero),
                  const SizedBox(height: 6),
                  Text(l.deviceHeroTitle,
                      style: context.text.headlineSmall
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(l.deviceHeroSub,
                      style: context.text.bodySmall?.copyWith(color: sx.onHero)),
                ],
              ),
            ),
            Icon(SxIcons.device, size: 44, color: sx.onHero),
          ]),
        )),
        Box(
          SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              for (final (i, c) in categories.indexed) ...[
                if (i > 0) const Divider(indent: 66, endIndent: 14),
                CategoryRow(
                  icon: c.$1,
                  color: c.$2,
                  title: c.$3,
                  subtitle: c.$4,
                  onTap: () => showComingSoon(context),
                ),
              ],
            ]),
          ),
          bottom: 0,
        ),
      ],
    );
  }
}
