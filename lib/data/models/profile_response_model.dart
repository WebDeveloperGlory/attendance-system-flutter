import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';
import 'user_model.dart';

class ProfileResponseModel extends Equatable {
  final String code;
  final String message;
  final UserModel? data;

  const ProfileResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
    );
  }

  bool get isSuccess => code == AppConfig.successCode;

  UserEntity toEntity() {
    return data!.toEntity();
  }

  @override
  List<Object?> get props => [code, message, data];
}
