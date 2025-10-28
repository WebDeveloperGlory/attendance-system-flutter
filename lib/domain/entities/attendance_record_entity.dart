import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/class_entity.dart';

class AttendanceRecordEntity extends Equatable{
  final ClassEntity classSession;
  final String student;
  final DateTime timestamp;
  final String status;
  final bool verifiedByFingerprint;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceRecordEntity({
    required this.classSession,
    required this.student,
    required this.timestamp,
    required this.status,
    required this.verifiedByFingerprint,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [classSession, student, timestamp, status, verifiedByFingerprint, createdAt, updatedAt];
}