import 'package:equatable/equatable.dart';

class StudentCreateResponseEntity extends Equatable {
  final String name;
  final String email;
  final String faculty;
  final String department;
  final String level;
  final String matricNumber;

  const StudentCreateResponseEntity({
    required this.name,
    required this.email,
    required this.faculty,
    required this.department,
    required this.level,
    required this.matricNumber,
  });

  @override
  List<Object?> get props => [name, email, faculty, department, level, matricNumber];
}