import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/admin_dashboard_model.dart';
import 'package:smart_attendance_system/data/models/lecturer_create_response_model.dart';
import 'package:smart_attendance_system/data/models/student_create_response_model.dart';
import 'package:smart_attendance_system/domain/entities/admin_dashboard_entity.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_create_response_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_create_response_entity.dart';

abstract class AdminRemoteDataSource {
  Future<AdminDashboardEntity> getDashboardAnalytics();
  Future<LecturerCreateResponseEntity> registerLecturer({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
  });
  Future<StudentCreateResponseEntity> registerStudent({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
    required String level,
    required String matricNumber,
  });
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final DioClient dioClient;

  AdminRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AdminDashboardEntity> getDashboardAnalytics() async {
    final response = await dioClient.dio.get(
      '${AppConfig.baseUrl}${AppConfig.dashboardAnalyticsEndpoint}',
    );

    if (response.data['code'] == AppConfig.successCode) {
      return AdminDashboardModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message']);
    }
  }

  @override
  Future<LecturerCreateResponseEntity> registerLecturer({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
  }) async {
    final response = await dioClient.dio.post(
      '${AppConfig.baseUrl}${AppConfig.lecturerRegistrationEndpoint}',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'facultyId': facultyId,
        'departmentId': departmentId,
      },
    );

    if (response.data['code'] == AppConfig.successCode) {
      return LecturerCreateResponseModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message']);
    }
  }

  @override
  Future<StudentCreateResponseEntity> registerStudent({
    required String name,
    required String email,
    required String password,
    required String facultyId,
    required String departmentId,
    required String level,
    required String matricNumber,
  }) async {
    final response = await dioClient.dio.post(
      '${AppConfig.baseUrl}${AppConfig.studentRegistrationEndpoint}',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'facultyId': facultyId,
        'departmentId': departmentId,
        'level': level,
        'matricNumber': matricNumber,
      },
    );

    if (response.data['code'] == AppConfig.successCode) {
      return StudentCreateResponseModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message']);
    }
  }
}