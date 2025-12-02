import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/course_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/usecases/get_lecturer_courses_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/get_carryover_students_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/create_class_session_usecase.dart';
import 'package:smart_attendance_system/data/models/carryover_student_model.dart';
import 'package:smart_attendance_system/data/models/create_class_request_model.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  final GetLecturerCoursesUseCase getLecturerCoursesUseCase;
  final GetCarryoverStudentsUseCase getCarryoverStudentsUseCase;
  final CreateClassSessionUseCase createClassSessionUseCase;

  CreateClassCubit({
    required this.getLecturerCoursesUseCase,
    required this.getCarryoverStudentsUseCase,
    required this.createClassSessionUseCase,
  }) : super(const CreateClassState());

  Future<void> loadInitialData() async {
    emit(state.copyWith(status: CreateClassStatus.loading));

    try {
      // Get lecturer courses
      await _loadLecturerCourses();
      emit(state.copyWith(status: CreateClassStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateClassStatus.error,
          failure: ServerFailure('Failed to load initial data: $e'),
        ),
      );
    }
  }

  Future<void> _loadLecturerCourses() async {
    final result = await getLecturerCoursesUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(status: CreateClassStatus.error, failure: failure));
      },
      (courses) {
        emit(
          state.copyWith(
            lecturerCourses: courses,
            status: CreateClassStatus.initial,
          ),
        );
      },
    );
  }

  Future<void> loadPotentialCarryoverStudents() async {
    if (state.selectedCourse == null) return;

    emit(state.copyWith(status: CreateClassStatus.loading));

    final result = await getCarryoverStudentsUseCase(
      departmentId: state.selectedCourse!.department.id,
      currentLevel: state.selectedCourse!.level,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: CreateClassStatus.error, failure: failure));
      },
      (students) {
        emit(
          state.copyWith(
            potentialCarryoverStudents: students,
            filteredCarryoverStudents: students,
            status: CreateClassStatus.initial,
          ),
        );
      },
    );
  }

  void nextStep() {
    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));

      // Load potential carryover students when moving to step 3
      if (state.currentStep + 1 == 3) {
        loadPotentialCarryoverStudents();
      }
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void updateCourse(String courseId) {
    CourseEntity? selectedCourse;

    if (courseId.isNotEmpty) {
      // Find the course with the matching ID
      for (final course in state.lecturerCourses) {
        if (course.id == courseId) {
          selectedCourse = course;
          break;
        }
      }
    }

    emit(state.copyWith(courseId: courseId, selectedCourse: selectedCourse));
  }

  void updateTopic(String topic) {
    emit(state.copyWith(topic: topic));
  }

  void updateDate(DateTime date) {
    emit(state.copyWith(date: date.toIso8601String().split('T').first));
  }

  void updateStartTime(TimeOfDay time) {
    emit(state.copyWith(startTime: _formatTimeOfDay(time)));
  }

  void updateEndTime(TimeOfDay time) {
    emit(state.copyWith(endTime: _formatTimeOfDay(time)));
  }

  void updateVenue(String venue) {
    emit(state.copyWith(venue: venue));
  }

  void updateCarryoverSearch(String search) {
    final filtered = state.potentialCarryoverStudents.where((student) {
      return student.name.toLowerCase().contains(search.toLowerCase()) ||
          (student.matricNumber?.toLowerCase().contains(search.toLowerCase()) ??
              false);
    }).toList();
    emit(
      state.copyWith(
        carryoverSearch: search,
        filteredCarryoverStudents: filtered,
      ),
    );
  }

  void addCarryoverStudent(String studentId) {
    final student = state.potentialCarryoverStudents.firstWhere(
      (s) => s.id == studentId,
    );
    final updatedCarryover = [...state.carryoverStudents, student];
    emit(
      state.copyWith(
        carryoverStudents: updatedCarryover,
        carryoverSearch: '',
        filteredCarryoverStudents: state.potentialCarryoverStudents,
      ),
    );
  }

  void removeCarryoverStudent(String studentId) {
    final updatedCarryover = state.carryoverStudents
        .where((s) => s.id != studentId)
        .toList();
    emit(state.copyWith(carryoverStudents: updatedCarryover));
  }

  Future<void> createClassSession() async {
    if (state.courseId.isEmpty) {
      emit(
        state.copyWith(
          status: CreateClassStatus.error,
          failure: const ServerFailure('Please select a course'),
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateClassStatus.loading));

    // Combine course students and carryover students
    final allStudentIds = [
      ...state.selectedCourse!.students,
      ...state.carryoverStudents.map((s) => s.id),
    ];

    final request = CreateClassRequestModel(
      courseId: state.courseId,
      lecturerId: '', // Will be determined by backend from auth token
      topic: state.topic,
      date: state.date,
      startTime: _formatTimeForApi(state.startTime),
      endTime: _formatTimeForApi(state.endTime),
      venue: state.venue,
      studentIds: allStudentIds,
    );

    final result = await createClassSessionUseCase(request);

    result.fold(
      (failure) {
        emit(state.copyWith(status: CreateClassStatus.error, failure: failure));
      },
      (response) {
        emit(state.copyWith(status: CreateClassStatus.success));
      },
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatTimeForApi(String timeString) {
    // Convert "9:30 AM" to "09:30:00"
    try {
      final parts = timeString.split(' ');
      if (parts.length != 2) return timeString;

      final timeParts = parts[0].split(':');
      if (timeParts.length != 2) return timeString;

      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      final isPM = parts[1].toUpperCase() == 'PM';

      final hour24 = isPM && hour < 12 ? hour + 12 : hour;
      return '${hour24.toString().padLeft(2, '0')}:$minute:00';
    } catch (e) {
      return timeString;
    }
  }
}
