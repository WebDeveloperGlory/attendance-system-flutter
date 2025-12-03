import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/class_session_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/class_session_repo.dart';
import 'package:smart_attendance_system/data/datasources/class_session_remote_datasource.dart';
import 'package:smart_attendance_system/data/models/update_attendance_request_model.dart';

class ClassSessionRepoImpl implements ClassSessionRepo {
  final ClassSessionRemoteDataSource remoteDataSource;

  ClassSessionRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ClassSessionEntity>> getClassSession(
    String classId,
  ) async {
    try {
      final classSession = await remoteDataSource.getClassSession(classId);
      return Right(classSession);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure('Failed to get class session: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendanceStatus(
    UpdateAttendanceRequestModel request,
  ) async {
    try {
      await remoteDataSource.updateAttendanceStatus(request);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure('Failed to update attendance: ${e.toString()}'),
      );
    }
  }
}
