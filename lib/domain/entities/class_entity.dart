import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/attendance_record_entity.dart';
import 'package:smart_attendance_system/domain/entities/course_entity.dart';

class ClassEntity extends Equatable{
  final CourseEntity course;
  final String lecturer;
  final String topic;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final List<AttendanceRecordEntity> attendanceRecords;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClassEntity({
    required this.course,
    required this.lecturer,
    required this.topic,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.attendanceRecords,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [course, lecturer, topic, date, startTime, endTime, attendanceRecords, createdAt, updatedAt];
}