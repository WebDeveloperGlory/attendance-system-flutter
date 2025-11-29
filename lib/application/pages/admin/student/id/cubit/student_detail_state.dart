part of 'student_detail_cubit.dart';

abstract class StudentDetailState extends Equatable {
  final String studentId;

  const StudentDetailState({required this.studentId});

  @override
  List<Object> get props => [studentId];
}

class StudentDetailInitial extends StudentDetailState {
  const StudentDetailInitial() : super(studentId: '');
}

class StudentDetailLoading extends StudentDetailState {
  final String loadingStudentId;

  const StudentDetailLoading(this.loadingStudentId) : super(studentId: loadingStudentId);

  @override
  List<Object> get props => [loadingStudentId];
}

class StudentDetailLoaded extends StudentDetailState {
  final StudentEntity student;

  StudentDetailLoaded(this.student) : super(studentId: student.id);

  @override
  List<Object> get props => [student];
}

class StudentDetailUpdating extends StudentDetailState {
  final StudentEntity student;

  StudentDetailUpdating(this.student) : super(studentId: student.id);

  @override
  List<Object> get props => [student];
}

class StudentDetailDeleting extends StudentDetailState {
  final StudentEntity student;

  StudentDetailDeleting(this.student) : super(studentId: student.id);

  @override
  List<Object> get props => [student];
}

class StudentDetailDeleted extends StudentDetailState {
  const StudentDetailDeleted() : super(studentId: '');
}

class StudentDetailError extends StudentDetailState {
  final Failure failure;
  final String errorStudentId;

  const StudentDetailError(this.failure, this.errorStudentId) : super(studentId: errorStudentId);

  @override
  List<Object> get props => [failure, errorStudentId];
}