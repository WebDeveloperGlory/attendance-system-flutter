import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_attendance_system/data/datasources/fnd_remote_datasource.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/fnd_repo.dart';

class FndRepoImpl implements FndRepo {
  final FndRemoteDataSource remoteDataSource;

  FndRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FacultyEntity>>> getFaculties() async {
    try {
      final result = await remoteDataSource.getFaculties();
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure());
      } else {
        final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Server error';
        return Left(ServerFailure(errorMessage));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FacultyDetailEntity>> getFaculty(String id) async {
    try {
      final result = await remoteDataSource.getFaculty(id);
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure());
      } else {
        final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Server error';
        return Left(ServerFailure(errorMessage));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments() async {
    try {
      final result = await remoteDataSource.getDepartments();
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure());
      } else {
        final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Server error';
        return Left(ServerFailure(errorMessage));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartmentsByFaculty(String facultyId) async {
    try {
      final result = await remoteDataSource.getDepartmentsByFaculty(facultyId);
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure());
      } else {
        final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Server error';
        return Left(ServerFailure(errorMessage));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}