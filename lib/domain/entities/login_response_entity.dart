import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final bool success;
  final String message;
  final String data;

  const LoginResponseEntity({required this.success, required this.message, required this.data});

  @override
  List<Object?> get props => [success, message, data];
}
