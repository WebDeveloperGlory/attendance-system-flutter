import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';

class FacultyModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FacultyModel({
    required this.id,
    required this.name,
    required this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    return FacultyModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  FacultyEntity toEntity() {
    return FacultyEntity(
      id: id,
      name: name,
      code: code,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object> get props => [id, name, code, createdAt ?? '', updatedAt ?? ''];
}