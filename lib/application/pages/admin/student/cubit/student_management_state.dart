part of 'student_management_cubit.dart';

abstract class StudentManagementState extends Equatable {
  const StudentManagementState();

  @override
  List<Object> get props => [];
}

class StudentManagementInitial extends StudentManagementState {}

class StudentManagementLoading extends StudentManagementState {}

class StudentManagementActionInProgress extends StudentManagementState {}

class StudentManagementLoaded extends StudentManagementState {
  final List<StudentEntity> students;
  final List<StudentEntity> filteredStudents;
  final String searchQuery;
  final String filterFaculty;
  final String filterStatus;

  const StudentManagementLoaded({
    required this.students,
    required this.filteredStudents,
    required this.searchQuery,
    required this.filterFaculty,
    required this.filterStatus,
  });

  StudentManagementLoaded copyWith({
    List<StudentEntity>? students,
    List<StudentEntity>? filteredStudents,
    String? searchQuery,
    String? filterFaculty,
    String? filterStatus,
  }) {
    return StudentManagementLoaded(
      students: students ?? this.students,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      searchQuery: searchQuery ?? this.searchQuery,
      filterFaculty: filterFaculty ?? this.filterFaculty,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }

  @override
  List<Object> get props => [
    students,
    filteredStudents,
    searchQuery,
    filterFaculty,
    filterStatus,
  ];
}

class StudentManagementError extends StudentManagementState {
  final Failure failure;

  const StudentManagementError({required this.failure});

  @override
  List<Object> get props => [failure];
}
