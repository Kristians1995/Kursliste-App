import 'package:json_annotation/json_annotation.dart';
import 'course.dart';

part 'project.g.dart';

@JsonSerializable(explicitToJson: true)
class Project {
  final String id;
  final String customerName;
  final DateTime lastModified;
  final String status;
  final String fordelingstype;
  final String systemspenning;
  final String jordElektrodeType;
  final String jordElektrodeSted;
  final String kortslutningsverdier;
  final List<Course> courses;

  Project({
    required this.id,
    required this.customerName,
    required this.lastModified,
    required this.status,
    required this.fordelingstype,
    required this.systemspenning,
    required this.jordElektrodeType,
    required this.jordElektrodeSted,
    required this.kortslutningsverdier,
    required this.courses,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
