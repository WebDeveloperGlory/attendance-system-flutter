import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/lecturer_model.dart';

abstract class LecturerRemoteDataSource {
  Future<List<LecturerModel>> getLecturers();
  Future<void> deleteLecturer(String id);
  Future<void> resetLecturerPassword({
    required String lecturerId,
    required String newPassword,
  });
  Future<void> createCourse({
    required String name,
    required String code,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    required String lecturerId,
    required String facultyId,
    required String departmentId,
    required String level,
  });
}

class LecturerRemoteDataSourceImpl implements LecturerRemoteDataSource {
  final DioClient dioClient;

  LecturerRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<LecturerModel>> getLecturers() async {
    final response = await dioClient.dio.get(AppConfig.getLecturersEndpoint);
    
    if (response.data['code'] == AppConfig.successCode) {
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => LecturerModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception(response.data['message']);
    }

  }

  @override
  Future<void> deleteLecturer(String id) async {
    await dioClient.dio.delete(AppConfig.deleteLecturerEndpoint(id));
  }

  @override
  Future<void> resetLecturerPassword({
    required String lecturerId,
    required String newPassword,
  }) async {
    await dioClient.dio.patch(
      AppConfig.lecturerPasswordResetEndpoint,
      data: {
        'lecturerId': lecturerId,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<void> createCourse({
    required String name,
    required String code,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    required String lecturerId,
    required String facultyId,
    required String departmentId,
    required String level,
  }) async {
    await dioClient.dio.post(
      AppConfig.createCourseEndpoint,
      data: {
        'name': name,
        'code': code,
        'dayOfWeek': dayOfWeek,
        'startTime': startTime,
        'endTime': endTime,
        'lecturerId': lecturerId,
        'facultyId': facultyId,
        'departmentId': departmentId,
        'level': level,
      },
    );
  }
}
