import 'package:smart_attendance_system/domain/entities/lecturer_create_response_entity.dart';

class LecturerCreateResponseModel extends LecturerCreateResponseEntity {
  const LecturerCreateResponseModel({
    required super.name,
    required super.email,
    required super.faculty,
    required super.department,
  });

  factory LecturerCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return LecturerCreateResponseModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      faculty: json['faculty'] ?? '',
      department: json['department'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'facultyId': '', // You'll need to get these from somewhere
      'departmentId': '',
      'password': '', // You'll need to handle password separately
    };
  }
}
