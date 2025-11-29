part of 'create_class_cubit.dart';

enum CreateClassStatus { initial, loading, success, error }

class CreateClassState extends Equatable {
  final int currentStep;
  final CreateClassStatus status;
  final String courseId;
  final Course? selectedCourse;
  final String topic;
  final String date;
  final String startTime;
  final String endTime;
  final String venue;
  final String carryoverSearch;
  final List<Student> carryoverStudents;
  final bool saveAsTemplate;
  final Failure? failure;

  const CreateClassState({
    this.currentStep = 1,
    this.status = CreateClassStatus.initial,
    this.courseId = '',
    this.selectedCourse,
    this.topic = '',
    this.date = '',
    this.startTime = '',
    this.endTime = '',
    this.venue = '',
    this.carryoverSearch = '',
    this.carryoverStudents = const [],
    this.saveAsTemplate = false,
    this.failure,
  });

  CreateClassState copyWith({
    int? currentStep,
    CreateClassStatus? status,
    String? courseId,
    Course? selectedCourse,
    String? topic,
    String? date,
    String? startTime,
    String? endTime,
    String? venue,
    String? carryoverSearch,
    List<Student>? carryoverStudents,
    bool? saveAsTemplate,
    Failure? failure,
  }) {
    return CreateClassState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      courseId: courseId ?? this.courseId,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      topic: topic ?? this.topic,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      venue: venue ?? this.venue,
      carryoverSearch: carryoverSearch ?? this.carryoverSearch,
      carryoverStudents: carryoverStudents ?? this.carryoverStudents,
      saveAsTemplate: saveAsTemplate ?? this.saveAsTemplate,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        status,
        courseId,
        selectedCourse,
        topic,
        date,
        startTime,
        endTime,
        venue,
        carryoverSearch,
        carryoverStudents,
        saveAsTemplate,
        failure,
      ];
}

class Course {
  final String id;
  final String name;
  final String code;
  final String level;
  final String department;
  final List<Student> students;

  const Course({
    required this.id,
    required this.name,
    required this.code,
    required this.level,
    required this.department,
    required this.students,
  });

  factory Course.empty() {
    return Course(
      id: '',
      name: '',
      code: '',
      level: '',
      department: '',
      students: const [],
    );
  }
}

class Student {
  final String id;
  final String name;
  final String matricNumber;

  const Student({
    required this.id,
    required this.name,
    required this.matricNumber,
  });
}