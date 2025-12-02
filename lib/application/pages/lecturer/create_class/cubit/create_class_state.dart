part of 'create_class_cubit.dart';

enum CreateClassStatus { initial, loading, success, error }

class CreateClassState extends Equatable {
  final int currentStep;
  final CreateClassStatus status;
  final String courseId;
  final CourseEntity? selectedCourse;
  final String topic;
  final String date;
  final String startTime;
  final String endTime;
  final String venue;
  final String carryoverSearch;
  final List<CourseEntity> lecturerCourses;
  final List<CarryoverStudentModel> potentialCarryoverStudents;
  final List<CarryoverStudentModel> filteredCarryoverStudents;
  final List<CarryoverStudentModel> carryoverStudents;
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
    this.lecturerCourses = const [],
    this.potentialCarryoverStudents = const [],
    this.filteredCarryoverStudents = const [],
    this.carryoverStudents = const [],
    this.failure,
  });

  CreateClassState copyWith({
    int? currentStep,
    CreateClassStatus? status,
    String? courseId,
    CourseEntity? selectedCourse,
    String? topic,
    String? date,
    String? startTime,
    String? endTime,
    String? venue,
    String? carryoverSearch,
    List<CourseEntity>? lecturerCourses,
    List<CarryoverStudentModel>? potentialCarryoverStudents,
    List<CarryoverStudentModel>? filteredCarryoverStudents,
    List<CarryoverStudentModel>? carryoverStudents,
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
      lecturerCourses: lecturerCourses ?? this.lecturerCourses,
      potentialCarryoverStudents:
          potentialCarryoverStudents ?? this.potentialCarryoverStudents,
      filteredCarryoverStudents:
          filteredCarryoverStudents ?? this.filteredCarryoverStudents,
      carryoverStudents: carryoverStudents ?? this.carryoverStudents,
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
    lecturerCourses,
    potentialCarryoverStudents,
    filteredCarryoverStudents,
    carryoverStudents,
    failure,
  ];
}
