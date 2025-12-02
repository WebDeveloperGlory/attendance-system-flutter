import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/course_repo.dart';
import 'package:smart_attendance_system/data/models/carryover_student_model.dart';

class GetCarryoverStudentsUseCase {
  final CourseRepo repository;

  GetCarryoverStudentsUseCase({required this.repository});

  Future<Either<Failure, List<CarryoverStudentModel>>> call({
    required String departmentId,
    required String currentLevel,
  }) async {
    return await repository.getPotentialCarryoverStudents(
      departmentId: departmentId,
      currentLevel: currentLevel,
    );
  }
}
