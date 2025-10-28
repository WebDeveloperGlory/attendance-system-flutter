import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/lecturer/widgets/lecturer_bottom_navbar.dart';

class LecturerShell extends StatefulWidget {
  final Widget child;

  const LecturerShell({
    super.key,
    required this.child,
  });

  @override
  State<LecturerShell> createState() => _LecturerShellState();
}

class _LecturerShellState extends State<LecturerShell> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate to the corresponding lecturer page
    switch (index) {
      case 0:
        context.go('/lecturer/dashboard');
        break;
      case 1:
        context.go('/lecturer/create-class');
        break;
      case 2:
        context.go('/lecturer/records');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: LecturerBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}