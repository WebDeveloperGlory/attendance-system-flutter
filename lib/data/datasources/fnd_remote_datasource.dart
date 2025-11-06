import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/department_model.dart';
import 'package:smart_attendance_system/data/models/faculty_model.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';

abstract class FndRemoteDataSource {
  Future<List<FacultyEntity>> getFaculties();
  Future<FacultyDetailEntity> getFaculty(String id);
  Future<List<DepartmentEntity>> getDepartments();
  Future<List<DepartmentEntity>> getDepartmentsByFaculty(String facultyId);
}

class FndRemoteDataSourceImpl implements FndRemoteDataSource {
  final DioClient dioClient;

  FndRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<FacultyEntity>> getFaculties() async {
    final response = await dioClient.dio.get(
      AppConfig.getFacultyEndpoint,
    );

    if (response.data['code'] == AppConfig.successCode) {
      return (response.data['data'] as List)
          .map((faculty) => FacultyModel.fromJson(faculty))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load faculties');
    }
  }

  @override
  Future<FacultyDetailEntity> getFaculty(String id) async {
    final response = await dioClient.dio.get(
      AppConfig.getSingleFacultyEndpoint(id),
    );

    if (response.data['code'] == AppConfig.successCode) {
      return FacultyDetailModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load faculty');
    }
  }

  @override
  Future<List<DepartmentEntity>> getDepartments() async {
    final response = await dioClient.dio.get(
      AppConfig.getDepartmentEndpoint,
    );

    if (response.data['code'] == AppConfig.successCode) {
      return (response.data['data'] as List)
          .map((department) => DepartmentModel.fromJson(department))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load departments');
    }
  }

  @override
  Future<List<DepartmentEntity>> getDepartmentsByFaculty(
    String facultyId,
  ) async {
    final response = await dioClient.dio.get(
      AppConfig.getDepartmentOfFacultyEndpoint(facultyId),
    );

    if (response.data['code'] == AppConfig.successCode) {
      return (response.data['data'] as List)
          .map((department) => DepartmentModel.fromJson(department))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load departments');
    }
  }
}
