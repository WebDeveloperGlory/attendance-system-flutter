import 'package:smart_attendance_system/domain/entities/user_entity.dart';
import 'faculty_model.dart';
import 'department_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.matricNumber,
    required super.role,
    required super.faculty,
    required super.department,
    required super.level,
    required super.fingerprintHash,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final facultyData = json['faculty'];
    final departmentData = json['department'];

    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      matricNumber: json['matricNumber']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      faculty: facultyData != null && facultyData is Map<String, dynamic>
          ? FacultyModel.fromJson(facultyData)
          : FacultyModel(
              id: '',
              name: '',
              code: '',
              description: '',
              departments: const [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      department: departmentData != null && departmentData is Map<String, dynamic>
          ? DepartmentModel.fromJson(departmentData)
          : DepartmentModel(
              id: '',
              name: '',
              code: '',
              description: '',
              facultyId: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      level: json['level']?.toString() ?? '',
      fingerprintHash: json['fingerprintHash']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      token: json['token']?.toString(),
    );
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'matricNumber': matricNumber,
      'role': role,
      'faculty': (faculty as FacultyModel).toJson(),
      'department': (department as DepartmentModel).toJson(),
      'level': level,
      'fingerprintHash': fingerprintHash,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'token': token,
    };
  }

  UserModel copyWithToken(String newToken) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      matricNumber: matricNumber,
      role: role,
      faculty: faculty,
      department: department,
      level: level,
      fingerprintHash: fingerprintHash,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      token: newToken,
    );
  }

  @override
  List<Object?> get props => [
    id, name, email, matricNumber, role, faculty, department,
    level, fingerprintHash, isActive, createdAt, updatedAt, token
  ];
}