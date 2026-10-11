import 'package:flutter/material.dart';

import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/gauges.dart';
import '../../ui/widgets/page_scaffold.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;

    final charts = <(String, String, String, Color, List<double>)>[
      (l.monitorCpu, '1.82', 'GHz', sx.cpu,
          [1.1, 1.4, 1.2, 1.9, 1.5, 2.2, 1.7, 2.0, 1.4, 1.6, 2.1, 1.8, 1.9, 1.82]),
      (l.monitorRam, '64', '%', sx.ram,
          [58, 59, 61, 60, 62, 63, 61, 64, 66, 65, 63, 64, 65, 64]),
      (l.monitorBattery, '+2,140', 'mA', sx.battery,
          [400, 2300, 2350, 2320, 2310, 2280, 2250, 2230, 2200, 2190, 2170, 2160, 2150, 2140]),
      (l.monitorNet, '2.4', 'MB/s', sx.network,
          [0.3, 0.8, 2.6, 2.1, 0.9, 3.0, 2.7, 1.6, 2.8, 2.0, 2.5, 1.9, 2.6, 2.4]),
    ];

    return PageScaffold(
      title: l.monitorTitle,
      slivers: [
        Box(Text(l.monitorBody, style: context.text.bodyMedium?.copyWith(color: sx.muted))),
        SliverList.separated(
          itemCount: charts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final c = charts[i];
            return SxCard(
              onTap: () => showComingSoon(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Eyebrow(c.$1, color: c.$4)),
                    StatusChip(l.sample),
                  ]),
                  const SizedBox(height: 8),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: c.$2, style: SxText.readout(26, sx.ink)),
                    TextSpan(
                        text: ' ${c.$3}',
                        style: SxText.readout(13, sx.muted, weight: FontWeight.w500)),
                  ])),
                  const SizedBox(height: 12),
                  Sparkline(values: c.$5, color: c.$4, height: 84, showGrid: true),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
