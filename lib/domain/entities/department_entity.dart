import 'package:equatable/equatable.dart';

class DepartmentEntity extends Equatable{
  final String id;
  final String name;
  final String code;
  final String faculty;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.faculty,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, code, faculty, createdAt, updatedAt];
}