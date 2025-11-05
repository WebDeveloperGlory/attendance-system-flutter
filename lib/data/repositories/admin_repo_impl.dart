import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_attendance_system/data/datasources/admin_remote_datasource.dart';
import 'package:smart_attendance_system/domain/entities/admin_dashboard_entity.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_create_response_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_create_response_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/admin_repo.dart';

class AdminRepoImpl implements AdminRepo {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AdminDashboardEntity>> getDashboardAnalytics() async {
    try {
      final result = await remoteDataSource.getDashboardAnalytics();
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure());
      } else {
        return Left(
          ServerFailure(e.response?.data['message'] ?? 'Server error'),
        );
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LecturerCreateResponseEntity>> registerLecturer({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
  }) async {
    try {
      final result = await remoteDataSource.registerLecturer(
        name: name,
        email: email,
        password: password,
        facultyId: facultyId,
        departmentId: departmentId,
      );
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure());
      } else {
        return Left(
          ServerFailure(e.response?.data['message'] ?? 'Server error'),
        );
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StudentCreateResponseEntity>> registerStudent({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
    required String level,
    required String matricNumber,
  }) async {
    try {
      final result = await remoteDataSource.registerStudent(
        name: name,
        email: email,
        password: password,
        facultyId: facultyId,
        departmentId: departmentId,
        level: level,
        matricNumber: matricNumber,
      );
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure());
      } else {
        return Left(
          ServerFailure(e.response?.data['message'] ?? 'Server error'),
        );
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
