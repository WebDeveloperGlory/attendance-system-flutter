import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/class_session_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/data/models/update_attendance_request_model.dart';

abstract class ClassSessionRepo {
  Future<Either<Failure, ClassSessionEntity>> getClassSession(String classId);
  Future<Either<Failure, void>> updateAttendanceStatus(
    UpdateAttendanceRequestModel request,
  );
}
