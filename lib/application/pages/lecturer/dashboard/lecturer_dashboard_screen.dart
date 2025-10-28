import 'package:flutter/material.dart';

class LecturerDashboardScreen extends StatelessWidget {
  const LecturerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final List<Course> lecturerCourses = [
      Course(
        id: "course-1",
        name: "Data Structures",
        code: "CSC 301",
        level: "300",
        department: "Computer Science",
        faculty: "Science",
        studentCount: 45,
        schedule: ClassSchedule(
          dayOfWeek: "Monday",
          startTime: "10:00",
          endTime: "12:00",
        ),
        isActive: true,
      ),
      Course(
        id: "course-2",
        name: "Algorithm Design",
        code: "CSC 401",
        level: "400",
        department: "Computer Science",
        faculty: "Science",
        studentCount: 38,
        schedule: ClassSchedule(
          dayOfWeek: "Wednesday",
          startTime: "14:00",
          endTime: "16:00",
        ),
        isActive: true,
      ),
      Course(
        id: "course-3",
        name: "Programming II",
        code: "CSC 201",
        level: "200",
        department: "Computer Science",
        faculty: "Science",
        studentCount: 52,
        schedule: ClassSchedule(
          dayOfWeek: "Friday",
          startTime: "09:00",
          endTime: "11:00",
        ),
        isActive: true,
      ),
    ];

    final List<ClassSession> upcomingClassSessions = [
      ClassSession(
        id: "class-1",
        courseCode: "CSC 301",
        courseName: "Data Structures",
        date: "Today",
        startTime: "10:00 AM",
        endTime: "12:00 PM",
        topic: "Binary Trees and Traversal",
        studentCount: 45,
        status: "upcoming",
      ),
      ClassSession(
        id: "class-2",
        courseCode: "CSC 401",
        courseName: "Algorithm Design",
        date: "Today",
        startTime: "2:00 PM",
        endTime: "4:00 PM",
        topic: "Dynamic Programming",
        studentCount: 38,
        status: "upcoming",
      ),
      ClassSession(
        id: "class-3",
        courseCode: "CSC 201",
        courseName: "Programming II",
        date: "Tomorrow",
        startTime: "9:00 AM",
        endTime: "11:00 AM",
        topic: "Object-Oriented Programming",
        studentCount: 52,
        status: "scheduled",
      ),
    ];

    final List<AttendanceRecord> recentAttendanceRecords = [
      AttendanceRecord(
        courseCode: "CSC 301",
        courseName: "Data Structures",
        date: "Oct 23, 2025",
        totalStudents: 45,
        presentCount: 42,
        fingerprintVerified: 40,
        manualOverride: 2,
      ),
      AttendanceRecord(
        courseCode: "CSC 401",
        courseName: "Algorithm Design",
        date: "Oct 22, 2025",
        totalStudents: 38,
        presentCount: 35,
        fingerprintVerified: 33,
        manualOverride: 2,
      ),
      AttendanceRecord(
        courseCode: "CSC 201",
        courseName: "Programming II",
        date: "Oct 21, 2025",
        totalStudents: 52,
        presentCount: 48,
        fingerprintVerified: 46,
        manualOverride: 2,
      ),
    ];

    final List<StatCardData> stats = [
      StatCardData(
        title: "Active Courses",
        value: lecturerCourses.where((c) => c.isActive).length.toString(),
        icon: Icons.menu_book,
        description: "Assigned",
      ),
      StatCardData(
        title: "Total Students",
        value: lecturerCourses.fold(0, (sum, c) => sum + c.studentCount).toString(),
        icon: Icons.people,
        description: "All courses",
      ),
      StatCardData(
        title: "Avg. Attendance",
        value: "92%",
        icon: Icons.trending_up,
        description: "Last 3 sessions",
      ),
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
              ),
              child: Padding(
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
                        onPressed: () {
                          // TODO: Implement menu toggle
                        },
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Courses",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Dr. Sarah Johnson",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification Button
                    Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surface,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // TODO: Implement notifications
                            },
                            icon: Icon(
                              Icons.notifications_outlined,
                              size: 20,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Stats Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        return _buildStatCard(context, stats[index]);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Quick Create Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withValues(alpha: 0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // TODO: Implement create class session
                          },
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 20,
                                  color: colorScheme.onPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Create New Class Session",
                                  style: textTheme.labelLarge?.copyWith(
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

                    const SizedBox(height: 24),

                    // Upcoming Sessions
                    _buildUpcomingSessionsSection(context, upcomingClassSessions),

                    const SizedBox(height: 24),

                    // My Courses Section
                    _buildMyCoursesSection(context, lecturerCourses),

                    const SizedBox(height: 24),

                    // Recent Attendance Summary
                    _buildRecentAttendanceSection(context, recentAttendanceRecords),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, StatCardData stat) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              stat.icon,
              size: 20,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            stat.description,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessionsSection(BuildContext context, List<ClassSession> sessions) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Sessions",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement view all sessions
              },
              child: Text(
                "View All",
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: sessions.map((session) {
            return _buildSessionCard(context, session);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSessionCard(BuildContext context, ClassSession session) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.menu_book,
                    size: 24,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              session.courseCode,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              session.date,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        session.courseName,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.topic,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${session.startTime} - ${session.endTime}",
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
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
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${session.studentCount}",
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            if (session.status == "upcoming") ...[
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // TODO: Implement start attendance
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fingerprint,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Start Attendance",
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
          ],
        ),
      ),
    );
  }

  Widget _buildMyCoursesSection(BuildContext context, List<Course> courses) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          "My Courses",
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        // TODO: Add search and filter functionality
        Text(
          "Search and filter functionality would be implemented here",
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Courses List
        Column(
          children: courses.map((course) {
            return _buildCourseCard(context, course);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    course.code,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Level ${course.level}",
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              course.name,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${course.department} • ${course.faculty}",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${course.studentCount} students",
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      course.schedule.dayOfWeek,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      course.schedule.startTime,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                // TODO: Implement view course details
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("View Course Details"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAttendanceSection(BuildContext context, List<AttendanceRecord> records) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Attendance",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: records.map((record) {
              return _buildAttendanceRecord(context, record);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRecord(BuildContext context, AttendanceRecord record) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final percentage = ((record.presentCount / record.totalStudents) * 100).round();

    Color progressColor;
    if (percentage >= 85) {
      progressColor = Colors.green;
    } else if (percentage >= 70) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.courseName,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      record.date,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${record.presentCount}/${record.totalStudents}",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "$percentage%",
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
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
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progressColor,
                      progressColor.withValues(alpha: 0.8),
                    ],
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
                "${record.fingerprintVerified} verified",
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "•",
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${record.manualOverride} manual",
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Data Models
class Course {
  final String id;
  final String name;
  final String code;
  final String level;
  final String department;
  final String faculty;
  final int studentCount;
  final ClassSchedule schedule;
  final bool isActive;

  const Course({
    required this.id,
    required this.name,
    required this.code,
    required this.level,
    required this.department,
    required this.faculty,
    required this.studentCount,
    required this.schedule,
    required this.isActive,
  });
}

class ClassSchedule {
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  const ClassSchedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}

class ClassSession {
  final String id;
  final String courseCode;
  final String courseName;
  final String date;
  final String startTime;
  final String endTime;
  final String topic;
  final int studentCount;
  final String status;

  const ClassSession({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.studentCount,
    required this.status,
  });
}

class AttendanceRecord {
  final String courseCode;
  final String courseName;
  final String date;
  final int totalStudents;
  final int presentCount;
  final int fingerprintVerified;
  final int manualOverride;

  const AttendanceRecord({
    required this.courseCode,
    required this.courseName,
    required this.date,
    required this.totalStudents,
    required this.presentCount,
    required this.fingerprintVerified,
    required this.manualOverride,
  });
}

class StatCardData {
  final String title;
  final String value;
  final IconData icon;
  final String description;

  const StatCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.description,
  });
}