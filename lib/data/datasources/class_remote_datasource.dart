import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/create_class_request_model.dart';
import 'package:smart_attendance_system/data/models/create_class_response_model.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

abstract class ClassRemoteDataSource {
  Future<CreateClassResponseModel> createClassSession(
    CreateClassRequestModel request,
  );
}

class ClassRemoteDataSourceImpl implements ClassRemoteDataSource {
  final DioClient dioClient;

  ClassRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CreateClassResponseModel> createClassSession(
    CreateClassRequestModel request,
  ) async {
    try {
      final response = await dioClient.dio.post(
        '/class',
        data: request.toJson(),
      );

      return CreateClassResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to create class: ${e.toString()}');
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
