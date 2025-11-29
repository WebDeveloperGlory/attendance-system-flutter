import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';

class AttendanceSummaryModel extends AttendanceSummaryEntity {
  const AttendanceSummaryModel({
    required super.totalSessions,
    required super.averageAttendance,
    required super.courses,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalSessions: json['totalSessions'] ?? 0,
      averageAttendance: (json['averageAttendance'] ?? 0).toDouble(),
      courses: (json['courses'] as List? ?? [])
          .map((course) => CourseAttendanceModel.fromJson(course))
          .toList(),
    );
  }
}

class CourseAttendanceModel extends CourseAttendanceEntity {
  const CourseAttendanceModel({
    required super.courseName,
    required super.courseCode,
    required super.sessions,
  });

  factory CourseAttendanceModel.fromJson(Map<String, dynamic> json) {
    return CourseAttendanceModel(
      courseName: json['courseName'] ?? '',
      courseCode: json['courseCode'] ?? '',
      sessions: (json['sessions'] as List? ?? [])
          .map((session) => ClassSessionModel.fromJson(session))
          .toList(),
    );
  }
}

class ClassSessionModel extends ClassSessionEntity {
  const ClassSessionModel({
    required super.id,
    required super.topic,
    required super.date,
    required super.attendanceRate,
    required super.present,
    required super.absent,
    required super.fingerprintVerified,
  });

  factory ClassSessionModel.fromJson(Map<String, dynamic> json) {
    return ClassSessionModel(
      id: json['_id'] ?? '',
      topic: json['topic'] ?? '',
      date: DateTime.parse(json['date']),
      attendanceRate: (json['attendanceRate'] ?? 0).toDouble(),
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      fingerprintVerified: json['fingerprintVerified'] ?? 0,
    );
  }
}

class ClassAttendanceDetailModel extends ClassAttendanceDetailEntity {
  const ClassAttendanceDetailModel({
    required super.classSession,
    required super.attendance,
  });

  factory ClassAttendanceDetailModel.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceDetailModel(
      classSession: ClassSessionDetailModel.fromJson(json['class']),
      attendance: (json['attendance'] as List? ?? [])
          .map((attendance) => StudentAttendanceModel.fromJson(attendance))
          .toList(),
    );
  }
}

class ClassSessionDetailModel extends ClassSessionDetailEntity {
  const ClassSessionDetailModel({
    required super.id,
    required super.topic,
    required super.date,
  });

  factory ClassSessionDetailModel.fromJson(Map<String, dynamic> json) {
    return ClassSessionDetailModel(
      id: json['_id'] ?? '',
      topic: json['topic'],
      date: DateTime.parse(json['date']),
    );
  }
}

class StudentAttendanceModel extends StudentAttendanceEntity {
  const StudentAttendanceModel({
    required super.studentId,
    required super.name,
    required super.email,
    required super.matricNumber,
    required super.status,
    required super.verifiedByFingerprint,
    required super.timestamp,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      studentId: json['studentId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      matricNumber: json['matricNumber'] ?? '',
      status: json['status'] ?? '',
      verifiedByFingerprint: json['verifiedByFingerprint'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }
}
