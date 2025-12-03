import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/class_session_repo.dart';
import 'package:smart_attendance_system/data/models/update_attendance_request_model.dart';

class UpdateAttendanceStatusUseCase {
  final ClassSessionRepo repository;

  UpdateAttendanceStatusUseCase({required this.repository});

  Future<Either<Failure, void>> call(
    UpdateAttendanceRequestModel request,
  ) async {
    return await repository.updateAttendanceStatus(request);
  }
}
