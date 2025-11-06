import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';
import 'package:smart_attendance_system/data/models/user_model.dart';
import 'package:smart_attendance_system/data/models/faculty_model.dart';
import 'package:smart_attendance_system/data/models/department_model.dart';

class LocalStorageService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _authTokenKey = 'auth_token';

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Save user data
  static Future<void> saveUser(UserEntity user) async {
    try {
      final prefs = await _instance;
      
      // Convert to model for consistent serialization
      final userModel = user is UserModel 
          ? user 
          : UserModel(
              id: user.id,
              name: user.name,
              email: user.email,
              matricNumber: user.matricNumber,
              role: user.role,
              faculty: FacultyModel(
                id: user.faculty.id,
                name: user.faculty.name,
                code: user.faculty.code,
                description: user.faculty.description,
                departments: user.faculty.departments,
                createdAt: user.faculty.createdAt,
                updatedAt: user.faculty.updatedAt,
              ),
              department: DepartmentModel(
                id: user.department.id,
                name: user.department.name,
                code: user.department.code,
                description: user.department.description,
                facultyId: user.department.facultyId,
                createdAt: user.department.createdAt,
                updatedAt: user.department.updatedAt,
              ),
              level: user.level,
              fingerprintHash: user.fingerprintHash,
              isActive: user.isActive,
              createdAt: user.createdAt,
              updatedAt: user.updatedAt,
              token: user.token,
            );

      final userJson = userModel.toJson();
      
      await prefs.setString(_userKey, jsonEncode(userJson));
      await prefs.setBool(_isLoggedInKey, true);
      
      // Save token separately for easy access
      if (user.token != null) {
        await prefs.setString(_authTokenKey, user.token!);
      }
      
      print('✅ User data saved successfully');
    } catch (e) {
      print('❌ Error saving user data: $e');
      rethrow;
    }
  }

  // Get current user
  static Future<UserEntity?> getUser() async {
    try {
      final prefs = await _instance;
      final userJsonString = prefs.getString(_userKey);
      
      if (userJsonString == null) {
        print('📭 No user data found in storage');
        return null;
      }
      
      final userJson = jsonDecode(userJsonString) as Map<String, dynamic>;
      
      print('📖 Retrieved user data from storage');
      return UserModel.fromJson(userJson);
    } catch (e) {
      print('❌ Error parsing user data: $e');
      // Clear corrupted data
      await clearUserData();
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await _instance;
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      final hasUserData = prefs.containsKey(_userKey);
      final hasToken = prefs.containsKey(_authTokenKey);
      
      print('🔐 Login check - isLoggedIn: $isLoggedIn, hasUserData: $hasUserData, hasToken: $hasToken');
      
      return isLoggedIn && hasUserData && hasToken;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Get auth token
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await _instance;
      final token = prefs.getString(_authTokenKey);
      print('🔑 Token retrieval - exists: ${token != null}');
      return token;
    } catch (e) {
      print('❌ Error getting auth token: $e');
      return null;
    }
  }

  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    try {
      final prefs = await _instance;
      await prefs.remove(_userKey);
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_authTokenKey);
      print('🗑️ User data cleared successfully');
    } catch (e) {
      print('❌ Error clearing user data: $e');
    }
  }

  // Update user token (useful for token refresh)
  static Future<void> updateToken(String token) async {
    try {
      final prefs = await _instance;
      await prefs.setString(_authTokenKey, token);
      
      // Also update token in user object
      final user = await getUser();
      if (user != null) {
        final updatedUser = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          matricNumber: user.matricNumber,
          role: user.role,
          faculty: FacultyModel(
            id: user.faculty.id,
            name: user.faculty.name,
            code: user.faculty.code,
            description: user.faculty.description,
            departments: user.faculty.departments,
            createdAt: user.faculty.createdAt,
            updatedAt: user.faculty.updatedAt,
          ),
          department: DepartmentModel(
            id: user.department.id,
            name: user.department.name,
            code: user.department.code,
            description: user.department.description,
            facultyId: user.department.facultyId,
            createdAt: user.department.createdAt,
            updatedAt: user.department.updatedAt,
          ),
          level: user.level,
          fingerprintHash: user.fingerprintHash,
          isActive: user.isActive,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
          token: token,
        );
        await saveUser(updatedUser);
      }
      print('🔄 Token updated successfully');
    } catch (e) {
      print('❌ Error updating token: $e');
      rethrow;
    }
  }

  // Test storage functionality
  static Future<bool> testStorage() async {
    try {
      final prefs = await _instance;
      await prefs.setString('test_key', 'test_value');
      final value = prefs.getString('test_key');
      await prefs.remove('test_key');
      final success = value == 'test_value';
      print('🧪 Storage test ${success ? 'passed' : 'failed'}');
      return success;
    } catch (e) {
      print('❌ Storage test failed: $e');
      return false;
    }
  }
}