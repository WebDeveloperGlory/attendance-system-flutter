import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class FndRepo {
  // Faculty operations
  Future<Either<Failure, List<FacultyEntity>>> getFaculties();
  Future<Either<Failure, FacultyDetailEntity>> getFaculty(String id);
  Future<Either<Failure, FacultyEntity>> createFaculty(Map<String, dynamic> facultyData);
  Future<Either<Failure, FacultyEntity>> updateFaculty(String id, Map<String, dynamic> facultyData);
  Future<Either<Failure, void>> deleteFaculty(String id);
  
  // Department operations
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments();
  Future<Either<Failure, List<DepartmentEntity>>> getDepartmentsByFaculty(String facultyId);
  Future<Either<Failure, DepartmentEntity>> createDepartment(Map<String, dynamic> departmentData);
  Future<Either<Failure, DepartmentEntity>> updateDepartment(String id, Map<String, dynamic> departmentData);
  Future<Either<Failure, void>> deleteDepartment(String id);
}