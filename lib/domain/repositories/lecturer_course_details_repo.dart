import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_course_details_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class LecturerCourseDetailsRepo {
  Future<Either<Failure, LecturerCourseDetailsEntity>> getCourseDetails(
    String courseId,
  );
}
