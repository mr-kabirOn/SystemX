import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/settings/policy_screen.dart';

import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  test('policy lines become titles, headings, bullets and text', () {
    final blocks = parsePolicy('# Title\nIntro\n\n## Head\n- One\nBody');
    expect(blocks.map((b) => b.runtimeType), [
      PolicyTitle,
      PolicyParagraph,
      PolicyHeading,
      PolicyBullet,
      PolicyParagraph,
    ]);
    expect(blocks[3].text, 'One');
  });

  testWidgets('Settings opens the policy inside the app', (tester) async {
    await pumpApp(tester);
    await go(tester, Routes.policy);
    expect(find.text('SystemX privacy policy'), findsOneWidget);
    expect(find.text('The short version'), findsOneWidget);
  });
}
