// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  id: json['id'] as String,
  customerName: json['customerName'] as String,
  lastModified: DateTime.parse(json['lastModified'] as String),
  status: json['status'] as String? ?? 'Ikke påbegynt',
  fordelingstype: json['fordelingstype'] as String? ?? '',
  systemspenning: json['systemspenning'] as String? ?? '',
  jordElektrodeType: json['jordElektrodeType'] as String? ?? '',
  jordElektrodeSted: json['jordElektrodeSted'] as String? ?? '',
  kortslutningsverdier: json['kortslutningsverdier'] as String? ?? '',
  courses:
      (json['courses'] as List<dynamic>?)
          ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  'id': instance.id,
  'customerName': instance.customerName,
  'lastModified': instance.lastModified.toIso8601String(),
  'status': instance.status,
  'fordelingstype': instance.fordelingstype,
  'systemspenning': instance.systemspenning,
  'jordElektrodeType': instance.jordElektrodeType,
  'jordElektrodeSted': instance.jordElektrodeSted,
  'kortslutningsverdier': instance.kortslutningsverdier,
  'courses': instance.courses.map((e) => e.toJson()).toList(),
};
