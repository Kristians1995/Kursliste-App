// lib/screens/course_list_screen.dart
import 'package:flutter/material.dart';
import 'package:kursliste_app/models/project.dart';
import 'package:kursliste_app/models/course.dart';
import 'package:kursliste_app/services/pdf_service.dart';
import 'package:kursliste_app/screens/course_edit_screen.dart';

class CourseListScreen extends StatefulWidget {
  final Project project;
  const CourseListScreen({super.key, required this.project});

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late Project _currentProject;

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
  }

  String _findNextAvailableCourseNr() {
    if (_currentProject.courses.isEmpty) {
      return '1';
    }
    final existing = _currentProject.courses
        .map((c) => int.tryParse(c.kursNr) ?? 0)
        .toSet();
    int next = 1;
    while (existing.contains(next)) {
      next++;
    }
    return next.toString();
  }

  Future<void> _addOrEditCourse({
    Course? existingCourse,
    String? template,
  }) async {
    final isNew = existingCourse == null;
    late Course courseToEdit;
    if (isNew) {
      courseToEdit = _createCourseFromTemplate(template!);
    } else {
      courseToEdit = existingCourse;
    }

    final result = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => CourseEditScreen(course: courseToEdit)),
    );

    if (result != null) {
      setState(() {
        if (isNew) {
          _currentProject.courses.add(result);
        } else {
          final idx = _currentProject.courses.indexWhere(
            (c) => c.id == result.id,
          );
          if (idx != -1) _currentProject.courses[idx] = result;
        }
        _currentProject = _currentProject.copyWith(
          lastModified: DateTime.now(),
        );
      });
    }
  }

  Course _createCourseFromTemplate(String template) {
    final nr = _findNextAvailableCourseNr();
    String amp = '';
    String char = '';
    String cable = '';
    String earth = '';
    bool placeholder = false;

    switch (template) {
      case 'Forbrukerkurs':
        amp = '16';
        char = 'B';
        cable = '2.5';
        earth = '30';
        break;
      case 'Hovedkurs':
        amp = '63';
        cable = '16';
        break;
      case 'Jordfeilbryter':
        break;
      case 'Tom Linje':
        placeholder = true;
        break;
    }

    return Course(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      kursNr: placeholder ? '' : nr,
      description: template,
      fuseType: '',
      ampereRating: amp,
      characteristic: char,
      cableCrossSection: cable,
      length: '',
      earthFaultBreaker: earth,
      forlMaate: '',
      isPlaceholder: placeholder,
    );
  }

  void _showTemplateDialog() async {
    final tpl = await showDialog<String>(
      context: context,
      builder: (dCtx) => SimpleDialog(
        title: const Text('Velg kurstype-mal'),
        children: [
          SimpleDialogOption(
            child: const Text('Forbrukerkurs'),
            onPressed: () => Navigator.pop(dCtx, 'Forbrukerkurs'),
          ),
          SimpleDialogOption(
            child: const Text('Hovedkurs'),
            onPressed: () => Navigator.pop(dCtx, 'Hovedkurs'),
          ),
          SimpleDialogOption(
            child: const Text('Jordfeilbryter'),
            onPressed: () => Navigator.pop(dCtx, 'Jordfeilbryter'),
          ),
          SimpleDialogOption(
            child: const Text('Komponent (tom)'),
            onPressed: () => Navigator.pop(dCtx, 'Komponent'),
          ),
          SimpleDialogOption(
            child: const Text('Tom Linje'),
            onPressed: () => Navigator.pop(dCtx, 'Tom Linje'),
          ),
        ],
      ),
    );

    if (tpl != null) _addOrEditCourse(template: tpl);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _currentProject);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentProject.customerName),
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => PdfService.createAndSharePdf(_currentProject),
            ),
          ],
        ),
        body: ReorderableListView.builder(
          itemCount: _currentProject.courses.length,
          itemBuilder: (ctx, idx) {
            final course = _currentProject.courses[idx];
            if (course.isPlaceholder) {
              return ListTile(
                key: ValueKey(course.id),
                title: const Center(
                  child: Text(
                    '--- Tom Linje ---',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            return Dismissible(
              key: ValueKey(course.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                return showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Slett kurs'),
                    content: Text(
                      'Slette "${course.kursNr} - ${course.description}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Avbryt'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Slett'),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (_) {
                setState(() {
                  _currentProject.courses.removeAt(idx);
                  _currentProject = _currentProject.copyWith(
                    lastModified: DateTime.now(),
                  );
                });
              },
              child: ListTile(
                leading: CircleAvatar(child: Text(course.kursNr)),
                title: Text(course.description),
                subtitle: Text(
                  'Kabel: ${course.cableCrossSection} mm², Vern: ${course.ampereRating} A',
                ),
                onTap: () => _addOrEditCourse(existingCourse: course),
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final item = _currentProject.courses.removeAt(oldIndex);
              _currentProject.courses.insert(newIndex, item);
              _currentProject = _currentProject.copyWith(
                lastModified: DateTime.now(),
              );
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showTemplateDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
