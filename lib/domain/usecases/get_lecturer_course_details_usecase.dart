import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_course_details_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/lecturer_course_details_repo.dart';

class GetLecturerCourseDetailsUseCase {
  final LecturerCourseDetailsRepo repository;

  GetLecturerCourseDetailsUseCase({required this.repository});

  Future<Either<Failure, LecturerCourseDetailsEntity>> call(
    String courseId,
  ) async {
    return await repository.getCourseDetails(courseId);
  }
}
