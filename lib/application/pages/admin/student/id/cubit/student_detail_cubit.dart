import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/student_detail_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/student_repo.dart';

part 'student_detail_state.dart';

class StudentDetailCubit extends Cubit<StudentDetailState> {
  final StudentRepo studentRepo;
  final String studentId;

  StudentDetailCubit({
    required this.studentRepo,
    required this.studentId,
  }) : super(StudentDetailInitial()) {
    loadStudentDetails();
  }

  Future<void> loadStudentDetails() async {
    emit(StudentDetailLoading());
    
    final result = await studentRepo.getStudentDetail(studentId);
    
    result.fold(
      (failure) {
        emit(StudentDetailError(failure: failure));
      },
      (student) {
        emit(StudentDetailLoaded(student: student));
      },
    );
  }

  Future<void> updateStudentStatus(bool isActive) async {
    final currentState = state;
    if (currentState is StudentDetailLoaded) {
      final result = await studentRepo.updateStudent(
        studentId,
        {'isActive': isActive},
      );
      
      result.fold(
        (failure) {
          emit(StudentDetailError(failure: failure));
          // Reload to restore previous state
          loadStudentDetails();
        },
        (updatedStudent) {
          // Since updateStudent returns base student, reload full details
          loadStudentDetails();
        },
      );
    }
  }

  Future<void> updateStudentProfile({
    required String name,
    required String email,
    required String level,
    required String facultyId,
    required String departmentId,
  }) async {
    final currentState = state;
    if (currentState is StudentDetailLoaded) {
      final updates = {
        'name': name,
        'email': email,
        'level': level,
        'facultyId': facultyId,
        'departmentId': departmentId,
      };
      
      final result = await studentRepo.updateStudent(studentId, updates);
      
      result.fold(
        (failure) {
          emit(StudentDetailError(failure: failure));
        },
        (updatedStudent) {
          // Reload full details since update returns base student
          loadStudentDetails();
        },
      );
    }
  }

  Future<void> deleteStudent() async {
    final result = await studentRepo.deleteStudent(studentId);
    
    result.fold(
      (failure) {
        emit(StudentDetailError(failure: failure));
      },
      (_) {
        emit(StudentDetailDeleted());
      },
    );
  }

  Future<void> registerFingerprint() async {
    // Simulate fingerprint registration
    // In a real app, this would integrate with hardware
    final currentState = state;
    if (currentState is StudentDetailLoaded) {
      final result = await studentRepo.registerFingerprint(
        studentId, 
        'fingerprint_${DateTime.now().millisecondsSinceEpoch}'
      );
      
      result.fold(
        (failure) {
          emit(StudentDetailError(failure: failure));
        },
        (_) {
          // Reload student to get updated fingerprint status
          loadStudentDetails();
        },
      );
    }
  }
}