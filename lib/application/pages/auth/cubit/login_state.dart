import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;
  final String redirectRoute;

  const LoginSuccess({required this.user, required this.redirectRoute});

  @override
  List<Object> get props => [user, redirectRoute];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}