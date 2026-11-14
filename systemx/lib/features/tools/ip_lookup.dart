import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/sx_colors.dart';
import '../../core/theme/sx_type.dart';
import '../../l10n/app_localizations.dart';
import '../../platform/platform.dart';
import '../../ui/widgets/cards.dart';
import '../../ui/widgets/page_scaffold.dart';
import '../device/csc_codes.dart' show flagEmoji;

/// Lookup services, tried in order until one answers. These are the only
/// addresses SystemX ever connects to, and only when the user taps Look up.
/// Each receives the phone's public IP address (as every website does) and
/// returns where that address is registered. Several are listed because a
/// free service can refuse a request, for example when many phones share
/// one mobile network address.
const ipLookupServices = <IpService>[
  IpService('ipinfo.io', 'https://ipinfo.io/json', IpInfo.fromIpinfo),
  IpService('ipwho.is', 'https://ipwho.is/', IpInfo.fromIpwho),
  IpService('ipapi.co', 'https://ipapi.co/json/', IpInfo.fromIpapi),
  IpService('ipify.org', 'https://api.ipify.org/?format=json', IpInfo.fromIpify),
];

/// The hosts above, for the privacy note.
String get ipLookupHosts => ipLookupServices.map((s) => s.host).join(', ');

class IpService {
  const IpService(this.host, this.url, this.parse);
  final String host;
  final String url;
  final IpInfo? Function(Map<String, Object?> json) parse;
}

/// What a service says about the phone's public IP address.
class IpInfo {
  const IpInfo({
    required this.ip,
    this.isp,
    this.asn,
    this.city,
    this.region,
    this.country,
    this.countryCode,
    this.timezone,
    this.source,
  });

  final String ip;
  final String? isp;
  final String? asn;
  final String? city;
  final String? region;
  final String? country;
  final String? countryCode;
  final String? timezone;

  /// Which service answered.
  final String? source;

  IpInfo withSource(String host) => IpInfo(
        ip: ip, isp: isp, asn: asn, city: city, region: region,
        country: country, countryCode: countryCode, timezone: timezone, source: host,
      );

  static String? _s(Object? v) => v is String && v.trim().isNotEmpty ? v.trim() : v is num ? '$v' : null;

  /// ipapi.co; null when it reports an error (e.g. rate limited).
  static IpInfo? fromIpapi(Map<String, Object?> j) {
    if (j['error'] == true) return null;
    final ip = _s(j['ip']);
    if (ip == null) return null;
    return IpInfo(
      ip: ip,
      isp: _s(j['org']),
      asn: _s(j['asn']),
      city: _s(j['city']),
      region: _s(j['region']),
      country: _s(j['country_name']),
      countryCode: _s(j['country_code']),
      timezone: _s(j['timezone']),
    );
  }

  /// ipinfo.io: "org" is "AS24389 Grameenphone Ltd.", "country" a code.
  static IpInfo? fromIpinfo(Map<String, Object?> j) {
    final ip = _s(j['ip']);
    if (ip == null || j['bogon'] == true) return null;
    final org = _s(j['org']);
    final m = org == null ? null : RegExp(r'^(AS\d+)\s+(.+)$').firstMatch(org);
    final code = _s(j['country']);
    return IpInfo(
      ip: ip,
      isp: m?.group(2) ?? org,
      asn: m?.group(1),
      city: _s(j['city']),
      region: _s(j['region']),
      country: code == null ? null : countryName(code),
      countryCode: code,
      timezone: _s(j['timezone']),
    );
  }

  /// ipwho.is: "success": false on errors.
  static IpInfo? fromIpwho(Map<String, Object?> j) {
    if (j['success'] == false) return null;
    final ip = _s(j['ip']);
    if (ip == null) return null;
    final conn = j['connection'] is Map ? (j['connection'] as Map).cast<String, Object?>() : const <String, Object?>{};
    final tz = j['timezone'] is Map ? (j['timezone'] as Map).cast<String, Object?>() : const <String, Object?>{};
    final asn = _s(conn['asn']);
    return IpInfo(
      ip: ip,
      isp: _s(conn['isp']) ?? _s(conn['org']),
      asn: asn == null ? null : 'AS$asn',
      city: _s(j['city']),
      region: _s(j['region']),
      country: _s(j['country']),
      countryCode: _s(j['country_code']),
      timezone: _s(tz['id']),
    );
  }

  /// ipify.org: the address only.
  static IpInfo? fromIpify(Map<String, Object?> j) {
    final ip = _s(j['ip']);
    return ip == null ? null : IpInfo(ip: ip);
  }
}

/// English country name for an ISO code from the few services that send
/// only the code; the code itself otherwise.
String countryName(String code) => const {
      'BD': 'Bangladesh', 'IN': 'India', 'PK': 'Pakistan', 'NP': 'Nepal', 'LK': 'Sri Lanka',
      'US': 'United States', 'GB': 'United Kingdom', 'KR': 'South Korea', 'JP': 'Japan',
      'CN': 'China', 'SG': 'Singapore', 'MY': 'Malaysia', 'AE': 'United Arab Emirates',
      'SA': 'Saudi Arabia', 'DE': 'Germany', 'FR': 'France', 'CA': 'Canada', 'AU': 'Australia',
    }[code.toUpperCase()] ?? code.toUpperCase();

class IpLookupException implements Exception {
  const IpLookupException(this.rateLimited, [this.details = '']);
  final bool rateLimited;

  /// What each service answered, for troubleshooting ("ipinfo.io: HTTP 429").
  final String details;
}

/// Asks the services in turn. Swappable in tests.
final ipLookupProvider = Provider<Future<IpInfo> Function()>((ref) => _lookup);

Future<IpInfo> _lookup() async {
  final problems = <String>[];
  var limited = false;
  for (final service in ipLookupServices) {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      ..userAgent = 'SystemX/1.0 (Android)';
    try {
      final req = await client.getUrl(Uri.parse(service.url));
      req.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final res = await req.close().timeout(const Duration(seconds: 10));
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode == 200) {
        final json = jsonDecode(body);
        final info = json is Map ? service.parse(json.cast<String, Object?>()) : null;
        if (info != null) return info.withSource(service.host);
        problems.add('${service.host}: no address');
      } else {
        if (res.statusCode == 429) limited = true;
        problems.add('${service.host}: HTTP ${res.statusCode}');
      }
    } on TimeoutException {
      problems.add('${service.host}: timed out');
    } on SocketException catch (e) {
      problems.add('${service.host}: ${e.osError?.message ?? e.message}');
    } on HandshakeException {
      problems.add('${service.host}: secure connection failed');
    } catch (e) {
      problems.add('${service.host}: ${e.runtimeType}');
    } finally {
      client.close(force: true);
    }
  }
  throw IpLookupException(limited, problems.join('\n'));
}

/// Public IP lookup on request, plus the phone's own network addresses
/// (read on the phone, no internet needed).
class IpLookupScreen extends ConsumerStatefulWidget {
  const IpLookupScreen({super.key});

  @override
  ConsumerState<IpLookupScreen> createState() => _IpLookupScreenState();
}

class _IpLookupScreenState extends ConsumerState<IpLookupScreen> {
  IpInfo? _info;
  String? _error;
  String _details = '';
  bool _busy = false;

  Future<void> _lookUp() async {
    final l = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
      _details = '';
    });
    try {
      final info = await ref.read(ipLookupProvider)();
      if (mounted) setState(() => _info = info);
    } on IpLookupException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.rateLimited ? l.ipRateLimited : l.ipFailed;
          _details = e.details;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = l.ipFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final info = _info;
    final net = ref.watch(_networkProvider).value;
    final place = info == null
        ? null
        : [info.city, info.region, info.country].whereType<String>().toSet().join(', ');

    return PageScaffold(
      title: l.ipTitle,
      leading: const BackButton(),
      slivers: [
        Box(SxCard(
          gradient: heroGradient(sx),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Eyebrow(l.ipPublic, color: sx.onHero.withValues(alpha: 0.8)),
            const SizedBox(height: 8),
            SelectableText(info?.ip ?? '–', style: SxText.readout(28, sx.onHero, weight: FontWeight.w600)),
            if (place != null && place.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text([place, ?flagEmoji(info?.countryCode)].join(' '),
                  style: context.text.bodyLarge?.copyWith(color: sx.onHero)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: sx.onHero, foregroundColor: sx.heroStart),
              onPressed: _busy ? null : _lookUp,
              child: _busy
                  ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: sx.heroStart))
                  : Text(info == null ? l.ipLookUp : l.ipAgain),
            ),
          ]),
        )),
        if (_error != null)
          Box(SxCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_error!, style: context.text.bodyMedium?.copyWith(color: sx.bad)),
              if (_details.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_details, style: context.text.bodySmall?.copyWith(color: sx.muted)),
              ],
            ]),
          )),
        if (info != null)
          Box(SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              InfoRow(label: l.ipIsp, value: info.isp ?? '–'),
              if (info.asn != null) InfoRow(label: 'ASN', value: info.asn!),
              if (info.timezone != null) InfoRow(label: l.specTimezone, value: info.timezone!),
              if (info.source != null) InfoRow(label: l.ipSource, value: info.source!),
            ]),
          )),
        if (net != null) ...[
          SliverToBoxAdapter(child: SectionLabel(l.ipLocal)),
          Box(SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              InfoRow(label: l.specIpv4, value: net.ipv4.isEmpty ? '–' : net.ipv4.join('\n')),
              if (net.ipv6.isNotEmpty) InfoRow(label: l.specIpv6, value: net.ipv6.join('\n')),
              InfoRow(label: l.specGateway, value: net.gateway ?? '–'),
              if (net.dns.isNotEmpty) InfoRow(label: l.specDns, value: net.dns.join('\n')),
            ]),
          )),
        ],
        Box(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(l.ipNote(ipLookupHosts), style: context.text.bodySmall?.copyWith(color: sx.muted)),
        )),
      ],
    );
  }
}

final _networkProvider = FutureProvider.autoDispose<NetworkInfo>((ref) => ref.watch(deviceApiProvider).network());
