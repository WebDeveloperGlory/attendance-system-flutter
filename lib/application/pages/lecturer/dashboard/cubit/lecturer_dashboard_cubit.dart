import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_dashboard_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/lecturer_repo.dart';

part 'lecturer_dashboard_state.dart';

class LecturerDashboardCubit extends Cubit<LecturerDashboardState> {
  final LecturerRepo lecturerRepo;

  LecturerDashboardCubit({required this.lecturerRepo})
      : super(LecturerDashboardInitial());

  Future<void> loadDashboardAnalytics() async {
    emit(LecturerDashboardLoading());
    
    final result = await lecturerRepo.getDashboardAnalytics();
    
    result.fold(
      (failure) {
        emit(LecturerDashboardError(failure: failure));
      },
      (dashboard) {
        emit(LecturerDashboardLoaded(dashboard: dashboard));
      },
    );
  }
}