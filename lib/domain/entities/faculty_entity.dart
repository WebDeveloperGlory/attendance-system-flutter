import 'package:equatable/equatable.dart';

class FacultyEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String description;
  final List<String> departments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FacultyEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.departments,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, code, description, departments, createdAt, updatedAt];
}

class FacultyDetailEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String description;
  final int totalStudents;
  final int activeDepartments;
  final List<DepartmentSummaryEntity> departments;

  const FacultyDetailEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.totalStudents,
    required this.activeDepartments,
    required this.departments,
  });

  @override
  List<Object?> get props => [id, name, code, description, totalStudents, activeDepartments, departments];
}

class DepartmentSummaryEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String description;
  final int students;
  final int courses;

  const DepartmentSummaryEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.students,
    required this.courses,
  });

  @override
  List<Object?> get props => [id, name, code, description, students, courses];
}