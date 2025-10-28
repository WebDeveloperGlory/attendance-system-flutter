import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/core/services/go_router_observer.dart';
import 'package:smart_attendance_system/application/pages/admin/admin_shell.dart';
import 'package:smart_attendance_system/application/pages/admin/dashboard/admin_dashboard_screen.dart';
import 'package:smart_attendance_system/application/pages/admin/lecturer/admin_lecturer_management.dart';
import 'package:smart_attendance_system/application/pages/auth/admin_login_screen.dart';
import 'package:smart_attendance_system/application/pages/auth/lecturer_login_screen.dart';
import 'package:smart_attendance_system/application/pages/auth/user_type_selection_screen.dart';
import 'package:smart_attendance_system/application/pages/lecturer/dashboard/lecturer_dashboard_screen.dart';
import 'package:smart_attendance_system/application/pages/lecturer/lecturer_shell.dart';
import 'package:smart_attendance_system/application/pages/lecturer/records/lecturer_attendance_records_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _adminShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'adminShell');
final GlobalKey<NavigatorState> _lecturerShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'lecturerShell');

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  observers: [GoRouterObserver()],
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const UserTypeSelectionScreen(),
    ),
    GoRoute(
      path: '/admin-login',
      builder: (context, state) => const AdminLoginScreenWrapperProvider(), 
    ),
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
      ]
    ),
    GoRoute(
      path: '/lecturer-login',
      builder: (context, state) => const LecturerLoginScreen(),
    ),
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
      ]
    )
  ]
);