import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/department_model.dart';
import 'package:smart_attendance_system/data/models/faculty_model.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';

abstract class FndRemoteDataSource {
  Future<List<FacultyEntity>> getFaculties();
  Future<FacultyDetailEntity> getFaculty(String id);
  Future<FacultyEntity> createFaculty(Map<String, dynamic> facultyData);
  Future<FacultyEntity> updateFaculty(String id, Map<String, dynamic> facultyData);
  Future<void> deleteFaculty(String id);
  
  Future<List<DepartmentEntity>> getDepartments();
  Future<List<DepartmentEntity>> getDepartmentsByFaculty(String facultyId);
  Future<DepartmentEntity> createDepartment(Map<String, dynamic> departmentData);
  Future<DepartmentEntity> updateDepartment(String id, Map<String, dynamic> departmentData);
  Future<void> deleteDepartment(String id);
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
  Future<FacultyEntity> createFaculty(Map<String, dynamic> facultyData) async {
    final response = await dioClient.dio.post(
      AppConfig.createFacultyEndpoint,
      data: facultyData,
    );

    if (response.data['code'] == AppConfig.successCode) {
      return FacultyModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to create faculty');
    }
  }

  @override
  Future<FacultyEntity> updateFaculty(String id, Map<String, dynamic> facultyData) async {
    final response = await dioClient.dio.put(
      AppConfig.editFacultyEndpoint(id),
      data: facultyData,
    );

    if (response.data['code'] == AppConfig.successCode) {
      return FacultyModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to update faculty');
    }
  }

  @override
  Future<void> deleteFaculty(String id) async {
    final response = await dioClient.dio.delete(
      AppConfig.deleteFacultyEndpoint(id),
    );

    if (response.data['code'] != AppConfig.successCode) {
      throw Exception(response.data['message'] ?? 'Failed to delete faculty');
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
  Future<List<DepartmentEntity>> getDepartmentsByFaculty(String facultyId) async {
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

  @override
  Future<DepartmentEntity> createDepartment(Map<String, dynamic> departmentData) async {
    final response = await dioClient.dio.post(
      AppConfig.createDepartmentEndpoint,
      data: departmentData,
    );

    if (response.data['code'] == AppConfig.successCode) {
      return DepartmentModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to create department');
    }
  }

  @override
  Future<DepartmentEntity> updateDepartment(String id, Map<String, dynamic> departmentData) async {
    final response = await dioClient.dio.put(
      AppConfig.editDepartmentEndpoint(id),
      data: departmentData,
    );

    if (response.data['code'] == AppConfig.successCode) {
      return DepartmentModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to update department');
    }
  }

  @override
  Future<void> deleteDepartment(String id) async {
    final response = await dioClient.dio.delete(
      AppConfig.deleteDepartmentEndpoint(id),
    );

    if (response.data['code'] != AppConfig.successCode) {
      throw Exception(response.data['message'] ?? 'Failed to delete department');
    }
  }
}