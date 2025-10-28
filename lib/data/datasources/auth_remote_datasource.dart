import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/login_request_model.dart';
import 'package:smart_attendance_system/data/models/login_response_model.dart';
import 'package:smart_attendance_system/data/models/profile_response_model.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';

class RemoteDataSource {
  final DioClient dioClient;

  RemoteDataSource({required this.dioClient});

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dioClient.dio.post(
        AppConfig.loginEndpoint,
        data: request.toJson(),
      );

      // Directly parse as LoginResponseModel
      final loginResponse = LoginResponseModel.fromJson(response.data);

      if (loginResponse.isSuccess && loginResponse.data != null) {
        // Store the token in Dio client for future requests
        dioClient.setAuthToken(loginResponse.data!);
        return loginResponse;
      } else {
        throw ServerFailure(loginResponse.message);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Login failed: ${e.toString()}');
    }
  }

  Future<ProfileResponseModel> getProfile() async {
    try {
      final response = await dioClient.dio.get(
        AppConfig.profileEndpoint,
      );

      // Directly parse as ProfileResponseModel
      final profileResponse = ProfileResponseModel.fromJson(response.data);

      if (profileResponse.isSuccess && profileResponse.data != null) {
        return profileResponse;
      } else {
        throw ServerFailure(profileResponse.message);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Failed to fetch profile: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await dioClient.dio.post(AppConfig.logoutEndpoint);
    } finally {
      // Always clear the token on logout
      dioClient.clearAuthToken();
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