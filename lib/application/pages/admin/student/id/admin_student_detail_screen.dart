import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/admin/student/id/cubit/student_detail_cubit.dart';
import 'package:smart_attendance_system/domain/entities/student_detail_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/injection_container.dart';

class AdminStudentDetailScreen extends StatelessWidget {
  final String studentId;

  const AdminStudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentDetailCubit>(param1: studentId),
      child: _AdminStudentDetailContent(),
    );
  }
}

class _AdminStudentDetailContent extends StatefulWidget {
  @override
  State<_AdminStudentDetailContent> createState() => _AdminStudentDetailContentState();
}

class _AdminStudentDetailContentState extends State<_AdminStudentDetailContent> {
  bool _showMenu = false;
  bool _showEditDialog = false;
  bool _showFingerprintDialog = false;
  bool _showDeleteDialog = false;
  bool _scanningFingerprint = false;
  double _fingerprintProgress = 0.0;

  // Form controllers for edit dialog
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _levelController = TextEditingController();
  String? _selectedFacultyId;
  String? _selectedDepartmentId;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _handleUpdateFingerprint(BuildContext context) {
    setState(() {
      _scanningFingerprint = true;
      _fingerprintProgress = 0.0;
    });

    // Simulate fingerprint scanning
    const totalSteps = 5;
    var currentStep = 0;

    final interval = (const Duration(milliseconds: 600) ~/ totalSteps).inMilliseconds;

    Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        currentStep++;
        _fingerprintProgress = (currentStep / totalSteps) * 100;
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        setState(() {
          _scanningFingerprint = false;
          _fingerprintProgress = 0.0;
        });

        // Register fingerprint
        context.read<StudentDetailCubit>().registerFingerprint();
        
        // Close dialog
        setState(() {
          _showFingerprintDialog = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fingerprint updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _handleDeleteStudent(BuildContext context) {
    context.read<StudentDetailCubit>().deleteStudent();
  }

  void _initializeEditForm(StudentDetailEntity student) {
    _nameController.text = student.name;
    _emailController.text = student.email;
    _levelController.text = student.level ?? '';
    _selectedFacultyId = student.faculty?.id;
    _selectedDepartmentId = student.department?.id;
  }

  void _handleSaveProfile(BuildContext context) {
    final cubit = context.read<StudentDetailCubit>();
    
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    cubit.updateStudentProfile(
      name: _nameController.text,
      email: _emailController.text,
      level: _levelController.text,
      facultyId: _selectedFacultyId ?? '',
      departmentId: _selectedDepartmentId ?? '',
    );

    setState(() {
      _showEditDialog = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentDetailCubit, StudentDetailState>(
      listener: (context, state) {
        if (state is StudentDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is StudentDetailDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Student deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      },
      builder: (context, state) {
        if (state is StudentDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StudentDetailError) {
          return _buildErrorState(context, state.failure);
        }

        if (state is StudentDetailLoaded) {
          return _buildContent(context, state.student);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildContent(BuildContext context, StudentDetailEntity student) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cubit = context.read<StudentDetailCubit>();

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    student.matricNumber ?? student.id,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => setState(() => _showMenu = true),
                ),
              ],
              pinned: true,
            ),

            // Content
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Profile Card
                      _buildProfileCard(context, student, isDark),
                      const SizedBox(height: 16),
                      
                      // Account Status Toggle
                      _buildAccountStatusToggle(context, student, cubit, isDark),
                      const SizedBox(height: 16),
                      
                      // Contact Information
                      _buildContactInfo(context, student, isDark),
                      const SizedBox(height: 16),
                      
                      // Academic Information
                      _buildAcademicInfo(context, student, isDark),
                      const SizedBox(height: 16),
                      
                      // Overall Attendance
                      _buildOverallAttendance(context, student, isDark),
                      const SizedBox(height: 16),
                      
                      // Enrolled Classes
                      _buildEnrolledClasses(context, student, isDark),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),

        // Menu Dropdown
        if (_showMenu) _buildMenuOverlay(context, theme, student),

        // Dialogs - These are now inside the BlocConsumer, so they have access to the cubit
        if (_showEditDialog) _buildEditDialog(context, student, theme),
        if (_showFingerprintDialog) _buildFingerprintDialog(context, theme),
        if (_showDeleteDialog) _buildDeleteDialog(context, theme),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, StudentDetailEntity student, bool isDark) {
    final _ = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E40AF), const Color(0xFF1E3A8A)]
              : [const Color(0xFFDBEAFE), const Color(0xFFE0F2FE)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with fingerprint badge
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF3B82F6), const Color(0xFF2563EB)]
                        : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    student.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (student.hasFingerprintEnrolled)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  student.matricNumber ?? 'No ID',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: student.isActive
                            ? (isDark ? const Color(0xFF166534) : const Color(0xFFDCFCE7))
                            : (isDark ? const Color(0xFF991B1B) : const Color(0xFFFEE2E2)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: student.isActive
                              ? (isDark ? const Color(0xFF22C55E) : const Color(0xFFBBF7D0))
                              : (isDark ? const Color(0xFFEF4444) : const Color(0xFFFECACA)),
                        ),
                      ),
                      child: Text(
                        student.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: student.isActive
                              ? (isDark ? Colors.white : const Color(0xFF166534))
                              : (isDark ? Colors.white : const Color(0xFF991B1B)),
                        ),
                      ),
                    ),
                    // Fingerprint badge
                    if (student.hasFingerprintEnrolled)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E40AF) : const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF3B82F6) : const Color(0xFFBFDBFE),
                          ),
                        ),
                        child: Text(
                          'Fingerprint Enrolled',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStatusToggle(BuildContext context, StudentDetailEntity student, StudentDetailCubit cubit, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                student.isActive ? 'Student can access system' : 'Student access disabled',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Switch(
            value: student.isActive,
            onChanged: (value) => cubit.updateStudentStatus(value),
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, StudentDetailEntity student, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.email,
            label: 'Email:',
            value: student.email,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfo(BuildContext context, StudentDetailEntity student, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Academic Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.business,
            label: 'Faculty:',
            value: student.faculty?.name ?? 'Not assigned',
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.school,
            label: 'Department:',
            value: student.department?.name ?? 'Not assigned',
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.library_books,
            label: 'Level:',
            value: student.level ?? 'Not specified',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildOverallAttendance(BuildContext context, StudentDetailEntity student, bool isDark) {
    final theme = Theme.of(context);
    final attendanceRate = student.attendanceSummary?.attendanceRate ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Attendance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Rate',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Row(
                children: [
                  Icon(
                    attendanceRate >= 75 ? Icons.trending_up : Icons.trending_down,
                    size: 20,
                    color: attendanceRate >= 75 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${attendanceRate.round()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: attendanceRate / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: attendanceRate >= 75
                        ? [const Color(0xFF16A34A), const Color(0xFF15803D)]
                        : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            attendanceRate >= 75
                ? 'Meets minimum attendance requirement'
                : 'Below minimum attendance requirement (75%)',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrolledClasses(BuildContext context, StudentDetailEntity student, bool isDark) {
    final theme = Theme.of(context);
    final courses = student.courses ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enrolled Classes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${courses.length} courses',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (courses.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.class_,
                    size: 48,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Enrolled Classes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This student is not enrolled in any courses yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Column(
              children: courses.map((course) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.code,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // Menu Overlay
  Widget _buildMenuOverlay(BuildContext context, ThemeData theme, StudentDetailEntity student) {
    return GestureDetector(
      onTap: () => setState(() => _showMenu = false),
      child: Container(
        color: Colors.black54,
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 80, right: 16),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Profile
                    ListTile(
                      leading: Icon(Icons.edit, size: 20, color: theme.colorScheme.onSurface),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      onTap: () {
    setState(() {
      _showMenu = false;
      _initializeEditForm(student);
      _showEditDialog = true;
    });
  },
                    ),
                    // Update Fingerprint
                    ListTile(
                      leading: Icon(Icons.fingerprint, size: 20, color: theme.colorScheme.onSurface),
                      title: Text(
                        'Update Fingerprint',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _showMenu = false;
                          _showFingerprintDialog = true;
                        });
                      },
                    ),
                    // Delete Student
                    ListTile(
                      leading: Icon(Icons.delete, size: 20, color: Colors.red),
                      title: Text(
                        'Delete Student',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _showMenu = false;
                          _showDeleteDialog = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Edit Dialog
  Widget _buildEditDialog(BuildContext context, StudentDetailEntity student, ThemeData theme) {
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Update student information',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _handleSaveProfile(context),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Level Field
                    TextFormField(
                      controller: _levelController,
                      decoration: InputDecoration(
                        labelText: 'Level',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Faculty Dropdown (simplified for now)
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFacultyId,
                      decoration: InputDecoration(
                        labelText: 'Faculty',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: student.faculty?.id,
                          child: Text(student.faculty?.name ?? 'Select Faculty'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedFacultyId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Department Dropdown (simplified for now)
                    DropdownButtonFormField<String>(
                      initialValue: _selectedDepartmentId,
                      decoration: InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: student.department?.id,
                          child: Text(student.department?.name ?? 'Select Department'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartmentId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _showEditDialog = false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleSaveProfile(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fingerprint Dialog
  Widget _buildFingerprintDialog(BuildContext context, ThemeData theme) {
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Fingerprint',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect scanner and follow instructions',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            // Fingerprint Animation
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _scanningFingerprint
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: 4,
                    ),
                    color: _scanningFingerprint
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerLow,
                  ),
                  child: _scanningFingerprint
                      ? TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          builder: (context, value, child) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 4,
                              color: theme.colorScheme.primary,
                            );
                          },
                        )
                      : Icon(
                          Icons.fingerprint,
                          size: 48,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_scanningFingerprint) ...[
              Text(
                'Scanning fingerprint... ${_fingerprintProgress.round()}%',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _fingerprintProgress / 100,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
              ),
            ] else
              Text(
                'Place finger on the scanner when ready',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _scanningFingerprint ? null : () => _handleUpdateFingerprint(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _scanningFingerprint ? null : () => _handleUpdateFingerprint(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_scanningFingerprint ? 'Scanning...' : 'Start Scan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Delete Dialog
  Widget _buildDeleteDialog(BuildContext context, ThemeData theme) {
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Student',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to delete this student? This action cannot be undone. All attendance records and enrollment data will be permanently deleted.',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _showDeleteDialog = false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _showDeleteDialog = false);
                      _handleDeleteStudent(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Delete Student'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                TextSpan(
                  text: ' $value',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, Failure failure) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load student details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            failure.message,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}