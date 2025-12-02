import 'package:dartz/dartz.dart';
import 'package:smart_attendance_system/domain/entities/student_detail_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class StudentRepo {
  Future<Either<Failure, List<StudentEntity>>> getAllStudents();
  Future<Either<Failure, List<StudentEntity>>> searchStudents(String query);
  Future<Either<Failure, StudentEntity>> getStudentById(String studentId);
  Future<Either<Failure, void>> deleteStudent(String studentId);
  Future<Either<Failure, StudentEntity>> updateStudent(
    String studentId,
    Map<String, dynamic> updates,
  );
  Future<Either<Failure, void>> registerFingerprint(
    String studentId,
    String fingerprintHash,
  );
  Future<Either<Failure, StudentDetailEntity>> getStudentDetail(String studentId);
}
