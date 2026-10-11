/// Marketing names and process nodes for common chips, keyed by the model
/// code Android reports (Build.SOC_MODEL or /proc/cpuinfo "Hardware").
/// Codes shared by several chips are labelled as a family.
class SocName {
  const SocName(this.name, [this.process]);
  final String name;
  final String? process;
}

const _socs = <String, SocName>{
  // Qualcomm
  'SM8750': SocName('Snapdragon 8 Elite', '3 nm'),
  'SM8650': SocName('Snapdragon 8 Gen 3', '4 nm'),
  'SM8635': SocName('Snapdragon 8s Gen 3', '4 nm'),
  'SM8550': SocName('Snapdragon 8 Gen 2', '4 nm'),
  'SM8475': SocName('Snapdragon 8+ Gen 1', '4 nm'),
  'SM8450': SocName('Snapdragon 8 Gen 1', '4 nm'),
  'SM8350': SocName('Snapdragon 888', '5 nm'),
  'SM8250': SocName('Snapdragon 865', '7 nm'),
  'SM8150': SocName('Snapdragon 855', '7 nm'),
  'SDM845': SocName('Snapdragon 845', '10 nm'),
  'SM7675': SocName('Snapdragon 7+ Gen 3', '4 nm'),
  'SM7550': SocName('Snapdragon 7 Gen 3', '4 nm'),
  'SM7475': SocName('Snapdragon 7+ Gen 2', '4 nm'),
  'SM7450': SocName('Snapdragon 7 Gen 1', '4 nm'),
  'SM7435': SocName('Snapdragon 7s Gen 2', '4 nm'),
  'SM7325': SocName('Snapdragon 778G', '6 nm'),
  'SM7225': SocName('Snapdragon 750G', '8 nm'),
  'SM7150': SocName('Snapdragon 730 / 730G', '8 nm'),
  'SM7125': SocName('Snapdragon 720G', '8 nm'),
  'SDM710': SocName('Snapdragon 710', '10 nm'),
  'SDM660': SocName('Snapdragon 660', '14 nm'),
  'SM6450': SocName('Snapdragon 6 Gen 1', '4 nm'),
  'SM6375': SocName('Snapdragon 695', '6 nm'),
  'SM6225': SocName('Snapdragon 680 / 685', '6 nm'),
  'SM6150': SocName('Snapdragon 675', '11 nm'),
  'SM6125': SocName('Snapdragon 665', '11 nm'),
  'SM6115': SocName('Snapdragon 662', '11 nm'),
  'SM4450': SocName('Snapdragon 4 Gen 2', '4 nm'),
  'SM4375': SocName('Snapdragon 4 Gen 1', '6 nm'),
  'SM4350': SocName('Snapdragon 480', '8 nm'),
  'SM4250': SocName('Snapdragon 460', '11 nm'),
  'SDM450': SocName('Snapdragon 450', '14 nm'),
  'SDM439': SocName('Snapdragon 439', '12 nm'),
  // MediaTek
  'MT6991': SocName('Dimensity 9400', '3 nm'),
  'MT6989': SocName('Dimensity 9300', '4 nm'),
  'MT6985': SocName('Dimensity 9200', '4 nm'),
  'MT6983': SocName('Dimensity 9000', '4 nm'),
  'MT6897': SocName('Dimensity 8300', '4 nm'),
  'MT6896': SocName('Dimensity 8200', '4 nm'),
  'MT6895': SocName('Dimensity 8100', '5 nm'),
  'MT6893': SocName('Dimensity 1200 / 1300', '6 nm'),
  'MT6886': SocName('Dimensity 7200', '4 nm'),
  'MT6878': SocName('Dimensity 7300', '4 nm'),
  'MT6877': SocName('Dimensity 900 / 1080 / 7050 family', '6 nm'),
  'MT6855': SocName('Dimensity 930 / 7020', '6 nm'),
  'MT6853': SocName('Dimensity 720', '7 nm'),
  'MT6835': SocName('Dimensity 6100+ / 6300', '6 nm'),
  'MT6833': SocName('Dimensity 700 / 6020 / 6080 family'),
  'MT6789': SocName('Helio G99', '6 nm'),
  'MT6785': SocName('Helio G90T / G95', '12 nm'),
  'MT6781': SocName('Helio G96', '12 nm'),
  'MT6769': SocName('Helio G70 / G80 / G85 / G88 family', '12 nm'),
  'MT6765': SocName('Helio G35 / G37 / P35 family', '12 nm'),
  'MT6762': SocName('Helio G25 / P22', '12 nm'),
  'MT6761': SocName('Helio A22', '12 nm'),
  // Samsung Exynos
  'S5E9945': SocName('Exynos 2400', '4 nm'),
  'S5E9925': SocName('Exynos 2200', '4 nm'),
  'S5E9840': SocName('Exynos 2100', '5 nm'),
  'S5E8845': SocName('Exynos 1480', '4 nm'),
  'S5E8835': SocName('Exynos 1380', '5 nm'),
  'S5E8825': SocName('Exynos 1280', '5 nm'),
  'S5E8535': SocName('Exynos 1330', '5 nm'),
  'S5E3830': SocName('Exynos 850', '8 nm'),
  'EXYNOS9611': SocName('Exynos 9611', '10 nm'),
  'EXYNOS9825': SocName('Exynos 9825', '7 nm'),
  // Google Tensor
  'GS101': SocName('Google Tensor', '5 nm'),
  'GS201': SocName('Google Tensor G2', '5 nm'),
  'ZUMA': SocName('Google Tensor G3', '4 nm'),
  'ZUMAPRO': SocName('Google Tensor G4', '4 nm'),
  // Unisoc
  'T820': SocName('Unisoc T820', '6 nm'),
  'T760': SocName('Unisoc T760', '6 nm'),
  'T700': SocName('Unisoc T700', '12 nm'),
  'T618': SocName('Unisoc T618', '12 nm'),
  'T616': SocName('Unisoc T616', '12 nm'),
  'T612': SocName('Unisoc T612', '12 nm'),
  'T610': SocName('Unisoc T610', '12 nm'),
  'T606': SocName('Unisoc T606', '12 nm'),
  'UMS9230': SocName('Unisoc T606 / T612 / T616 family', '12 nm'),
  'UMS512': SocName('Unisoc T610 / T618 family', '12 nm'),
  'SC9863A': SocName('Unisoc SC9863A', '28 nm'),
};

/// Looks up a chip from the SoC model, falling back to the hardware string
/// (e.g. "MT6769V/CZ" -> MT6769).
SocName? lookupSoc(String? socModel, String? hardware) {
  for (final raw in [socModel, hardware]) {
    if (raw == null || raw.isEmpty) continue;
    final key = raw.toUpperCase().replaceAll(' ', '');
    if (_socs[key] != null) return _socs[key];
    if (key.startsWith('TENSOR')) return SocName(raw, null);
    final mt = RegExp(r'MT\d{4}').firstMatch(key)?.group(0);
    if (mt != null && _socs[mt] != null) return _socs[mt];
    final sm = RegExp(r'(SM|SDM)\d{3,4}').firstMatch(key)?.group(0);
    if (sm != null && _socs[sm] != null) return _socs[sm];
  }
  return null;
}
