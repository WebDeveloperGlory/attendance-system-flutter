import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  CreateClassCubit() : super(const CreateClassState());

  // Mock data - replace with actual API calls
  final List<Course> lecturerCourses = [
    Course(
      id: "course-1",
      name: "Data Structures",
      code: "CSC 301",
      level: "300",
      department: "Computer Science",
      students: [
        Student(id: "s1", name: "John Doe", matricNumber: "CSC/2021/001"),
        Student(id: "s2", name: "Jane Smith", matricNumber: "CSC/2021/002"),
        Student(id: "s3", name: "Mike Johnson", matricNumber: "CSC/2021/003"),
      ],
    ),
    Course(
      id: "course-2",
      name: "Algorithm Design",
      code: "CSC 401",
      level: "400",
      department: "Computer Science",
      students: [
        Student(id: "s4", name: "Alice Brown", matricNumber: "CSC/2021/010"),
        Student(id: "s5", name: "Bob Wilson", matricNumber: "CSC/2021/011"),
      ],
    ),
  ];

  final List<Student> allStudents = [
    Student(id: "s6", name: "Carol Davis", matricNumber: "CSC/2021/020"),
    Student(id: "s7", name: "David Miller", matricNumber: "CSC/2021/021"),
    Student(id: "s8", name: "Eve Taylor", matricNumber: "CSC/2021/022"),
  ];

  void nextStep() {
    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void updateCourse(String courseId) {
    final selectedCourse = lecturerCourses.firstWhere(
      (course) => course.id == courseId,
      orElse: () => Course.empty(),
    );
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
    emit(state.copyWith(carryoverSearch: search));
  }

  void addCarryoverStudent(String studentId) {
    final student = allStudents.firstWhere((s) => s.id == studentId);
    final updatedCarryover = [...state.carryoverStudents, student];
    emit(state.copyWith(carryoverStudents: updatedCarryover, carryoverSearch: ''));
  }

  void removeCarryoverStudent(String studentId) {
    final updatedCarryover = state.carryoverStudents.where((s) => s.id != studentId).toList();
    emit(state.copyWith(carryoverStudents: updatedCarryover));
  }

  void updateSaveAsTemplate(bool saveAsTemplate) {
    emit(state.copyWith(saveAsTemplate: saveAsTemplate));
  }

  Future<void> createClassSession() async {
    emit(state.copyWith(status: CreateClassStatus.loading));
    
    try {
      // TODO: Implement API call to create class session
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      emit(state.copyWith(status: CreateClassStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: CreateClassStatus.error,
        failure: ServerFailure(e.toString()),
      ));
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}