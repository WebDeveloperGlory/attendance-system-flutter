import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/application/core/services/local_storage_service.dart';
import 'package:smart_attendance_system/application/core/services/route.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/auth_state_cubit.dart';
import 'application/core/themes/app_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final storageWorking = await LocalStorageService.testStorage();
    print('Storage test result: $storageWorking');
  } catch (e) {
    print('Storage test error: $e');
  }
  
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide AuthStateCubit at the top level
      create: (context) => di.getIt<AuthStateCubit>(),
      child: const SmartAttendanceApp(),
    );
  }
}

class SmartAttendanceApp extends StatelessWidget {
  const SmartAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Attendance System',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: routes(context), // Now context has AuthStateCubit
    );
  }
}