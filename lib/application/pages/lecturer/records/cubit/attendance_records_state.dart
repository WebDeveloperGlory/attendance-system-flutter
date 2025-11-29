part of 'attendance_records_cubit.dart';

abstract class AttendanceRecordsState extends Equatable {
  const AttendanceRecordsState();

  @override
  List<Object> get props => [];
}

class AttendanceRecordsInitial extends AttendanceRecordsState {}

class AttendanceRecordsLoading extends AttendanceRecordsState {}

class AttendanceRecordsLoadingDetails extends AttendanceRecordsState {}

class AttendanceRecordsLoaded extends AttendanceRecordsState {
  final AttendanceSummaryEntity summary;

  const AttendanceRecordsLoaded({required this.summary});

  @override
  List<Object> get props => [summary];
}

class AttendanceRecordsClassDetailsLoaded extends AttendanceRecordsState {
  final AttendanceSummaryEntity summary;
  final ClassAttendanceDetailEntity classAttendance;

  const AttendanceRecordsClassDetailsLoaded({
    required this.summary,
    required this.classAttendance,
  });

  @override
  List<Object> get props => [summary, classAttendance];
}

class AttendanceRecordsError extends AttendanceRecordsState {
  final Failure failure;

  const AttendanceRecordsError({required this.failure});

  @override
  List<Object> get props => [failure];
}
