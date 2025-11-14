import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/application/pages/admin/lecturer/cubit/lecturer_management_cubit.dart';
// import 'package:smart_attendance_system/domain/entities/department_entity.dart';
// import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_entity.dart';
import 'package:smart_attendance_system/injection_container.dart' as di;

class AdminLecturerManagement extends StatelessWidget {
  const AdminLecturerManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<LecturerManagementCubit>()
        ..loadLecturers()
        ..loadFacultiesAndDepartments(),
      child: const AdminLecturerManagementView(),
    );
  }
}

class AdminLecturerManagementView extends StatefulWidget {
  const AdminLecturerManagementView({super.key});

  @override
  State<AdminLecturerManagementView> createState() => _AdminLecturerManagementViewState();
}

class _AdminLecturerManagementViewState extends State<AdminLecturerManagementView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<LecturerManagementCubit, LecturerManagementState>(
      listener: (context, state) {
        if (state is LecturerManagementActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is LecturerManagementActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is LecturerManagementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outline),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Menu Button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: colorScheme.surface,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.menu,
                                size: 20,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Title
                          Expanded(
                            child: BlocBuilder<LecturerManagementCubit, LecturerManagementState>(
                              builder: (context, state) {
                                final count = state is LecturerManagementLoaded
                                    ? state.lecturers.length
                                    : 0;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lecturers",
                                      style: textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      "$count total",
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // Add Button
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  _showAddLecturerDialog(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 16,
                                        color: colorScheme.onPrimary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Add",
                                        style: textTheme.labelMedium?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(
                              Icons.search,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: "Search lecturers...",
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                onChanged: (value) {
                                  context.read<LecturerManagementCubit>().searchLecturers(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lecturers List
              Expanded(
                child: BlocBuilder<LecturerManagementCubit, LecturerManagementState>(
                  builder: (context, state) {
                    if (state is LecturerManagementLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      );
                    }

                    if (state is LecturerManagementLoaded) {
                      if (state.lecturers.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return Stack(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.lecturers.length,
                            itemBuilder: (context, index) {
                              return _buildLecturerCard(context, state.lecturers[index]);
                            },
                          ),
                          if (context.watch<LecturerManagementCubit>().state
                              is LecturerManagementActionLoading)
                            Container(
                              color: Colors.black.withValues(alpha: 0.3),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      );
                    }

                    return _buildEmptyState(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLecturerCard(BuildContext context, LecturerEntity lecturer) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.people,
                        size: 24,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lecturer.name,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: lecturer.isActive
                                      ? (isDark
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : const Color(0xFFDCFCE7))
                                      : (isDark
                                          ? Colors.grey.withValues(alpha: 0.2)
                                          : const Color(0xFFF3F4F6)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  lecturer.isActive ? "Active" : "Inactive",
                                  style: textTheme.labelSmall?.copyWith(
                                    color: lecturer.isActive
                                        ? (isDark
                                            ? Colors.green.shade300
                                            : const Color(0xFF166534))
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Email
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                size: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  lecturer.email,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Stats
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.class_,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${lecturer.courseCount} courses",
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${lecturer.totalStudents} students",
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Action Buttons
                          Container(
                            height: 1,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildIconActionButton(
                                  context,
                                  icon: Icons.add,
                                  label: "Course",
                                  onTap: () => _showCreateCourseDialog(context, lecturer),
                                ),
                              ),
                              Expanded(
                                child: _buildIconActionButton(
                                  context,
                                  icon: Icons.lock,
                                  label: "Reset",
                                  onTap: () => _showResetPasswordDialog(context, lecturer),
                                ),
                              ),
                              Expanded(
                                child: _buildIconActionButton(
                                  context,
                                  icon: Icons.delete,
                                  label: "Delete",
                                  isDestructive: true,
                                  onTap: () => _showDeleteConfirmation(context, lecturer),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: isDestructive ? colorScheme.error : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              "No lecturers found",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLecturerDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<LecturerManagementCubit>();

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String? selectedFaculty;
    String? selectedDepartment;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (stateContext, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register Lecturer",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Add new lecturer to system",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(bottomSheetContext),
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field
                        _buildTextField(
                          context,
                          label: "Full Name",
                          hint: "Dr. Adeyemi Johnson",
                          controller: nameController,
                        ),
                        const SizedBox(height: 16),
                        // Email Field
                        _buildTextField(
                          context,
                          label: "Email",
                          hint: "lecturer@university.edu",
                          controller: emailController,
                        ),
                        const SizedBox(height: 16),
                        // Faculty Dropdown
                        _buildDropdown(
                          context,
                          label: "Faculty",
                          hint: "Select faculty",
                          value: selectedFaculty,
                          items: cubit.faculties
                              .map((f) => DropdownMenuItem(
                                    value: f.id,
                                    child: Text(f.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFaculty = value;
                              selectedDepartment = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Department Dropdown
                        _buildDropdown(
                          context,
                          label: "Department",
                          hint: "Select department",
                          value: selectedDepartment,
                          items: selectedFaculty != null
                              ? cubit
                                  .getDepartmentsByFacultyId(selectedFaculty!)
                                  .map((d) => DropdownMenuItem(
                                        value: d.id,
                                        child: Text(d.name),
                                      ))
                                  .toList()
                              : [],
                          onChanged: (value) {
                            setState(() {
                              selectedDepartment = value as String?;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(bottomSheetContext),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colorScheme.onSurface,
                                  side: BorderSide(
                                      color: colorScheme.outline.withValues(alpha: 0.3)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.isEmpty ||
                                      emailController.text.isEmpty ||
                                      selectedFaculty == null ||
                                      selectedDepartment == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text("Please fill all fields"),
                                        backgroundColor: colorScheme.error,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.pop(bottomSheetContext);
                                  // context.read<LecturerManagementCubit>().registerLecturer(
                                  //       name: nameController.text,
                                  //       email: emailController.text,
                                  //       facultyId: selectedFaculty!,
                                  //       departmentId: selectedDepartment!,
                                  //     );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Register"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, LecturerEntity lecturer) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                "Delete Lecturer",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to delete ${lecturer.name}? This action cannot be undone.",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.read<LecturerManagementCubit>().deleteLecturer(lecturer.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, LecturerEntity lecturer) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final newPassword = "TempPass@2024";

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Reset Password",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "For ${lecturer.name}",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.primary.withValues(alpha: 0.2)
                          : const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? colorScheme.primary.withValues(alpha: 0.3)
                            : const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Temporary Password",
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme.outline.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  newPassword,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Lecturer must change this on first login",
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.onSurface,
                            side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            context.read<LecturerManagementCubit>().resetPassword(
                                  lecturerId: lecturer.id,
                                  newPassword: newPassword,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Confirm Reset"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCourseDialog(BuildContext context, LecturerEntity lecturer) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<LecturerManagementCubit>();

    // Form controllers
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    String? selectedFaculty;
    String? selectedDepartment;
    String? selectedLevel;
    String? selectedDay;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (stateContext, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Course",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "For ${lecturer.name}",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(bottomSheetContext),
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Name
                        _buildTextField(
                          context,
                          label: "Course Name",
                          hint: "e.g., Introduction to Computer Science",
                          controller: nameController,
                        ),
                        const SizedBox(height: 16),
                        // Course Code
                        _buildTextField(
                          context,
                          label: "Course Code",
                          hint: "e.g., CSC101",
                          controller: codeController,
                        ),
                        const SizedBox(height: 16),
                        // Faculty Dropdown
                        _buildDropdown(
                          context,
                          label: "Faculty",
                          hint: "Select faculty",
                          value: selectedFaculty,
                          items: cubit.faculties
                              .map((f) => DropdownMenuItem(
                                    value: f.id,
                                    child: Text(f.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFaculty = value;
                              selectedDepartment = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Department Dropdown
                        _buildDropdown(
                          context,
                          label: "Department",
                          hint: "Select department",
                          value: selectedDepartment,
                          items: selectedFaculty != null
                              ? cubit
                                  .getDepartmentsByFacultyId(selectedFaculty!)
                                  .map((d) => DropdownMenuItem(
                                        value: d.id,
                                        child: Text(d.name),
                                      ))
                                  .toList()
                              : [],
                          onChanged: (value) {
                            setState(() {
                              selectedDepartment = value as String?;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Level Dropdown
                        _buildDropdown(
                          context,
                          label: "Level",
                          hint: "Select level",
                          value: selectedLevel,
                          items: ['100', '200', '300', '400', '500', '600', '700', '800']
                              .map((level) => DropdownMenuItem(
                                    value: level,
                                    child: Text("Level $level"),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLevel = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Day of Week Dropdown
                        _buildDropdown(
                          context,
                          label: "Day of Week",
                          hint: "Select day",
                          value: selectedDay,
                          items: [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday',
                            'Sunday'
                          ]
                              .map((day) => DropdownMenuItem(
                                    value: day,
                                    child: Text(day),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDay = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Time Pickers
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start Time",
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () async {
                                      final time = await showTimePicker(
                                        context: stateContext,
                                        initialTime: startTime ?? TimeOfDay.now(),
                                      );
                                      if (time != null) {
                                        setState(() {
                                          startTime = time;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: colorScheme.outline.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.access_time,
                                            size: 20,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            startTime?.format(stateContext) ?? "Select time",
                                            style: textTheme.bodyMedium?.copyWith(
                                              color: startTime != null
                                                  ? colorScheme.onSurface
                                                  : colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "End Time",
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () async {
                                      final time = await showTimePicker(
                                        context: stateContext,
                                        initialTime: endTime ?? TimeOfDay.now(),
                                      );
                                      if (time != null) {
                                        setState(() {
                                          endTime = time;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: colorScheme.outline.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.access_time,
                                            size: 20,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            endTime?.format(stateContext) ?? "Select time",
                                            style: textTheme.bodyMedium?.copyWith(
                                              color: endTime != null
                                                  ? colorScheme.onSurface
                                                  : colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(bottomSheetContext),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colorScheme.onSurface,
                                  side: BorderSide(
                                      color: colorScheme.outline.withValues(alpha: 0.3)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.isEmpty ||
                                      codeController.text.isEmpty ||
                                      selectedFaculty == null ||
                                      selectedDepartment == null ||
                                      selectedLevel == null ||
                                      selectedDay == null ||
                                      startTime == null ||
                                      endTime == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text("Please fill all fields"),
                                        backgroundColor: colorScheme.error,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.pop(bottomSheetContext);
                                  context.read<LecturerManagementCubit>().createCourse(
                                        name: nameController.text,
                                        code: codeController.text,
                                        dayOfWeek: selectedDay!,
                                        startTime:
                                            "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}",
                                        endTime:
                                            "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}",
                                        lecturerId: lecturer.id,
                                        facultyId: selectedFaculty!,
                                        departmentId: selectedDepartment!,
                                        level: selectedLevel!,
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Create Course"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>(
    BuildContext context, {
    required String label,
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  hint,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              dropdownColor: colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}