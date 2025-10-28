import 'package:equatable/equatable.dart';

class FacultyEntity extends Equatable{
  final String id;
  final String name;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FacultyEntity({
    required this.id,
    required this.name,
    required this.code,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, code, createdAt, updatedAt];
}