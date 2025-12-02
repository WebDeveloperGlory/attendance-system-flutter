import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/course_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/data/datasources/course_remote_datasource.dart';
import 'package:smart_attendance_system/data/models/carryover_student_model.dart';
import 'package:smart_attendance_system/domain/repositories/course_repo.dart';

class CourseRepoImpl implements CourseRepo {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CourseEntity>>> getLecturerCourses() async {
    try {
      final courses = await remoteDataSource.getLecturerCourses();
      return Right(courses);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure('Failed to get lecturer courses: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<CarryoverStudentModel>>>
  getPotentialCarryoverStudents({
    required String departmentId,
    required String currentLevel,
  }) async {
    try {
      final students = await remoteDataSource.getPotentialCarryoverStudents(
        departmentId: departmentId,
        currentLevel: currentLevel,
      );
      return Right(students);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure('Failed to get carryover students: ${e.toString()}'),
      );
    }
  }
}
