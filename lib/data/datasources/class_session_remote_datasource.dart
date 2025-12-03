import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/class_session_model.dart';
import 'package:smart_attendance_system/data/models/update_attendance_request_model.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class ClassSessionRemoteDataSource {
  Future<ClassSessionModel> getClassSession(String classId);
  Future<void> updateAttendanceStatus(UpdateAttendanceRequestModel request);
}

class ClassSessionRemoteDataSourceImpl implements ClassSessionRemoteDataSource {
  final DioClient dioClient;

  ClassSessionRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ClassSessionModel> getClassSession(String classId) async {
    try {
      final response = await dioClient.dio.get('/class/$classId');

      if (response.data['code'] == '00') {
        return ClassSessionModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch class session',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch class session: ${e.toString()}');
    }
  }

  @override
  Future<void> updateAttendanceStatus(
    UpdateAttendanceRequestModel request,
  ) async {
    try {
      final response = await dioClient.dio.post(
        '/attendance/attendance/status',
        data: request.toJson(),
      );

      if (response.data['code'] != '00') {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to update attendance',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to update attendance: ${e.toString()}');
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
