part of 'student_detail_cubit.dart';

abstract class StudentDetailState extends Equatable {
  const StudentDetailState();

  @override
  List<Object> get props => [];
}

class StudentDetailInitial extends StudentDetailState {}

class StudentDetailLoading extends StudentDetailState {}

class StudentDetailLoaded extends StudentDetailState {
  final StudentDetailEntity student;

  const StudentDetailLoaded({required this.student});

  @override
  List<Object> get props => [student];
}

class StudentDetailError extends StudentDetailState {
  final Failure failure;

  const StudentDetailError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class StudentDetailDeleted extends StudentDetailState {}

class StudentDetailUpdating extends StudentDetailState {
  final StudentDetailEntity student;

  const StudentDetailUpdating({required this.student});

  @override
  List<Object> get props => [student];
}