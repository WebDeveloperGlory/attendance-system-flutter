import 'package:dio/dio.dart';
import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/services/local_storage_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal() {
    _dio = Dio(_baseOptions);
    _initializeAuthToken();
    _addInterceptors();
  }

  late final Dio _dio;
  String? _authToken;

  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
    receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
    headers: AppConfig.defaultHeaders,
  );

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // You can add global error handling here
          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in development
    if (AppConfig.enableDioLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
          requestHeader: true,
        ),
      );
    }
  }

  void _initializeAuthToken() async {
    try {
      final token = await LocalStorageService.getAuthToken();
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
        print('Auth token initialized from storage');
      }
    } catch (e) {
      print('Error initializing auth token: $e');
    }
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }
}
