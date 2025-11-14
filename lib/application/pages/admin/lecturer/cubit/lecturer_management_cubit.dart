import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_entity.dart';
import 'package:smart_attendance_system/domain/repositories/fnd_repo.dart';
import 'package:smart_attendance_system/domain/repositories/lecturer_repo.dart';

part 'lecturer_management_state.dart';

class LecturerManagementCubit extends Cubit<LecturerManagementState> {
  final LecturerRepo lecturerRepository;
  final FndRepo fndRepository;

  LecturerManagementCubit({
    required this.lecturerRepository,
    required this.fndRepository,
  }) : super(LecturerManagementInitial());

  List<LecturerEntity> _allLecturers = [];
  List<FacultyEntity> _faculties = [];
  List<DepartmentEntity> _departments = [];

  Future<void> loadLecturers() async {
    emit(LecturerManagementLoading());

    final result = await lecturerRepository.getLecturers();

    result.fold(
      (failure) => emit(LecturerManagementError(failure.message)),
      (lecturers) {
        _allLecturers = lecturers;
        emit(LecturerManagementLoaded(lecturers));
      },
    );
  }

  Future<void> loadFacultiesAndDepartments() async {
    final facultiesResult = await fndRepository.getFaculties();
    final departmentsResult = await fndRepository.getDepartments();

    facultiesResult.fold(
      (failure) => emit(LecturerManagementError(failure.message)),
      (faculties) {
        _faculties = faculties;
      },
    );

    departmentsResult.fold(
      (failure) => emit(LecturerManagementError(failure.message)),
      (departments) {
        _departments = departments;
      },
    );
  }

  void searchLecturers(String query) {
    if (query.isEmpty) {
      emit(LecturerManagementLoaded(_allLecturers));
      return;
    }

    final filtered = _allLecturers.where((lecturer) {
      final nameLower = lecturer.name.toLowerCase();
      final emailLower = lecturer.email.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) || emailLower.contains(queryLower);
    }).toList();

    emit(LecturerManagementLoaded(filtered));
  }

  Future<void> deleteLecturer(String id) async {
    emit(LecturerManagementActionLoading());

    final result = await lecturerRepository.deleteLecturer(id);

    result.fold(
      (failure) => emit(LecturerManagementActionError(failure.message)),
      (_) {
        _allLecturers.removeWhere((lecturer) => lecturer.id == id);
        emit(LecturerManagementActionSuccess('Lecturer deleted successfully'));
        emit(LecturerManagementLoaded(_allLecturers));
      },
    );
  }

  Future<void> resetPassword({
    required String lecturerId,
    required String newPassword,
  }) async {
    emit(LecturerManagementActionLoading());

    final result = await lecturerRepository.resetLecturerPassword(
      lecturerId: lecturerId,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(LecturerManagementActionError(failure.message)),
      (_) {
        emit(LecturerManagementActionSuccess('Password reset successfully'));
        emit(LecturerManagementLoaded(_allLecturers));
      },
    );
  }

  Future<void> createCourse({
    required String name,
    required String code,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    required String lecturerId,
    required String facultyId,
    required String departmentId,
    required String level,
  }) async {
    emit(LecturerManagementActionLoading());

    final result = await lecturerRepository.createCourse(
      name: name,
      code: code,
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
      lecturerId: lecturerId,
      facultyId: facultyId,
      departmentId: departmentId,
      level: level,
    );

    result.fold(
      (failure) => emit(LecturerManagementActionError(failure.message)),
      (_) {
        emit(LecturerManagementActionSuccess('Course created successfully'));
        loadLecturers(); // Refresh to get updated course counts
      },
    );
  }

  List<FacultyEntity> get faculties => _faculties;
  List<DepartmentEntity> get departments => _departments;

  List<DepartmentEntity> getDepartmentsByFacultyId(String facultyId) {
    return _departments.where((dept) => dept.facultyId == facultyId).toList();
  }
}