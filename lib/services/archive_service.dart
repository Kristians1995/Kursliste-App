import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kursliste_app/models/project.dart';

class ArchiveService {
  /// Exports a Project as a ZIP containing prosjektdata.json and opens share dialog
  static Future<void> exportProject(Project project) async {
    // Serialize project to JSON
    final jsonString = jsonEncode(project.toJson());

    // Create archive and add JSON file
    final archive = Archive()
      ..addFile(
        ArchiveFile(
          'prosjektdata.json',
          utf8.encode(jsonString).length,
          utf8.encode(jsonString),
        ),
      );

    // Encode archive as ZIP
    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) return;

    // Write ZIP to temporary file
    final tempDir = Directory.systemTemp.createTempSync('eksport');
    final zipPath = '${tempDir.path}/${project.customerName}.zip';
    File(zipPath).writeAsBytesSync(zipData, flush: true);

    // Share the ZIP file
    await Share.shareXFiles([
      XFile(zipPath),
    ], text: 'Eksporter prosjekt: ${project.customerName}');
  }

  /// Imports a Project from a picked ZIP file containing prosjektdata.json
  static Future<Project?> importProject() async {
    // Let user pick a ZIP file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    // Read and decode ZIP
    final bytes = await File(path).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Find prosjektdata.json and deserialize
    for (final file in archive) {
      if (file.name == 'prosjektdata.json' && file.content is List<int>) {
        final content = utf8.decode(file.content as List<int>);
        final jsonMap = jsonDecode(content) as Map<String, dynamic>;
        return Project.fromJson(jsonMap);
      }
    }

    return null;
  }
}
