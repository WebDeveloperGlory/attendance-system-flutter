import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/admin/widgets/admin_bottom_navbar.dart';

class AdminShell extends StatefulWidget {
  final Widget child;

  const AdminShell({
    super.key,
    required this.child,
  });

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate to the corresponding admin page
    switch (index) {
      case 0:
        context.go('/admin/dashboard');
        break;
      case 1:
        context.go('/admin/students');
        break;
      case 2:
        context.go('/admin/lecturers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}