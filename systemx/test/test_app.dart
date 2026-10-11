import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:systemx/app.dart';
import 'package:systemx/core/settings/settings.dart';
import 'package:systemx/features/device/share.dart';
import 'package:systemx/platform/platform.dart';

import 'fakes.dart';

/// Starts the real app on fake platform data. Returns the container so tests
/// can read providers.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  FakeDeviceApi? api,
  FakePermissionApi? permissions,
  bool onboarded = true,
  List<(String, String)>? shared,
  Stream<List<double>> Function(int type)? sensorReadings,
}) async {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsNotifier.keys),
  );
  final device = api ?? FakeDeviceApi();
  final c = ProviderContainer(overrides: [
    prefsProvider.overrideWithValue(prefs),
    deviceApiProvider.overrideWithValue(device),
    permissionApiProvider
        .overrideWithValue(permissions ?? FakePermissionApi(device)),
    shareTextProvider.overrideWithValue(
        (text, subject) async => shared?.add((text, subject))),
    sensorReadingsProvider.overrideWithValue(
        sensorReadings ?? (_) => const Stream.empty()),
  ]);
  addTearDown(c.dispose);
  if (onboarded) await c.read(settingsProvider.notifier).completeOnboarding();

  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(UncontrolledProviderScope(
    container: c,
    child: const SystemXApp(),
  ));
  await tester.pumpAndSettle();
  return c;
}

/// Unmounts the app so live timers are cancelled before the test ends.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}
