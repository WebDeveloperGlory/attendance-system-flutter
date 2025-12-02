import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/course_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/course_repo.dart';

class GetLecturerCoursesUseCase {
  final CourseRepo repository;

  GetLecturerCoursesUseCase({required this.repository});

  Future<Either<Failure, List<CourseEntity>>> call() async {
    return await repository.getLecturerCourses();
  }
}
