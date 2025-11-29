import 'package:equatable/equatable.dart';

class AttendanceSummaryEntity extends Equatable {
  final int totalSessions;
  final double averageAttendance;
  final List<CourseAttendanceEntity> courses;

  const AttendanceSummaryEntity({
    required this.totalSessions,
    required this.averageAttendance,
    required this.courses,
  });

  @override
  List<Object?> get props => [totalSessions, averageAttendance, courses];
}

class CourseAttendanceEntity extends Equatable {
  final String courseName;
  final String courseCode;
  final List<ClassSessionEntity> sessions;

  const CourseAttendanceEntity({
    required this.courseName,
    required this.courseCode,
    required this.sessions,
  });

  @override
  List<Object?> get props => [courseName, courseCode, sessions];
}

class ClassSessionEntity extends Equatable {
  final String id;
  final String topic;
  final DateTime date;
  final double attendanceRate;
  final int present;
  final int absent;
  final int fingerprintVerified;

  const ClassSessionEntity({
    required this.id,
    required this.topic,
    required this.date,
    required this.attendanceRate,
    required this.present,
    required this.absent,
    required this.fingerprintVerified,
  });

  @override
  List<Object?> get props => [
    id,
    topic,
    date,
    attendanceRate,
    present,
    absent,
    fingerprintVerified,
  ];
}

class ClassAttendanceDetailEntity extends Equatable {
  final ClassSessionDetailEntity classSession;
  final List<StudentAttendanceEntity> attendance;

  const ClassAttendanceDetailEntity({
    required this.classSession,
    required this.attendance,
  });

  @override
  List<Object?> get props => [classSession, attendance];
}

class ClassSessionDetailEntity extends Equatable {
  final String id;
  final String? topic;
  final DateTime date;

  const ClassSessionDetailEntity({
    required this.id,
    required this.topic,
    required this.date,
  });

  @override
  List<Object?> get props => [id, topic, date];
}

class StudentAttendanceEntity extends Equatable {
  final String studentId;
  final String name;
  final String email;
  final String matricNumber;
  final String status;
  final bool verifiedByFingerprint;
  final DateTime? timestamp;

  const StudentAttendanceEntity({
    required this.studentId,
    required this.name,
    required this.email,
    required this.matricNumber,
    required this.status,
    required this.verifiedByFingerprint,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    studentId,
    name,
    email,
    matricNumber,
    status,
    verifiedByFingerprint,
    timestamp,
  ];
}
