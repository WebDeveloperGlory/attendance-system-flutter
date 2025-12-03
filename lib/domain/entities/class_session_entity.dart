import 'package:equatable/equatable.dart';

class ClassSessionEntity extends Equatable {
  final String id;
  final String courseId;
  final Lecturer lecturer;
  final String? topic;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? venue;
  final ClassStats stats;
  final List<AttendanceRecord> attendanceRecords;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClassSessionEntity({
    required this.id,
    required this.courseId,
    required this.lecturer,
    this.topic,
    required this.date,
    this.startTime,
    this.endTime,
    this.venue,
    required this.stats,
    required this.attendanceRecords,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    courseId,
    lecturer,
    topic,
    date,
    startTime,
    endTime,
    venue,
    stats,
    attendanceRecords,
    createdAt,
    updatedAt,
  ];
}

class Lecturer extends Equatable {
  final String name;
  final String email;

  const Lecturer({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}

class ClassStats extends Equatable {
  final int totalStudents;
  final int present;
  final int absent;
  final double attendanceRate;

  const ClassStats({
    required this.totalStudents,
    required this.present,
    required this.absent,
    required this.attendanceRate,
  });

  @override
  List<Object?> get props => [totalStudents, present, absent, attendanceRate];
}

class AttendanceRecord extends Equatable {
  final String id;
  final Student student;
  final String status;
  final DateTime? timestamp;
  final bool verifiedByFingerprint;

  const AttendanceRecord({
    required this.id,
    required this.student,
    required this.status,
    this.timestamp,
    required this.verifiedByFingerprint,
  });

  @override
  List<Object?> get props => [
    id,
    student,
    status,
    timestamp,
    verifiedByFingerprint,
  ];
}

class Student extends Equatable {
  final String name;
  final String email;
  final String matricNumber;

  const Student({
    required this.name,
    required this.email,
    required this.matricNumber,
  });

  @override
  List<Object?> get props => [name, email, matricNumber];
}
