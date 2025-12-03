import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';

class ClassAttendanceDetailModel extends ClassAttendanceDetailEntity {
  const ClassAttendanceDetailModel({
    required super.classSession,
    required super.attendance,
  });

  factory ClassAttendanceDetailModel.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceDetailModel(
      classSession: ClassSessionDetailModel.fromJson(json),
      attendance:
          (json['students'] as List<dynamic>?)
              ?.map((student) => StudentAttendanceModel.fromJson(student))
              .toList() ??
          const [],
    );
  }
}

class ClassSessionDetailModel extends ClassSessionDetailEntity {
  const ClassSessionDetailModel({
    required super.id,
    required super.topic,
    required super.date,
  });

  factory ClassSessionDetailModel.fromJson(Map<String, dynamic> json) {
    return ClassSessionDetailModel(
      id: json['_id']?.toString() ?? '',
      topic: json['topic']?.toString(),
      date: _parseDateTime(json['date']),
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

class StudentAttendanceModel extends StudentAttendanceEntity {
  const StudentAttendanceModel({
    required super.studentId,
    required super.name,
    required super.email,
    required super.matricNumber,
    required super.status,
    required super.verifiedByFingerprint,
    required super.timestamp,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      studentId: json['_id']?.toString() ?? json['studentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      matricNumber: json['matricNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? 'absent',
      verifiedByFingerprint: json['verifiedByFingerprint'] ?? false,
      timestamp: json['timestamp'] != null
          ? _parseDateTime(json['timestamp'])
          : null,
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
