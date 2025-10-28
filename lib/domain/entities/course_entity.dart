import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';

class CourseEntity extends Equatable{
  final String id;
  final String name;
  final String code;
  final Schedule schedule;
  final String lecturer;
  final FacultyEntity faculty;
  final DepartmentEntity department;
  final String level;
  final List<String> students;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.schedule,
    required this.lecturer,
    required this.faculty,
    required this.department,
    required this.level,
    required this.students,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, code, schedule, lecturer, faculty, department, level, students, isActive];
}

class Schedule {
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  const Schedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}