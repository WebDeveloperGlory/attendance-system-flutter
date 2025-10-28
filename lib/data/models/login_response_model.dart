import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/application/core/config/app_config.dart';

class LoginResponseModel extends Equatable {
  final String code;
  final String message;
  final String? data; // Just the token string

  const LoginResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] as String?, // Directly get the token string
    );
  }

  bool get isSuccess => code == AppConfig.successCode;

  @override
  List<Object?> get props => [code, message, data];
}
