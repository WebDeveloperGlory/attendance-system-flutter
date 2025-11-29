import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/admin/student/id/cubit/student_detail_cubit.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';
import 'package:smart_attendance_system/injection_container.dart';

class AdminStudentDetailScreen extends StatelessWidget {
  final String studentId;
  
  const AdminStudentDetailScreen({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentDetailCubit>()..loadStudent(studentId),
      child: const _AdminStudentDetailContent(),
    );
  }
}

class _AdminStudentDetailContent extends StatelessWidget {
  const _AdminStudentDetailContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<StudentDetailCubit, StudentDetailState>(
      listener: (context, state) {
        if (state is StudentDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, state, isDark),
                // Content
                Expanded(
                  child: state is StudentDetailLoaded
                      ? _buildContent(context, state.student, isDark)
                      : state is StudentDetailLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildErrorState(context, isDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    StudentDetailState state,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final student = state is StudentDetailLoaded ? state.student : null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Student Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    student?.matricNumber ?? "Loading...",
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            _StudentDetailMenu(
              student: student,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StudentEntity student,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final attendanceRate = student.attendanceSummary?.attendanceRate ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Card
          _buildProfileCard(context, student, isDark),
          const SizedBox(height: 12),
          
          // Account Status Toggle
          _buildAccountStatusToggle(context, student, isDark),
          const SizedBox(height: 12),
          
          // Contact Information
          _buildContactInfoCard(student, theme, isDark),
          const SizedBox(height: 12),
          
          // Academic Information
          _buildAcademicInfoCard(student, theme, isDark),
          const SizedBox(height: 12),
          
          // Overall Attendance
          _buildAttendanceCard(student, attendanceRate, theme, isDark),
          const SizedBox(height: 12),
          
          // Enrolled Classes
          if (student.courses != null && student.courses!.isNotEmpty)
            _buildEnrolledClassesCard(student, theme, isDark),
          
          // Recent Attendance (Placeholder for now)
          _buildRecentAttendanceCard(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    StudentEntity student,
    bool isDark,
  ) {
    final _ = Theme.of(context);
    final initials = student.name.split(' ').map((n) => n[0]).join('').toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF1E3A8A)],
              )
            : const LinearGradient(
                colors: [Color(0xFFDBEAFE), Color(0xFFE0F2FE)],
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          // Avatar with fingerprint indicator
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
                        ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials.length > 2 ? initials.substring(0, 2) : initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              if (student.hasFingerprintEnrolled)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.fingerprint,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.matricNumber ?? "No ID",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: student.isActive
                            ? (isDark ? const Color(0xFF10B981) : const Color(0xFFDCFCE7))
                            : (isDark ? const Color(0xFFEF4444) : const Color(0xFFFEE2E2)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        student.isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: student.isActive
                              ? (isDark ? Colors.white : const Color(0xFF166534))
                              : (isDark ? Colors.white : const Color(0xFF991B1B)),
                        ),
                      ),
                    ),
                    if (student.hasFingerprintEnrolled)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E40AF) : const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Fingerprint Enrolled",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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

  Widget _buildAccountStatusToggle(
    BuildContext context,
    StudentEntity student,
    bool isDark,
  ) {
    final cubit = context.read<StudentDetailCubit>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account Status",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                student.isActive ? "Student can access system" : "Student access disabled",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Switch(
            value: student.isActive,
            onChanged: (value) {
              cubit.updateStudentStatus(!student.isActive);
            },
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard(StudentEntity student, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            Icons.email,
            "Email:",
            student.email,
            theme,
          ),
          const SizedBox(height: 8),
          // Phone would be added when available in the API
          _buildContactItem(
            Icons.phone,
            "Phone:",
            "Not available",
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label ",
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                TextSpan(
                  text: value,
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

  Widget _buildAcademicInfoCard(StudentEntity student, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Academic Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildAcademicItem(Icons.school, "Faculty:", student.faculty?.name ?? 'N/A', theme),
          const SizedBox(height: 8),
          _buildAcademicItem(Icons.architecture, "Department:", student.department?.name ?? 'N/A', theme),
          const SizedBox(height: 8),
          _buildAcademicItem(Icons.library_books, "Level:", student.level ?? 'N/A', theme),
        ],
      ),
    );
  }

  Widget _buildAcademicItem(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label ",
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                TextSpan(
                  text: value,
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

  Widget _buildAttendanceCard(
    StudentEntity student,
    double attendanceRate,
    ThemeData theme,
    bool isDark,
  ) {
    final isGoodAttendance = attendanceRate >= 75;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overall Attendance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attendance Rate",
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Row(
                children: [
                  Icon(
                    isGoodAttendance ? Icons.trending_up : Icons.trending_down,
                    size: 20,
                    color: isGoodAttendance ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${attendanceRate.round()}%",
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
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: attendanceRate / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isGoodAttendance
                      ? LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF10B981), const Color(0xFF059669)]
                              : [const Color(0xFF10B981), const Color(0xFF059669)],
                        )
                      : LinearGradient(
                          colors: isDark
                              ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                              : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                        ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isGoodAttendance
                ? "Meets minimum attendance requirement"
                : "Below minimum attendance requirement (75%)",
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (student.attendanceSummary != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _buildAttendanceStat("Present", student.attendanceSummary!.present, const Color(0xFF10B981), theme),
                const SizedBox(width: 12),
                _buildAttendanceStat("Absent", student.attendanceSummary!.absent, const Color(0xFFEF4444), theme),
                const SizedBox(width: 12),
                _buildAttendanceStat("Total", student.attendanceSummary!.totalSessions, theme.colorScheme.primary, theme),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttendanceStat(String label, int value, Color color, ThemeData theme) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildEnrolledClassesCard(StudentEntity student, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enrolled Classes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                "${student.courses!.length} courses",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: student.courses!.map((course) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
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
                    const SizedBox(height: 2),
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

  Widget _buildRecentAttendanceCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Attendance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Attendance history will be displayed here",
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final cubit = context.read<StudentDetailCubit>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            "Failed to load student details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => cubit.loadStudent(cubit.state.studentId),
            child: Text(
              "Try Again",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentDetailMenu extends StatefulWidget {
  final StudentEntity? student;
  final bool isDark;

  const _StudentDetailMenu({
    required this.student,
    required this.isDark,
  });

  @override
  State<_StudentDetailMenu> createState() => _StudentDetailMenuState();
}

class _StudentDetailMenuState extends State<_StudentDetailMenu> {
  bool _showMenu = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<StudentDetailCubit>();

    return Stack(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _showMenu = !_showMenu;
            });
          },
          icon: Icon(
            Icons.more_vert,
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (_showMenu) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showMenu = false;
                });
              },
            ),
          ),
          Positioned(
            right: 0,
            top: 48,
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  // Edit Profile
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _showMenu = false);
                      _showEditDialog(context, widget.student!, cubit, widget.isDark);
                    },
                    icon: Icon(Icons.edit, size: 16, color: theme.colorScheme.onSurface),
                    label: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  // Update Fingerprint
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _showMenu = false);
                      _showFingerprintDialog(context, widget.student!, cubit, widget.isDark);
                    },
                    icon: Icon(Icons.fingerprint, size: 16, color: theme.colorScheme.onSurface),
                    label: Text(
                      "Update Fingerprint",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  // Delete Student
                  Container(
                    height: 1,
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _showMenu = false);
                      _showDeleteConfirmation(context, widget.student!, cubit, widget.isDark);
                    },
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    label: const Text(
                      "Delete Student",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    StudentEntity student,
    StudentDetailCubit cubit,
    bool isDark,
  ) {
    // TODO: Implement edit dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit ${student.name}"),
        content: Text("Edit functionality will be implemented here"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showFingerprintDialog(
    BuildContext context,
    StudentEntity student,
    StudentDetailCubit cubit,
    bool isDark,
  ) {
    // TODO: Implement fingerprint dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Fingerprint"),
        content: const Text("Fingerprint enrollment will be implemented here"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Start Scan"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    StudentEntity student,
    StudentDetailCubit cubit,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Delete Student",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          "Are you sure you want to delete ${student.name}? This action cannot be undone. All attendance records and enrollment data will be permanently deleted.",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    cubit.deleteStudent();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Delete"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}