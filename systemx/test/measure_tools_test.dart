import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/tools/measure_tools.dart';
import 'package:systemx/l10n/app_localizations_en.dart';

import 'fakes.dart';
import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  final l = AppLocalizationsEn();

  test('tilt is zero flat and follows gravity', () {
    expect(tiltDegrees(0, 0, 9.81), (0.0, 0.0));
    final (x, y) = tiltDegrees(9.81 * math.sin(math.pi / 18), 0, 9.81 * math.cos(math.pi / 18));
    expect(x, closeTo(10, 0.01)); // left edge 10° lower
    expect(y, closeTo(0, 0.01));
  });

  test('compass heading from a rotation vector', () {
    // No rotation: facing magnetic north.
    expect(azimuthFromRotationVector([0, 0, 0, 1]), closeTo(0, 1e-9));
    // Rotated 90° about -z (clockwise seen from above): facing east.
    const half = -math.pi / 4;
    expect(azimuthFromRotationVector([0, 0, math.sin(half), math.cos(half)]), closeTo(90, 1e-6));
    expect(compassPoint(0), 'N');
    expect(compassPoint(93), 'E');
    expect(compassPoint(350), 'N');
    expect(compassPoint(225), 'SW');
  });

  test('sound, light and magnet bands', () {
    expect(approxSpl(-94), 20); // floor
    expect(approxSpl(-40), 54);
    expect(soundBand(l, 54), 'Conversation');
    expect(lightBand(l, 300), 'Indoor light');
    expect(lightBand(l, 50000), 'Direct sunlight');
    expect(fieldStrength([30, 40, 0]), 50);
  });

  testWidgets('a tool without its sensor says so', (tester) async {
    await pumpApp(tester, sensorReadings: (_) => const Stream.empty());
    await go(tester, Routes.lightMeter);
    expect(find.text("This phone doesn't have the sensor this tool needs."), findsOneWidget);
  });

  testWidgets('light meter shows lux and a description', (tester) async {
    final c = StreamController<List<double>>.broadcast();
    await pumpApp(tester, sensorReadings: (_) => c.stream);
    await go(tester, Routes.lightMeter);
    c.add([320]);
    await tester.pump();
    await tester.pump();
    expect(find.text('320'), findsOneWidget);
    expect(find.text('Indoor light'), findsOneWidget);
    await c.close();
  });

  testWidgets('sound meter asks for the microphone, then shows levels', (tester) async {
    final api = FakeDeviceApi();
    final perms = FakePermissionApi(api);
    final levels = StreamController<double>.broadcast();
    await pumpApp(tester, api: api, permissions: perms, soundLevels: () => levels.stream);
    await go(tester, Routes.soundMeter);
    await tester.tap(find.text('Allow'));
    await tester.pumpAndSettle();
    levels.add(-30);
    await tester.pump();
    await tester.pump();
    expect(find.text('64'), findsOneWidget);
    expect(find.text('Conversation'), findsOneWidget);
    expect(find.text('Highest 64 dB'), findsOneWidget);
    await levels.close();
  });
}
