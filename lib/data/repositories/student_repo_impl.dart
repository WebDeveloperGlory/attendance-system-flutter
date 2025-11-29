import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_attendance_system/data/datasources/student_remote_datasource.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/student_repo.dart';

class StudentRepoImpl implements StudentRepo {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StudentEntity>>> getAllStudents() async {
    try {
      final result = await remoteDataSource.getAllStudents();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudentEntity>>> searchStudents(
    String query,
  ) async {
    try {
      final result = await remoteDataSource.searchStudents(query);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StudentEntity>> getStudentById(
    String studentId,
  ) async {
    try {
      final result = await remoteDataSource.getStudentById(studentId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(String studentId) async {
    try {
      await remoteDataSource.deleteStudent(studentId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StudentEntity>> updateStudent(
    String studentId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final result = await remoteDataSource.updateStudent(studentId, updates);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerFingerprint(
    String studentId,
    String fingerprintHash,
  ) async {
    try {
      await remoteDataSource.registerFingerprint(studentId, fingerprintHash);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkFailure();
    } else if (e.response?.statusCode == 401) {
      return const AuthenticationFailure('Session expired');
    } else if (e.response?.statusCode == 404) {
      return const ServerFailure('Resource not found');
    } else {
      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Server error';
      return ServerFailure(errorMessage);
    }
  }
}
