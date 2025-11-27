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

  // Faculty operations
  @override
  Future<Either<Failure, List<FacultyEntity>>> getFaculties() async {
    try {
      final result = await remoteDataSource.getFaculties();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
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
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FacultyEntity>> createFaculty(Map<String, dynamic> facultyData) async {
    try {
      final result = await remoteDataSource.createFaculty(facultyData);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FacultyEntity>> updateFaculty(String id, Map<String, dynamic> facultyData) async {
    try {
      final result = await remoteDataSource.updateFaculty(id, facultyData);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFaculty(String id) async {
    try {
      await remoteDataSource.deleteFaculty(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Department operations
  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments() async {
    try {
      final result = await remoteDataSource.getDepartments();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
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
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> createDepartment(Map<String, dynamic> departmentData) async {
    try {
      final result = await remoteDataSource.createDepartment(departmentData);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> updateDepartment(String id, Map<String, dynamic> departmentData) async {
    try {
      final result = await remoteDataSource.updateDepartment(id, departmentData);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDepartment(String id) async {
    try {
      await remoteDataSource.deleteDepartment(id);
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
      return NetworkFailure();
    } else {
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Server error';
      return ServerFailure(errorMessage);
    }
  }
}