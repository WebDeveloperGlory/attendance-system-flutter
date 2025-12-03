import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/lecturer_course_details_model.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class LecturerCourseDetailsRemoteDataSource {
  Future<LecturerCourseDetailsModel> getCourseDetails(String courseId);
}

class LecturerCourseDetailsRemoteDataSourceImpl
    implements LecturerCourseDetailsRemoteDataSource {
  final DioClient dioClient;

  LecturerCourseDetailsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LecturerCourseDetailsModel> getCourseDetails(String courseId) async {
    try {
      final response = await dioClient.dio.get('/course/$courseId');

      if (response.data['code'] == '00') {
        return LecturerCourseDetailsModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch course details',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch course details: ${e.toString()}');
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
          return ServerFailure('Course not found.');
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
