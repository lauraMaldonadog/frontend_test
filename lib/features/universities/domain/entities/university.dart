import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'university.freezed.dart';
part 'university.g.dart';

// Entidad de universidad
@freezed
abstract class University with _$University {
  const factory University({
    @JsonKey(name: 'alpha_two_code') String? alphaTwoCode,
    List<String>? domains,
    String? country,
    String? stateProvince,
    List<String>? webPages,
    String? name,
    // Campos adicionales para edición local
    @Default(null) String? imagePath,
    @Default(null) int? studentCount,
  }) = _University;

  factory University.fromJson(Map<String, dynamic> json) =>
      _$UniversityFromJson(json);
}
