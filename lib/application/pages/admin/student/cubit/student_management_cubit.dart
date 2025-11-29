import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/student_repo.dart';

part 'student_management_state.dart';

class StudentManagementCubit extends Cubit<StudentManagementState> {
  final StudentRepo studentRepo;

  StudentManagementCubit({required this.studentRepo}) : super(StudentManagementInitial());

  Future<void> loadStudents() async {
    emit(StudentManagementLoading());
    
    final result = await studentRepo.getAllStudents();
    
    result.fold(
      (failure) {
        emit(StudentManagementError(failure: failure));
      },
      (students) {
        emit(StudentManagementLoaded(
          students: students,
          filteredStudents: students,
          searchQuery: '',
          filterFaculty: 'all',
          filterStatus: 'all',
        ));
      },
    );
  }

  void filterStudents({
    String? searchQuery,
    String? filterFaculty,
    String? filterStatus,
  }) {
    final currentState = state;
    if (currentState is StudentManagementLoaded) {
      final newSearchQuery = searchQuery ?? currentState.searchQuery;
      final newFilterFaculty = filterFaculty ?? currentState.filterFaculty;
      final newFilterStatus = filterStatus ?? currentState.filterStatus;

      List<StudentEntity> filteredStudents = currentState.students;

      // Apply search filter
      if (newSearchQuery.isNotEmpty) {
        filteredStudents = filteredStudents.where((student) =>
            student.name.toLowerCase().contains(newSearchQuery.toLowerCase()) ||
            student.matricNumber?.toLowerCase().contains(newSearchQuery.toLowerCase()) == true ||
            student.email.toLowerCase().contains(newSearchQuery.toLowerCase())).toList();
      }

      // Apply faculty filter
      if (newFilterFaculty != 'all') {
        filteredStudents = filteredStudents.where((student) =>
            student.faculty?.name == newFilterFaculty).toList();
      }

      // Apply status filter
      if (newFilterStatus != 'all') {
        final isActive = newFilterStatus == 'active';
        filteredStudents = filteredStudents.where((student) =>
            student.isActive == isActive).toList();
      }

      emit(currentState.copyWith(
        filteredStudents: filteredStudents,
        searchQuery: newSearchQuery,
        filterFaculty: newFilterFaculty,
        filterStatus: newFilterStatus,
      ));
    }
  }

  void clearFilters() {
    final currentState = state;
    if (currentState is StudentManagementLoaded) {
      emit(currentState.copyWith(
        filteredStudents: currentState.students,
        searchQuery: '',
        filterFaculty: 'all',
        filterStatus: 'all',
      ));
    }
  }


  Future<void> deleteStudent(String studentId) async {
    final currentState = state;
    if (currentState is StudentManagementLoaded) {
      emit(StudentManagementActionInProgress());

      final result = await studentRepo.deleteStudent(studentId);

      result.fold(
        (failure) {
          emit(StudentManagementError(failure: failure));
          // Reload students to ensure consistent state
          loadStudents();
        },
        (_) {
          // Remove student from the list
          final updatedStudents = currentState.students.where((student) => student.id != studentId).toList();
          final updatedFilteredStudents = currentState.filteredStudents.where((student) => student.id != studentId).toList();

          emit(StudentManagementLoaded(
            students: updatedStudents,
            filteredStudents: updatedFilteredStudents,
            searchQuery: currentState.searchQuery,
            filterFaculty: currentState.filterFaculty,
            filterStatus: currentState.filterStatus,
          ));
        },
      );
    }
  }

  // Get unique faculties for filter dropdown
  List<String?> getFaculties(List<StudentEntity> students) {
    final faculties = students
        .map((student) => student.faculty?.name)
        .where((faculty) => faculty != null)
        .toSet()
        .toList();
    faculties.sort();
    return faculties;
  }
}