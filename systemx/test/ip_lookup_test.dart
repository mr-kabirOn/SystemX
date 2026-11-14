import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/tools/ip_lookup.dart';

import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  test('parses the service answer and rejects errors', () {
    final info = IpInfo.fromJson({
      'ip': '103.12.34.56',
      'city': 'Dhaka',
      'region': 'Dhaka Division',
      'country_name': 'Bangladesh',
      'country_code': 'BD',
      'org': 'Grameenphone Ltd.',
      'asn': 'AS24389',
      'timezone': 'Asia/Dhaka',
    })!;
    expect(info.ip, '103.12.34.56');
    expect(info.isp, 'Grameenphone Ltd.');
    expect(info.countryCode, 'BD');
    expect(IpInfo.fromJson({'error': true, 'reason': 'RateLimited'}), isNull);
    expect(IpInfo.fromJson({'city': 'Dhaka'}), isNull);
  });

  testWidgets('looks up only on tap and shows the result', (tester) async {
    var calls = 0;
    await pumpApp(tester, ipLookup: () async {
      calls++;
      return const IpInfo(ip: '103.12.34.56', city: 'Dhaka', country: 'Bangladesh', countryCode: 'BD', isp: 'Grameenphone Ltd.');
    });
    await go(tester, Routes.ipLookup);
    expect(calls, 0); // nothing is sent until the user asks
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.text('103.12.34.56'), findsOneWidget);
    expect(find.text('Grameenphone Ltd.'), findsOneWidget);
    expect(find.textContaining('Dhaka, Bangladesh'), findsOneWidget);
  });

  testWidgets('a failed lookup explains itself', (tester) async {
    await pumpApp(tester, ipLookup: () async => throw const IpLookupException(true));
    await go(tester, Routes.ipLookup);
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();
    expect(find.textContaining('busy right now'), findsOneWidget);
  });
}
