import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';
import 'faculty_model.dart';
import 'department_model.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String matricNumber;
  final String role;
  final FacultyModel faculty;
  final DepartmentModel department;
  final String level;
  final String fingerprintHash;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? token;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.matricNumber,
    required this.role,
    required this.faculty,
    required this.department,
    required this.level,
    required this.fingerprintHash,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      matricNumber: json['matricNumber'] ?? '',
      role: json['role'] ?? '',
      faculty: FacultyModel.fromJson(json['faculty'] ?? {}),
      department: DepartmentModel.fromJson(json['department'] ?? {}),
      level: json['level'] ?? '',
      fingerprintHash: json['fingerprintHash'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'matricNumber': matricNumber,
      'role': role,
      'faculty': faculty.toJson(),
      'department': department.toJson(),
      'level': level,
      'fingerprintHash': fingerprintHash,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      matricNumber: matricNumber,
      role: role,
      faculty: faculty.toEntity(),
      department: department.toEntity(),
      level: level,
      fingerprintHash: fingerprintHash,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      token: token,
    );
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