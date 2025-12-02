import 'package:smart_attendance_system/domain/entities/course_entity.dart';
import 'faculty_model.dart';
import 'department_model.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.code,
    required super.schedule,
    required super.lecturer,
    required super.faculty,
    required super.department,
    required super.level,
    required super.students,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final scheduleData = json['schedule'];

    return CourseModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      schedule: scheduleData != null && scheduleData is Map<String, dynamic>
          ? Schedule(
              dayOfWeek: scheduleData['dayOfWeek']?.toString() ?? '',
              startTime: scheduleData['startTime']?.toString() ?? '',
              endTime: scheduleData['endTime']?.toString() ?? '',
            )
          : const Schedule(dayOfWeek: '', startTime: '', endTime: ''),
      lecturer: json['lecturer']?.toString() ?? '',
      faculty:
          json['faculty'] != null && json['faculty'] is Map<String, dynamic>
          ? FacultyModel.fromJson(json['faculty'])
          : FacultyModel(
              id: '',
              name: '',
              code: '',
              description: '',
              departments: const [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      department:
          json['department'] != null &&
              json['department'] is Map<String, dynamic>
          ? DepartmentModel.fromJson(json['department'])
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
      students:
          (json['students'] as List<dynamic>?)
              ?.map((student) => student.toString())
              .toList() ??
          const [],
      isActive: json['isActive'] ?? false,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
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
      '_id': id,
      'name': name,
      'code': code,
      'schedule': {
        'dayOfWeek': schedule.dayOfWeek,
        'startTime': schedule.startTime,
        'endTime': schedule.endTime,
      },
      'lecturer': lecturer,
      'faculty': (faculty as FacultyModel).toJson(),
      'department': (department as DepartmentModel).toJson(),
      'level': level,
      'students': students,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
