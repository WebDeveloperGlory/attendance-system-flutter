import 'package:equatable/equatable.dart';

class LecturerEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final String? facultyId;
  final String? departmentId;
  final int classCount;
  final int courseCount;
  final int totalStudents;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LecturerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    this.facultyId,
    this.departmentId,
    required this.classCount,
    required this.courseCount,
    required this.totalStudents,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        isActive,
        facultyId,
        departmentId,
        classCount,
        courseCount,
        totalStudents,
        createdAt,
        updatedAt,
      ];
}