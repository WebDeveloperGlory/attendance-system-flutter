import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/admin/dashboard/cubit/admin_dashboard_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/student/cubit/student_management_cubit.dart';
import 'package:smart_attendance_system/domain/entities/department_entity.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart'
    hide FacultyEntity, DepartmentEntity;
import 'package:smart_attendance_system/domain/repositories/fnd_repo.dart';
import 'package:smart_attendance_system/injection_container.dart';

class AdminStudentsScreen extends StatelessWidget {
  const AdminStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentManagementCubit>()..loadStudents(),
      child: const _AdminStudentsContent(),
    );
  }
}

class _AdminStudentsContent extends StatelessWidget {
  const _AdminStudentsContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<StudentManagementCubit, StudentManagementState>(
      listener: (context, state) {
        if (state is StudentManagementError) {
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
                Expanded(child: _buildContent(context, state, isDark)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    StudentManagementState state,
    bool isDark,
  ) {
    final cubit = context.read<StudentManagementCubit>();
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title and Register Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Students",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state is StudentManagementLoaded
                          ? "${state.filteredStudents.length} total"
                          : "Loading...",
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showWorkInProgressDialog(context);
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Register"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.search,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (value) =>
                          cubit.filterStudents(searchQuery: value),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: "Search by name, ID, or email...",
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Filters
            _buildFilters(context, state, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    StudentManagementState state,
    bool isDark,
  ) {
    final cubit = context.read<StudentManagementCubit>();
    final theme = Theme.of(context);
    final faculties = state is StudentManagementLoaded
        ? cubit.getFaculties(state.students)
        : [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Faculty Filter
          Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              color: theme.colorScheme.surface,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state is StudentManagementLoaded
                    ? state.filterFaculty
                    : 'all',
                items: [
                  DropdownMenuItem(
                    value: 'all',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "All Faculties",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  ...faculties.map((faculty) {
                    return DropdownMenuItem(
                      value: faculty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          faculty ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: (value) =>
                    cubit.filterStudents(filterFaculty: value),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Status Filter
          Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              color: theme.colorScheme.surface,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state is StudentManagementLoaded
                    ? state.filterStatus
                    : 'all',
                items: [
                  DropdownMenuItem(
                    value: 'all',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "All Status",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'active',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Active",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'inactive',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Inactive",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => cubit.filterStudents(filterStatus: value),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          // Clear Filters Button
          if (state is StudentManagementLoaded &&
              (state.searchQuery.isNotEmpty ||
                  state.filterFaculty != 'all' ||
                  state.filterStatus != 'all')) ...[
            const SizedBox(width: 8),
            Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
                color: theme.colorScheme.surface,
              ),
              child: TextButton(
                onPressed: cubit.clearFilters,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  "Clear Filters",
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StudentManagementState state,
    bool isDark,
  ) {
    if (state is StudentManagementLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is StudentManagementError) {
      return _buildErrorState(context, isDark);
    }

    if (state is StudentManagementLoaded) {
      return _buildStudentsList(context, state, isDark);
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildStudentsList(
    BuildContext context,
    StudentManagementLoaded state,
    bool isDark,
  ) {
    final cubit = context.read<StudentManagementCubit>();
    Theme.of(context);
    final activeStudents = state.students.where((s) => s.isActive).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: Container(
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
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFBFDBFE),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Students",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF1E40AF),
                              ),
                            ),
                            Text(
                              state.students.length.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1E3A8A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.people,
                        size: 32,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(
                            colors: [Color(0xFF166534), Color(0xFF14532D)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFFDCFCE7), Color(0xFFF0FDF4)],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Active",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF166534),
                              ),
                            ),
                            Text(
                              activeStudents.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF14532D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        size: 32,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF16A34A),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Students List
          state.filteredStudents.isNotEmpty
              ? Column(
                  children: state.filteredStudents.map((student) {
                    return _buildStudentCard(context, student, cubit, isDark);
                  }).toList(),
                )
              : _buildEmptyState(context, state, isDark),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
    BuildContext context,
    StudentEntity student,
    StudentManagementCubit cubit,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final attendanceRate = student.attendanceSummary?.attendanceRate ?? 0;
    final coursesCount = student.coursesCount ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Header Row - FIXED SPACING
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student name with proper spacing - FIXED NAVIGATION
                    GestureDetector(
                      onTap: () {
                        print('🎯 Navigating to student detail: ${student.id}');
                        context.push('/admin/students/${student.id}');
                      },
                      child: Text(
                        student.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      student.matricNumber ?? "No ID",
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Status and Menu with proper spacing
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Status badge with bottom margin
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: student.isActive
                          ? (isDark
                                ? const Color(0xFF166534)
                                : const Color(0xFFDCFCE7))
                          : (isDark
                                ? const Color(0xFF991B1B)
                                : const Color(0xFFFEE2E2)),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: student.isActive
                            ? (isDark
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFFBBF7D0))
                            : (isDark
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFFFECACA)),
                      ),
                    ),
                    child: Text(
                      student.isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: student.isActive
                            ? (isDark ? Colors.white : const Color(0xFF166534))
                            : (isDark ? Colors.white : const Color(0xFF991B1B)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _StudentMenu(
                    student: student,
                    onViewProfile: () {
                      print(
                        '🎯 Menu - Navigating to student detail: ${student.id}',
                      );
                      context.push('/admin/students/${student.id}');
                    },
                    onDelete: () {
                      _showDeleteConfirmation(context, student, cubit, isDark);
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Info Grid
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 8,
              childAspectRatio: 10,
            ),
            children: [
              Text(
                "Faculty: ${student.faculty?.name ?? 'N/A'}",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                "Department: ${student.department?.name ?? 'N/A'}",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                "Level: ${student.level ?? 'N/A'}",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                "Classes: $coursesCount",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Attendance and Fingerprint
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                // Attendance Progress
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Attendance",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          Text(
                            "${attendanceRate.round()}%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
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
                              gradient: _getAttendanceGradient(
                                attendanceRate,
                                isDark,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Fingerprint Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: student.hasFingerprintEnrolled
                        ? (isDark
                              ? const Color(0xFF1E40AF)
                              : const Color(0xFFDBEAFE))
                        : (isDark
                              ? const Color(0xFF92400E)
                              : const Color(0xFFFEF3C7)),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: student.hasFingerprintEnrolled
                          ? (isDark
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFFBFDBFE))
                          : (isDark
                                ? const Color(0xFFD97706)
                                : const Color(0xFFFDE68A)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fingerprint,
                        size: 12,
                        color: student.hasFingerprintEnrolled
                            ? (isDark ? Colors.white : const Color(0xFF2563EB))
                            : (isDark ? Colors.white : const Color(0xFF92400E)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        student.hasFingerprintEnrolled ? "Enrolled" : "Pending",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: student.hasFingerprintEnrolled
                              ? (isDark
                                    ? Colors.white
                                    : const Color(0xFF2563EB))
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF92400E)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    StudentManagementLoaded state,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(64),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            "No Students Found",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.searchQuery.isNotEmpty ||
                    state.filterFaculty != 'all' ||
                    state.filterStatus != 'all'
                ? "Try adjusting your search or filters"
                : "Start by registering a new student",
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          if (state.searchQuery.isEmpty &&
              state.filterFaculty == 'all' &&
              state.filterStatus == 'all') ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _showWorkInProgressDialog(context);
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Register First Student"),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            "Failed to load students",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.read<StudentManagementCubit>().loadStudents();
            },
            child: Text(
              "Try Again",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    StudentEntity student,
    StudentManagementCubit cubit,
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
            fontSize: 20,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          "Are you sure you want to delete ${student.name}? This action cannot be undone. All attendance records and enrollment data will be permanently deleted.",
          style: TextStyle(
            fontSize: 14,
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
                      side: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
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
                    cubit.deleteStudent(student.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Delete Student"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LinearGradient _getAttendanceGradient(double rate, bool isDark) {
    if (rate >= 75) {
      return LinearGradient(
        colors: isDark
            ? [const Color(0xFF22C55E), const Color(0xFF16A34A)]
            : [const Color(0xFF16A34A), const Color(0xFF15803D)],
      );
    } else if (rate >= 60) {
      return LinearGradient(
        colors: isDark
            ? [const Color(0xFFEAB308), const Color(0xFFCA8A04)]
            : [const Color(0xFFEAB308), const Color(0xFFCA8A04)],
      );
    } else {
      return LinearGradient(
        colors: isDark
            ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
            : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
      );
    }
  }
}

// FIXED: Using PopupMenuButton instead of custom menu
class _StudentMenu extends StatelessWidget {
  final StudentEntity student;
  final VoidCallback onViewProfile;
  final VoidCallback onDelete;
  final bool isDark;

  const _StudentMenu({
    required this.student,
    required this.onViewProfile,
    required this.onDelete,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 20,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      onSelected: (value) {
        switch (value) {
          case 'view_profile':
            onViewProfile();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'view_profile',
          child: Row(
            children: [
              Icon(
                Icons.visibility,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Text(
                "View Profile",
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                "Delete Student",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

// ENHANCED STUDENT REGISTRATION DIALOG
class _StudentRegistrationDialog extends StatefulWidget {
  final bool isDark;

  const _StudentRegistrationDialog({required this.isDark});

  @override
  State<_StudentRegistrationDialog> createState() =>
      _StudentRegistrationDialogState();
}

class _StudentRegistrationDialogState
    extends State<_StudentRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _matricNumberController = TextEditingController();
  final _levelController = TextEditingController();

  List<FacultyEntity> _faculties = [];
  List<DepartmentEntity> _departments = [];
  String? _selectedFacultyId;
  String? _selectedDepartmentId;
  bool _isLoading = false;
  bool _facultiesLoading = false;
  bool _departmentsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    setState(() {
      _facultiesLoading = true;
    });

    try {
      final fndRepo = getIt<FndRepo>();
      final result = await fndRepo.getFaculties();

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load faculties: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (faculties) {
          if (mounted) {
            setState(() {
              _faculties = faculties;
              _facultiesLoading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _facultiesLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading faculties: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadDepartments(String facultyId) async {
    setState(() {
      _departmentsLoading = true;
      _selectedDepartmentId = null;
    });

    try {
      final fndRepo = getIt<FndRepo>();
      final result = await fndRepo.getDepartmentsByFaculty(facultyId);

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load departments: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (departments) {
          if (mounted) {
            setState(() {
              _departments = departments;
              _departmentsLoading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _departmentsLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading departments: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFacultyId == null || _selectedDepartmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both faculty and department'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final adminDashboardCubit = getIt<AdminDashboardCubit>();

      await adminDashboardCubit.registerStudent(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        facultyId: _selectedFacultyId!,
        departmentId: _selectedDepartmentId!,
        level: _levelController.text.trim(),
        matricNumber: _matricNumberController.text.trim(),
      );

      // Success
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Student ${_nameController.text} registered successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh student list
        context.read<StudentManagementCubit>().loadStudents();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register student: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _matricNumberController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        "Register New Student",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Matric Number
              TextFormField(
                controller: _matricNumberController,
                decoration: InputDecoration(
                  labelText: "Matric Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter matric number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Level
              TextFormField(
                controller: _levelController,
                decoration: InputDecoration(
                  labelText: "Level",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Faculty Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Faculty",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _facultiesLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                initialValue: _selectedFacultyId,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("Select Faculty"),
                  ),
                  ..._faculties.map((faculty) {
                    return DropdownMenuItem(
                      value: faculty.id,
                      child: Text(faculty.name),
                    );
                  }),
                ],
                onChanged: _facultiesLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedFacultyId = value;
                          _selectedDepartmentId = null;
                          _departments = [];
                        });
                        if (value != null) {
                          _loadDepartments(value);
                        }
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a faculty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Department Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _departmentsLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                initialValue: _selectedDepartmentId,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("Select Department"),
                  ),
                  ..._departments.map((department) {
                    return DropdownMenuItem(
                      value: department.id,
                      child: Text(department.name),
                    );
                  }),
                ],
                onChanged: _departmentsLoading || _selectedFacultyId == null
                    ? null
                    : (value) {
                        setState(() {
                          _selectedDepartmentId = value;
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  backgroundColor: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text("Register Student"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void _showWorkInProgressDialog(BuildContext context) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Icon(Icons.build, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Text(
            "Work in Progress",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      content: Text(
        "Student registration is currently available from the Admin Dashboard screen. Please navigate to the Dashboard to register new students.",
        style: TextStyle(
          fontSize: 14,
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
                    side: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("OK"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/admin/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Go to Dashboard"),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
