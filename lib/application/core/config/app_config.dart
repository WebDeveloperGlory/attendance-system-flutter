class AppConfig {
  // Base URL //
  static const String baseUrl = 'http://localhost:5000/api/v1';
  static const String authEndpoint = '/auth';
  // End of Base URL //

  // Auth Endpoints //
  static const String loginEndpoint = '$authEndpoint/login/general';
  static const String profileEndpoint = '$authEndpoint/me';
  static const String logoutEndpoint = '$authEndpoint/logout';
  // End of Auth Endpoints //

  // Network Settings //
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  // End of Network Settings //

  // Server Response Codes //
  static const String successCode = '00';
  static const String errorCode = '99';
  // End of Server Response Codes //

  // Dio Settings //
  static const bool enableDioLogging = true;  
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  // End of Dio Settings //
}
