import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../core/settings/settings.dart';
import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import 'device_data.dart';
import 'spec_sheets.dart';
import 'spec_view.dart';
import 'specs.dart';

/// Finds any spec across all 15 categories.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final unit = ref.watch(settingsProvider.select((s) => s.tempUnit));
    final snap = ref.watch(fullSnapshotProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _query,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: l.deviceSearch,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: _query.text.isEmpty
                ? null
                : IconButton(
                    tooltip: l.clearSearch,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => setState(_query.clear),
                  ),
          ),
        ),
      ),
      body: snap.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Padding(
          padding: EdgeInsets.all(16),
          child: SpecsUnavailable(),
        ),
        data: (snap) {
          final b = SpecBuilder(l, tempUnit: unit);
          final sheets = {
            for (final c in DeviceCategory.values) c: b.build(c, snap),
          };
          final query = _query.text.trim();
          if (query.isEmpty) {
            return _Message(l.searchHint);
          }
          final results = searchSpecs(sheets, query);
          if (results.isEmpty) return _Message(l.searchNoResults(query));
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: results.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final (category, spec) = results[i];
              return SxCard(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: [
                        Icon(category.icon,
                            size: 14, color: category.color(sx)),
                        const SizedBox(width: 6),
                        Eyebrow(category.title(l), color: category.color(sx)),
                      ]),
                    ),
                    SpecRow(
                      spec: spec,
                      onTap: () => context.push(Routes.category(category)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: context.text.bodyMedium?.copyWith(color: context.sx.muted),
        ),
      );
}
