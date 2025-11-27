import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/fnd_repo.dart';

part 'faculty_details_state.dart';

class FacultyDetailsCubit extends Cubit<FacultyDetailsState> {
  final FndRepo fndRepo;

  FacultyDetailsCubit({required this.fndRepo}) : super(FacultyDetailsInitial());

  Future<void> loadFaculty(String facultyId) async {
    emit(FacultyDetailsLoading());
    
    final result = await fndRepo.getFaculty(facultyId);
    
    result.fold(
      (failure) {
        emit(FacultyDetailsError(failure: failure));
      },
      (faculty) {
        emit(FacultyDetailsLoaded(faculty: faculty));
      },
    );
  }

  Future<void> updateFaculty({
    required String id,
    required String name,
    required String code,
    required String description,
  }) async {
    final currentState = state;
    if (currentState is FacultyDetailsLoaded) {
      emit(FacultyDetailsActionInProgress());

      final result = await fndRepo.updateFaculty(id, {
        'name': name,
        'code': code,
        'description': description,
      });

      result.fold(
        (failure) {
          emit(FacultyDetailsError(failure: failure));
          // Reload faculty to ensure consistent state
          loadFaculty(id);
        },
        (updatedFaculty) {
          // Update faculty details while preserving departments
          emit(FacultyDetailsLoaded(
            faculty: FacultyDetailEntity(
              id: updatedFaculty.id,
              name: updatedFaculty.name,
              code: updatedFaculty.code,
              description: updatedFaculty.description,
              totalStudents: currentState.faculty.totalStudents,
              activeDepartments: currentState.faculty.activeDepartments,
              departments: currentState.faculty.departments,
            ),
          ));
        },
      );
    }
  }

  Future<void> deleteFaculty(String id) async {
    final currentState = state;
    if (currentState is FacultyDetailsLoaded) {
      emit(FacultyDetailsActionInProgress());

      final result = await fndRepo.deleteFaculty(id);

      result.fold(
        (failure) {
          emit(FacultyDetailsError(failure: failure));
        },
        (_) {
          emit(FacultyDetailsDeleted());
        },
      );
    }
  }

  Future<void> createDepartment({
    required String facultyId,
    required String name,
    required String code,
    required String description,
  }) async {
    final currentState = state;
    if (currentState is FacultyDetailsLoaded) {
      emit(FacultyDetailsActionInProgress());

      final result = await fndRepo.createDepartment({
        'name': name,
        'code': code,
        'description': description,
        'faculty': facultyId,
      });

      result.fold(
        (failure) {
          emit(FacultyDetailsError(failure: failure));
          // Reload faculty to ensure consistent state
          loadFaculty(facultyId);
        },
        (newDepartment) {
          // Add new department to the faculty
          final updatedDepartments = [
            ...currentState.faculty.departments,
            // Convert DepartmentEntity to DepartmentSummaryEntity
            DepartmentSummaryEntity(
              id: newDepartment.id,
              name: newDepartment.name,
              code: newDepartment.code,
              description: newDepartment.description,
              students: 0, // You might need to update this based on your API
              courses: 0,  // You might need to update this based on your API
            ),
          ];

          emit(FacultyDetailsLoaded(
            faculty: FacultyDetailEntity(
              id: currentState.faculty.id,
              name: currentState.faculty.name,
              code: currentState.faculty.code,
              description: currentState.faculty.description,
              totalStudents: currentState.faculty.totalStudents,
              activeDepartments: updatedDepartments.length,
              departments: updatedDepartments,
            ),
          ));
        },
      );
    }
  }

  Future<void> updateDepartment({
    required String id,
    required String name,
    required String code,
    required String description,
  }) async {
    final currentState = state;
    if (currentState is FacultyDetailsLoaded) {
      emit(FacultyDetailsActionInProgress());

      final result = await fndRepo.updateDepartment(id, {
        'name': name,
        'code': code,
        'description': description,
      });

      result.fold(
        (failure) {
          emit(FacultyDetailsError(failure: failure));
          // Reload faculty to ensure consistent state
          loadFaculty(currentState.faculty.id);
        },
        (updatedDepartment) {
          // Update department in the list
          final updatedDepartments = currentState.faculty.departments.map((dept) =>
            dept.id == id 
              ? DepartmentSummaryEntity(
                  id: updatedDepartment.id,
                  name: updatedDepartment.name,
                  code: updatedDepartment.code,
                  description: updatedDepartment.description,
                  students: dept.students, // Preserve existing stats
                  courses: dept.courses,   // Preserve existing stats
                )
              : dept
          ).toList();

          emit(FacultyDetailsLoaded(
            faculty: FacultyDetailEntity(
              id: currentState.faculty.id,
              name: currentState.faculty.name,
              code: currentState.faculty.code,
              description: currentState.faculty.description,
              totalStudents: currentState.faculty.totalStudents,
              activeDepartments: updatedDepartments.length,
              departments: updatedDepartments,
            ),
          ));
        },
      );
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    final currentState = state;
    if (currentState is FacultyDetailsLoaded) {
      emit(FacultyDetailsActionInProgress());

      final result = await fndRepo.deleteDepartment(departmentId);

      result.fold(
        (failure) {
          emit(FacultyDetailsError(failure: failure));
          // Reload faculty to ensure consistent state
          loadFaculty(currentState.faculty.id);
        },
        (_) {
          // Remove department from the list
          final updatedDepartments = currentState.faculty.departments
              .where((dept) => dept.id != departmentId)
              .toList();

          emit(FacultyDetailsLoaded(
            faculty: FacultyDetailEntity(
              id: currentState.faculty.id,
              name: currentState.faculty.name,
              code: currentState.faculty.code,
              description: currentState.faculty.description,
              totalStudents: currentState.faculty.totalStudents,
              activeDepartments: updatedDepartments.length,
              departments: updatedDepartments,
            ),
          ));
        },
      );
    }
  }
}