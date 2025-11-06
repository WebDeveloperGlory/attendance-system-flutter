import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';


abstract class FndRepo {
  Future<Either<Failure, List<FacultyEntity>>> getFaculties();
  Future<Either<Failure, FacultyDetailEntity>> getFaculty(String id);
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments();
  Future<Either<Failure, List<DepartmentEntity>>> getDepartmentsByFaculty(String facultyId);
}