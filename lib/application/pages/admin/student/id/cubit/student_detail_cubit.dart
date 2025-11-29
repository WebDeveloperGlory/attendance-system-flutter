import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/student_repo.dart';

part 'student_detail_state.dart';

class StudentDetailCubit extends Cubit<StudentDetailState> {
  final StudentRepo _studentRepo;

  StudentDetailCubit(this._studentRepo, {required Object studentRepo}) : super(const StudentDetailInitial());

  Future<void> loadStudent(String studentId) async {
    emit(StudentDetailLoading(studentId));
    
    try {
      final result = await _studentRepo.getStudentById(studentId);
      result.fold(
        (failure) => emit(StudentDetailError(failure, studentId)),
        (student) => emit(StudentDetailLoaded(student)),
      );
    } catch (e) {
      emit(StudentDetailError(ServerFailure(e.toString()), studentId));
    }
  }

  Future<void> updateStudentStatus(bool isActive) async {
    final currentState = state;
    if (currentState is! StudentDetailLoaded) return;

    emit(StudentDetailUpdating(currentState.student));

    try {
      final result = await _studentRepo.updateStudent(
        currentState.student.id, 
        {'isActive': isActive},
      );
      
      result.fold(
        (failure) => emit(StudentDetailError(failure, currentState.student.id)),
        (student) => emit(StudentDetailLoaded(student)),
      );
    } catch (e) {
      emit(StudentDetailError(ServerFailure(e.toString()), currentState.student.id));
      // Revert to original state on error
      emit(StudentDetailLoaded(currentState.student));
    }
  }

  Future<void> updateStudentProfile(Map<String, dynamic> updates) async {
    final currentState = state;
    if (currentState is! StudentDetailLoaded) return;

    emit(StudentDetailUpdating(currentState.student));

    try {
      final result = await _studentRepo.updateStudent(
        currentState.student.id, 
        updates,
      );
      
      result.fold(
        (failure) => emit(StudentDetailError(failure, currentState.student.id)),
        (student) => emit(StudentDetailLoaded(student)),
      );
    } catch (e) {
      emit(StudentDetailError(ServerFailure(e.toString()), currentState.student.id));
      // Revert to original state on error
      emit(StudentDetailLoaded(currentState.student));
    }
  }

  Future<void> registerFingerprint(String fingerprintHash) async {
    final currentState = state;
    if (currentState is! StudentDetailLoaded) return;

    emit(StudentDetailUpdating(currentState.student));

    try {
      final result = await _studentRepo.registerFingerprint(
        currentState.student.id, 
        fingerprintHash,
      );
      
      result.fold(
        (failure) => emit(StudentDetailError(failure, currentState.student.id)),
        (_) {
          // Reload student to get updated fingerprint status
          loadStudent(currentState.student.id);
        },
      );
    } catch (e) {
      emit(StudentDetailError(ServerFailure(e.toString()), currentState.student.id));
      // Revert to original state on error
      emit(StudentDetailLoaded(currentState.student));
    }
  }

  Future<void> deleteStudent() async {
    final currentState = state;
    if (currentState is! StudentDetailLoaded) return;

    emit(StudentDetailDeleting(currentState.student));
    
    try {
      final result = await _studentRepo.deleteStudent(currentState.student.id);
      result.fold(
        (failure) {
          emit(StudentDetailError(failure, currentState.student.id));
          // Revert to loaded state on error
          emit(StudentDetailLoaded(currentState.student));
        },
        (_) => emit(const StudentDetailDeleted()),
      );
    } catch (e) {
      emit(StudentDetailError(ServerFailure(e.toString()), currentState.student.id));
      // Revert to loaded state on error
      emit(StudentDetailLoaded(currentState.student));
    }
  }
}