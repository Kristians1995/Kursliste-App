import 'package:flutter/material.dart';

/// Stub for Settings screen
import 'package:kursliste_app/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _service = SettingsService();
  List<String> _fordelingstyper = [];
  List<String> _systemspenninger = [];
  List<String> _jordTyper = [];
  List<String> _kabeldimensjoner = [];
  List<String> _vernkar = [];
  final _newFordCtrl = TextEditingController();
  final _newSysCtrl = TextEditingController();
  final _newJordCtrl = TextEditingController();
  final _newKabelCtrl = TextEditingController();
  final _newVernCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _newFordCtrl.dispose();
    _newSysCtrl.dispose();
    _newJordCtrl.dispose();
    _newKabelCtrl.dispose();
    _newVernCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    final f = await _service.loadFordelingstyper();
    final s = await _service.loadSystemspenninger();
    final j = await _service.loadJordElektrodetyper();
    final k = await _service.loadKabeldimensjoner();
    final v = await _service.loadVernKarakteristikker();
    setState(() {
      _fordelingstyper = f;
      _systemspenninger = s;
      _jordTyper = j;
      _kabeldimensjoner = k;
      _vernkar = v;
    });
  }

  Widget _buildCategory(
    String title,
    List<String> items,
    TextEditingController ctrl,
    Future<void> Function(List<String>) saver,
  ) {
    return ExpansionTile(
      title: Text(title),
      children: [
        for (var val in items) ListTile(title: Text(val)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrl,
                  decoration: InputDecoration(labelText: 'Legg til ny'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final text = ctrl.text.trim();
                  if (text.isEmpty) return;
                  final updated = List<String>.from(items)..add(text);
                  await saver(updated);
                  ctrl.clear();
                  _loadAll();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Innstillinger')),
      body: ListView(
        children: [
          _buildCategory(
            'Fordelingstyper',
            _fordelingstyper,
            _newFordCtrl,
            _service.saveFordelingstyper,
          ),
          _buildCategory(
            'Systemspenninger',
            _systemspenninger,
            _newSysCtrl,
            _service.saveSystemspenninger,
          ),
          _buildCategory(
            'Jordelektrodetyper',
            _jordTyper,
            _newJordCtrl,
            _service.saveJordElektrodetyper,
          ),
          _buildCategory(
            'Kabeldimensjoner',
            _kabeldimensjoner,
            _newKabelCtrl,
            _service.saveKabeldimensjoner,
          ),
          _buildCategory(
            'Vern karakteristikker',
            _vernkar,
            _newVernCtrl,
            _service.saveVernKarakteristikker,
          ),
        ],
      ),
    );
  }
}
