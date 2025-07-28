import 'package:flutter/material.dart';
import 'package:kursliste_app/models/project.dart';
import 'package:kursliste_app/models/course.dart';
import 'package:kursliste_app/services/pdf_service.dart';
import 'package:kursliste_app/screens/course_edit_screen.dart';

class CourseListScreen extends StatefulWidget {
  final Project project;
  const CourseListScreen({Key? key, required this.project}) : super(key: key);

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.from(widget.project.courses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.customerName),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => PdfService.createAndSharePdf(widget.project),
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _courses.removeAt(oldIndex);
            _courses.insert(newIndex, item);
          });
        },
        children: [
          for (int index = 0; index < _courses.length; index++)
            ListTile(
              key: ValueKey(_courses[index].id),
              title: Text(
                '${_courses[index].kursNr} - ${_courses[index].description}',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseEditScreen(
                      project: widget.project,
                      course: _courses[index],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final template = await showDialog<String>(
            context: context,
            builder: (dialogContext) => SimpleDialog(
              title: const Text('Velg kurstype'),
              children: [
                SimpleDialogOption(
                  child: const Text('Forbrukerkurs'),
                  onPressed: () =>
                      Navigator.pop(dialogContext, 'Forbrukerkurs'),
                ),
                SimpleDialogOption(
                  child: const Text('Hovedkurs'),
                  onPressed: () => Navigator.pop(dialogContext, 'Hovedkurs'),
                ),
                SimpleDialogOption(
                  child: const Text('Jordfeilbryter'),
                  onPressed: () =>
                      Navigator.pop(dialogContext, 'Jordfeilbryter'),
                ),
                SimpleDialogOption(
                  child: const Text('Komponent'),
                  onPressed: () => Navigator.pop(dialogContext, 'Komponent'),
                ),
                SimpleDialogOption(
                  child: const Text('Tom Linje'),
                  onPressed: () => Navigator.pop(dialogContext, 'Tom Linje'),
                ),
              ],
            ),
          );
          if (template == null) return;
          final newCourse = Course(
            id: DateTime.now().toIso8601String(),
            kursNr: '',
            description: '',
            fuseType: '',
            ampereRating: '',
            characteristic: '',
            cableCrossSection: '',
            length: '',
            earthFaultBreaker: '',
            forlMaate: '',
            isPlaceholder: template == 'Tom Linje',
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseEditScreen(
                project: widget.project,
                course: newCourse,
                isNew: true,
                template: template,
              ),
            ),
          );
        },
      ),
    );
  }
}
