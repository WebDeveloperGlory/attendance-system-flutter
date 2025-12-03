import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';

class AttendanceSummaryModel extends AttendanceSummaryEntity {
  const AttendanceSummaryModel({
    required super.totalSessions,
    required super.averageAttendance,
    required super.courses,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalSessions: (json['totalSessions'] ?? 0).toInt(),
      averageAttendance: (json['averageAttendance'] ?? 0).toDouble(),
      courses:
          (json['courses'] as List<dynamic>?)
              ?.map((course) => CourseAttendanceModel.fromJson(course))
              .toList() ??
          const [],
    );
  }
}

class CourseAttendanceModel extends CourseAttendanceEntity {
  const CourseAttendanceModel({
    required super.courseId,
    required super.courseName,
    required super.courseCode,
    required super.sessions,
  });

  factory CourseAttendanceModel.fromJson(Map<String, dynamic> json) {
    return CourseAttendanceModel(
      courseId: json['courseId']?.toString() ?? '',
      courseName: json['courseName']?.toString() ?? '',
      courseCode: json['courseCode']?.toString() ?? '',
      sessions:
          (json['sessions'] as List<dynamic>?)
              ?.map((session) => ClassSessionModel.fromJson(session))
              .toList() ??
          const [],
    );
  }
}

class ClassSessionModel extends ClassSessionEntity {
  const ClassSessionModel({
    required super.id,
    required super.topic,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.attendanceRate,
    required super.present,
    required super.absent,
    required super.fingerprintVerified,
  });

  factory ClassSessionModel.fromJson(Map<String, dynamic> json) {
    return ClassSessionModel(
      id: json['classId']?.toString() ?? '',
      topic: json['topic']?.toString() ?? '',
      date: _parseDateTime(json['date']),
      startTime: _parseDateTime(json['startTime']),
      endTime: _parseDateTime(json['endTime']),
      attendanceRate: (json['attendanceRate'] ?? 0).toDouble(),
      present: (json['present'] ?? 0).toInt(),
      absent: (json['absent'] ?? 0).toInt(),
      fingerprintVerified: (json['fingerprintVerified'] ?? 0).toInt(),
    );
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
