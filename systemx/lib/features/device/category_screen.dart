import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/permissions.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import 'carriers.dart';
import 'device_data.dart';
import 'share.dart';
import 'spec_sheets.dart';
import 'spec_view.dart';
import 'specs.dart';

/// Full specs for one category. Processor, memory and battery refresh live
/// while the screen is visible and the app is in the foreground.
class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key, required this.category});

  final DeviceCategory category;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  Timer? _timer;
  late final AppLifecycleListener _lifecycle;

  bool get _live => const {
        DeviceCategory.processor,
        DeviceCategory.memory,
        DeviceCategory.battery,
      }.contains(widget.category);

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        _refresh();
        _start();
      },
      onPause: _stop,
    );
    _start();
  }

  void _start() {
    _stop();
    if (!_live) return;
    final rate = ref.read(settingsProvider).refreshRate;
    _timer = Timer.periodic(
        Duration(milliseconds: rate.millis), (_) => _refresh());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _refresh() => ref.invalidate(categorySnapshotProvider(widget.category));

  @override
  void dispose() {
    _stop();
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _onAction(SpecAction action) async {
    switch (action) {
      case OpenSettings(:final action):
        await openSystemSettings(context, ref, action);
      case AskPermission(:final kind):
        await _askPermission(kind);
      case ShowSensor():
        showComingSoon(context);
    }
  }

  Future<void> _askPermission(String kind) async {
    final permission = AppPermission.byName(kind);
    if (permission == null) return;
    final status = await ref.read(permissionApiProvider).status(kind);
    if (!mounted) return;
    if (status == 'granted' && permission == AppPermission.location) {
      // Allowed already, so the name is hidden because Location is off.
      await openSystemSettings(context, ref, SettingsActions.location);
      return;
    }
    if (await requestPermission(context, ref, permission)) {
      _refresh();
      ref.invalidate(fullSnapshotProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(settingsProvider.select((s) => s.refreshRate), (_, _) => _start());
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final c = widget.category;
    final snapshot = ref.watch(categorySnapshotProvider(c));
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final sections = switch (snapshot.value) {
      final snap? => SpecBuilder(l, tempUnit: unit).build(c, snap),
      null => const <SpecSection>[],
    };

    return PageScaffold(
      title: c.title(l),
      leading: const BackButton(),
      actions: [
        if (_live)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Center(
              child: StatusChip(l.live, color: c.color(sx), icon: Icons.circle),
            ),
          ),
        IconButton(
          tooltip: l.shareSpecs,
          icon: const Icon(Icons.share_outlined),
          onPressed: sections.isEmpty
              ? null
              : () => ref.read(shareTextProvider)(
                    specsToText(c.title(l), sections),
                    shareSubject(l, snapshot.value),
                  ),
        ),
      ],
      slivers: [
        ...snapshot.when(
          skipLoadingOnRefresh: true,
          loading: () => [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
          error: (_, _) => [const Box(SpecsUnavailable())],
          data: (snap) {
            if (sections.isEmpty) return [const Box(SpecsUnavailable())];
            return [
              if (c == DeviceCategory.sim && snap.sim != null)
                _BalanceCard(sim: snap.sim!),
              SpecSections(sections: sections, onAction: _onAction),
            ];
          },
        ),
      ],
    );
  }
}

/// Opens the dialer with each Bangladeshi carrier's balance code.
class _BalanceCard extends ConsumerWidget {
  const _BalanceCard({required this.sim});

  final SimInfo sim;

  List<Carrier> get _carriers {
    final found = <String, Carrier>{};
    for (final card in sim.cards) {
      final mccMnc = card.mcc != null && card.mnc != null
          ? '${card.mcc}${card.mnc}'
          : null;
      final c = carrierFor(mccMnc: mccMnc, name: card.carrier);
      if (c != null) found[c.name] = c;
    }
    if (found.isEmpty) {
      final c = carrierFor(mccMnc: sim.simOperator, name: sim.simOperatorName);
      if (c != null) found[c.name] = c;
    }
    return found.values.toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carriers = _carriers;
    if (carriers.isEmpty) return const SliverToBoxAdapter();
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    return Box(SxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.balanceTitle, style: context.text.titleMedium),
          const SizedBox(height: 4),
          Text(l.balanceBody,
              style: context.text.bodySmall?.copyWith(color: sx.muted)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final c in carriers)
              FilledButton.tonalIcon(
                onPressed: () => ref.read(deviceApiProvider).dial(c.balanceCode),
                icon: const Icon(Icons.dialpad_rounded, size: 18),
                label: Text(l.balanceButton(c.name, c.balanceCode)),
              ),
          ]),
        ],
      ),
    ));
  }
}
