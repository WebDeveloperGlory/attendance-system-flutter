import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/application/core/services/go_router_observer.dart';
import 'package:smart_attendance_system/application/core/services/go_router_refresh_stream.dart';
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
  final authStateCubit = BlocProvider.of<AuthStateCubit>(context);
  print('🚀 Router using AuthStateCubit instance: ${authStateCubit.hashCode}');
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    observers: [GoRouterObserver()],
    refreshListenable: GoRouterRefreshStream(authStateCubit.stream),
    redirect: (context, state) => _handleRedirect(context, state),
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
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
        builder: (context, state) => const LecturerLoginScreenWrapperProvider(),
      ),
      
      // Admin Shell Routes (Protected)
      ShellRoute(
        navigatorKey: _adminShellNavigatorKey,
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/students',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/lecturers',
            builder: (context, state) => const AdminLecturerManagement(),
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
          ),
          GoRoute(
            path: '/lecturer/create-class',
            builder: (context, state) => const LecturerDashboardScreen(),
          ),
          GoRoute(
            path: '/lecturer/records',
            builder: (context, state) => const LecturerAttendanceRecordsScreen(),
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

// ========== UNIFIED REDIRECT LOGIC ==========

String? _handleRedirect(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthStateCubit>().state;
  final location = state.uri.toString();
  
  print('🔄 Router redirect check: $location, Auth: ${authState.runtimeType}');
  
  // If auth is still loading, don't redirect yet
  if (authState is AuthStateLoading) {
    print('⏳ Auth loading, staying on current route');
    return null;
  }
  
  final isAuthenticated = authState is AuthStateAuthenticated;
  final userRole = isAuthenticated ? (authState).user.role.toLowerCase() : null;
  
  // Public routes - accessible to everyone
  final publicRoutes = ['/home', '/admin-login', '/lecturer-login'];
  if (publicRoutes.contains(location)) {
    // If authenticated user tries to access login pages, redirect to their dashboard
    if (isAuthenticated && (location == '/admin-login' || location == '/lecturer-login')) {
      final dashboard = _getDashboardRoute(userRole!);
      print('✅ Authenticated user on login page, redirecting to: $dashboard');
      return dashboard;
    }
    return null;
  }
  
  // Protected routes - require authentication
  if (location.startsWith('/admin/')) {
    if (!isAuthenticated) {
      print('❌ Not authenticated, redirecting to admin login');
      return '/admin-login';
    }
    if (userRole != 'admin') {
      print('❌ Wrong role for admin route, redirecting to: ${_getDashboardRoute(userRole!)}');
      return _getDashboardRoute(userRole);
    }
    print('✅ Admin access granted');
    return null;
  }
  
  if (location.startsWith('/lecturer/')) {
    if (!isAuthenticated) {
      print('❌ Not authenticated, redirecting to lecturer login');
      return '/lecturer-login';
    }
    if (userRole != 'lecturer') {
      print('❌ Wrong role for lecturer route, redirecting to: ${_getDashboardRoute(userRole!)}');
      return _getDashboardRoute(userRole);
    }
    print('✅ Lecturer access granted');
    return null;
  }
  
  // For any other route, if authenticated, redirect to dashboard
  if (isAuthenticated) {
    final dashboard = _getDashboardRoute(userRole!);
    print('✅ Authenticated, redirecting to dashboard: $dashboard');
    return dashboard;
  }
  
  // Default: redirect to home
  print('🏠 Default redirect to home');
  return '/home';
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