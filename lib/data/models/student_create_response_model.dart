import 'package:smart_attendance_system/domain/entities/student_create_response_entity.dart';

class StudentCreateResponseModel extends StudentCreateResponseEntity {
  const StudentCreateResponseModel({
    required super.name,
    required super.email,
    required super.faculty,
    required super.department,
    required super.level,
    required super.matricNumber,
  });

  factory StudentCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentCreateResponseModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      faculty: json['faculty'] ?? '',
      department: json['department'] ?? '',
      level: json['level'] ?? '',
      matricNumber: json['matricNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'facultyId': '', // You'll need to get these from somewhere
      'departmentId': '',
      'level': level,
      'matricNumber': matricNumber,
      'password': '', // You'll need to handle password separately
    };
  }
}
