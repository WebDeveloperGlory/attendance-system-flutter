import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/admin_dashboard_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/repositories/admin_repo.dart';

part 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminRepo adminRepository;

  AdminDashboardCubit({required this.adminRepository})
      : super(AdminDashboardInitial());

  Future<void> loadDashboardAnalytics() async {
    emit(AdminDashboardLoading());
    
    final result = await adminRepository.getDashboardAnalytics();
    
    result.fold(
      (failure) {
        emit(AdminDashboardError(failure: failure));
      },
      (dashboard) {
        emit(AdminDashboardLoaded(dashboard: dashboard));
      },
    );
  }

  Future<void> registerLecturer({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
  }) async {
    final result = await adminRepository.registerLecturer(
      name: name,
      email: email,
      password: password,
      facultyId: facultyId,
      departmentId: departmentId,
    );

    result.fold(
      (failure) {
        // Handle failure - could emit a different state or show error
        emit(AdminDashboardError(failure: failure));
      },
      (lecturer) {
        // Handle success - refresh dashboard or show success message
        loadDashboardAnalytics(); // Refresh data
      },
    );
  }

  Future<void> registerStudent({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
    required String level,
    required String matricNumber,
  }) async {
    final result = await adminRepository.registerStudent(
      name: name,
      email: email,
      password: password,
      facultyId: facultyId,
      departmentId: departmentId,
      level: level,
      matricNumber: matricNumber,
    );

    result.fold(
      (failure) {
        emit(AdminDashboardError(failure: failure));
      },
      (student) {
        loadDashboardAnalytics(); // Refresh data
      },
    );
  }
}