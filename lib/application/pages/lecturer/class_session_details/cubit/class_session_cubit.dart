import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/class_session_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/usecases/get_class_session_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/update_attendance_status_usecase.dart';
import 'package:smart_attendance_system/data/models/update_attendance_request_model.dart';

part 'class_session_state.dart';

class ClassSessionCubit extends Cubit<ClassSessionState> {
  final GetClassSessionUseCase getClassSessionUseCase;
  final UpdateAttendanceStatusUseCase updateAttendanceStatusUseCase;
  final String classId;

  ClassSessionCubit({
    required this.getClassSessionUseCase,
    required this.updateAttendanceStatusUseCase,
    required this.classId,
  }) : super(const ClassSessionState()) {
    loadClassSession();
  }

  Future<void> loadClassSession() async {
    emit(state.copyWith(status: ClassSessionStatus.loading));

    final result = await getClassSessionUseCase(classId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ClassSessionStatus.error,
          failure: failure,
        ));
      },
      (classSession) {
        emit(state.copyWith(
          status: ClassSessionStatus.loaded,
          classSession: classSession,
        ));
      },
    );
  }

  Future<void> updateAttendanceStatus({
    required String attendanceRecordId,
    required String status,
    bool verifiedByFingerprint = false,
  }) async {
    emit(state.copyWith(status: ClassSessionStatus.updating));

    final request = UpdateAttendanceRequestModel(
      attendanceRecordId: attendanceRecordId,
      status: status,
      verifiedByFingerprint: verifiedByFingerprint,
    );

    final result = await updateAttendanceStatusUseCase(request);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ClassSessionStatus.error,
          failure: failure,
        ));
        // Reload data after error
        loadClassSession();
      },
      (_) {
        // Reload data after successful update
        loadClassSession();
      },
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleAttendanceSession(bool isActive) {
    emit(state.copyWith(isAttendanceActive: isActive));
  }

  void toggleMenu(bool showMenu) {
    emit(state.copyWith(showMenu: showMenu));
  }

  void toggleAddStudentDialog(bool showDialog) {
    emit(state.copyWith(showAddStudentDialog: showDialog));
  }
}