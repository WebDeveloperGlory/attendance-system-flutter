import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_attendance_system/data/datasources/attendance_remote_datasource.dart';
import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/attendance_repo.dart';

class AttendanceRepoImpl implements AttendanceRepo {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AttendanceSummaryEntity>>
  getAttendanceRecordsSummary() async {
    try {
      final result = await remoteDataSource.getAttendanceRecordsSummary();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassAttendanceDetailEntity>> getClassAttendance(
    String classId,
  ) async {
    try {
      final result = await remoteDataSource.getClassAttendance(classId);
      return Right(result);
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
      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Server error';
      return ServerFailure(errorMessage);
    }
  }
}
