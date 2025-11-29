import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final String? level;
  final DepartmentEntity? department;
  final String? matricNumber;
  final FacultyEntity? faculty;
  final String? fingerprintHash;
  final int? coursesCount;
  final List<CourseEntity>? courses;
  final AttendanceSummaryEntity? attendanceSummary;

  const StudentEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    this.level,
    this.department,
    this.matricNumber,
    this.faculty,
    this.fingerprintHash,
    this.coursesCount,
    this.courses,
    this.attendanceSummary,
  });

  bool get hasFingerprintEnrolled =>
      fingerprintHash != null && fingerprintHash!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    isActive,
    level,
    department,
    matricNumber,
    faculty,
    fingerprintHash,
    coursesCount,
    courses,
    attendanceSummary,
  ];
}

class DepartmentEntity extends Equatable {
  final String id;
  final String name;

  const DepartmentEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class FacultyEntity extends Equatable {
  final String id;
  final String name;

  const FacultyEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String code;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

class AttendanceSummaryEntity extends Equatable {
  final int totalSessions;
  final int present;
  final int absent;
  final double attendanceRate;

  const AttendanceSummaryEntity({
    required this.totalSessions,
    required this.present,
    required this.absent,
    required this.attendanceRate,
  });

  @override
  List<Object?> get props => [totalSessions, present, absent, attendanceRate];
}
