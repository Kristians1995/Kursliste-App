import 'package:flutter/material.dart';
import 'package:kursliste_app/models/project.dart';
import 'package:kursliste_app/services/archive_service.dart';
import 'package:kursliste_app/screens/settings_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final List<Project> _projects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prosjekter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              final imported = await ArchiveService.importProject();
              if (imported != null) {
                setState(() {
                  _projects.add(imported);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return ListTile(
            title: Text(project.customerName),
            subtitle: Text('Sist endret: ${project.lastModified.toLocal()}'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'Rediger':
                    // TODO: navigate to edit screen
                    break;
                  case 'Eksporter':
                    await ArchiveService.exportProject(project);
                    break;
                  case 'Slett':
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Slett prosjekt'),
                        content: const Text(
                          'Er du sikker på at du vil slette prosjektet?',
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
                    if (confirm == true) {
                      setState(() {
                        _projects.removeAt(index);
                      });
                    }
                    break;
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'Rediger', child: Text('Rediger')),
                const PopupMenuItem(
                  value: 'Eksporter',
                  child: Text('Eksporter'),
                ),
                const PopupMenuItem(value: 'Slett', child: Text('Slett')),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final newProject = Project(
            id: DateTime.now().toIso8601String(),
            customerName: 'Nytt prosjekt',
            lastModified: DateTime.now(),
            status: 'Ikke påbegynt',
            fordelingstype: '',
            systemspenning: '',
            jordElektrodeType: '',
            jordElektrodeSted: '',
            kortslutningsverdier: '',
            courses: [],
          );
          setState(() {
            _projects.add(newProject);
          });
        },
      ),
    );
  }
}
