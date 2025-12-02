import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/data/models/create_class_request_model.dart';
import 'package:smart_attendance_system/data/models/create_class_response_model.dart';

abstract class ClassRepo {
  Future<Either<Failure, CreateClassResponseModel>> createClassSession(
    CreateClassRequestModel request,
  );
}
