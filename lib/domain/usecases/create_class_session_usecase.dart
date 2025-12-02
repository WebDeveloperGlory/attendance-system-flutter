import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/class_repo.dart';
import 'package:smart_attendance_system/data/models/create_class_request_model.dart';
import 'package:smart_attendance_system/data/models/create_class_response_model.dart';

class CreateClassSessionUseCase {
  final ClassRepo repository;

  CreateClassSessionUseCase({required this.repository});

  Future<Either<Failure, CreateClassResponseModel>> call(
    CreateClassRequestModel request,
  ) async {
    return await repository.createClassSession(request);
  }
}
