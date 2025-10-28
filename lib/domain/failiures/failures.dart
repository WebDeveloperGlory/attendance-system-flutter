import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// General Failures //
class NetworkFailure extends Failure {
  const NetworkFailure() : super('Network connection failed');
}

class ServerFailure extends Failure {
  final int statusCode;

  const ServerFailure(super.message, {this.statusCode = 400});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
// End of General Failures //

// Authentication Failures //
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

class InvalidCredentialsFailure extends AuthenticationFailure {
  const InvalidCredentialsFailure() : super('Invalid username or password');
}
// End of Authentication Failures //