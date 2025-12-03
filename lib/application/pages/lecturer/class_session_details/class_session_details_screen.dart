import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/lecturer/class_session_details/cubit/class_session_cubit.dart';
import 'package:smart_attendance_system/domain/entities/class_session_entity.dart';
import 'package:smart_attendance_system/injection_container.dart';

class ClassSessionDetailsScreen extends StatelessWidget {
  final String classId;

  const ClassSessionDetailsScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassSessionCubit(
        getClassSessionUseCase: getIt(),
        updateAttendanceStatusUseCase: getIt(),
        classId: classId,
      ),
      child: const _ClassSessionDetailsContent(),
    );
  }
}

class _ClassSessionDetailsContent extends StatelessWidget {
  const _ClassSessionDetailsContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ClassSessionCubit, ClassSessionState>(
      listener: (context, state) {
        if (state.status == ClassSessionStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure?.message ?? 'An error occurred'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ClassSessionStatus.loading) {
          return _buildLoadingState(theme);
        }

        if (state.status == ClassSessionStatus.error &&
            state.classSession == null) {
          return _buildErrorState(context, theme);
        }

        if (state.classSession == null) {
          return _buildEmptyState(theme);
        }

        return _buildContent(context, state, theme);
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Loading class session...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load class session',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<ClassSessionCubit>().loadClassSession(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'Class session not found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested class session could not be found',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ClassSessionState state,
    ThemeData theme,
  ) {
    final cubit = context.read<ClassSessionCubit>();
    final classSession = state.classSession!;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(
              context,
              classSession,
              cubit,
              state.showMenu,
              colorScheme,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Class Info Card
                    _buildClassInfoCard(classSession, colorScheme),

                    const SizedBox(height: 16),

                    // Attendance Stats
                    _buildAttendanceStats(classSession.stats, colorScheme),

                    const SizedBox(height: 16),

                    // Attendance Rate Card
                    _buildAttendanceRateCard(
                      classSession.stats.attendanceRate,
                      state.fingerprintVerifiedCount,
                      colorScheme,
                    ),

                    const SizedBox(height: 16),

                    // Attendance Session Control
                    _buildAttendanceSessionControl(
                      cubit,
                      state.isAttendanceActive,
                      colorScheme,
                    ),

                    const SizedBox(height: 16),

                    // Student List
                    _buildStudentList(cubit, state, colorScheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ClassSessionEntity classSession,
    ClassSessionCubit cubit,
    bool showMenu,
    ColorScheme colorScheme,
  ) {
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
                    "Class Session",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    classSession.date.toLocal().toString().split(' ')[0],
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Menu Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surface,
              ),
              child: IconButton(
                onPressed: () => cubit.toggleMenu(!showMenu),
                icon: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassInfoCard(
    ClassSessionEntity classSession,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Session Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.person,
            "Lecturer:",
            classSession.lecturer.name,
            colorScheme,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            "Date:",
            _formatDate(classSession.date),
            colorScheme,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.access_time,
            "Time:",
            _formatTimeRange(classSession.startTime, classSession.endTime),
            colorScheme,
          ),
          const SizedBox(height: 8),
          if (classSession.venue != null && classSession.venue!.isNotEmpty)
            _buildInfoRow(
              Icons.location_on,
              "Venue:",
              classSession.venue!,
              colorScheme,
            ),
          if (classSession.topic != null && classSession.topic!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Topic",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    classSession.topic!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceStats(ClassStats stats, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            stats.totalStudents.toString(),
            "Total",
            colorScheme.primary,
            colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            stats.present.toString(),
            "Present",
            Colors.green,
            colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            stats.absent.toString(),
            "Absent",
            Colors.red,
            colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRateCard(
    double attendanceRate,
    int fingerprintCount,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attendance Rate",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                "${attendanceRate.round()}%",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: attendanceRate / 100,
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
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.fingerprint,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                "$fingerprintCount fingerprint verified",
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSessionControl(
    ClassSessionCubit cubit,
    bool isAttendanceActive,
    ColorScheme colorScheme,
  ) {
    if (!isAttendanceActive) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.primaryContainer],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => cubit.toggleAttendanceSession(true),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow,
                    size: 20,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Start Attendance Session",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Attendance Session Active",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => cubit.toggleAttendanceSession(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.stop, size: 16),
                    SizedBox(width: 4),
                    Text("End Session"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Scanner ready. Students can now check in with fingerprint.",
            style: TextStyle(fontSize: 12, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(
    ClassSessionCubit cubit,
    ClassSessionState state,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Students",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => cubit.toggleAddStudentDialog(true),
                icon: Icon(
                  Icons.person_add,
                  size: 16,
                  color: colorScheme.onSurface,
                ),
                label: Text(
                  "Add",
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
            ),
            child: TextField(
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: "Search students...",
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                ),
                fillColor: colorScheme.surface,
              ),
              onChanged: cubit.updateSearchQuery,
            ),
          ),
          const SizedBox(height: 16),
          // Student List
          Column(
            children: state.filteredAttendanceRecords.map((record) {
              return _buildStudentCard(
                cubit,
                record,
                state.isAttendanceActive,
                colorScheme,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
    ClassSessionCubit cubit,
    AttendanceRecord record,
    bool isAttendanceActive,
    ColorScheme colorScheme,
  ) {
    final statusColor = _getStatusColor(record.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.student.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  record.student.matricNumber,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (record.timestamp != null)
                  Text(
                    _formatTime(record.timestamp!),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          // Status and Actions
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(record.status),
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.status.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAttendanceActive && record.status == 'absent')
                TextButton(
                  onPressed: () {
                    cubit.updateAttendanceStatus(
                      attendanceRecordId: record.id,
                      status: 'present',
                      verifiedByFingerprint: false,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                  child: Text(
                    "Mark",
                    style: TextStyle(fontSize: 12, color: colorScheme.primary),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    return "${_getWeekday(date.weekday)}, ${_getMonth(date.month)} ${date.day}, ${date.year}";
  }

  String _formatTimeRange(DateTime? startTime, DateTime? endTime) {
    if (startTime == null && endTime == null) return 'Not scheduled';
    if (startTime == null) return 'Ends at ${_formatTime(endTime!)}';
    if (endTime == null) return 'Starts at ${_formatTime(startTime)}';
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _getWeekday(int weekday) {
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
