import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/data/repositories/auth_repo_impl.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

class LoginUseCase {
  final AuthRepositoryImpl repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
  ) async {
    return await repository.login(email, password);
  }
}
