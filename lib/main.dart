import 'package:flutter/material.dart';
import 'package:smart_attendance_system/application/core/services/local_storage_service.dart';
import 'package:smart_attendance_system/application/core/services/route.dart';
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
  runApp(const SmartAttendanceApp());
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
      routerConfig: routes(context),
    );
  }
}