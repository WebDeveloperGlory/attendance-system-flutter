import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/attendance_summary_model.dart';
import 'package:smart_attendance_system/data/models/class_attendance_model.dart';
import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceSummaryEntity> getAttendanceRecordsSummary();
  Future<ClassAttendanceDetailEntity> getClassAttendance(String classId);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient dioClient;

  AttendanceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AttendanceSummaryModel> getAttendanceRecordsSummary() async {
    try {
      final response = await dioClient.dio.get('/lecturer/attendance/records');

      if (response.data['code'] == '00') {
        return AttendanceSummaryModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch attendance records',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(
        'Failed to fetch attendance records: ${e.toString()}',
      );
    }
  }

  @override
  Future<ClassAttendanceDetailModel> getClassAttendance(String classId) async {
    try {
      final response = await dioClient.dio.get(
        '/attendance/class/attendance',
        queryParameters: {'classId': classId},
      );

      if (response.data['code'] == '00') {
        return ClassAttendanceDetailModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch class attendance',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch class attendance: ${e.toString()}');
    }
  }

  ServerFailure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Request timeout. Please try again.');

      case DioExceptionType.connectionError:
        return ServerFailure('No internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        String errorMessage = 'Request failed with status $statusCode';

        if (data != null && data is Map<String, dynamic>) {
          errorMessage = data['message'] ?? errorMessage;
        }

        if (statusCode == 401) {
          return ServerFailure('Authentication failed.');
        } else if (statusCode == 403) {
          return ServerFailure('Access denied.');
        } else if (statusCode == 404) {
          return ServerFailure('Resource not found.');
        } else if (statusCode == 500) {
          return ServerFailure('Server error. Please try again later.');
        } else {
          return ServerFailure(errorMessage, statusCode: statusCode ?? 400);
        }

      case DioExceptionType.cancel:
        return ServerFailure('Request cancelled.');

      case DioExceptionType.unknown:
      default:
        return ServerFailure('An unexpected error occurred.');
    }
  }
}
