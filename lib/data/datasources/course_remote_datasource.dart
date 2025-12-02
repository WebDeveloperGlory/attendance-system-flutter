import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/course_model.dart';
import 'package:smart_attendance_system/data/models/carryover_student_model.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getLecturerCourses();
  Future<List<CarryoverStudentModel>> getPotentialCarryoverStudents({
    required String departmentId,
    required String currentLevel,
  });
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final DioClient dioClient;

  CourseRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CourseModel>> getLecturerCourses() async {
    try {
      final response = await dioClient.dio.get('/lecturer/course');

      if (response.data['code'] == '00') {
        final List<dynamic> coursesData = response.data['data'];
        final courses = coursesData.map((course) {
          return CourseModel.fromJson(course);
        }).toList();

        return courses;
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch courses',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch courses: ${e.toString()}');
    }
  }

  @override
  Future<List<CarryoverStudentModel>> getPotentialCarryoverStudents({
    required String departmentId,
    required String currentLevel,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/course/potential-carryover',
        queryParameters: {
          'departmentId': departmentId,
          'currentLevel': currentLevel,
        },
      );

      if (response.data['code'] == '00') {
        final List<dynamic> studentsData = response.data['data'];
        final students = studentsData.map((student) {
          return CarryoverStudentModel.fromJson(student);
        }).toList();

        return students;
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch carryover students',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(
        'Failed to fetch carryover students: ${e.toString()}',
      );
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
