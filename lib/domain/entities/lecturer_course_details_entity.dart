import 'package:equatable/equatable.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';

class LecturerCourseDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String level;
  final String department;
  final String faculty;
  final Lecturer lecturer;
  final CourseSchedule schedule;
  final List<StudentEntity> students;
  final bool isActive;
  final List<UpcomingClassEntity> upcomingClasses;
  final List<RecentAttendanceEntity> recentAttendance;
  final AverageAttendanceEntity averageAttendance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LecturerCourseDetailsEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.level,
    required this.department,
    required this.faculty,
    required this.lecturer,
    required this.schedule,
    required this.students,
    required this.isActive,
    required this.upcomingClasses,
    required this.recentAttendance,
    required this.averageAttendance,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    level,
    department,
    faculty,
    lecturer,
    schedule,
    students,
    isActive,
    upcomingClasses,
    recentAttendance,
    averageAttendance,
    createdAt,
    updatedAt,
  ];
}

class CourseSchedule extends Equatable {
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  const CourseSchedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime];
}

class UpcomingClassEntity extends Equatable {
  final String id;
  final String topic;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  const UpcomingClassEntity({
    required this.id,
    required this.topic,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final classDate = DateTime(date.year, date.month, date.day);

    if (classDate == today) return "Today";
    if (classDate == today.add(const Duration(days: 1))) return "Tomorrow";

    return "${_getWeekday(date.weekday)}, ${_getMonth(date.month)} ${date.day}";
  }

  String get formattedTime {
    final start = _formatTime(startTime);
    final end = _formatTime(endTime);
    return '$start - $end';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _getWeekday(int weekday) {
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  @override
  List<Object?> get props => [id, topic, date, startTime, endTime];
}

class RecentAttendanceEntity extends Equatable {
  final String topic;
  final DateTime date;
  final int present;
  final int absent;
  final String? classId;

  const RecentAttendanceEntity({
    required this.topic,
    required this.date,
    required this.present,
    required this.absent,
    this.classId,
  });

  double get attendanceRate {
    final total = present + absent;
    if (total == 0) return 0;
    return (present / total) * 100;
  }

  @override
  List<Object?> get props => [topic, date, present, absent, classId];
}

class AverageAttendanceEntity extends Equatable {
  final int totalPresent;
  final int totalAbsent;
  final int totalRecords;
  final double presentPercentage;

  const AverageAttendanceEntity({
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalRecords,
    required this.presentPercentage,
  });

  @override
  List<Object?> get props => [
    totalPresent,
    totalAbsent,
    totalRecords,
    presentPercentage,
  ];
}

class Lecturer extends Equatable {
  final String id;
  final String name;
  final String email;

  const Lecturer({required this.id, required this.name, required this.email});

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, email];
}
