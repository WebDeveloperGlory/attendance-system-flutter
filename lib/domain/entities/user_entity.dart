import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String matricNumber;
  final String role;
  final FacultyEntity faculty;
  final DepartmentEntity department;
  final String level;
  final String fingerprintHash;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? token;

  const UserEntity({
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

  @override
  List<Object?> get props => [id, name, email, matricNumber, role, faculty, department, level, fingerprintHash, isActive, createdAt, updatedAt, token];
}
