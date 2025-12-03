import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_attendance_system/application/pages/lecturer/course_details/cubit/lecturer_course_details_cubit.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_course_details_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';
import 'package:smart_attendance_system/injection_container.dart';

class LecturerCourseDetailsScreen extends StatelessWidget {
  final String courseId;

  const LecturerCourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LecturerCourseDetailsCubit(
        getCourseDetailsUseCase: getIt(),
        courseId: courseId,
      ),
      child: const _LecturerCourseDetailsContent(),
    );
  }
}

class _LecturerCourseDetailsContent extends StatelessWidget {
  const _LecturerCourseDetailsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LecturerCourseDetailsCubit, LecturerCourseDetailsState>(
      builder: (context, state) {
        if (state.status == LecturerCourseDetailsStatus.loading) {
          return _buildLoadingState();
        }

        if (state.status == LecturerCourseDetailsStatus.error &&
            state.courseDetails == null) {
          return _buildErrorState(context);
        }

        if (state.courseDetails == null) {
          return _buildEmptyState();
        }

        return _buildContent(context, state);
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading course details...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Failed to load course details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<LecturerCourseDetailsCubit>().refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
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

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Course not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested course could not be found',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LecturerCourseDetailsState state) {
    final cubit = context.read<LecturerCourseDetailsCubit>();
    final courseDetails = state.courseDetails!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, courseDetails, cubit, state.showMenu),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Course Info Card
                    _buildCourseInfoCard(courseDetails),

                    SizedBox(height: 16),

                    // Stats
                    _buildStatsCards(
                      state.enrolledStudentsCount,
                      state.averageAttendancePercentage,
                    ),

                    SizedBox(height: 16),

                    // Upcoming Sessions
                    _buildUpcomingSessionsSection(
                      context,
                      courseDetails.upcomingClasses,
                    ),

                    SizedBox(height: 16),

                    // Recent Attendance
                    _buildRecentAttendanceSection(
                      context,
                      courseDetails.recentAttendance,
                    ),

                    SizedBox(height: 16),

                    // Enrolled Students
                    _buildEnrolledStudentsSection(
                      cubit,
                      state.filteredStudents,
                      state.searchQuery,
                      state.enrolledStudentsCount,
                    ),
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
    LecturerCourseDetailsEntity courseDetails,
    LecturerCourseDetailsCubit cubit,
    bool showMenu,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
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
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.black,
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
                    courseDetails.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    courseDetails.code,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () => cubit.toggleMenu(!showMenu),
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseInfoCard(LecturerCourseDetailsEntity courseDetails) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Course Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.school, "Level:", courseDetails.level),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.business,
            "Department:",
            courseDetails.department,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            "Schedule:",
            courseDetails.schedule.dayOfWeek,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.access_time,
            "Time:",
            '${courseDetails.schedule.startTime} - ${courseDetails.schedule.endTime}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(int studentCount, double avgAttendance) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            studentCount.toString(),
            "Enrolled Students",
            const Color(0xFF2563EB),
            Icons.people,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            "${avgAttendance.round()}%",
            "Avg. Attendance",
            const Color(0xFF10B981),
            Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: Colors.white),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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

  Widget _buildUpcomingSessionsSection(
    BuildContext context,
    List<UpcomingClassEntity> upcomingClasses,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Upcoming Sessions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => context.push('/lecturer/create-class'),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("New"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (upcomingClasses.isEmpty) _buildEmptyUpcomingSessions(),
        if (upcomingClasses.isNotEmpty)
          Column(
            children: upcomingClasses.map((session) {
              return _buildUpcomingSessionCard(context, session);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildUpcomingSessionCard(
    BuildContext context,
    UpcomingClassEntity session,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/lecturer/class/${session.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        session.topic,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      session.formattedDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      session.formattedTime,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildEmptyUpcomingSessions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          const Text(
            "No Upcoming Sessions",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Create a new class session to get started",
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAttendanceSection(
    BuildContext context,
    List<RecentAttendanceEntity> recentAttendance,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Recent Attendance",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        if (recentAttendance.isEmpty) _buildEmptyAttendanceHistory(),
        if (recentAttendance.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: recentAttendance.take(3).map((attendance) {
                return _buildAttendanceItem(context, attendance);
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAttendanceItem(
    BuildContext context,
    RecentAttendanceEntity attendance,
  ) {
    final attendanceRate = attendance.attendanceRate;
    final attendanceColor = _getAttendanceColor(attendanceRate);
    final hasClassId =
        attendance.classId != null && attendance.classId!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: hasClassId
              ? () {
                  // Navigate to class session page
                  context.push('/lecturer/class/${attendance.classId}');
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        attendance.topic.isNotEmpty
                            ? attendance.topic
                            : "Class Session",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hasClassId)
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.grey,
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(attendance.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "${attendanceRate.round()}%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: attendanceColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Attendance Bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: attendanceRate / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            attendanceColor,
                            attendanceColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Stats Row
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${attendance.present} present",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(Icons.cancel, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          "${attendance.absent} absent",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (hasClassId)
                      Text(
                        "View Details",
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF2563EB),
                          fontWeight: FontWeight.w500,
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

  Color _getAttendanceColor(double rate) {
    if (rate >= 90) return const Color(0xFF10B981);
    if (rate >= 80) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _formatDate(DateTime date) {
    final month = _getMonth(date.month);
    final day = date.day;
    final year = date.year;
    return "$month $day, $year";
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

  Widget _buildEmptyAttendanceHistory() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.bar_chart, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          const Text(
            "No Attendance Records",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Attendance records will appear here after classes",
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrolledStudentsSection(
    LecturerCourseDetailsCubit cubit,
    List<StudentEntity> filteredStudents,
    String searchQuery,
    int totalStudents,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Enrolled Students",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        // Search Bar
        Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search students...",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            onChanged: cubit.updateSearchQuery,
          ),
        ),
        const SizedBox(height: 16),
        // Student List
        if (filteredStudents.isEmpty) _buildEmptyStudentsList(),
        if (filteredStudents.isNotEmpty)
          Column(
            children: filteredStudents.map((student) {
              return _buildStudentCard(student);
            }).toList(),
          ),
        // Student Count
        if (filteredStudents.isNotEmpty &&
            filteredStudents.length != totalStudents)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Text(
              "Showing ${filteredStudents.length} of $totalStudents students",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildStudentCard(StudentEntity student) {
    final initials = student.name
        .split(' ')
        .map((name) => name.isNotEmpty ? name[0] : '')
        .join('')
        .toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  student.matricNumber ?? 'N/A',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStudentsList() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.people, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          const Text(
            "No Students Enrolled",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Students enrolled in this course will appear here",
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
