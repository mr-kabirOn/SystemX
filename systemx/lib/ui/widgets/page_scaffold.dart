import 'package:flutter/material.dart';

/// Widest the content gets on tablets and unfolded foldables.
const maxContentWidth = 720.0;

/// Side padding that centers content no wider than [maxContentWidth].
double sidePadding(BuildContext context, [double min = 16]) {
  final w = MediaQuery.sizeOf(context).width;
  return w > maxContentWidth + 2 * min ? (w - maxContentWidth) / 2 : min;
}

/// Page with a pinned title (same size as the Home header) and padded content.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.actions = const [],
    this.leading,
  });

  final String title;
  final List<Widget> slivers;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 68,
            titleSpacing: leading == null ? 20 : 4,
            title: Text(title),
            titleTextStyle: Theme.of(context).textTheme.headlineMedium,
            leading: leading,
            actions: [...actions, const SizedBox(width: 8)],
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                sidePadding(context), 4, sidePadding(context), 28),
            sliver: SliverMainAxisGroup(slivers: slivers),
          ),
        ],
      ),
    );
  }
}

/// Convenience to drop a plain widget into a sliver list.
class Box extends StatelessWidget {
  const Box(this.child, {super.key, this.bottom = 12});

  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Padding(padding: EdgeInsets.only(bottom: bottom), child: child),
      );
}
