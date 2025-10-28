import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> login(String email, String password);

  Future<Either<Failure, UserEntity>> getProfile();

  Future<Either<Failure, void>> logout();
}
