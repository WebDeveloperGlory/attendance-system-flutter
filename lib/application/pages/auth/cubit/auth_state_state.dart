part of 'auth_state_cubit.dart';

@immutable
abstract class AuthStateState extends Equatable {
  const AuthStateState();

  @override
  List<Object> get props => [];
}

class AuthStateInitial extends AuthStateState {}

class AuthStateLoading extends AuthStateState {}

class AuthStateAuthenticated extends AuthStateState {
  final UserEntity user;

  const AuthStateAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthStateUnauthenticated extends AuthStateState {}

class AuthStateError extends AuthStateState {
  final String message;

  const AuthStateError(this.message);

  @override
  List<Object> get props => [message];
}