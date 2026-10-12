import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/sx_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';

/// The privacy policy, bundled with the app so it opens offline. The text
/// files mirror docs/privacy.html, the public copy for Google Play.
final policyTextProvider = FutureProvider.autoDispose.family<String, String>(
    (ref, lang) => rootBundle.loadString(
        'assets/privacy/policy_${lang == 'bn' ? 'bn' : 'en'}.txt'));

/// One line of the policy file: "# title", "## heading", "- bullet" or text.
sealed class PolicyBlock {
  const PolicyBlock(this.text);
  final String text;
}

class PolicyTitle extends PolicyBlock {
  const PolicyTitle(super.text);
}

class PolicyHeading extends PolicyBlock {
  const PolicyHeading(super.text);
}

class PolicyBullet extends PolicyBlock {
  const PolicyBullet(super.text);
}

class PolicyParagraph extends PolicyBlock {
  const PolicyParagraph(super.text);
}

List<PolicyBlock> parsePolicy(String source) => [
      for (final raw in source.split('\n'))
        if (raw.trim().isNotEmpty)
          switch (raw.trim()) {
            final t when t.startsWith('## ') => PolicyHeading(t.substring(3)),
            final t when t.startsWith('# ') => PolicyTitle(t.substring(2)),
            final t when t.startsWith('- ') => PolicyBullet(t.substring(2)),
            final t => PolicyParagraph(t),
          },
    ];

class PolicyScreen extends ConsumerWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final text = ref.watch(policyTextProvider(l.localeName)).value;
    final blocks = text == null ? const <PolicyBlock>[] : parsePolicy(text);
    final body = context.text.bodyMedium?.copyWith(height: 1.55);

    return PageScaffold(
      title: l.privacyPolicy,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final b in blocks)
                switch (b) {
                  PolicyTitle() => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(b.text, style: context.text.titleLarge),
                    ),
                  PolicyHeading() => Padding(
                      padding: const EdgeInsets.only(top: 18, bottom: 6),
                      child: Text(b.text, style: context.text.titleMedium),
                    ),
                  PolicyBullet() => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 9, right: 10),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: sx.muted, shape: BoxShape.circle),
                            ),
                          ),
                          Expanded(child: Text(b.text, style: body)),
                        ],
                      ),
                    ),
                  PolicyParagraph() => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(b.text, style: body),
                    ),
                },
            ],
          ),
        )),
      ],
    );
  }
}
