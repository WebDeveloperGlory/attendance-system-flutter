import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/course_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/data/models/carryover_student_model.dart';

abstract class CourseRepo {
  Future<Either<Failure, List<CourseEntity>>> getLecturerCourses();
  Future<Either<Failure, List<CarryoverStudentModel>>>
  getPotentialCarryoverStudents({
    required String departmentId,
    required String currentLevel,
  });
}
