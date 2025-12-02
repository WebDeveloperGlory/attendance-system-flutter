import 'package:equatable/equatable.dart';

// Update LecturerDashboardEntity
class LecturerDashboardEntity extends Equatable {
  final int totalCourses;
  final int totalClasses;
  final List<CourseEntity> courses;
  final List<UpcomingClassWithCourseEntity> upcomingClasses;

  const LecturerDashboardEntity({
    required this.totalCourses,
    required this.totalClasses,
    required this.courses,
    required this.upcomingClasses,
  });

  @override
  List<Object?> get props => [
    totalCourses,
    totalClasses,
    courses,
    upcomingClasses,
  ];
}

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String lecturerId;
  final String code;
  final String facultyId;
  final String departmentId;
  final String level;
  final List<String> students;
  final bool isActive;
  final ClassScheduleEntity? schedule;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.lecturerId,
    required this.code,
    required this.facultyId,
    required this.departmentId,
    required this.level,
    required this.students,
    required this.isActive,
    this.schedule,
  });

  int get studentCount => students.length;

  @override
  List<Object?> get props => [
    id,
    name,
    lecturerId,
    code,
    facultyId,
    departmentId,
    level,
    students,
    isActive,
    schedule,
  ];
}

// Update lib/domain/entities/lecturer_dashboard_entity.dart
class UpcomingClassEntity extends Equatable {
  final String id;
  final String courseId;
  final String lecturerId;
  final String topic;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> attendanceRecords;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UpcomingClassEntity({
    required this.id,
    required this.courseId,
    required this.lecturerId,
    required this.topic,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.attendanceRecords,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final classDate = DateTime(date.year, date.month, date.day);

    if (classDate == today) {
      return 'Today';
    } else if (classDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${_getWeekday(date.weekday)} ${date.day}/${date.month}';
    }
  }

  String get formattedTime {
    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  List<Object?> get props => [
    id,
    courseId,
    lecturerId,
    topic,
    date,
    startTime,
    endTime,
    attendanceRecords,
    createdAt,
    updatedAt,
  ];
}

class ClassScheduleEntity extends Equatable {
  final String? startTime;
  final String? endTime;
  final String? dayOfWeek;

  const ClassScheduleEntity({this.startTime, this.endTime, this.dayOfWeek});

  @override
  List<Object?> get props => [startTime, endTime, dayOfWeek];
}

class UpcomingClassWithCourseEntity extends Equatable {
  final UpcomingClassEntity upcomingClass;
  final CourseEntity course;

  const UpcomingClassWithCourseEntity({
    required this.upcomingClass,
    required this.course,
  });

  String get formattedDate => upcomingClass.formattedDate;
  String get formattedTime => upcomingClass.formattedTime;
  String get topic => upcomingClass.topic;
  int get studentCount => course.studentCount;
  String get courseName => course.name;
  String get courseCode => course.code;
  String get level => course.level;

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final classDate = DateTime(
      upcomingClass.date.year,
      upcomingClass.date.month,
      upcomingClass.date.day,
    );
    return classDate == today;
  }

  @override
  List<Object?> get props => [upcomingClass, course];
}
