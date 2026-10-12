import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/sx_icons.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';

final appsProvider = FutureProvider.autoDispose<List<AppEntry>>(
    (ref) => ref.watch(deviceApiProvider).apps());

final usageAccessProvider = FutureProvider.autoDispose<bool>(
    (ref) => ref.watch(deviceApiProvider).usageAccessGranted());

/// Settings screens the Apps page links to.
abstract final class AppsActions {
  static const usageAccess = 'android.settings.USAGE_ACCESS_SETTINGS';
  static const manageStorage = 'android.os.storage.action.MANAGE_STORAGE';
  static const internalStorage = 'android.settings.INTERNAL_STORAGE_SETTINGS';
}

enum AppSort { size, cache, name, recent }

int _total(AppEntry a) =>
    (a.appBytes ?? 0) + (a.dataBytes ?? 0) + (a.cacheBytes ?? 0);

/// Sorts and filters the app list. Pure, so it is unit tested.
List<AppEntry> arrangeApps(
  List<AppEntry> apps, {
  required AppSort sort,
  bool showSystem = false,
  String query = '',
}) {
  final q = query.trim().toLowerCase();
  final list = apps.where((a) {
    if (!showSystem && a.system) return false;
    if (q.isEmpty) return true;
    return a.label.toLowerCase().contains(q) ||
        a.packageName.toLowerCase().contains(q);
  }).toList();
  int byName(AppEntry a, AppEntry b) =>
      a.label.toLowerCase().compareTo(b.label.toLowerCase());
  list.sort(switch (sort) {
    AppSort.size => (a, b) {
        final c = _total(b).compareTo(_total(a));
        return c != 0 ? c : byName(a, b);
      },
    AppSort.cache => (a, b) {
        final c = (b.cacheBytes ?? 0).compareTo(a.cacheBytes ?? 0);
        return c != 0 ? c : byName(a, b);
      },
    AppSort.name => byName,
    AppSort.recent => (a, b) => b.updatedMs.compareTo(a.updatedMs),
  });
  return list;
}

/// Installed apps with their size and cache. Android doesn't let an app clear
/// other apps' cache, so each row opens that app's info page instead.
class AppsScreen extends ConsumerStatefulWidget {
  const AppsScreen({super.key});

  @override
  ConsumerState<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends ConsumerState<AppsScreen> {
  late final AppLifecycleListener _lifecycle;
  AppSort? _sort;
  bool _showSystem = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Coming back from Settings: access may have changed, caches cleared.
    _lifecycle = AppLifecycleListener(onResume: () {
      ref.invalidate(usageAccessProvider);
      ref.invalidate(appsProvider);
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _freeUpSpace() async {
    final api = ref.read(deviceApiProvider);
    if (!await api.openSettings(AppsActions.manageStorage)) {
      await api.openSettings(AppsActions.internalStorage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final apps = ref.watch(appsProvider);
    final hasSizes = ref.watch(usageAccessProvider).value ?? false;
    final sort = _sort ?? (hasSizes ? AppSort.size : AppSort.name);

    return PageScaffold(
      title: l.appsTitle,
      leading: const BackButton(),
      slivers: [
        ...apps.when(
          skipLoadingOnRefresh: true,
          loading: () => [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
          error: (_, _) => [Box(Center(child: Text(l.appsEmpty)))],
          data: (all) {
            final visible = all.where((a) => _showSystem || !a.system);
            final shown = arrangeApps(all,
                sort: sort, showSystem: _showSystem, query: _query);
            return [
              Box(_Totals(apps: visible.toList(), hasSizes: hasSizes)),
              if (!hasSizes)
                Box(_Notice(
                  icon: SxIcons.storage,
                  title: l.appsUsageTitle,
                  body: l.appsUsageBody,
                  button: FilledButton(
                    onPressed: () => ref
                        .read(deviceApiProvider)
                        .openSettings(AppsActions.usageAccess),
                    child: Text(l.appsUsageButton),
                  ),
                )),
              Box(_Notice(
                icon: SxIcons.cache,
                title: l.appsCacheTitle,
                body: l.appsCacheBody,
                button: OutlinedButton(
                  onPressed: _freeUpSpace,
                  child: Text(l.appsFreeUp),
                ),
              )),
              Box(TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l.appsSearch,
                  prefixIcon: Icon(Icons.search_rounded, color: sx.muted),
                ),
              )),
              Box(Wrap(spacing: 8, runSpacing: 8, children: [
                for (final s in AppSort.values)
                  if (hasSizes || s == AppSort.name || s == AppSort.recent)
                    ChoiceChip(
                      label: Text(switch (s) {
                        AppSort.size => l.appsSortSize,
                        AppSort.cache => l.appsSortCache,
                        AppSort.name => l.appsSortName,
                        AppSort.recent => l.appsSortRecent,
                      }),
                      selected: s == sort,
                      onSelected: (_) => setState(() => _sort = s),
                    ),
                FilterChip(
                  label: Text(l.appsShowSystem),
                  selected: _showSystem,
                  onSelected: (v) => setState(() => _showSystem = v),
                ),
              ])),
              if (shown.isEmpty)
                Box(Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Text(l.appsEmpty,
                        style: context.text.bodyMedium
                            ?.copyWith(color: sx.muted)),
                  ),
                ))
              else
                SliverList.separated(
                  itemCount: shown.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, i) => _AppRow(
                    app: shown[i],
                    onTap: () => ref
                        .read(deviceApiProvider)
                        .openAppDetails(shown[i].packageName),
                  ),
                ),
            ];
          },
        ),
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.apps, required this.hasSizes});

  final List<AppEntry> apps;
  final bool hasSizes;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final size = apps.fold<int>(0, (t, a) => t + _total(a));
    final cache = apps.fold<int>(0, (t, a) => t + (a.cacheBytes ?? 0));
    Widget stat(String label, String value) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(label),
              const SizedBox(height: 4),
              Text(value, style: context.text.titleLarge),
            ],
          ),
        );
    return SxCard(
      child: Row(children: [
        stat(l.appsTitle, '${apps.length}'),
        if (hasSizes) ...[
          stat(l.appsTotalSize, formatStorage(size)),
          stat(l.appsCacheTotal, formatStorage(cache)),
        ] else
          Icon(SxIcons.apps, color: sx.muted, size: 28),
      ]),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.title,
    required this.body,
    required this.button,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final sx = context.sx;
    return SxCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon, color: sx.storage),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall),
                const SizedBox(height: 4),
                Text(body,
                    style: context.text.bodySmall?.copyWith(color: sx.muted)),
                const SizedBox(height: 10),
                button,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({required this.app, required this.onTap});

  final AppEntry app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final icon = app.icon;
    final cache = app.cacheBytes;
    final subtitle = cache != null
        ? l.appsSizeLine(formatStorage(_total(app)), formatStorage(cache))
        : (app.versionName ?? app.packageName);
    return SxCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: onTap,
      child: Row(children: [
        SizedBox.square(
          dimension: 40,
          child: icon == null
              ? Icon(SxIcons.apps, color: sx.muted)
              : Image.memory(icon, gaplessPlayback: true),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(app.label,
                  style: context.text.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: sx.muted),
      ]),
    );
  }
}
