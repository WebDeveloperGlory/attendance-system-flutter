import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/lecturer/create_class/cubit/create_class_cubit.dart';
import 'package:smart_attendance_system/injection_container.dart';

class CreateClassSessionScreen extends StatelessWidget {
  const CreateClassSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateClassCubit>()..loadInitialData(),
      child: const _CreateClassSessionContent(),
    );
  }
}

class _CreateClassSessionContent extends StatelessWidget {
  const _CreateClassSessionContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<CreateClassCubit, CreateClassState>(
      listener: (context, state) {
        if (state.status == CreateClassStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Class session created successfully!'),
              backgroundColor: theme.colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.push('/lecturer/dashboard');
            }
          });
        }

        if (state.status == CreateClassStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure?.message ?? 'An error occurred'),
              backgroundColor: theme.colorScheme.error,
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
                _buildHeader(context, theme),
                // Content
                Expanded(child: _buildContent(context, state, theme)),
                // Bottom Navigation
                _buildBottomNavigation(context, state, theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Back Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surface,
              ),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Class Session",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  BlocBuilder<CreateClassCubit, CreateClassState>(
                    builder: (context, state) {
                      final step = state.currentStep;
                      return Text(
                        "Step $step of 3",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CreateClassState state,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    if (state.status == CreateClassStatus.loading && state.currentStep == 1) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress Bar
          _buildProgressBar(context, state, colorScheme),
          const SizedBox(height: 16),
          // Step Indicators
          _buildStepIndicators(context, state, colorScheme),
          const SizedBox(height: 16),
          // Step Content
          _buildStepContent(context, state, theme),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    CreateClassState state,
    ColorScheme colorScheme,
  ) {
    final progress = (state.currentStep / 3) * 100;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress",
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              "${progress.round()}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: state.currentStep / 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicators(
    BuildContext context,
    CreateClassState state,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: List.generate(3, (index) {
        final stepNum = index + 1;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            decoration: BoxDecoration(
              color: stepNum <= state.currentStep
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    CreateClassState state,
    ThemeData theme,
  ) {
    switch (state.currentStep) {
      case 1:
        return _buildStep1(context, state, theme);
      case 2:
        return _buildStep2(context, state, theme);
      case 3:
        return _buildStep3(context, state, theme);
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1(
    BuildContext context,
    CreateClassState state,
    ThemeData theme,
  ) {
    final cubit = context.read<CreateClassCubit>();
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        // Course Selection Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    "Select Course",
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Course",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: state.courseId.isEmpty ? null : state.courseId,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        fillColor: colorScheme.surface,
                      ),
                      dropdownColor: colorScheme.surface,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            "Select a course...",
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        ...state.lecturerCourses.map((course) {
                          return DropdownMenuItem(
                            value: course.id,
                            child: Text(
                              "${course.code} - ${course.name}",
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        cubit.updateCourse(value ?? '');
                      },
                    ),
                  ),
                ],
              ),
              if (state.selectedCourse != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Level ${state.selectedCourse!.level}",
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "•",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.selectedCourse!.department.name,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${state.selectedCourse!.students.length} students enrolled",
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Topic Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Class Topic",
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Topic/Description",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) => cubit.updateTopic(value),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g., Binary Trees and Traversal",
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(
    BuildContext context,
    CreateClassState state,
    ThemeData theme,
  ) {
    final cubit = context.read<CreateClassCubit>();
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        // Schedule Details Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Schedule Details",
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  // Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.5),
                          ),
                        ),
                        child: TextField(
                          controller: TextEditingController(text: state.date),
                          readOnly: true,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 1),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(
                                    context,
                                  ).copyWith(colorScheme: colorScheme),
                                  child: child!,
                                );
                              },
                            );
                            if (selectedDate != null) {
                              cubit.updateDate(selectedDate);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Select date",
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            fillColor: colorScheme.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Time
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Time",
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.outline.withValues(alpha: 0.5),
                                ),
                              ),
                              child: TextField(
                                controller: TextEditingController(
                                  text: state.startTime,
                                ),
                                readOnly: true,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(
                                          context,
                                        ).copyWith(colorScheme: colorScheme),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (selectedTime != null) {
                                    cubit.updateStartTime(selectedTime);
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Start time",
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.access_time,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  fillColor: colorScheme.surface,
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
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.outline.withValues(alpha: 0.5),
                                ),
                              ),
                              child: TextField(
                                controller: TextEditingController(
                                  text: state.endTime,
                                ),
                                readOnly: true,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(
                                          context,
                                        ).copyWith(colorScheme: colorScheme),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (selectedTime != null) {
                                    cubit.updateEndTime(selectedTime);
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "End time",
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.access_time,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  fillColor: colorScheme.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Venue
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Venue/Location",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) => cubit.updateVenue(value),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: "e.g., Room 101, Building A",
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(color: colorScheme.outline),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Session Preview
        if (state.date.isNotEmpty && state.startTime.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Session Preview",
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(state.date),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${state.startTime} - ${state.endTime}",
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (state.venue.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.venue,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStep3(
    BuildContext context,
    CreateClassState state,
    ThemeData theme,
  ) {
    final cubit = context.read<CreateClassCubit>();
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final totalStudents =
        (state.selectedCourse?.students.length ?? 0) +
        state.carryoverStudents.length;

    return Column(
      children: [
        // Course Students Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.people, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    "Course Students",
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "${state.selectedCourse?.students.length ?? 0} students enrolled in ${state.selectedCourse?.code}",
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              if (state.status == CreateClassStatus.loading)
                Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                )
              else
                SizedBox(
                  height: 256,
                  child: ListView.builder(
                    itemCount: state.selectedCourse?.students.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Student enrolled in course",
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    "Will be automatically included",
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Carryover Students Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_add, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    "Add Carryover Students",
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Optional: Add students from other levels taking this course",
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              // Search and Add Carryover
              Column(
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    child: TextField(
                      controller: TextEditingController(
                        text: state.carryoverSearch,
                      ),
                      onChanged: (value) => cubit.updateCarryoverSearch(value),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search students...",
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        fillColor: colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Carryover Students List
                  if (state.filteredCarryoverStudents.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: state.filteredCarryoverStudents.length,
                        itemBuilder: (context, index) {
                          final student =
                              state.filteredCarryoverStudents[index];
                          final isAdded = state.carryoverStudents.any(
                            (s) => s.id == student.id,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isAdded
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isAdded
                                    ? Colors.green.withValues(alpha: 0.3)
                                    : colorScheme.outline.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.name,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        student.matricNumber ??
                                            'No matric number',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        "Level ${student.level ?? 'N/A'} • ${student.department?.name ?? 'No department'}",
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isAdded)
                                  IconButton(
                                    onPressed: () =>
                                        cubit.addCarryoverStudent(student.id),
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 20,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (state.carryoverStudents.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${state.carryoverStudents.length} carryover student${state.carryoverStudents.length != 1 ? 's' : ''} added",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...state.carryoverStudents.map((student) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.name,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        student.matricNumber ??
                                            'No matric number',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      cubit.removeCarryoverStudent(student.id),
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Total Students Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Students",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                "$totalStudents",
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    CreateClassState state,
    ThemeData theme,
  ) {
    final cubit = context.read<CreateClassCubit>();
    final colorScheme = theme.colorScheme;
    final canProceed = state.currentStep == 1
        ? state.courseId.isNotEmpty && state.topic.isNotEmpty
        : state.currentStep == 2
        ? state.date.isNotEmpty &&
              state.startTime.isNotEmpty &&
              state.endTime.isNotEmpty
        : true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          if (state.currentStep > 1) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: state.status == CreateClassStatus.loading
                    ? null
                    : () => cubit.previousStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outline),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Back"),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed:
                  state.status == CreateClassStatus.loading || !canProceed
                  ? null
                  : () {
                      if (state.currentStep < 3) {
                        cubit.nextStep();
                      } else {
                        cubit.createClassSession();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.status == CreateClassStatus.loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.currentStep == 3)
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                        if (state.currentStep == 3) const SizedBox(width: 8),
                        Text(
                          state.currentStep < 3 ? "Next" : "Create Session",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (state.currentStep < 3) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${_getWeekday(date.weekday)}, ${_getMonth(date.month)} ${date.day}, ${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
