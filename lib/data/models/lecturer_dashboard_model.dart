import 'package:smart_attendance_system/domain/entities/lecturer_dashboard_entity.dart';

class LecturerDashboardModel extends LecturerDashboardEntity {
  const LecturerDashboardModel({
    required super.totalCourses,
    required super.totalClasses,
    required super.courses,
    required super.upcomingClasses,
  });

  factory LecturerDashboardModel.fromJson(Map<String, dynamic> json) {
    final courses =
        (json['courses'] as List?)
            ?.map((course) => CourseModel.fromJson(course))
            .toList() ??
        [];

    final upcomingClasses =
        (json['upcomingClasses'] as List?)
            ?.map((classItem) => UpcomingClassModel.fromJson(classItem))
            .toList() ??
        [];

    final enrichedUpcomingClasses = upcomingClasses.map((upcoming) {
      final course = courses.firstWhere(
        (c) => c.id == upcoming.courseId,
        orElse: () => CourseModel(
          id: upcoming.courseId,
          name: 'Unknown Course',
          lecturerId: upcoming.lecturerId,
          code: 'N/A',
          facultyId: '',
          departmentId: '',
          level: '',
          students: [],
          isActive: true,
        ),
      );

      return UpcomingClassWithCourseEntity(
        upcomingClass: upcoming,
        course: course,
      );
    }).toList();

    return LecturerDashboardModel(
      totalCourses: json['totalCourses'] ?? 0,
      totalClasses: json['totalClasses'] ?? 0,
      courses: courses,
      upcomingClasses: enrichedUpcomingClasses,
    );
  }
}

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.lecturerId,
    required super.code,
    required super.facultyId,
    required super.departmentId,
    required super.level,
    required super.students,
    required super.isActive,
    super.schedule,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      lecturerId: json['lecturer'] ?? '',
      code: json['code'] ?? '',
      facultyId: json['faculty'] ?? '',
      departmentId: json['department'] ?? '',
      level: json['level'] ?? '',
      students: (json['students'] as List?)?.cast<String>() ?? [],
      isActive: json['isActive'] ?? false,
      schedule: json['schedule'] != null
          ? ClassScheduleModel.fromJson(json['schedule'])
          : null,
    );
  }
}

class UpcomingClassModel extends UpcomingClassEntity {
  const UpcomingClassModel({
    required super.id,
    required super.courseId,
    required super.lecturerId,
    required super.topic,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.attendanceRecords,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UpcomingClassModel.fromJson(Map<String, dynamic> json) {
    return UpcomingClassModel(
      id: json['_id'] ?? '',
      courseId: json['course'] ?? '',
      lecturerId: json['lecturer'] ?? '',
      topic: json['topic'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.now(),
      attendanceRecords:
          (json['attendanceRecords'] as List?)?.cast<String>() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class ClassScheduleModel extends ClassScheduleEntity {
  const ClassScheduleModel({super.startTime, super.endTime, super.dayOfWeek});

  factory ClassScheduleModel.fromJson(Map<String, dynamic> json) {
    return ClassScheduleModel(
      startTime: json['startTime'],
      endTime: json['endTime'],
      dayOfWeek: json['dayOfWeek'],
    );
  }
}
