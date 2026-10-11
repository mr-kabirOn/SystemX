/// Balance check codes for Bangladeshi carriers, carried over from the old
/// app. Dialing only opens the dialer with the code filled in; the user
/// presses call, so no call permission is needed.
class Carrier {
  const Carrier(this.name, this.balanceCode);
  final String name;
  final String balanceCode;
}

const _byMccMnc = <String, Carrier>{
  '47001': Carrier('Grameenphone', '*121#'),
  '47002': Carrier('Robi', '*222#'),
  '47003': Carrier('Banglalink', '*124#'),
  '47004': Carrier('Teletalk', '*152#'),
  '47007': Carrier('Airtel', '*123#'),
};

/// Finds the carrier from the SIM's MCC+MNC ("47001"), falling back to the
/// carrier name the SIM reports.
Carrier? carrierFor({String? mccMnc, String? name}) {
  final byCode = mccMnc == null ? null : _byMccMnc[mccMnc];
  if (byCode != null) return byCode;
  final n = name?.toLowerCase().replaceAll(' ', '') ?? '';
  if (n.isEmpty) return null;
  for (final c in _byMccMnc.values) {
    final key = c.name.toLowerCase();
    if (n.contains(key) || (key == 'grameenphone' && n.startsWith('gp'))) {
      return c;
    }
  }
  return null;
}
