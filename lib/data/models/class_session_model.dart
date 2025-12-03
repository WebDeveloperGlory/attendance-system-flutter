import 'package:smart_attendance_system/domain/entities/class_session_entity.dart';

class ClassSessionModel extends ClassSessionEntity {
  const ClassSessionModel({
    required super.id,
    required super.courseId,
    required super.lecturer,
    super.topic,
    required super.date,
    super.startTime,
    super.endTime,
    super.venue,
    required super.stats,
    required super.attendanceRecords,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClassSessionModel.fromJson(Map<String, dynamic> json) {
    return ClassSessionModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      courseId: json['course']?.toString() ?? '',
      lecturer:
          json['lecturer'] != null && json['lecturer'] is Map<String, dynamic>
          ? LecturerModel.fromJson(json['lecturer'])
          : const Lecturer(name: '', email: ''),
      topic: json['topic']?.toString(),
      date: _parseDateTime(json['date']),
      startTime: json['startTime'] != null
          ? _parseDateTime(json['startTime'])
          : null,
      endTime: json['endTime'] != null ? _parseDateTime(json['endTime']) : null,
      venue: json['venue']?.toString(),
      stats: json['stats'] != null && json['stats'] is Map<String, dynamic>
          ? ClassStatsModel.fromJson(json['stats'])
          : const ClassStatsModel(
              totalStudents: 0,
              present: 0,
              absent: 0,
              attendanceRate: 0,
            ),
      attendanceRecords:
          (json['attendanceRecords'] as List<dynamic>?)
              ?.map((record) => AttendanceRecordModel.fromJson(record))
              .toList() ??
          const [],
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

class LecturerModel extends Lecturer {
  const LecturerModel({required super.name, required super.email});

  factory LecturerModel.fromJson(Map<String, dynamic> json) {
    return LecturerModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class ClassStatsModel extends ClassStats {
  const ClassStatsModel({
    required super.totalStudents,
    required super.present,
    required super.absent,
    required super.attendanceRate,
  });

  factory ClassStatsModel.fromJson(Map<String, dynamic> json) {
    return ClassStatsModel(
      totalStudents: (json['totalStudents'] ?? 0).toInt(),
      present: (json['present'] ?? 0).toInt(),
      absent: (json['absent'] ?? 0).toInt(),
      attendanceRate: (json['attendanceRate'] ?? 0).toDouble(),
    );
  }
}

class AttendanceRecordModel extends AttendanceRecord {
  const AttendanceRecordModel({
    required super.id,
    required super.student,
    required super.status,
    super.timestamp,
    required super.verifiedByFingerprint,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      student:
          json['student'] != null && json['student'] is Map<String, dynamic>
          ? StudentModel.fromJson(json['student'])
          : const StudentModel(name: '', email: '', matricNumber: ''),
      status: json['status']?.toString() ?? 'absent',
      timestamp: json['timestamp'] != null
          ? _parseDateTime(json['timestamp'])
          : null,
      verifiedByFingerprint: json['verifiedByFingerprint'] ?? false,
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

class StudentModel extends Student {
  const StudentModel({
    required super.name,
    required super.email,
    required super.matricNumber,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      matricNumber: json['matricNumber']?.toString() ?? '',
    );
  }
}
