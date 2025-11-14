part of 'lecturer_management_cubit.dart';

abstract class LecturerManagementState extends Equatable {
  const LecturerManagementState();

  @override
  List<Object?> get props => [];
}

class LecturerManagementInitial extends LecturerManagementState {}

class LecturerManagementLoading extends LecturerManagementState {}

class LecturerManagementLoaded extends LecturerManagementState {
  final List<LecturerEntity> lecturers;

  const LecturerManagementLoaded(this.lecturers);

  @override
  List<Object?> get props => [lecturers];
}

class LecturerManagementError extends LecturerManagementState {
  final String message;

  const LecturerManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

class LecturerManagementActionLoading extends LecturerManagementState {}

class LecturerManagementActionSuccess extends LecturerManagementState {
  final String message;

  const LecturerManagementActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LecturerManagementActionError extends LecturerManagementState {
  final String message;

  const LecturerManagementActionError(this.message);

  @override
  List<Object?> get props => [message];
}