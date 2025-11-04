import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';

class LocalStorageService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _authTokenKey = 'auth_token';

  // Use a singleton pattern to ensure consistent access
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Save user data
  static Future<void> saveUser(UserEntity user) async {
    try {
      final prefs = await _instance;
      final userJson = {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'matricNumber': user.matricNumber,
        'role': user.role,
        'faculty': {
          'id': user.faculty.id,
          'name': user.faculty.name,
          'code': user.faculty.code,
          'createdAt': user.faculty.createdAt?.toIso8601String(),
          'updatedAt': user.faculty.updatedAt?.toIso8601String(),
        },
        'department': {
          'id': user.department.id,
          'name': user.department.name,
          'code': user.department.code,
          'faculty': user.department.faculty,
          'createdAt': user.department.createdAt?.toIso8601String(),
          'updatedAt': user.department.updatedAt?.toIso8601String(),
        },
        'level': user.level,
        'fingerprintHash': user.fingerprintHash,
        'isActive': user.isActive,
        'createdAt': user.createdAt.toIso8601String(),
        'updatedAt': user.updatedAt.toIso8601String(),
        'token': user.token,
      };
      
      await prefs.setString(_userKey, jsonEncode(userJson));
      await prefs.setBool(_isLoggedInKey, true);
      
      // Save token separately for easy access
      if (user.token != null) {
        await prefs.setString(_authTokenKey, user.token!);
      }
      
      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  // Get current user
  static Future<UserEntity?> getUser() async {
    try {
      final prefs = await _instance;
      final userJsonString = prefs.getString(_userKey);
      
      if (userJsonString == null) return null;
      
      final userJson = jsonDecode(userJsonString) as Map<String, dynamic>;
      
      return UserEntity(
        id: userJson['id'] as String,
        name: userJson['name'] as String,
        email: userJson['email'] as String,
        matricNumber: userJson['matricNumber'] as String,
        role: userJson['role'] as String,
        faculty: FacultyEntity(
          id: userJson['faculty']['id'] as String,
          name: userJson['faculty']['name'] as String,
          code: userJson['faculty']['code'] as String,
          createdAt: userJson['faculty']['createdAt'] != null 
              ? DateTime.parse(userJson['faculty']['createdAt'] as String)
              : null,
          updatedAt: userJson['faculty']['updatedAt'] != null 
              ? DateTime.parse(userJson['faculty']['updatedAt'] as String)
              : null,
        ),
        department: DepartmentEntity(
          id: userJson['department']['id'] as String,
          name: userJson['department']['name'] as String,
          code: userJson['department']['code'] as String,
          faculty: userJson['department']['faculty'] as String,
          createdAt: userJson['department']['createdAt'] != null 
              ? DateTime.parse(userJson['department']['createdAt'] as String)
              : null,
          updatedAt: userJson['department']['updatedAt'] != null 
              ? DateTime.parse(userJson['department']['updatedAt'] as String)
              : null,
        ),
        level: userJson['level'] as String,
        fingerprintHash: userJson['fingerprintHash'] as String,
        isActive: userJson['isActive'] as bool,
        createdAt: DateTime.parse(userJson['createdAt'] as String),
        updatedAt: DateTime.parse(userJson['updatedAt'] as String),
        token: userJson['token'] as String?,
      );
    } catch (e) {
      print('Error parsing user data: $e');
      // Clear corrupted data
      await clearUserData();
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await _instance;
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Get auth token
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await _instance;
      return prefs.getString(_authTokenKey);
    } catch (e) {
      print('Error getting auth token: $e');
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
      print('User data cleared successfully');
    } catch (e) {
      print('Error clearing user data: $e');
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
        final updatedUser = UserEntity(
          id: user.id,
          name: user.name,
          email: user.email,
          matricNumber: user.matricNumber,
          role: user.role,
          faculty: user.faculty,
          department: user.department,
          level: user.level,
          fingerprintHash: user.fingerprintHash,
          isActive: user.isActive,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
          token: token,
        );
        await saveUser(updatedUser);
      }
    } catch (e) {
      print('Error updating token: $e');
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
      return value == 'test_value';
    } catch (e) {
      print('Storage test failed: $e');
      return false;
    }
  }
}