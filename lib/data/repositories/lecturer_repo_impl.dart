import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_attendance_system/data/datasources/lecturer_remote_datasource.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/lecturer_repo.dart';

class LecturerRepoImpl implements LecturerRepo {
  final LecturerRemoteDataSource remoteDataSource;

  LecturerRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LecturerEntity>>> getLecturers() async {
    try {
      final lecturers = await remoteDataSource.getLecturers();
      return Right(lecturers);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(
        e.response?.data['message'] ?? 'Failed to fetch lecturers',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLecturer(String id) async {
    try {
      await remoteDataSource.deleteLecturer(id);
      return const Right(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(
        e.response?.data['message'] ?? 'Failed to delete lecturer',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetLecturerPassword({
    required String lecturerId,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetLecturerPassword(
        lecturerId: lecturerId,
        newPassword: newPassword,
      );
      return const Right(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(
        e.response?.data['message'] ?? 'Failed to reset password',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      await remoteDataSource.createCourse(
        name: name,
        code: code,
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime,
        lecturerId: lecturerId,
        facultyId: facultyId,
        departmentId: departmentId,
        level: level,
      );
      return const Right(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(
        e.response?.data['message'] ?? 'Failed to create course',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}