import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/apps/apps_screen.dart';
import 'package:systemx/features/apps/screen_time.dart';
import 'package:systemx/l10n/app_localizations_en.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  final l = AppLocalizationsEn();

  test('day starts are local midnights, oldest first', () {
    final starts = lastDayStarts(DateTime(2026, 3, 2, 15, 30), 3);
    expect(starts.map(DateTime.fromMillisecondsSinceEpoch),
        [DateTime(2026, 2, 28), DateTime(2026, 3, 1), DateTime(2026, 3, 2)]);
  });

  test('durations read naturally', () {
    expect(formatUsage(20000, l), '< 1 min');
    expect(formatUsage(45 * 60000, l), '45 min');
    expect(formatUsage(120 * 60000, l), '2 h');
    expect(formatUsage(192 * 60000, l), '3 h 12 min');
    expect(batteryPoints(0.4), '< 1');
    expect(batteryPoints(12.6), '13');
  });

  test('the daily average leaves out today and days without data', () {
    UsageDay day(int min) => UsageDay(dayStartMs: 0, screenOnMs: min * 60000, apps: []);
    expect(dailyAverageMs([day(100), day(0), day(200), day(999)]), 150 * 60000);
    expect(dailyAverageMs([day(0), day(300)]), isNull);
  });

  testWidgets('without Usage access: explains and links to the setting', (tester) async {
    final api = FakeDeviceApi();
    await pumpApp(tester, api: api);
    await go(tester, Routes.screenTime);

    expect(find.text('Allow usage access'), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Allow usage access'));
    expect(api.opened, [AppsActions.usageAccess]);
  });

  testWidgets('shows today, the week and apps; a bar selects that day', (tester) async {
    final api = FakeDeviceApi()..usageGranted = true;
    await pumpApp(tester, api: api);
    await go(tester, Routes.screenTime);

    expect(find.text('4 h 12 min'), findsOneWidget); // today: 252 min
    expect(find.text('58'), findsOneWidget); // unlocks
    expect(find.text('42%'), findsOneWidget); // battery with screen on
    expect(find.text('Daily average 3 h 50 min'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.text('Opened 21 times · ≈13% battery'), findsOneWidget);

    final now = DateTime.now();
    final first = DateFormat.E('en').format(DateTime(now.year, now.month, now.day - 6));
    await tester.tap(find.text(first));
    await tester.pumpAndSettle();
    expect(find.text('3 h 15 min'), findsOneWidget); // oldest day: 195 min

    await tester.scrollUntilVisible(find.text('YouTube'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('YouTube'));
    expect(api.openedApps, ['com.google.android.youtube']);
  });
}
