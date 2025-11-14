import 'package:smart_attendance_system/domain/entities/lecturer_entity.dart';

class LecturerModel extends LecturerEntity {
  const LecturerModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
    super.facultyId,
    super.departmentId,
    required super.classCount,
    required super.courseCount,
    required super.totalStudents,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LecturerModel.fromJson(Map<String, dynamic> json) {
    return LecturerModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      facultyId: json['faculty'] != null ? json['faculty'].toString() : null,
      departmentId: json['department'] != null ? json['department'].toString() : null,
      classCount: json['classCount'] as int? ?? 0,
      courseCount: json['couseCount'] as int? ?? 0, // Note: API has typo "couseCount"
      totalStudents: json['totalStudents'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
      'faculty': facultyId,
      'department': departmentId,
      'classCount': classCount,
      'couseCount': courseCount,
      'totalStudents': totalStudents,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}