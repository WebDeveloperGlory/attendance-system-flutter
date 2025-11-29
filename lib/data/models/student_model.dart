import 'package:smart_attendance_system/domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
    super.level,
    super.department,
    super.matricNumber,
    super.faculty,
    super.fingerprintHash,
    super.coursesCount,
    super.courses,
    super.attendanceSummary,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      level: json['level'],
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
      matricNumber: json['matricNumber'],
      faculty: json['faculty'] != null
          ? FacultyModel.fromJson(json['faculty'])
          : null,
      fingerprintHash: json['fingerprintHash'],
      coursesCount: json['coursesCount'],
      courses: (json['courses'] as List?)
          ?.map((course) => CourseModel.fromJson(course))
          .toList(),
      attendanceSummary: json['attendanceSummary'] != null
          ? AttendanceSummaryModel.fromJson(json['attendanceSummary'])
          : null,
    );
  }
}

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({required super.id, required super.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class FacultyModel extends FacultyEntity {
  const FacultyModel({required super.id, required super.name});

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    return FacultyModel(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class AttendanceSummaryModel extends AttendanceSummaryEntity {
  const AttendanceSummaryModel({
    required super.totalSessions,
    required super.present,
    required super.absent,
    required super.attendanceRate,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalSessions: json['totalSessions'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      attendanceRate: (json['attendanceRate'] ?? 0).toDouble(),
    );
  }
}
