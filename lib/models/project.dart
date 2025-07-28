// lib/models/project.dart
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
    this.status = 'Ikke påbegynt',
    this.fordelingstype = '',
    this.systemspenning = '',
    this.jordElektrodeType = '',
    this.jordElektrodeSted = '',
    this.kortslutningsverdier = '',
    this.courses = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
  Project copyWith({
    String? id,
    String? customerName,
    DateTime? lastModified,
    String? status,
    String? fordelingstype,
    String? systemspenning,
    String? jordElektrodeType,
    String? jordElektrodeSted,
    String? kortslutningsverdier,
    List<Course>? courses,
  }) {
    return Project(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      lastModified: lastModified ?? this.lastModified,
      status: status ?? this.status,
      fordelingstype: fordelingstype ?? this.fordelingstype,
      systemspenning: systemspenning ?? this.systemspenning,
      jordElektrodeType: jordElektrodeType ?? this.jordElektrodeType,
      jordElektrodeSted: jordElektrodeSted ?? this.jordElektrodeSted,
      kortslutningsverdier: kortslutningsverdier ?? this.kortslutningsverdier,
      courses: courses ?? this.courses,
    );
  }
}
