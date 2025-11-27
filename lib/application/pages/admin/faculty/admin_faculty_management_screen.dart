import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/admin/faculty/cubit/faculty_management_cubit.dart';
import 'package:smart_attendance_system/domain/entities/faculty_entity.dart';
import 'package:smart_attendance_system/injection_container.dart';

class AdminFacultyManagementScreen extends StatelessWidget {
  const AdminFacultyManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FacultyManagementCubit>()..loadFaculties(),
      child: const _AdminFacultyManagementContent(),
    );
  }
}

class _AdminFacultyManagementContent extends StatelessWidget {
  const _AdminFacultyManagementContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocConsumer<FacultyManagementCubit, FacultyManagementState>(
        listener: (context, state) {
          if (state is FacultyManagementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.failure.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return _FacultyManagementBody(state: state);
        },
      ),
    );
  }
}

class _FacultyManagementBody extends StatefulWidget {
  final FacultyManagementState state;

  const _FacultyManagementBody({required this.state});

  @override
  State<_FacultyManagementBody> createState() => _FacultyManagementBodyState();
}

class _FacultyManagementBodyState extends State<_FacultyManagementBody> {
  String _searchQuery = "";
  bool _showAddDialog = false;
  FacultyEntity? _selectedFaculty;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize search when state changes to loaded
    if (widget.state is FacultyManagementLoaded) {
      _updateSearch();
    }
  }

  @override
  void didUpdateWidget(_FacultyManagementBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update search when state changes
    if (widget.state is FacultyManagementLoaded) {
      _updateSearch();
    }
  }

  void _updateSearch() {
    if (widget.state is FacultyManagementLoaded) {
      context.read<FacultyManagementCubit>().filterFaculties(_searchQuery);
    }
  }

  void _navigateToFacultyDetails(FacultyEntity faculty) {
    context.push('/admin/faculty/${faculty.id}');
    // Or use Navigator if you prefer:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FacultyDetailsScreen(facultyId: faculty.id),
    //   ),
    // );
  }

  void _showEditFacultyDialog(FacultyEntity faculty) {
    _nameController.text = faculty.name;
    _codeController.text = faculty.code;
    _descriptionController.text = faculty.description;
    setState(() {
      _selectedFaculty = faculty;
    });
  }

  void _clearDialogControllers() {
    _nameController.clear();
    _codeController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Main Content
        _buildMainContent(theme, isDark),

        // Dialogs
        if (_showAddDialog)
          _AddFacultyDialog(
            nameController: _nameController,
            codeController: _codeController,
            descriptionController: _descriptionController,
            onClose: () {
              setState(() {
                _showAddDialog = false;
              });
              _clearDialogControllers();
            },
            onCreate: () {
              context.read<FacultyManagementCubit>().createFaculty(
                name: _nameController.text.trim(),
                code: _codeController.text.trim(),
                description: _descriptionController.text.trim(),
              );
              setState(() {
                _showAddDialog = false;
              });
              _clearDialogControllers();
            },
          ),

        if (_selectedFaculty != null)
          _EditFacultyDialog(
            faculty: _selectedFaculty!,
            nameController: _nameController,
            codeController: _codeController,
            descriptionController: _descriptionController,
            onClose: () {
              setState(() {
                _selectedFaculty = null;
              });
              _clearDialogControllers();
            },
            onSave: () {
              context.read<FacultyManagementCubit>().updateFaculty(
                id: _selectedFaculty!.id,
                name: _nameController.text.trim(),
                code: _codeController.text.trim(),
                description: _descriptionController.text.trim(),
              );
              setState(() {
                _selectedFaculty = null;
              });
              _clearDialogControllers();
            },
          ),
      ],
    );
  }

  Widget _buildMainContent(ThemeData theme, bool isDark) {
    return CustomScrollView(
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
          title: _buildAppBarTitle(),
          actions: [_buildAddButton()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: _buildSearchBar(theme),
          ),
        ),

        // Content based on state
        _buildContentSliver(theme),
      ],
    );
  }

  Widget _buildAppBarTitle() {
    return BlocBuilder<FacultyManagementCubit, FacultyManagementState>(
      builder: (context, state) {
        final facultyCount = state is FacultyManagementLoaded 
            ? state.faculties.length 
            : 0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Faculties",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "$facultyCount total",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _showAddDialog = true;
          });
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text("Add"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Container(
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
            context.read<FacultyManagementCubit>().filterFaculties(value);
          },
          decoration: InputDecoration(
            hintText: "Search faculties...",
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
    );
  }

  Widget _buildContentSliver(ThemeData theme) {
    if (widget.state is FacultyManagementLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.state is FacultyManagementError) {
      return SliverFillRemaining(
        child: _ErrorState(
          theme: theme,
          onRetry: () => context.read<FacultyManagementCubit>().loadFaculties(),
        ),
      );
    }

    if (widget.state is FacultyManagementLoaded) {
      final loadedState = widget.state as FacultyManagementLoaded;
      final facultiesToShow = loadedState.filteredFaculties.isNotEmpty
          ? loadedState.filteredFaculties
          : loadedState.faculties;

      if (facultiesToShow.isEmpty && loadedState.searchQuery.isNotEmpty) {
        return SliverFillRemaining(
          child: _NoResultsState(theme: theme),
        );
      }

      if (facultiesToShow.isEmpty) {
        return SliverFillRemaining(
          child: _EmptyState(
            theme: theme,
            onAddFaculty: () {
              setState(() {
                _showAddDialog = true;
              });
            },
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final faculty = facultiesToShow[index];
              return _FacultyCard(
                faculty: faculty,
                theme: theme,
                onTap: () => _navigateToFacultyDetails(faculty),
                onEdit: () => _showEditFacultyDialog(faculty),
                onDelete: () {
                  _showDeleteConfirmation(context, faculty);
                },
              );
            },
            childCount: facultiesToShow.length,
          ),
        ),
      );
    }

    // Initial state
    return const SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, FacultyEntity faculty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Faculty'),
        content: Text('Are you sure you want to delete ${faculty.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FacultyManagementCubit>().deleteFaculty(faculty.id);
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

// ========== REUSABLE WIDGET COMPONENTS ==========

class _FacultyCard extends StatelessWidget {
  final FacultyEntity faculty;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FacultyCard({
    required this.faculty,
    required this.theme,
    required this.onTap,
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
                  Icons.account_balance,
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
                                faculty.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                faculty.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onTap,
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Stats
                    Row(
                      children: [
                        _FacultyStat(
                          icon: Icons.menu_book,
                          value: "${faculty.departments.length} depts",
                          theme: theme,
                        ),
                        const SizedBox(width: 16),
                        _FacultyStat(
                          icon: Icons.people,
                          value: "0 students", // TODO: Get actual student count
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
                        faculty.code,
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
              border: Border (
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              )
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

class _FacultyStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final ThemeData theme;

  const _FacultyStat({
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
  final VoidCallback onAddFaculty;

  const _EmptyState({
    required this.theme,
    required this.onAddFaculty,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_balance,
          size: 64,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 16),
        Text(
          "No Faculties Yet",
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
            "Create your first faculty to organize departments and courses",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onAddFaculty,
          icon: const Icon(Icons.add),
          label: const Text("Add First Faculty"),
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
          Icons.account_balance,
          size: 48,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 16),
        Text(
          "No faculties match your search",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.theme,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 64,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          "Failed to load faculties",
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
            "Please check your connection and try again",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text("Try Again"),
        ),
      ],
    );
  }
}

// ========== DIALOG COMPONENTS ==========

class _AddFacultyDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final VoidCallback onClose;
  final VoidCallback onCreate;

  const _AddFacultyDialog({
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.onClose,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      title: "Add Faculty",
      subtitle: "Create a new faculty in the system",
      onClose: onClose,
      content: Column(
        children: [
          _DialogTextField(
            label: "Faculty Name",
            hintText: "e.g., Faculty of Science",
            controller: nameController,
          ),
          const SizedBox(height: 16),
          _DialogTextField(
            label: "Faculty Code",
            hintText: "e.g., SCI",
            controller: codeController,
          ),
          const SizedBox(height: 16),
          _DialogTextArea(
            label: "Description",
            hintText: "Brief description of the faculty",
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
  final FacultyEntity faculty;
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