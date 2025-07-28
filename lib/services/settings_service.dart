import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyFordelingstyper = 'fordelingstyper';
  static const _keySystemspenninger = 'systemspenninger';
  static const _keyJordElektrodetyper = 'jordElektrodetyper';
  static const _keyKabeldimensjoner = 'kabeldimensjoner';
  static const _keyVernKarakteristikker = 'vernkarakteristikker';

  // Default values
  static const List<String> defaultFordelingstyper = [
    'TN-C-S',
    'TN-C',
    'TN-S',
    'TT',
    'IT',
  ];
  static const List<String> defaultSystemspenninger = ['230V', '400V'];
  static const List<String> defaultJordElektrodetyper = [
    'Matajord',
    'Stangelektrode',
    'Plateelektrode',
  ];
  static const List<String> defaultKabeldimensjoner = [
    '1.5',
    '2.5',
    '4',
    '6',
    '10',
    '16',
    '25',
    '35',
    '50',
  ];
  static const List<String> defaultVernKarakteristikker = ['B', 'C', 'D'];

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<List<String>> loadFordelingstyper() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyFordelingstyper) ?? defaultFordelingstyper;
  }

  Future<void> saveFordelingstyper(List<String> values) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyFordelingstyper, values);
  }

  Future<List<String>> loadSystemspenninger() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keySystemspenninger) ?? defaultSystemspenninger;
  }

  Future<void> saveSystemspenninger(List<String> values) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keySystemspenninger, values);
  }

  Future<List<String>> loadJordElektrodetyper() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyJordElektrodetyper) ??
        defaultJordElektrodetyper;
  }

  Future<void> saveJordElektrodetyper(List<String> values) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyJordElektrodetyper, values);
  }

  Future<List<String>> loadKabeldimensjoner() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyKabeldimensjoner) ?? defaultKabeldimensjoner;
  }

  Future<void> saveKabeldimensjoner(List<String> values) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyKabeldimensjoner, values);
  }

  Future<List<String>> loadVernKarakteristikker() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyVernKarakteristikker) ??
        defaultVernKarakteristikker;
  }

  Future<void> saveVernKarakteristikker(List<String> values) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyVernKarakteristikker, values);
  }
}
