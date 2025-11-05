import 'package:equatable/equatable.dart';

class LecturerCreateResponseEntity extends Equatable {
  final String name;
  final String email;
  final String faculty;
  final String department;

  const LecturerCreateResponseEntity({
    required this.name,
    required this.email,
    required this.faculty,
    required this.department,
  });

  @override
  List<Object?> get props => [name, email, faculty, department];
}