// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
  id: json['id'] as String,
  kursNr: json['kursNr'] as String,
  description: json['description'] as String,
  fuseType: json['fuseType'] as String,
  ampereRating: json['ampereRating'] as String,
  characteristic: json['characteristic'] as String,
  cableCrossSection: json['cableCrossSection'] as String,
  length: json['length'] as String,
  earthFaultBreaker: json['earthFaultBreaker'] as String,
  forlMaate: json['forlMaate'] as String,
  isPlaceholder: json['isPlaceholder'] as bool? ?? false,
);

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'id': instance.id,
  'kursNr': instance.kursNr,
  'description': instance.description,
  'fuseType': instance.fuseType,
  'ampereRating': instance.ampereRating,
  'characteristic': instance.characteristic,
  'cableCrossSection': instance.cableCrossSection,
  'length': instance.length,
  'earthFaultBreaker': instance.earthFaultBreaker,
  'forlMaate': instance.forlMaate,
  'isPlaceholder': instance.isPlaceholder,
};
