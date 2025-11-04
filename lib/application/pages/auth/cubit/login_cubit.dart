import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/auth_state_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/login_state.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/usecases/login_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final AuthStateCubit authStateCubit;

  LoginCubit({required this.loginUseCase, required this.authStateCubit}) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginError('Please enter both email and password'));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(const LoginError('Please enter a valid email address'));
      return;
    }

    emit(LoginLoading());
    
    final result = await loginUseCase(email, password);
    
    result.fold(
      (failure) {
        if (failure is AuthenticationFailure) {
          emit(LoginError(failure.message));
        } else if (failure is ServerFailure) {
          emit(LoginError(failure.message));
        } else if (failure is NetworkFailure) {
          emit(const LoginError('No internet connection. Please check your network.'));
        } else {
          emit(const LoginError('An unexpected error occurred. Please try again.'));
        }
      },
      (user) async {
        await authStateCubit.setAuthenticated(user);
        
        final route = _getDashboardRoute(user.role);
        emit(LoginSuccess(user: user, redirectRoute: route));
      },
    );
  }

  String _getDashboardRoute(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return '/admin/dashboard';
      case 'lecturer':
        return '/lecturer/dashboard';
      default:
        return '/home';
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  void reset() {
    emit(LoginInitial());
  }
}