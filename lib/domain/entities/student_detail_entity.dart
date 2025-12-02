import 'package:equatable/equatable.dart';

class StudentDetailEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final String? level;
  final String? matricNumber;
  final FacultyEntity? faculty;
  final DepartmentEntity? department;
  final String? fingerprintHash;
  final int? coursesCount;
  final List<CourseEntity>? courses;
  final AttendanceSummaryEntity? attendanceSummary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentDetailEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    this.level,
    this.matricNumber,
    this.faculty,
    this.department,
    this.fingerprintHash,
    this.coursesCount,
    this.courses,
    this.attendanceSummary,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasFingerprintEnrolled =>
      fingerprintHash != null && fingerprintHash!.isNotEmpty;

  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return '?';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    isActive,
    level,
    matricNumber,
    faculty,
    department,
    fingerprintHash,
    coursesCount,
    courses,
    attendanceSummary,
    createdAt,
    updatedAt,
  ];
}

class FacultyEntity extends Equatable {
  final String id;
  final String name;

  const FacultyEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class DepartmentEntity extends Equatable {
  final String id;
  final String name;

  const DepartmentEntity({required this.id, required this.name});

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
