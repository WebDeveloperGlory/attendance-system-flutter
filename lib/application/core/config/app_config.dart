class AppConfig {
  // Base URL //
  // static const String baseUrl = 'http://localhost:5000/api/v1'; // LOCAL
  static const String baseUrl = 'https://attendance-system-g8qd.onrender.com/api/v1'; // PROD
  static const String authEndpoint = '/auth';
  static const String adminEndpoint = '/admin';
  static const String fndEndpoint = '/fnd';
  static const String courseEndpoint = '/course';
  static const String lecturerEndpoint = '/lecturer';
  static const String classEndpoint = '/class';
  static const String attendanceEndpoint = '/attendance';
  static const String studentEndpoint = '/student';
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
  static const String lecturerPasswordResetEndpoint = '$adminEndpoint/password/reset/lecturer';
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
  
  // Course Endpoints //
  static const String createCourseEndpoint = courseEndpoint;
  static String getCourseDetailsEndpoint(String id) => '$courseEndpoint/$id';
  static String registerStudentsToCourseEndpoint(String id) => '$courseEndpoint/$id/register/students';
  static String getPotentialCarryoverEndpoint(String id, String level) => '$courseEndpoint/potential-carryover?departmentId=$id&currentLevel=$level';
  // End of Course Endpoints //
  
  // Lecturer Endpoints //
  static const String getLecturersEndpoint = lecturerEndpoint;
  static const String getLecturerDashboardEndpoint = '$lecturerEndpoint/dashboard';
  static const String getLecturerCourseEndpoint = '$lecturerEndpoint/course';
  static const String getAttendanceRecordsSummaryEndpoint = '$lecturerEndpoint/attendance/records';
  static String deleteLecturerEndpoint(String id) => '$lecturerEndpoint/$id';
  // End of Lecturer Endpoints //

  // Class Endpoints //
  static const String createClassEndpoint = classEndpoint;
  static String getClassEndpoint(String id) => '$classEndpoint/$id';
  static String editClassEndpoint(String id) => '$classEndpoint/$id';
  static String deleteClassEndpoint(String id) => '$classEndpoint/$id';
  static String addStudentToClassEndpoint(String id) => '$classEndpoint/$id/student/add';
  // End of Class Endpoints //

  // Attendance Endpoints //
  static const String getClassAttendanceEndpoint = '$attendanceEndpoint/class/attendance';
  static const String updateAttendanceStatusEndpoint = '$attendanceEndpoint/attendance/status';
  static const String getAttendanceRecordsForAllStudentsEndpoint = '$attendanceEndpoint/course/attendance/all';
  static const String getStudentCourseAttendanceEndpoint = '$attendanceEndpoint/course/attendance/student';
  // End of Attendance Endpoints //

  // Student Endpoints //
  static const String getAllStudentsEndpoint = studentEndpoint;
  static String searchStudentsEndpoint(String query) => '$studentEndpoint/search?query=$query';
  static String getStudentEndpoint(String id) => '$studentEndpoint/$id';
  static String editStudentEndpoint(String id) => '$studentEndpoint/$id';
  static String deleteStudentEndpoint(String id) => '$studentEndpoint/$id';
  // End of Student Endpoints //

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
