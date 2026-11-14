import 'package:flutter_test/flutter_test.dart';
import 'package:systemx/core/router.dart';
import 'package:systemx/features/tools/ip_lookup.dart';

import 'permissions_test.dart' show go;
import 'test_app.dart';

void main() {
  test('parses the service answer and rejects errors', () {
    final info = IpInfo.fromIpapi({
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
    expect(IpInfo.fromIpapi({'error': true, 'reason': 'RateLimited'}), isNull);
    expect(IpInfo.fromIpapi({'city': 'Dhaka'}), isNull);
  });

  test('reads each service\'s format', () {
    final a = IpInfo.fromIpinfo({
      'ip': '103.12.34.56', 'city': 'Dhaka', 'region': 'Dhaka Division', 'country': 'BD',
      'org': 'AS24389 Grameenphone Ltd.', 'timezone': 'Asia/Dhaka',
    })!;
    expect(a.asn, 'AS24389');
    expect(a.isp, 'Grameenphone Ltd.');
    expect(a.country, 'Bangladesh');
    final b = IpInfo.fromIpwho({
      'ip': '103.12.34.56', 'success': true, 'city': 'Dhaka', 'country': 'Bangladesh', 'country_code': 'BD',
      'connection': {'asn': 24389, 'isp': 'Grameenphone'}, 'timezone': {'id': 'Asia/Dhaka'},
    })!;
    expect(b.asn, 'AS24389');
    expect(b.timezone, 'Asia/Dhaka');
    expect(IpInfo.fromIpwho({'success': false, 'message': 'limit'}), isNull);
    expect(IpInfo.fromIpify({'ip': '1.2.3.4'})!.ip, '1.2.3.4');
    expect(ipLookupHosts, 'ipinfo.io, ipwho.is, ipapi.co, ipify.org');
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
    await pumpApp(tester, ipLookup: () async => throw const IpLookupException(true, 'ipinfo.io: HTTP 429'));
    await go(tester, Routes.ipLookup);
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();
    expect(find.textContaining('busy right now'), findsOneWidget);
    expect(find.text('ipinfo.io: HTTP 429'), findsOneWidget);
  });
}
