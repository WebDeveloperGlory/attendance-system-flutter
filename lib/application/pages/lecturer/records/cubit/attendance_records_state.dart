part of 'attendance_records_cubit.dart';

abstract class AttendanceRecordsState extends Equatable {
  const AttendanceRecordsState();

  @override
  List<Object?> get props => [];
}

class AttendanceRecordsInitial extends AttendanceRecordsState {}

class AttendanceRecordsLoading extends AttendanceRecordsState {}

class AttendanceRecordsLoadingDetails extends AttendanceRecordsState {}

class AttendanceRecordsLoaded extends AttendanceRecordsState {
  final AttendanceSummaryEntity summary;
  final String? selectedCourseId;

  const AttendanceRecordsLoaded({required this.summary, this.selectedCourseId});

  AttendanceRecordsLoaded copyWith({
    AttendanceSummaryEntity? summary,
    String? selectedCourseId,
  }) {
    return AttendanceRecordsLoaded(
      summary: summary ?? this.summary,
      selectedCourseId: selectedCourseId ?? this.selectedCourseId,
    );
  }

  // Get filtered sessions based on selected course
  List<ClassSessionEntity> get filteredSessions {
    if (selectedCourseId == null) {
      // Return all sessions flattened
      return summary.courses.expand((course) => course.sessions).toList();
    }

    // Find the selected course
    final course = summary.courses.firstWhere(
      (course) => course.courseId == selectedCourseId,
      orElse: () => summary.courses.first,
    );

    return course.sessions;
  }

  @override
  List<Object?> get props => [summary, selectedCourseId];
}

class AttendanceRecordsClassDetailsLoaded extends AttendanceRecordsState {
  final AttendanceSummaryEntity summary;
  final ClassAttendanceDetailEntity classAttendance;
  final String? selectedCourseId;

  const AttendanceRecordsClassDetailsLoaded({
    required this.summary,
    required this.classAttendance,
    this.selectedCourseId,
  });

  @override
  List<Object?> get props => [summary, classAttendance, selectedCourseId];
}

class AttendanceRecordsError extends AttendanceRecordsState {
  final Failure failure;

  const AttendanceRecordsError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
