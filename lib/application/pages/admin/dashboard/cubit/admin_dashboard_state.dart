part of 'admin_dashboard_cubit.dart';

abstract class AdminDashboardState {
  const AdminDashboardState();
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboardEntity dashboard;

  const AdminDashboardLoaded({required this.dashboard});
}

class AdminDashboardError extends AdminDashboardState {
  final Failure failure;

  const AdminDashboardError({required this.failure});
}
