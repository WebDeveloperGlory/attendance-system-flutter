import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/application/core/services/go_router_observer.dart';
import 'package:smart_attendance_system/application/pages/admin/admin_shell.dart';
import 'package:smart_attendance_system/application/pages/admin/dashboard/admin_dashboard_screen.dart';
import 'package:smart_attendance_system/application/pages/admin/lecturer/admin_lecturer_management.dart';
import 'package:smart_attendance_system/application/pages/auth/admin_login_screen.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/auth_state_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/lecturer_login_screen.dart';
import 'package:smart_attendance_system/application/pages/auth/user_type_selection_screen.dart';
import 'package:smart_attendance_system/application/pages/lecturer/dashboard/lecturer_dashboard_screen.dart';
import 'package:smart_attendance_system/application/pages/lecturer/lecturer_shell.dart';
import 'package:smart_attendance_system/application/pages/lecturer/records/lecturer_attendance_records_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _adminShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'adminShell');
final GlobalKey<NavigatorState> _lecturerShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'lecturerShell');

GoRouter routes(BuildContext context) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    observers: [GoRouterObserver()],
    redirect: (context, state) => _handleInitialRedirect(context, state),
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => _handleRootRedirect(context),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const UserTypeSelectionScreen(),
      ),
      GoRoute(
        path: '/admin-login',
        builder: (context, state) => const AdminLoginScreenWrapperProvider(), 
      ),
      GoRoute(
        path: '/lecturer-login',
        builder: (context, state) => const LecturerLoginScreen(),
      ),
      
      // Admin Shell Routes (Protected)
      ShellRoute(
        navigatorKey: _adminShellNavigatorKey,
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
            redirect: (context, state) => _adminAuthGuard(context),
          ),
          GoRoute(
            path: '/admin/students',
            builder: (context, state) => const AdminDashboardScreen(),
            redirect: (context, state) => _adminAuthGuard(context),
          ),
          GoRoute(
            path: '/admin/lecturers',
            builder: (context, state) => const AdminLecturerManagement(),
            redirect: (context, state) => _adminAuthGuard(context),
          ),        
        ],
      ),
      
      // Lecturer Shell Routes (Protected)
      ShellRoute(
        navigatorKey: _lecturerShellNavigatorKey,
        builder: (context, state, child) => LecturerShell(child: child),
        routes: [
          GoRoute(
            path: '/lecturer/dashboard',
            builder: (context, state) => const LecturerDashboardScreen(),
            redirect: (context, state) => _lecturerAuthGuard(context),
          ),
          GoRoute(
            path: '/lecturer/create-class',
            builder: (context, state) => const LecturerDashboardScreen(),
            redirect: (context, state) => _lecturerAuthGuard(context),
          ),
          GoRoute(
            path: '/lecturer/records',
            builder: (context, state) => const LecturerAttendanceRecordsScreen(),
            redirect: (context, state) => _lecturerAuthGuard(context),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// ========== AUTH GUARD FUNCTIONS ==========

String? _handleInitialRedirect(BuildContext context, GoRouterState state) {
  if (state.uri.toString() == '/home' || 
      state.uri.toString() == '/admin-login' || 
      state.uri.toString() == '/lecturer-login' ||
      state.uri.toString() == '/') {
    return null;
  }
  
  return _handleRootRedirect(context);
}

String? _handleRootRedirect(BuildContext context) {
  final authState = context.read<AuthStateCubit>().state;
  
  if (authState is AuthStateAuthenticated) {
    return _getDashboardRoute(authState.user.role);
  } else if (authState is AuthStateUnauthenticated) {
    return '/home';
  }
  
  return null;
}

String? _adminAuthGuard(BuildContext context) {
  final authState = context.read<AuthStateCubit>().state;
  
  if (authState is AuthStateAuthenticated) {
    if (authState.user.role.toLowerCase() == 'admin') {
      return null;
    } else {
      // User is logged in but not an admin, redirect to their dashboard
      return _getDashboardRoute(authState.user.role);
    }
  } else {
    // User is not logged in, redirect to admin login
    return '/admin-login';
  }
}

String? _lecturerAuthGuard(BuildContext context) {
  final authState = context.read<AuthStateCubit>().state;
  
  if (authState is AuthStateAuthenticated) {
    if (authState.user.role.toLowerCase() == 'lecturer') {
      return null; // Allow access to lecturer routes
    } else {
      // User is logged in but not a lecturer, redirect to their dashboard
      return _getDashboardRoute(authState.user.role);
    }
  } else {
    // User is not logged in, redirect to lecturer login
    return '/lecturer-login';
  }
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