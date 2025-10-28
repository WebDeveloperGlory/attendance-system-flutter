import 'package:equatable/equatable.dart';

class LoginParamsEntity extends Equatable {
  final String email;
  final String password;

  const LoginParamsEntity({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}