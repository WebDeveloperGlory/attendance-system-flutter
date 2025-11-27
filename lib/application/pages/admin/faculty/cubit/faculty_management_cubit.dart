import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/fnd_repo.dart';

part 'faculty_management_state.dart';

class FacultyManagementCubit extends Cubit<FacultyManagementState> {
  final FndRepo fndRepo;

  FacultyManagementCubit({required this.fndRepo}) : super(FacultyManagementInitial());

  Future<void> loadFaculties() async {
    emit(FacultyManagementLoading());
    
    final result = await fndRepo.getFaculties();
    
    result.fold(
      (failure) {
        emit(FacultyManagementError(failure: failure));
      },
      (faculties) {
        emit(FacultyManagementLoaded(
          faculties: faculties,
          filteredFaculties: faculties,
          searchQuery: '',
        ));
      },
    );
  }

  Future<void> createFaculty({
    required String name,
    required String code,
    required String description,
  }) async {
    final currentState = state;
    if (currentState is FacultyManagementLoaded) {
      emit(FacultyManagementActionInProgress());

      final result = await fndRepo.createFaculty({
        'name': name,
        'code': code,
        'description': description,
      });

      result.fold(
        (failure) {
          emit(FacultyManagementError(failure: failure));
          // Reload faculties to ensure consistent state
          loadFaculties();
        },
        (newFaculty) {
          // Add new faculty to the list and maintain search state
          final updatedFaculties = [...currentState.faculties, newFaculty];
          final updatedFilteredFaculties = currentState.searchQuery.isEmpty
              ? updatedFaculties
              : updatedFaculties.where((faculty) =>
                  faculty.name.toLowerCase().contains(currentState.searchQuery.toLowerCase()) ||
                  faculty.code.toLowerCase().contains(currentState.searchQuery.toLowerCase())).toList();

          emit(FacultyManagementLoaded(
            faculties: updatedFaculties,
            filteredFaculties: updatedFilteredFaculties,
            searchQuery: currentState.searchQuery,
          ));
        },
      );
    }
  }

  Future<void> updateFaculty({
    required String id,
    required String name,
    required String code,
    required String description,
  }) async {
    final currentState = state;
    if (currentState is FacultyManagementLoaded) {
      emit(FacultyManagementActionInProgress());

      final result = await fndRepo.updateFaculty(id, {
        'name': name,
        'code': code,
        'description': description,
      });

      result.fold(
        (failure) {
          emit(FacultyManagementError(failure: failure));
          // Reload faculties to ensure consistent state
          loadFaculties();
        },
        (updatedFaculty) {
          // Update faculty in the list
          final updatedFaculties = currentState.faculties.map((faculty) =>
            faculty.id == id ? updatedFaculty : faculty
          ).toList();

          final updatedFilteredFaculties = currentState.searchQuery.isEmpty
              ? updatedFaculties
              : updatedFaculties.where((faculty) =>
                  faculty.name.toLowerCase().contains(currentState.searchQuery.toLowerCase()) ||
                  faculty.code.toLowerCase().contains(currentState.searchQuery.toLowerCase())).toList();

          emit(FacultyManagementLoaded(
            faculties: updatedFaculties,
            filteredFaculties: updatedFilteredFaculties,
            searchQuery: currentState.searchQuery,
          ));
        },
      );
    }
  }

  Future<void> deleteFaculty(String id) async {
    final currentState = state;
    if (currentState is FacultyManagementLoaded) {
      emit(FacultyManagementActionInProgress());

      final result = await fndRepo.deleteFaculty(id);

      result.fold(
        (failure) {
          emit(FacultyManagementError(failure: failure));
          // Reload faculties to ensure consistent state
          loadFaculties();
        },
        (_) {
          // Remove faculty from the list
          final updatedFaculties = currentState.faculties.where((faculty) => faculty.id != id).toList();
          final updatedFilteredFaculties = currentState.searchQuery.isEmpty
              ? updatedFaculties
              : updatedFaculties.where((faculty) =>
                  faculty.name.toLowerCase().contains(currentState.searchQuery.toLowerCase()) ||
                  faculty.code.toLowerCase().contains(currentState.searchQuery.toLowerCase())).toList();

          emit(FacultyManagementLoaded(
            faculties: updatedFaculties,
            filteredFaculties: updatedFilteredFaculties,
            searchQuery: currentState.searchQuery,
          ));
        },
      );
    }
  }

  void filterFaculties(String query) {
    final currentState = state;
    if (currentState is FacultyManagementLoaded) {
      final filteredFaculties = query.isEmpty
          ? currentState.faculties
          : currentState.faculties.where((faculty) =>
              faculty.name.toLowerCase().contains(query.toLowerCase()) ||
              faculty.code.toLowerCase().contains(query.toLowerCase())).toList();
      
      emit(currentState.copyWith(
        filteredFaculties: filteredFaculties,
        searchQuery: query,
      ));
    }
  }

  void clearSearch() {
    final currentState = state;
    if (currentState is FacultyManagementLoaded) {
      emit(currentState.copyWith(
        filteredFaculties: currentState.faculties,
        searchQuery: '',
      ));
    }
  }
}