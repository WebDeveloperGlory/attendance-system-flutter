part of 'lecturer_dashboard_cubit.dart';

abstract class LecturerDashboardState extends Equatable {
  const LecturerDashboardState();

  @override
  List<Object> get props => [];
}

class LecturerDashboardInitial extends LecturerDashboardState {}

class LecturerDashboardLoading extends LecturerDashboardState {}

class LecturerDashboardLoaded extends LecturerDashboardState {
  final LecturerDashboardEntity dashboard;

  const LecturerDashboardLoaded({required this.dashboard});

  @override
  List<Object> get props => [dashboard];
}

class LecturerDashboardError extends LecturerDashboardState {
  final Failure failure;

  const LecturerDashboardError({required this.failure});

  @override
  List<Object> get props => [failure];
}