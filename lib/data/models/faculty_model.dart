import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';

class FacultyModel extends FacultyEntity {
  const FacultyModel({
    required super.id,
    required super.name,
    required super.code,
    required super.description,
    required super.departments,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    return FacultyModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      departments: List<String>.from(json['departments'] ?? []),
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
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'departments': departments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FacultyDetailModel extends FacultyDetailEntity {
  const FacultyDetailModel({
    required super.id,
    required super.name,
    required super.code,
    required super.description,
    required super.totalStudents,
    required super.activeDepartments,
    required super.departments,
  });

  factory FacultyDetailModel.fromJson(Map<String, dynamic> json) {
    return FacultyDetailModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      activeDepartments: json['activeDepartments'] ?? 0,
      departments: (json['departments'] as List? ?? [])
          .map((dept) => DepartmentSummaryModel.fromJson(dept))
          .toList(),
    );
  }
}

class DepartmentSummaryModel extends DepartmentSummaryEntity {
  const DepartmentSummaryModel({
    required super.id,
    required super.name,
    required super.code,
    required super.description,
    required super.students,
    required super.courses,
  });

  factory DepartmentSummaryModel.fromJson(Map<String, dynamic> json) {
    return DepartmentSummaryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      students: json['students'] ?? 0,
      courses: json['courses'] ?? 0,
    );
  }
}
