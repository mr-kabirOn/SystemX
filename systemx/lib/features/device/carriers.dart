/// USSD codes for Bangladeshi carriers. Tapping one only opens the dialer
/// with the code filled in; the user presses call, so no call permission is
/// needed.
///
/// Codes listed here appear in at least two independent public lists
/// (checked October 2026). Codes the lists disagree on are left out rather
/// than guessed; each carrier's menu code reaches everything else.
enum CodeKind { balance, internet, minutes, sms, ownNumber, menu, emergency, care }

class UssdCode {
  const UssdCode(this.kind, this.code);
  final CodeKind kind;
  final String code;
}

class Carrier {
  const Carrier(this.name, this.codes);
  final String name;
  final List<UssdCode> codes;

  String get balanceCode => codes.firstWhere((c) => c.kind == CodeKind.balance).code;
}

const _gp = Carrier('Grameenphone', [
  UssdCode(CodeKind.balance, '*566#'),
  UssdCode(CodeKind.internet, '*121*1*4#'),
  UssdCode(CodeKind.ownNumber, '*2#'),
  UssdCode(CodeKind.menu, '*121#'),
  UssdCode(CodeKind.care, '121'),
]);

const _robi = Carrier('Robi', [
  UssdCode(CodeKind.balance, '*222#'),
  UssdCode(CodeKind.internet, '*8444*88#'),
  UssdCode(CodeKind.sms, '*222*11#'),
  UssdCode(CodeKind.ownNumber, '*2#'),
  UssdCode(CodeKind.care, '121'),
]);

const _banglalink = Carrier('Banglalink', [
  UssdCode(CodeKind.balance, '*124#'),
  UssdCode(CodeKind.internet, '*5000*500#'),
  UssdCode(CodeKind.minutes, '*124*2#'),
  UssdCode(CodeKind.sms, '*124*3#'),
  UssdCode(CodeKind.ownNumber, '*511#'),
  UssdCode(CodeKind.emergency, '*874#'),
  UssdCode(CodeKind.care, '121'),
]);

const _teletalk = Carrier('Teletalk', [
  // One code shows main balance, internet, minutes and SMS together.
  UssdCode(CodeKind.balance, '*152#'),
  UssdCode(CodeKind.ownNumber, '*551#'),
  UssdCode(CodeKind.care, '121'),
]);

const _airtel = Carrier('Airtel', [
  UssdCode(CodeKind.balance, '*778#'),
  UssdCode(CodeKind.internet, '*3#'),
  UssdCode(CodeKind.minutes, '*778*5#'),
  UssdCode(CodeKind.sms, '*778*2#'),
  UssdCode(CodeKind.ownNumber, '*2#'),
  UssdCode(CodeKind.care, '121'),
]);

const _byMccMnc = <String, Carrier>{
  '47001': _gp,
  '47002': _robi,
  '47003': _banglalink,
  '47004': _teletalk,
  '47007': _airtel,
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
