import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  final String id;
  final String kursNr;
  final String description;
  final String fuseType;
  final String ampereRating;
  final String characteristic;
  final String cableCrossSection;
  final String length;
  final String earthFaultBreaker;
  final String forlMaate;
  final bool isPlaceholder;

  Course({
    required this.id,
    required this.kursNr,
    required this.description,
    required this.fuseType,
    required this.ampereRating,
    required this.characteristic,
    required this.cableCrossSection,
    required this.length,
    required this.earthFaultBreaker,
    required this.forlMaate,
    this.isPlaceholder = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);

  /// Creates a copy of this Course with the given fields replaced.
  Course copyWith({
    String? id,
    String? kursNr,
    String? description,
    String? fuseType,
    String? ampereRating,
    String? characteristic,
    String? cableCrossSection,
    String? length,
    String? earthFaultBreaker,
    String? forlMaate,
    bool? isPlaceholder,
  }) {
    return Course(
      id: id ?? this.id,
      kursNr: kursNr ?? this.kursNr,
      description: description ?? this.description,
      fuseType: fuseType ?? this.fuseType,
      ampereRating: ampereRating ?? this.ampereRating,
      characteristic: characteristic ?? this.characteristic,
      cableCrossSection: cableCrossSection ?? this.cableCrossSection,
      length: length ?? this.length,
      earthFaultBreaker: earthFaultBreaker ?? this.earthFaultBreaker,
      forlMaate: forlMaate ?? this.forlMaate,
      isPlaceholder: isPlaceholder ?? this.isPlaceholder,
    );
  }
}
