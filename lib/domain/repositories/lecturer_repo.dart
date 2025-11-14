
import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class LecturerRepo {
  Future<Either<Failure, List<LecturerEntity>>> getLecturers();
  Future<Either<Failure, void>> deleteLecturer(String id);
  Future<Either<Failure, void>> resetLecturerPassword({
    required String lecturerId,
    required String newPassword,
  });
  Future<Either<Failure, void>> createCourse({
    required String name,
    required String code,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    required String lecturerId,
    required String facultyId,
    required String departmentId,
    required String level,
  });
}