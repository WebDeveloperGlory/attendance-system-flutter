import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_attendance_system/application/core/services/local_storage_service.dart';
import 'package:smart_attendance_system/domain/entities/user_entity.dart';

part 'auth_state_state.dart';

class AuthStateCubit extends Cubit<AuthStateState> {
  AuthStateCubit() : super(AuthStateInitial()) {
    _initializeAuthState();
  }

  // Initialize auth state with error handling
  Future<void> _initializeAuthState() async {
    emit(AuthStateLoading());
    
    try {
      // Test storage first
      final storageWorking = await LocalStorageService.testStorage();
      if (!storageWorking) {
        print('Storage test failed - using unauthenticated state');
        emit(AuthStateUnauthenticated());
        return;
      }

      final isLoggedIn = await LocalStorageService.isLoggedIn();
      
      if (isLoggedIn) {
        final user = await LocalStorageService.getUser();
        if (user != null) {
          print('User found in storage: ${user.name} (${user.role})');
          emit(AuthStateAuthenticated(user: user));
        } else {
          print('User data not found in storage');
          await LocalStorageService.clearUserData();
          emit(AuthStateUnauthenticated());
        }
      } else {
        print('No user logged in');
        emit(AuthStateUnauthenticated());
      }
    } catch (e) {
      print('Error initializing auth state: $e');
      emit(AuthStateUnauthenticated());
    }
  }

  // Set user as authenticated (call this after successful login)
  Future<void> setAuthenticated(UserEntity user) async {
    try {
      await LocalStorageService.saveUser(user);
      emit(AuthStateAuthenticated(user: user));
      print('User authenticated: ${user.name}');
    } catch (e) {
      print('Error saving user data: $e');
      emit(AuthStateError('Failed to save user data'));
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await LocalStorageService.clearUserData();
      emit(AuthStateUnauthenticated());
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
      emit(AuthStateError('Failed to logout'));
    }
  }

  // Update user data
  Future<void> updateUser(UserEntity user) async {
    try {
      await LocalStorageService.saveUser(user);
      if (state is AuthStateAuthenticated) {
        emit(AuthStateAuthenticated(user: user));
        print('User data updated');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}