import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class AttendanceRepo {
  Future<Either<Failure, AttendanceSummaryEntity>> getAttendanceRecordsSummary();
  Future<Either<Failure, ClassAttendanceDetailEntity>> getClassAttendance(String classId);
}