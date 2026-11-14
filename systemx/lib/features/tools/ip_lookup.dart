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

/// The lookup service. The only address SystemX ever connects to, and only
/// when the user taps Look up. It receives the phone's public IP address
/// (as every website does) and returns where that address is registered.
const ipLookupUrl = 'https://ipapi.co/json/';
const ipLookupHost = 'ipapi.co';

/// What the service says about the phone's public IP address.
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
  });

  final String ip;
  final String? isp;
  final String? asn;
  final String? city;
  final String? region;
  final String? country;
  final String? countryCode;
  final String? timezone;

  /// Parses the service's JSON; null when it reports an error (for example
  /// too many requests) or has no IP address.
  static IpInfo? fromJson(Map<String, Object?> j) {
    if (j['error'] == true) return null;
    final ip = j['ip'];
    if (ip is! String || ip.isEmpty) return null;
    String? s(String key) {
      final v = j[key];
      return v is String && v.trim().isNotEmpty ? v.trim() : null;
    }

    return IpInfo(
      ip: ip,
      isp: s('org'),
      asn: s('asn'),
      city: s('city'),
      region: s('region'),
      country: s('country_name'),
      countryCode: s('country_code'),
      timezone: s('timezone'),
    );
  }
}

class IpLookupException implements Exception {
  const IpLookupException(this.rateLimited);
  final bool rateLimited;
}

/// Asks the service once. Swappable in tests.
final ipLookupProvider = Provider<Future<IpInfo> Function()>((ref) => _lookup);

Future<IpInfo> _lookup() async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    final req = await client.getUrl(Uri.parse(ipLookupUrl));
    req.headers.set(HttpHeaders.acceptHeader, 'application/json');
    req.headers.set(HttpHeaders.userAgentHeader, 'SystemX');
    final res = await req.close().timeout(const Duration(seconds: 15));
    final body = await res.transform(utf8.decoder).join();
    if (res.statusCode == 429) throw const IpLookupException(true);
    final info = res.statusCode == 200 ? IpInfo.fromJson((jsonDecode(body) as Map).cast<String, Object?>()) : null;
    if (info == null) throw IpLookupException(body.contains('RateLimited'));
    return info;
  } finally {
    client.close(force: true);
  }
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
  bool _busy = false;

  Future<void> _lookUp() async {
    final l = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final info = await ref.read(ipLookupProvider)();
      if (mounted) setState(() => _info = info);
    } on IpLookupException catch (e) {
      if (mounted) setState(() => _error = e.rateLimited ? l.ipRateLimited : l.ipFailed);
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
          Box(SxCard(child: Text(_error!, style: context.text.bodyMedium?.copyWith(color: sx.bad)))),
        if (info != null)
          Box(SxCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              InfoRow(label: l.ipIsp, value: info.isp ?? '–'),
              if (info.asn != null) InfoRow(label: 'ASN', value: info.asn!),
              if (info.timezone != null) InfoRow(label: l.specTimezone, value: info.timezone!),
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
          child: Text(l.ipNote(ipLookupHost), style: context.text.bodySmall?.copyWith(color: sx.muted)),
        )),
      ],
    );
  }
}

final _networkProvider = FutureProvider.autoDispose<NetworkInfo>((ref) => ref.watch(deviceApiProvider).network());
