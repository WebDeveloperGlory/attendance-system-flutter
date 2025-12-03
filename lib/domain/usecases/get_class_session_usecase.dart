import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/class_session_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/class_session_repo.dart';

class GetClassSessionUseCase {
  final ClassSessionRepo repository;

  GetClassSessionUseCase({required this.repository});

  Future<Either<Failure, ClassSessionEntity>> call(String classId) async {
    return await repository.getClassSession(classId);
  }
}