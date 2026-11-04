/// Carrier or market behind common Samsung sales codes (CSC). Codes for
/// unlocked, open-market builds map to null carrier and [CscInfo.open].
class CscInfo {
  const CscInfo(this.carrier, {this.open = false});

  /// Carrier name, or null for an open-market build.
  final String? carrier;

  /// True for unlocked, open-market builds.
  final bool open;
}

const _open = CscInfo(null, open: true);

const Map<String, CscInfo> _csc = {
  // Korea
  'SKC': CscInfo('SK Telecom'),
  'KTC': CscInfo('KT'),
  'LUC': CscInfo('LG Uplus'),
  'KOO': _open,
  // United States and Canada
  'ATT': CscInfo('AT&T'),
  'AIO': CscInfo('Cricket'),
  'TMB': CscInfo('T-Mobile'),
  'VZW': CscInfo('Verizon'),
  'SPR': CscInfo('Sprint'),
  'USC': CscInfo('US Cellular'),
  'TFN': CscInfo('Tracfone'),
  'XAA': _open,
  'XAC': _open,
  'BMC': CscInfo('Bell'),
  'RWC': CscInfo('Rogers'),
  'TLS': CscInfo('Telus'),
  // Japan
  'DCM': CscInfo('NTT Docomo'),
  'KDI': CscInfo('au (KDDI)'),
  'RKT': CscInfo('Rakuten Mobile'),
  'SJP': _open,
  // South and Southeast Asia
  'BKD': _open, // Bangladesh
  'INS': _open, // India
  'INU': _open, // India
  'SLK': _open, // Sri Lanka
  'PKD': _open, // Pakistan
  'NPL': _open, // Nepal
  'XID': _open, // Indonesia
  'XME': _open, // Malaysia
  'XSP': _open, // Singapore
  'XTC': _open, // Philippines
  'THL': _open, // Thailand
  'XXV': _open, // Vietnam
  // Greater China
  'CHC': _open,
  'TGY': _open, // Hong Kong
  'BRI': _open, // Taiwan
  // Middle East and Africa
  'XSG': _open, // UAE
  'KSA': _open, // Saudi Arabia
  'EGY': _open, // Egypt
  'TUR': _open, // Turkey
  'XFE': _open, // South Africa
  // Europe
  'EUX': _open,
  'XEU': _open, // UK and Ireland
  'BTU': _open, // UK
  'XEF': _open, // France
  'DBT': _open, // Germany
  'ITV': _open, // Italy
  'PHE': _open, // Spain
  'XEO': _open, // Poland
  'AUT': _open, // Switzerland
  'SER': _open, // Russia
  'SEK': _open, // Ukraine
  'SKZ': _open, // Kazakhstan
  // Oceania and Latin America
  'XSA': _open, // Australia
  'XNZ': _open, // New Zealand
  'ZTO': _open, // Brazil
};

/// Carrier details for a Samsung sales code, or null when unknown.
CscInfo? lookupCsc(String? code) => code == null ? null : _csc[code.toUpperCase()];

/// Flag emoji for an ISO 3166 country code ("KR" -> 🇰🇷); null otherwise.
String? flagEmoji(String? iso) {
  if (iso == null || iso.length != 2) return null;
  final up = iso.toUpperCase();
  if (!RegExp(r'^[A-Z]{2}$').hasMatch(up)) return null;
  return String.fromCharCodes(up.codeUnits.map((c) => 0x1F1E6 + c - 0x41));
}

/// Whole years, months and days from [from] to [to] (calendar arithmetic).
/// A month is counted when the same day of a later month is reached; days
/// past the end of a short month land on its last day (Jan 31 + 1 month is
/// the end of February).
(int, int, int) calendarAge(DateTime from, DateTime to) {
  final start = DateTime.utc(from.year, from.month, from.day);
  final end = DateTime.utc(to.year, to.month, to.day);
  if (!end.isAfter(start)) return (0, 0, 0);
  DateTime plusMonths(int k) {
    final first = DateTime.utc(start.year, start.month + k);
    final last = DateTime.utc(first.year, first.month + 1, 0).day;
    return DateTime.utc(first.year, first.month, start.day > last ? last : start.day);
  }

  var months = (end.year - start.year) * 12 + end.month - start.month;
  if (plusMonths(months).isAfter(end)) months--;
  final days = end.difference(plusMonths(months)).inDays;
  return (months ~/ 12, months % 12, days);
}
