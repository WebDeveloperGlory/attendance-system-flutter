class AppConfig {
  // Base URL //
  static const String baseUrl = 'http://localhost:5000/api/v1'; // LOCAL
  // static const String baseUrl = 'https://attendance-system-g8qd.onrender.com/api/v1'; // PROD
  static const String authEndpoint = '/auth';
  static const String adminEndpoint = '/admin';
  static const String fndEndpoint = '/fnd';
  // End of Base URL //

  // Auth Endpoints //
  static const String loginEndpoint = '$authEndpoint/login/general';
  static const String profileEndpoint = '$authEndpoint/me';
  static const String logoutEndpoint = '$authEndpoint/logout';
  // End of Auth Endpoints //

  // Admin Endpoints //
  static const String dashboardAnalyticsEndpoint = '$adminEndpoint/dashboard';
  static const String lecturerRegistrationEndpoint = '$adminEndpoint/register/lecturer';
  static const String studentRegistrationEndpoint = '$adminEndpoint/register/student';
  static const String fingerprintRegistrationEndpoint = '$adminEndpoint/register/student/fingerprint';
  // End of Admin Endpoints //
  
  // Faculty and Department Endpoints //
  static const String getFacultyEndpoint = '$fndEndpoint/faculty';
  static String getSingleFacultyEndpoint(String id) => '$fndEndpoint/faculty/$id';
  static const String createFacultyEndpoint = '$fndEndpoint/register/faculty';
  static String editFacultyEndpoint(String id) => '$fndEndpoint/edit/faculty/$id';
  static String deleteFacultyEndpoint(String id) => '$fndEndpoint/delete/faculty/$id';

  static const String getDepartmentEndpoint = '$fndEndpoint/department';
  static String getDepartmentOfFacultyEndpoint(String id) => '$fndEndpoint/department?facultyId=$id';
  static const String createDepartmentEndpoint = '$fndEndpoint/register/department';
  static String editDepartmentEndpoint(String id) => '$fndEndpoint/edit/department/$id';
  static String deleteDepartmentEndpoint(String id) => '$fndEndpoint/delete/department/$id';
  // End of Faculty and Department Endpoints //

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
