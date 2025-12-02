import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/class_repo.dart';
import 'package:smart_attendance_system/data/datasources/class_remote_datasource.dart';
import 'package:smart_attendance_system/data/models/create_class_request_model.dart';
import 'package:smart_attendance_system/data/models/create_class_response_model.dart';

class ClassRepoImpl implements ClassRepo {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CreateClassResponseModel>> createClassSession(
    CreateClassRequestModel request,
  ) async {
    try {
      final response = await remoteDataSource.createClassSession(request);
      if (response.isSuccess) {
        return Right(response);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Failed to create class: ${e.toString()}'));
    }
  }
}