import 'dart:convert';

import 'package:kursliste_app/models/project.dart';

class ArchiveService {
  /// Exports a Project as a ZIP - disabled in stub
  static Future<void> exportProject(Project project) async {
    // No-op: file export disabled
  }

  /// Imports a Project - disabled in stub
  static Future<Project?> importProject() async {
    // No-op: file import disabled
    return null;
  }
}
