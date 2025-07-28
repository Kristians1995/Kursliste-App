import 'package:flutter/material.dart';
import 'package:kursliste_app/models/course.dart';

class CourseEditScreen extends StatefulWidget {
  final Course course;

  const CourseEditScreen({
    super.key,
    required this.course,
  });

  @override
  _CourseEditScreenState createState() => _CourseEditScreenState();
}

class _CourseEditScreenState extends State<CourseEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _kursNrController;
  late TextEditingController _descriptionController;
  late TextEditingController _fuseTypeController;
  late TextEditingController _ampereRatingController;
  late TextEditingController _characteristicController;
  late TextEditingController _cableCrossSectionController;
  late TextEditingController _lengthController;
  late TextEditingController _earthFaultBreakerController;
  late TextEditingController _forlMaateController;

  @override
  void initState() {
    super.initState();
    _kursNrController = TextEditingController(text: widget.course.kursNr);
    _descriptionController = TextEditingController(text: widget.course.description);
    _fuseTypeController = TextEditingController(text: widget.course.fuseType);
    _ampereRatingController = TextEditingController(text: widget.course.ampereRating);
    _characteristicController = TextEditingController(text: widget.course.characteristic);
    _cableCrossSectionController = TextEditingController(text: widget.course.cableCrossSection);
    _lengthController = TextEditingController(text: widget.course.length);
    _earthFaultBreakerController = TextEditingController(text: widget.course.earthFaultBreaker);
    _forlMaateController = TextEditingController(text: widget.course.forlMaate);
  }

  @override
  void dispose() {
    _kursNrController.dispose();
    _descriptionController.dispose();
    _fuseTypeController.dispose();
    _ampereRatingController.dispose();
    _characteristicController.dispose();
    _cableCrossSectionController.dispose();
    _lengthController.dispose();
    _earthFaultBreakerController.dispose();
    _forlMaateController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final updatedCourse = widget.course.copyWith(
        kursNr: _kursNrController.text,
        description: _descriptionController.text,
        fuseType: _fuseTypeController.text,
        ampereRating: _ampereRatingController.text,
        characteristic: _characteristicController.text,
        cableCrossSection: _cableCrossSectionController.text,
        length: _lengthController.text,
        earthFaultBreaker: _earthFaultBreakerController.text,
        forlMaate: _forlMaateController.text,
      );
      Navigator.of(context).pop(updatedCourse);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.course.isPlaceholder) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tom Linje')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Dette er en tom linje for layout.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(widget.course),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.description.isEmpty ? 'Nytt kurs' : 'Rediger kurs'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _kursNrController,
                decoration: const InputDecoration(labelText: 'Kurs nr.'),
                validator: (value) => (value == null || value.isEmpty) ? 'Må fylles ut' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Lastbeskrivelse / utstyr'),
                validator: (value) => (value == null || value.isEmpty) ? 'Må fylles ut' : null,
              ),
              TextFormField(
                controller: _fuseTypeController,
                decoration: const InputDecoration(labelText: 'Vern (type)'),
              ),
              TextFormField(
                controller: _ampereRatingController,
                decoration: const InputDecoration(labelText: 'In [A]'),
              ),
              TextFormField(
                controller: _characteristicController,
                decoration: const InputDecoration(labelText: 'Kar.'),
              ),
              TextFormField(
                controller: _cableCrossSectionController,
                decoration: const InputDecoration(labelText: 'Kabel [mm2]'),
              ),
              TextFormField(
                controller: _lengthController,
                decoration: const InputDecoration(labelText: 'Lengde [m]'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _earthFaultBreakerController,
                decoration: const InputDecoration(labelText: 'Jordf.br. [mA]'),
              ),
              TextFormField(
                controller: _forlMaateController,
                decoration: const InputDecoration(labelText: 'Forl. måte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
