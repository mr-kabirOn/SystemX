import 'package:flutter/material.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../../ui/widgets/test_tile.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;

    final tests = <(IconData, Color, String)>[
      (SxIcons.brightness, sx.display, l.testDisplay),
      (SxIcons.touch, sx.accent, l.testTouch),
      (SxIcons.speaker, sx.network, l.testSpeaker),
      (SxIcons.earpiece, sx.network, l.testEarpiece),
      (SxIcons.mic, sx.ram, l.testMicrophone),
      (SxIcons.vibration, sx.cpu, l.testVibration),
      (SxIcons.camera, sx.camera, l.testCameras),
      (SxIcons.flashlight, sx.warn, l.testFlashlight),
      (SxIcons.sensors, sx.sensors, l.testSensors),
      (SxIcons.buttons, sx.storage, l.testButtons),
      (SxIcons.network, sx.network, l.testWifi),
      (SxIcons.bluetooth, sx.storage, l.testBluetooth),
      (SxIcons.gps, sx.good, l.testGps),
      (SxIcons.fingerprint, sx.accent, l.testFingerprint),
      (SxIcons.charging, sx.battery, l.testCharging),
      (SxIcons.speed, sx.storage, l.testStorage),
    ];

    return PageScaffold(
      title: l.testsTitle,
      slivers: [
        Box(SxCard(
          gradient: heroGradient(sx),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(l.checkupTitle, color: sx.onHero),
              const SizedBox(height: 8),
              Text(l.checkupMeta(32, 4),
                  style: context.text.titleLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 6),
              Text(l.checkupBody,
                  style: context.text.bodyMedium?.copyWith(color: sx.onHero)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: sx.onHero,
                    foregroundColor: sx.heroEnd,
                  ),
                  onPressed: () => showComingSoon(context),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l.startCheckup),
                ),
              ),
            ],
          ),
        )),
        SliverToBoxAdapter(child: SectionLabel(l.singleTests)),
        SliverGrid.builder(
          itemCount: tests.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 130,
            mainAxisExtent: 112,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, i) {
            final t = tests[i];
            return TestTile(
              icon: t.$1,
              color: t.$2,
              label: t.$3,
              onTap: () => showComingSoon(context),
            );
          },
        ),
      ],
    );
  }
}
