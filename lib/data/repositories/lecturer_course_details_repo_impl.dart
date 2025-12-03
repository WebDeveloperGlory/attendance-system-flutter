import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_course_details_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/lecturer_course_details_repo.dart';
import 'package:smart_attendance_system/data/datasources/lecturer_course_details_remote_datasource.dart';

class LecturerCourseDetailsRepoImpl implements LecturerCourseDetailsRepo {
  final LecturerCourseDetailsRemoteDataSource remoteDataSource;

  LecturerCourseDetailsRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LecturerCourseDetailsEntity>> getCourseDetails(String courseId) async {
    try {
      final courseDetails = await remoteDataSource.getCourseDetails(courseId);
      return Right(courseDetails);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Failed to get course details: ${e.toString()}'));
    }
  }
}