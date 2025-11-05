import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/admin_dashboard_entity.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_create_response_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_create_response_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class AdminRepo {
  Future<Either<Failure, AdminDashboardEntity>> getDashboardAnalytics();
  Future<Either<Failure, LecturerCreateResponseEntity>> registerLecturer({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
  });
  Future<Either<Failure, StudentCreateResponseEntity>> registerStudent({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
    required String level,
    required String matricNumber,
  });
}
