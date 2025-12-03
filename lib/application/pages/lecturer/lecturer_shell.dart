import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/lecturer/widgets/lecturer_bottom_navbar.dart';

class LecturerShell extends StatefulWidget {
  final Widget child;

  const LecturerShell({super.key, required this.child});

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
        context.push('/lecturer/dashboard');
        break;
      case 1:
        context.push('/lecturer/create-class');
        break;
      case 2:
        context.push('/lecturer/records');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents the default back button behavior
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Optionally show a dialog asking if user wants to logout
        _showExitDialog(context);
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: LecturerBottomNavbar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Do you want to logout and exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add your logout logic here
              // context.read<AuthStateCubit>().logout();
              context.go('/home');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
