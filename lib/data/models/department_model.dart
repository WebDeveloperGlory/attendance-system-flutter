// lib/data/models/department_model.dart
import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';

/// Handles JSON serialization/deserialization for Department
class DepartmentModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final String faculty;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.code,
    required this.faculty,
    this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      faculty: json['faculty'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'faculty': faculty,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  DepartmentEntity toEntity() {
    return DepartmentEntity(
      id: id,
      name: name,
      code: code,
      faculty: faculty,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object> get props => [id, name, code, faculty, createdAt ?? '', updatedAt ?? ''];
}