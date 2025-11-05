import 'package:equatable/equatable.dart';

class AdminDashboardEntity extends Equatable {
  final int totalStudents;
  final int totalActiveStudents;
  final int totalLecturers;
  final int totalActiveLecturers;
  final int totalFaculties;
  final int totalDepartments;
  final int totalCourses;
  final int activeCourses;
  final List<AttendanceRecordEntity> attendanceRecords;
  final double overallAttendance;

  const AdminDashboardEntity({
    required this.totalStudents,
    required this.totalActiveStudents,
    required this.totalLecturers,
    required this.totalActiveLecturers,
    required this.totalFaculties,
    required this.totalDepartments,
    required this.totalCourses,
    required this.activeCourses,
    required this.attendanceRecords,
    required this.overallAttendance,
  });

  @override
  List<Object?> get props => [
    totalStudents,
    totalActiveStudents,
    totalLecturers,
    totalActiveLecturers,
    totalFaculties,
    totalDepartments,
    totalCourses,
    activeCourses,
    attendanceRecords,
    overallAttendance,
  ];
}

class AttendanceRecordEntity extends Equatable {
  final String day;
  final double attendancePercentage;
  final bool hadAttendance;

  const AttendanceRecordEntity({
    required this.day,
    required this.attendancePercentage,
    required this.hadAttendance,
  });

  @override
  List<Object?> get props => [day, attendancePercentage, hadAttendance];
}
