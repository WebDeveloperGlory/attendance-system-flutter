import 'package:smart_attendance_system/data/models/student_model.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_course_details_entity.dart';

class LecturerCourseDetailsModel extends LecturerCourseDetailsEntity {
  const LecturerCourseDetailsModel({
    required super.id,
    required super.name,
    required super.code,
    required super.level,
    required super.department,
    required super.faculty,
    required super.lecturer,
    required super.schedule,
    required super.students,
    required super.isActive,
    required super.upcomingClasses,
    required super.recentAttendance,
    required super.averageAttendance,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LecturerCourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return LecturerCourseDetailsModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      department:
          json['department'] != null &&
              json['department'] is Map<String, dynamic>
          ? (json['department']['name']?.toString() ?? '')
          : '',
      faculty:
          json['faculty'] != null && json['faculty'] is Map<String, dynamic>
          ? (json['faculty']['name']?.toString() ?? '')
          : '',
      lecturer:
          json['lecturer'] != null && json['lecturer'] is Map<String, dynamic>
          ? Lecturer.fromJson(json['lecturer']) // Use the factory constructor
          : const Lecturer(id: '', name: '', email: ''),
      schedule:
          json['schedule'] != null && json['schedule'] is Map<String, dynamic>
          ? CourseScheduleModel.fromJson(json['schedule'])
          : const CourseScheduleModel(
              dayOfWeek: '',
              startTime: '',
              endTime: '',
            ),
      students:
          (json['students'] as List<dynamic>?)
              ?.map((student) => StudentModel.fromJson(student))
              .toList() ??
          const [],
      isActive: json['isActive'] ?? false,
      upcomingClasses:
          (json['upcomingClasses'] as List<dynamic>?)
              ?.map((classData) => UpcomingClassModel.fromJson(classData))
              .toList() ??
          const [],
      recentAttendance:
          (json['recentAttendance'] as List<dynamic>?)
              ?.map((attendance) => RecentAttendanceModel.fromJson(attendance))
              .toList() ??
          const [],
      averageAttendance:
          json['averageAttendance'] != null &&
              json['averageAttendance'] is Map<String, dynamic>
          ? AverageAttendanceModel.fromJson(json['averageAttendance'])
          : const AverageAttendanceModel(
              totalPresent: 0,
              totalAbsent: 0,
              totalRecords: 0,
              presentPercentage: 0,
            ),
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
}

class CourseScheduleModel extends CourseSchedule {
  const CourseScheduleModel({
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
  });

  factory CourseScheduleModel.fromJson(Map<String, dynamic> json) {
    return CourseScheduleModel(
      dayOfWeek: json['dayOfWeek']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
    );
  }
}

class UpcomingClassModel extends UpcomingClassEntity {
  const UpcomingClassModel({
    required super.id,
    required super.topic,
    required super.date,
    required super.startTime,
    required super.endTime,
  });

  factory UpcomingClassModel.fromJson(Map<String, dynamic> json) {
    return UpcomingClassModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      topic: json['topic']?.toString() ?? 'No Topic',
      date: _parseDateTime(json['date']),
      startTime: _parseDateTime(json['startTime']),
      endTime: _parseDateTime(json['endTime']),
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
}

class RecentAttendanceModel extends RecentAttendanceEntity {
  const RecentAttendanceModel({
    required super.topic,
    required super.date,
    required super.present,
    required super.absent,
    super.classId,
  });

  factory RecentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return RecentAttendanceModel(
      topic: json['topic']?.toString() ?? '',
      date: _parseDateTime(json['date']),
      present: (json['noPresent'] ?? 0).toInt(),
      absent: (json['noAbsent'] ?? 0).toInt(),
      classId: json['_id']?.toString(),
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
}

class AverageAttendanceModel extends AverageAttendanceEntity {
  const AverageAttendanceModel({
    required super.totalPresent,
    required super.totalAbsent,
    required super.totalRecords,
    required super.presentPercentage,
  });

  factory AverageAttendanceModel.fromJson(Map<String, dynamic> json) {
    final presentPercentage = json['presentPercentage'];
    double percentage = 0;

    if (presentPercentage is String) {
      percentage = double.tryParse(presentPercentage) ?? 0.0;
    } else if (presentPercentage is int) {
      percentage = presentPercentage.toDouble();
    } else if (presentPercentage is double) {
      percentage = presentPercentage;
    }

    return AverageAttendanceModel(
      totalPresent: (json['totalPresent'] ?? 0).toInt(),
      totalAbsent: (json['totalAbsent'] ?? 0).toInt(),
      totalRecords: (json['totalRecords'] ?? 0).toInt(),
      presentPercentage: percentage,
    );
  }
}
