// lib/screens/project_list_screen.dart
import 'package:flutter/material.dart';
import 'package:kursliste_app/models/project.dart';
import 'package:kursliste_app/services/archive_service.dart';
import 'package:kursliste_app/services/storage_service.dart';
import 'package:kursliste_app/screens/settings_screen.dart';
import 'package:kursliste_app/screens/course_list_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<Project> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final loadedProjects = await StorageService.loadProjects();
    setState(() {
      _projects = loadedProjects;
      _isLoading = false;
    });
  }

  Future<void> _saveProjects() async {
    await StorageService.saveProjects(_projects);
  }

  void _addProject() {
    final newProject = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: 'Nytt Prosjekt',
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
    _saveProjects();
  }

  void _importProject() async {
    final imported = await ArchiveService.importProject();
    if (imported != null) {
      if (_projects.any((p) => p.id == imported.id)) {
        final result = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Prosjekt finnes'),
            content: const Text('Et prosjekt med samme ID finnes allerede. Vil du importere som en kopi?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Avbryt')),
              TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Importer kopi')),
            ],
          ),
        );
        if (result == true) {
          final newId = DateTime.now().millisecondsSinceEpoch.toString();
          final copiedProject = imported.copyWith(
            id: newId,
            customerName: '${imported.customerName} (Kopi)',
          );
          setState(() => _projects.add(copiedProject));
          _saveProjects();
        }
      } else {
        setState(() => _projects.add(imported));
        _saveProjects();
      }
    }
  }

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
            onPressed: _importProject,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _projects.isEmpty
              ? const Center(
                  child: Text(
                    'Ingen prosjekter.\nTrykk på "+" for å lage et nytt, eller importer et.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    final project = _projects[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(project.customerName),
                        subtitle: Text(
                          'Status: ${project.status}\nSist endret: ${project.lastModified.toLocal()}',
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            switch (value) {
                              case 'Rediger':
                                break;
                              case 'Eksporter':
                                await ArchiveService.exportProject(project);
                                break;
                              case 'Dupliser':
                                final newId = DateTime.now().millisecondsSinceEpoch.toString();
                                final duplicated = project.copyWith(
                                  id: newId,
                                  customerName: '${project.customerName} (Kopi)',
                                );
                                setState(() => _projects.add(duplicated));
                                _saveProjects();
                                break;
                              case 'Slett':
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    title: const Text('Slett prosjekt'),
                                    content: Text('Er du sikker på at du vil slette "${project.customerName}"?'),
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
                                  setState(() => _projects.removeAt(index));
                                  _saveProjects();
                                }
                                break;
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'Rediger', child: Text('Rediger')),
                            const PopupMenuItem(value: 'Eksporter', child: Text('Eksporter')),
                            const PopupMenuItem(value: 'Dupliser', child: Text('Dupliser')),
                            const PopupMenuItem(value: 'Slett', child: Text('Slett')),
                          ],
                        ),
                        onTap: () async {
                          final updated = await Navigator.push<Project>(
                            context,
                            MaterialPageRoute(builder: (_) => CourseListScreen(project: project)),
                          );
                          if (updated != null) {
                            setState(() => _projects[index] = updated);
                            _saveProjects();
                          }
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProject,
        child: const Icon(Icons.add),
      ),
    );
  }
}
