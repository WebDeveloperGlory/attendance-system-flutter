import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/student_detail_model.dart';
import 'package:smart_attendance_system/data/models/student_model.dart';
import 'package:smart_attendance_system/domain/entities/student_detail_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';

abstract class StudentRemoteDataSource {
  Future<List<StudentEntity>> getAllStudents();
  Future<List<StudentEntity>> searchStudents(String query);
  Future<StudentEntity> getStudentById(String studentId);
  Future<void> deleteStudent(String studentId);
  Future<StudentEntity> updateStudent(
    String studentId,
    Map<String, dynamic> updates,
  );
  Future<void> registerFingerprint(String studentId, String fingerprintHash);
  Future<StudentDetailEntity> getStudentDetail(String studentId);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final DioClient dioClient;

  StudentRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<StudentEntity>> getAllStudents() async {
    try {
      final response = await dioClient.dio.get(
        AppConfig.getAllStudentsEndpoint,
      );

      if (response.data['code'] == AppConfig.successCode) {
        return (response.data['data'] as List)
            .map((student) => StudentModel.fromJson(student))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load students');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Failed to load students',
      );
    }
  }

  @override
  Future<List<StudentEntity>> searchStudents(String query) async {
    try {
      final response = await dioClient.dio.get(
        AppConfig.searchStudentsEndpoint(query),
      );

      if (response.data['code'] == AppConfig.successCode) {
        return (response.data['data'] as List)
            .map((student) => StudentModel.fromJson(student))
            .toList();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to search students',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to search students',
      );
    }
  }

  @override
  Future<StudentEntity> getStudentById(String studentId) async {
    try {
      final response = await dioClient.dio.get(
        AppConfig.getStudentEndpoint(studentId),
      );

      if (response.data['code'] == AppConfig.successCode) {
        return StudentModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load student details',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to load student details',
      );
    }
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    try {
      final response = await dioClient.dio.delete(
        AppConfig.deleteStudentEndpoint(studentId),
      );

      if (response.data['code'] != AppConfig.successCode) {
        throw Exception(response.data['message'] ?? 'Failed to delete student');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Failed to delete student',
      );
    }
  }

  @override
  Future<StudentEntity> updateStudent(
    String studentId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await dioClient.dio.put(
        AppConfig.editStudentEndpoint(studentId),
        data: updates,
      );

      if (response.data['code'] == AppConfig.successCode) {
        return StudentModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update student');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Failed to update student',
      );
    }
  }

  @override
  Future<void> registerFingerprint(
    String studentId,
    String fingerprintHash,
  ) async {
    try {
      final response = await dioClient.dio.post(
        AppConfig.fingerprintRegistrationEndpoint,
        data: {'studentId': studentId, 'fingerprintHash': fingerprintHash},
      );

      if (response.data['code'] != AppConfig.successCode) {
        throw Exception(
          response.data['message'] ?? 'Failed to register fingerprint',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to register fingerprint',
      );
    }
  }

  // Add this implementation to your StudentRemoteDataSourceImpl
  @override
  Future<StudentDetailEntity> getStudentDetail(String studentId) async {
    try {
      final response = await dioClient.dio.get(
        AppConfig.getStudentEndpoint(studentId),
      );

      if (response.data['code'] == AppConfig.successCode) {
        return StudentDetailModel.fromJson(response.data['data']);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load student details',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to load student details',
      );
    }
  }
}
