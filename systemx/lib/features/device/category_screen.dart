import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
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
      case AskPermission():
      case ShowSensor():
        showComingSoon(context);
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
          data: (_) {
            if (sections.isEmpty) return [const Box(SpecsUnavailable())];
            return [SpecSections(sections: sections, onAction: _onAction)];
          },
        ),
      ],
    );
  }
}
