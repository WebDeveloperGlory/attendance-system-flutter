import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/data/datasources/auth_remote_datasource.dart';
import 'package:smart_attendance_system/data/models/login_request_model.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepo {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final request = LoginRequestModel(email: email, password: password);
      final loginResponse = await remoteDataSource.login(request);

      if (loginResponse.isSuccess) {
        // After successful login, fetch the complete user profile
        final profileResponse = await remoteDataSource.getProfile();

        if (profileResponse.isSuccess && profileResponse.data != null) {
          return Right(profileResponse.toEntity());
        } else {
          return Left(ServerFailure(profileResponse.message));
        }
      } else {
        return Left(ServerFailure(loginResponse.message));
      }
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final profileResponse = await remoteDataSource.getProfile();

      if (profileResponse.isSuccess && profileResponse.data != null) {
        return Right(profileResponse.toEntity());
      } else {
        return Left(ServerFailure(profileResponse.message));
      }
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Logout failed: ${e.toString()}'));
    }
  }
}
