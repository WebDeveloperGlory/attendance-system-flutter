import 'package:equatable/equatable.dart';

class DepartmentEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String description;
  final String facultyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.facultyId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, code, description, facultyId, createdAt, updatedAt];
}