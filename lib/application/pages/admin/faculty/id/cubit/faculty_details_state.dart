part of 'faculty_details_cubit.dart';

abstract class FacultyDetailsState extends Equatable {
  const FacultyDetailsState();

  @override
  List<Object> get props => [];
}

class FacultyDetailsInitial extends FacultyDetailsState {}

class FacultyDetailsLoading extends FacultyDetailsState {}

class FacultyDetailsActionInProgress extends FacultyDetailsState {}

class FacultyDetailsLoaded extends FacultyDetailsState {
  final FacultyDetailEntity faculty;

  const FacultyDetailsLoaded({required this.faculty});

  @override
  List<Object> get props => [faculty];
}

class FacultyDetailsDeleted extends FacultyDetailsState {}

class FacultyDetailsError extends FacultyDetailsState {
  final Failure failure;

  const FacultyDetailsError({required this.failure});

  @override
  List<Object> get props => [failure];
}