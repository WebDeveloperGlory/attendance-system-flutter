part of 'faculty_management_cubit.dart';

abstract class FacultyManagementState extends Equatable {
  const FacultyManagementState();

  @override
  List<Object> get props => [];
}

class FacultyManagementInitial extends FacultyManagementState {}

class FacultyManagementLoading extends FacultyManagementState {}

class FacultyManagementActionInProgress extends FacultyManagementState {}

class FacultyManagementLoaded extends FacultyManagementState {
  final List<FacultyEntity> faculties;
  final List<FacultyEntity> filteredFaculties;
  final String searchQuery;

  const FacultyManagementLoaded({
    required this.faculties,
    required this.filteredFaculties,
    required this.searchQuery,
  });

  FacultyManagementLoaded copyWith({
    List<FacultyEntity>? faculties,
    List<FacultyEntity>? filteredFaculties,
    String? searchQuery,
  }) {
    return FacultyManagementLoaded(
      faculties: faculties ?? this.faculties,
      filteredFaculties: filteredFaculties ?? this.filteredFaculties,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [faculties, filteredFaculties, searchQuery];
}

class FacultyManagementError extends FacultyManagementState {
  final Failure failure;

  const FacultyManagementError({required this.failure});

  @override
  List<Object> get props => [failure];
}