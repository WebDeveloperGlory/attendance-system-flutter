import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/application/pages/admin/faculty/id/cubit/faculty_details_cubit.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/injection_container.dart';

class AdminFacultyDetailsScreen extends StatelessWidget {
  final String facultyId;

  const AdminFacultyDetailsScreen({super.key, required this.facultyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FacultyDetailsCubit>()..loadFaculty(facultyId),
      child: _AdminFacultyDetailsContent(facultyId: facultyId),
    );
  }
}

class _AdminFacultyDetailsContent extends StatelessWidget {
  final String facultyId;

  const _AdminFacultyDetailsContent({required this.facultyId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FacultyDetailsCubit, FacultyDetailsState>(
      listener: (context, state) {
        if (state is FacultyDetailsError) {
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FacultyDetailsState state) {
    if (state is FacultyDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FacultyDetailsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              "Failed to load faculty details",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.read<FacultyDetailsCubit>().loadFaculty(facultyId),
              child: const Text("Try Again"),
            ),
          ],
        ),
      );
    }

    if (state is FacultyDetailsLoaded) {
      return _FacultyDetailsView(faculty: state.faculty);
    }

    return const Center(child: CircularProgressIndicator());
  }
}

class _FacultyDetailsView extends StatefulWidget {
  final FacultyDetailEntity faculty;

  const _FacultyDetailsView({required this.faculty});

  @override
  State<_FacultyDetailsView> createState() => _FacultyDetailsViewState();
}

class _FacultyDetailsViewState extends State<_FacultyDetailsView> {
  String _searchQuery = "";
  bool _showAddDepartmentDialog = false;
  bool _showEditFacultyDialog = false;
  DepartmentSummaryEntity? _selectedDepartment;

  final TextEditingController _facultyNameController = TextEditingController();
  final TextEditingController _facultyCodeController = TextEditingController();
  final TextEditingController _facultyDescriptionController = TextEditingController();
  final TextEditingController _departmentNameController = TextEditingController();
  final TextEditingController _departmentCodeController = TextEditingController();
  final TextEditingController _departmentDescriptionController = TextEditingController();

  List<DepartmentSummaryEntity> get _filteredDepartments {
    if (_searchQuery.isEmpty) {
      return widget.faculty.departments;
    }
    return widget.faculty.departments.where((dept) =>
        dept.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        dept.code.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void _showEditFaculty() {
    _facultyNameController.text = widget.faculty.name;
    _facultyCodeController.text = widget.faculty.code;
    _facultyDescriptionController.text = widget.faculty.description;
    setState(() {
      _showEditFacultyDialog = true;
    });
  }

  void _showEditDepartment(DepartmentSummaryEntity department) {
    _departmentNameController.text = department.name;
    _departmentCodeController.text = department.code;
    _departmentDescriptionController.text = department.description;
    setState(() {
      _selectedDepartment = department;
    });
  }

  void _clearDialogControllers() {
    _facultyNameController.clear();
    _facultyCodeController.clear();
    _facultyDescriptionController.clear();
    _departmentNameController.clear();
    _departmentCodeController.clear();
    _departmentDescriptionController.clear();
  }

  @override
  void dispose() {
    _facultyNameController.dispose();
    _facultyCodeController.dispose();
    _facultyDescriptionController.dispose();
    _departmentNameController.dispose();
    _departmentCodeController.dispose();
    _departmentDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Header Section
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.faculty.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Code: ${widget.faculty.code}",
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAddDepartmentDialog = true;
                      });
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(200),
                child: _buildHeaderContent(theme, isDark),
              ),
            ),

            // Departments List
            if (_filteredDepartments.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final department = _filteredDepartments[index];
                      return _DepartmentCard(
                        department: department,
                        theme: theme,
                        onEdit: () => _showEditDepartment(department),
                        onDelete: () {
                          _showDeleteDepartmentConfirmation(context, department);
                        },
                      );
                    },
                    childCount: _filteredDepartments.length,
                  ),
                ),
              )
            else if (widget.faculty.departments.isEmpty)
              SliverFillRemaining(
                child: _EmptyState(
                  theme: theme,
                  onAddDepartment: () {
                    setState(() {
                      _showAddDepartmentDialog = true;
                    });
                  },
                ),
              )
            else
              SliverFillRemaining(
                child: _NoResultsState(theme: theme),
              ),
          ],
        ),

        // Dialogs
        if (_showAddDepartmentDialog)
          _AddDepartmentDialog(
            facultyName: widget.faculty.name,
            nameController: _departmentNameController,
            codeController: _departmentCodeController,
            descriptionController: _departmentDescriptionController,
            onClose: () {
              setState(() {
                _showAddDepartmentDialog = false;
              });
              _clearDialogControllers();
            },
            onCreate: () {
              context.read<FacultyDetailsCubit>().createDepartment(
                facultyId: widget.faculty.id,
                name: _departmentNameController.text.trim(),
                code: _departmentCodeController.text.trim(),
                description: _departmentDescriptionController.text.trim(),
              );
              setState(() {
                _showAddDepartmentDialog = false;
              });
              _clearDialogControllers();
            },
          ),

        if (_showEditFacultyDialog)
          _EditFacultyDialog(
            faculty: widget.faculty,
            nameController: _facultyNameController,
            codeController: _facultyCodeController,
            descriptionController: _facultyDescriptionController,
            onClose: () {
              setState(() {
                _showEditFacultyDialog = false;
              });
              _clearDialogControllers();
            },
            onSave: () {
              context.read<FacultyDetailsCubit>().updateFaculty(
                id: widget.faculty.id,
                name: _facultyNameController.text.trim(),
                code: _facultyCodeController.text.trim(),
                description: _facultyDescriptionController.text.trim(),
              );
              setState(() {
                _showEditFacultyDialog = false;
              });
              _clearDialogControllers();
            },
          ),

        if (_selectedDepartment != null)
          _EditDepartmentDialog(
            department: _selectedDepartment!,
            nameController: _departmentNameController,
            codeController: _departmentCodeController,
            descriptionController: _departmentDescriptionController,
            onClose: () {
              setState(() {
                _selectedDepartment = null;
              });
              _clearDialogControllers();
            },
            onSave: () {
              context.read<FacultyDetailsCubit>().updateDepartment(
                id: _selectedDepartment!.id,
                name: _departmentNameController.text.trim(),
                code: _departmentCodeController.text.trim(),
                description: _departmentDescriptionController.text.trim(),
              );
              setState(() {
                _selectedDepartment = null;
              });
              _clearDialogControllers();
            },
          ),
      ],
    );
  }

  Widget _buildHeaderContent(ThemeData theme, bool isDark) {
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Faculty Info Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E40AF),
                          const Color(0xFF1E3A8A),
                        ]
                      : [
                          const Color(0xFFDBEAFE),
                          const Color(0xFFE0F2FE),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFBFDBFE),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    value: widget.faculty.activeDepartments.toString(),
                    label: "Departments",
                    theme: theme,
                    isDark: isDark,
                  ),
                  _StatItem(
                    value: widget.faculty.totalStudents.toString(),
                    label: "Students",
                    theme: theme,
                    isDark: isDark,
                  ),
                  _StatItem(
                    value: widget.faculty.departments.length.toString(),
                    label: "Active",
                    theme: theme,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // Search and Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
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
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search departments...",
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showEditFaculty,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Edit Faculty"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface,
                          side: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showDeleteFacultyConfirmation(context);
                        },
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text("Delete"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
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

  void _showDeleteFacultyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Faculty'),
        content: Text('Are you sure you want to delete ${widget.faculty.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FacultyDetailsCubit>().deleteFaculty(widget.faculty.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDepartmentConfirmation(BuildContext context, DepartmentSummaryEntity department) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department'),
        content: Text('Are you sure you want to delete ${department.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FacultyDetailsCubit>().deleteDepartment(department.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final ThemeData theme;
  final bool isDark;

  const _StatItem({
    required this.value,
    required this.label,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : const Color(0xFF1E40AF),
          ),
        ),
      ],
    );
  }
}

class _DepartmentCard extends StatelessWidget {
  final DepartmentSummaryEntity department;
  final ThemeData theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DepartmentCard({
    required this.department,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                department.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                department.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Stats
                    Row(
                      children: [
                        _DepartmentStat(
                          icon: Icons.people,
                          value: "${department.students} students",
                          theme: theme,
                        ),
                        const SizedBox(width: 16),
                        _DepartmentStat(
                          icon: Icons.school,
                          value: "${department.courses} courses",
                          theme: theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Code Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        department.code,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
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
                Expanded(
                  child: TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Edit"),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text("Delete"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DepartmentStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final ThemeData theme;

  const _DepartmentStat({
    required this.icon,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onAddDepartment;

  const _EmptyState({
    required this.theme,
    required this.onAddDepartment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.school,
          size: 64,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 16),
        Text(
          "No Departments Yet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            "Create your first department to organize courses and students",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onAddDepartment,
          icon: const Icon(Icons.add),
          label: const Text("Add First Department"),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoResultsState extends StatelessWidget {
  final ThemeData theme;

  const _NoResultsState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu_book,
          size: 48,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 16),
        Text(
          "No departments match your search",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

// Dialog Components
class _AddDepartmentDialog extends StatelessWidget {
  final String facultyName;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final VoidCallback onClose;
  final VoidCallback onCreate;

  const _AddDepartmentDialog({
    required this.facultyName,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.onClose,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      title: "Add Department",
      subtitle: "Create new department in $facultyName",
      onClose: onClose,
      content: Column(
        children: [
          _DialogTextField(
            label: "Department Name",
            hintText: "e.g., Computer Science",
            controller: nameController,
          ),
          const SizedBox(height: 16),
          _DialogTextField(
            label: "Department Code",
            hintText: "e.g., CS",
            controller: codeController,
          ),
          const SizedBox(height: 16),
          _DialogTextArea(
            label: "Description",
            hintText: "Brief description of the department",
            controller: descriptionController,
          ),
        ],
      ),
      actions: [
        Expanded(
          child: OutlinedButton(
            onPressed: onClose,
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onCreate,
            child: const Text("Create"),
          ),
        ),
      ],
    );
  }
}

class _EditFacultyDialog extends StatelessWidget {
  final FacultyDetailEntity faculty;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final VoidCallback onClose;
  final VoidCallback onSave;

  const _EditFacultyDialog({
    required this.faculty,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.onClose,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      title: "Edit Faculty",
      subtitle: "Update faculty information",
      onClose: onClose,
      content: Column(
        children: [
          _DialogTextField(
            label: "Faculty Name",
            controller: nameController,
          ),
          const SizedBox(height: 16),
          _DialogTextField(
            label: "Faculty Code",
            controller: codeController,
          ),
          const SizedBox(height: 16),
          _DialogTextArea(
            label: "Description",
            controller: descriptionController,
          ),
        ],
      ),
      actions: [
        Expanded(
          child: OutlinedButton(
            onPressed: onClose,
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            child: const Text("Save Changes"),
          ),
        ),
      ],
    );
  }
}

class _EditDepartmentDialog extends StatelessWidget {
  final DepartmentSummaryEntity department;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final VoidCallback onClose;
  final VoidCallback onSave;

  const _EditDepartmentDialog({
    required this.department,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.onClose,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      title: "Edit Department",
      subtitle: "Update department information",
      onClose: onClose,
      content: Column(
        children: [
          _DialogTextField(
            label: "Department Name",
            controller: nameController,
          ),
          const SizedBox(height: 16),
          _DialogTextField(
            label: "Department Code",
            controller: codeController,
          ),
          const SizedBox(height: 16),
          _DialogTextArea(
            label: "Description",
            controller: descriptionController,
          ),
        ],
      ),
      actions: [
        Expanded(
          child: OutlinedButton(
            onPressed: onClose,
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            child: const Text("Save Changes"),
          ),
        ),
      ],
    );
  }
}

class _BaseDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final Widget content;
  final List<Widget> actions;

  const _BaseDialog({
    required this.title,
    required this.subtitle,
    required this.onClose,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: actions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;

  const _DialogTextField({
    required this.label,
    this.hintText = "",
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogTextArea extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;

  const _DialogTextArea({
    required this.label,
    this.hintText = "",
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}