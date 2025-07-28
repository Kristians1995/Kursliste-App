import 'package:flutter/material.dart';
import 'package:kursliste_app/models/project.dart';
import 'package:kursliste_app/models/course.dart';
import 'package:kursliste_app/services/settings_service.dart';

class CourseEditScreen extends StatefulWidget {
  final Project project;
  final Course course;
  final bool isNew;
  final String? template;

  const CourseEditScreen({
    Key? key,
    required this.project,
    required this.course,
    this.isNew = false,
    this.template,
  }) : super(key: key);

  @override
  _CourseEditScreenState createState() => _CourseEditScreenState();
}

class _CourseEditScreenState extends State<CourseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _kursNrController;
  late TextEditingController _descriptionController;
  late TextEditingController _customCableController;
  late TextEditingController _customCharController;
  List<String> _cableOptions = [];
  List<String> _charOptions = [];
  String? _selectedCable;
  String? _selectedChar;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _kursNrController = TextEditingController(text: widget.course.kursNr);
    _descriptionController = TextEditingController(
      text: widget.course.description,
    );
    _customCableController = TextEditingController();
    _customCharController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _kursNrController.dispose();
    _descriptionController.dispose();
    _customCableController.dispose();
    _customCharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isNew ? 'Nytt kurs (${widget.template})' : 'Rediger kurs',
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _kursNrController,
                      decoration: const InputDecoration(labelText: 'Kurs nr.'),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Beskrivelse',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Kabel tverrsnitt',
                      ),
                      items: [
                        ..._cableOptions.map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        ),
                        const DropdownMenuItem(
                          value: 'Annet',
                          child: Text('Annet'),
                        ),
                      ],
                      value: _selectedCable,
                      onChanged: (val) {
                        setState(() => _selectedCable = val);
                      },
                    ),
                    if (_selectedCable == 'Annet')
                      TextFormField(
                        controller: _customCableController,
                        decoration: const InputDecoration(
                          labelText: 'Egendefinert kabel',
                        ),
                      ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Karakteristikk',
                      ),
                      items: [
                        ..._charOptions.map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        ),
                        const DropdownMenuItem(
                          value: 'Annet',
                          child: Text('Annet'),
                        ),
                      ],
                      value: _selectedChar,
                      onChanged: (val) {
                        setState(() => _selectedChar = val);
                      },
                    ),
                    if (_selectedChar == 'Annet')
                      TextFormField(
                        controller: _customCharController,
                        decoration: const InputDecoration(
                          labelText: 'Egendefinert karakteristikk',
                        ),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        final updated = widget.course.copyWith(
                          kursNr: _kursNrController.text,
                          description: _descriptionController.text,
                          cableCrossSection: _selectedCable == 'Annet'
                              ? _customCableController.text
                              : _selectedCable ?? '',
                          characteristic: _selectedChar == 'Annet'
                              ? _customCharController.text
                              : _selectedChar ?? '',
                        );
                        Navigator.pop(context, updated);
                      },
                      child: const Text('Lagre'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _loadSettings() async {
    final service = SettingsService();
    final cables = await service.loadKabeldimensjoner();
    final chars = await service.loadVernKarakteristikker();
    setState(() {
      _cableOptions = cables;
      _charOptions = chars;
      _selectedCable = _cableOptions.contains(widget.course.cableCrossSection)
          ? widget.course.cableCrossSection
          : 'Annet';
      _selectedChar = _charOptions.contains(widget.course.characteristic)
          ? widget.course.characteristic
          : 'Annet';
      if (_selectedCable == 'Annet')
        _customCableController.text = widget.course.cableCrossSection;
      if (_selectedChar == 'Annet')
        _customCharController.text = widget.course.characteristic;
      _loading = false;
    });
  }
}
