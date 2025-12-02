import 'package:equatable/equatable.dart';

class CarryoverStudentModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? level;
  final String? matricNumber;
  final CarryoverFaculty? faculty;
  final CarryoverDepartment? department;

  const CarryoverStudentModel({
    required this.id,
    required this.name,
    required this.email,
    this.level,
    this.matricNumber,
    this.faculty,
    this.department,
  });

  factory CarryoverStudentModel.fromJson(Map<String, dynamic> json) {
    return CarryoverStudentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      level: json['level']?.toString(),
      matricNumber: json['matricNumber']?.toString(),
      faculty:
          json['faculty'] != null && json['faculty'] is Map<String, dynamic>
          ? CarryoverFaculty.fromJson(json['faculty'])
          : null,
      department:
          json['department'] != null &&
              json['department'] is Map<String, dynamic>
          ? CarryoverDepartment.fromJson(json['department'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'level': level,
      'matricNumber': matricNumber,
      'faculty': faculty?.toJson(),
      'department': department?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    level,
    matricNumber,
    faculty,
    department,
  ];
}

class CarryoverFaculty extends Equatable {
  final String name;

  const CarryoverFaculty({required this.name});

  factory CarryoverFaculty.fromJson(Map<String, dynamic> json) {
    return CarryoverFaculty(name: json['name']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  List<Object?> get props => [name];
}

class CarryoverDepartment extends Equatable {
  final String name;

  const CarryoverDepartment({required this.name});

  factory CarryoverDepartment.fromJson(Map<String, dynamic> json) {
    return CarryoverDepartment(name: json['name']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  List<Object?> get props => [name];
}
