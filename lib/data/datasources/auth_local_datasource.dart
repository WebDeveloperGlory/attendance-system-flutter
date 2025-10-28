import 'package:flutter/widgets.dart';
import 'package:smart_attendance_system/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getSavedUser();
  Future<void> clearUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

/// TODO: Implement this with actual storage solution
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  
  @override
  Future<void> saveUser(UserModel user) async {
    debugPrint('Saving user to local storage: ${user.name}');
    // Implementation with shared_preferences:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('user', jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getSavedUser() async {
    debugPrint('Reading user from local storage');
    // Implementation:
    // final prefs = await SharedPreferences.getInstance();
    // final userJson = prefs.getString('user');
    // if (userJson != null) {
    //   return UserModel.fromJson(jsonDecode(userJson));
    // }
    return null;
  }

  @override
  Future<void> clearUser() async {
    debugPrint('Clearing user from local storage');
    // Implementation:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('user');
  }

  @override
  Future<void> saveToken(String token) async {
    debugPrint('Saving token to secure storage');
    // Use flutter_secure_storage for tokens:
    // final storage = FlutterSecureStorage();
    // await storage.write(key: 'token', value: token);
  }

  @override
  Future<String?> getToken() async {
    debugPrint('Reading token from secure storage');
    // Implementation:
    // final storage = FlutterSecureStorage();
    // return await storage.read(key: 'token');
    return null;
  }

  @override
  Future<void> clearToken() async {
    debugPrint('Clearing token from secure storage');
    // Implementation:
    // final storage = FlutterSecureStorage();
    // await storage.delete(key: 'token');
  }
}