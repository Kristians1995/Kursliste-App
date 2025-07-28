// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class StorageService {
  static const _projectsKey = 'projects_storage_key';

  /// Lagrer en liste med prosjekter til SharedPreferences
  static Future<void> saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> projectsJson = projects
        .map((project) => project.toJson())
        .toList();
    await prefs.setString(_projectsKey, json.encode(projectsJson));
  }

  /// Laster listen med prosjekter fra SharedPreferences
  static Future<List<Project>> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? projectsString = prefs.getString(_projectsKey);

    if (projectsString == null) {
      return [];
    }

    try {
      final List<dynamic> projectsJson = json.decode(projectsString);
      return projectsJson
          .map((jsonItem) => Project.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Could not parse projects from storage: $e');
      return [];
    }
  }
}
