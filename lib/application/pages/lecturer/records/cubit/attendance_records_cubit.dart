import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/attendance_repo.dart';

part 'attendance_records_state.dart';

class AttendanceRecordsCubit extends Cubit<AttendanceRecordsState> {
  final AttendanceRepo attendanceRepo;
  String? _selectedCourseId;

  AttendanceRecordsCubit({required this.attendanceRepo})
    : super(AttendanceRecordsInitial());

  Future<void> loadAttendanceRecords() async {
    emit(AttendanceRecordsLoading());

    final result = await attendanceRepo.getAttendanceRecordsSummary();

    result.fold(
      (failure) {
        emit(AttendanceRecordsError(failure: failure));
      },
      (summary) {
        // Reset filter when loading new data
        _selectedCourseId = null;
        emit(AttendanceRecordsLoaded(summary: summary, selectedCourseId: null));
      },
    );
  }

  void filterByCourse(String? courseId) {
    final currentState = state;
    if (currentState is AttendanceRecordsLoaded) {
      _selectedCourseId = courseId;

      emit(
        AttendanceRecordsLoaded(
          summary: currentState.summary,
          selectedCourseId: courseId,
        ),
      );
    }
  }

  Future<void> loadClassAttendance(String classId) async {
    final currentState = state;
    if (currentState is AttendanceRecordsLoaded) {
      emit(AttendanceRecordsLoadingDetails());

      final result = await attendanceRepo.getClassAttendance(classId);

      result.fold(
        (failure) {
          emit(AttendanceRecordsError(failure: failure));
          // Return to previous state
          emit(currentState);
        },
        (classAttendance) {
          emit(
            AttendanceRecordsClassDetailsLoaded(
              summary: currentState.summary,
              classAttendance: classAttendance,
              selectedCourseId: currentState.selectedCourseId,
            ),
          );
        },
      );
    }
  }

  void clearClassDetails() {
    final currentState = state;
    if (currentState is AttendanceRecordsClassDetailsLoaded) {
      emit(
        AttendanceRecordsLoaded(
          summary: currentState.summary,
          selectedCourseId: currentState.selectedCourseId,
        ),
      );
    }
  }

  String? get selectedCourseId => _selectedCourseId;
}
