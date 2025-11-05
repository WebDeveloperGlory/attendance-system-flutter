import 'package:smart_attendance_system/domain/entities/admin_dashboard_entity.dart';

class AdminDashboardModel extends AdminDashboardEntity {
  const AdminDashboardModel({
    required super.totalStudents,
    required super.totalActiveStudents,
    required super.totalLecturers,
    required super.totalActiveLecturers,
    required super.totalFaculties,
    required super.totalDepartments,
    required super.totalCourses,
    required super.activeCourses,
    required super.attendanceRecords,
    required super.overallAttendance,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalStudents: json['totalStudents'] ?? 0,
      totalActiveStudents: json['totalActiveStudents'] ?? 0,
      totalLecturers: json['totalLecturers'] ?? 0,
      totalActiveLecturers: json['totalActiveLecturers'] ?? 0,
      totalFaculties: json['totalFaculties'] ?? 0,
      totalDepartments: json['totalDepartments'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
      activeCourses: json['activeCourses'] ?? 0,
      attendanceRecords: (json['attendanceRecords'] as List? ?? [])
          .map((record) => AttendanceRecordModel.fromJson(record))
          .toList(),
      overallAttendance: (json['overallAttendance'] ?? 0).toDouble(),
    );
  }
}

class AttendanceRecordModel extends AttendanceRecordEntity {
  const AttendanceRecordModel({
    required super.day,
    required super.attendancePercentage,
    required super.hadAttendance,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      day: json['day'] ?? '',
      attendancePercentage: (json['attendancePercentage'] ?? 0).toDouble(),
      hadAttendance: json['hadAttendance'] ?? false,
    );
  }
}
