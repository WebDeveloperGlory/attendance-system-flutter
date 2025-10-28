import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final List<StatCardData> stats = [
      StatCardData(
        title: "Total Students",
        value: "2,847",
        change: "+12%",
        active: 2734,
        inactive: 113,
        icon: Icons.people,
      ),
      StatCardData(
        title: "Total Lecturers",
        value: "156",
        change: "+3%",
        active: 148,
        inactive: 8,
        icon: Icons.school,
      ),
      StatCardData(
        title: "Faculties",
        value: "8",
        change: "0%",
        active: 8,
        inactive: 0,
        icon: Icons.business,
      ),
      StatCardData(
        title: "Attendance Rate",
        value: "87.3%",
        change: "+2.1%",
        icon: Icons.trending_up,
      ),
    ];

    final List<QuickActionData> quickActions = [
      QuickActionData(
        title: "Register Student",
        icon: Icons.person_add,
      ),
      QuickActionData(
        title: "Add Lecturer",
        icon: Icons.school,
      ),
      QuickActionData(
        title: "Create Class",
        icon: Icons.class_,
      ),
      QuickActionData(
        title: "Manage Faculties",
        icon: Icons.business,
      ),
    ];

    final List<ActivityData> recentActivity = [
      ActivityData(
        type: ActivityType.success,
        message: "New student registered: John Doe (CS/2024/001)",
        time: "5 mins ago",
      ),
      ActivityData(
        type: ActivityType.warning,
        message: "23 students pending fingerprint enrollment",
        time: "15 mins ago",
      ),
      ActivityData(
        type: ActivityType.success,
        message: "Attendance marked for CSC 301 - 45/50 present",
        time: "1 hour ago",
      ),
      ActivityData(
        type: ActivityType.info,
        message: "New lecturer added: Dr. Sarah Johnson",
        time: "2 hours ago",
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Changed to background
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline, // Increased opacity
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
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // TODO: Implement menu toggle
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
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
                            "Dashboard",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Welcome back, Admin",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification & Search Buttons
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // TODO: Implement notifications
                                },
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.onSurface,
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
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // TODO: Implement search
                            },
                            icon: Icon(
                              Icons.search,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
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
                padding: const EdgeInsets.all(12), // Reduced padding
                child: Column(
                  children: [
                    // Stats Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10, // Reduced spacing
                        mainAxisSpacing: 10, // Reduced spacing
                        childAspectRatio: 1.1,
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        return _buildStatCard(context, stats[index]);
                      },
                    ),

                    const SizedBox(height: 20), // Reduced spacing

                    // Quick Actions
                    _buildQuickActionsSection(context, quickActions),

                    const SizedBox(height: 20), // Reduced spacing

                    // Attendance Overview
                    _buildAttendanceOverview(context),

                    const SizedBox(height: 20), // Reduced spacing

                    // Recent Activity
                    _buildRecentActivitySection(context, recentActivity),

                    const SizedBox(height: 60), // Reduced space for bottom navigation
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), // Increased opacity
          width: 1.5, // Added border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42, // Slightly smaller
                height: 42, // Slightly smaller
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  stat.icon,
                  color: Colors.white,
                  size: 22, // Slightly smaller
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Reduced padding
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8), // Smaller radius
                ),
                child: Text(
                  stat.change,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF166534),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Reduced spacing
          Text(
            stat.value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith( // Changed to titleLarge
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            stat.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (stat.active > 0) ...[
            const SizedBox(height: 10), // Reduced spacing
            Container(
              height: 1,
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), // Increased opacity
            ),
            const SizedBox(height: 6), // Reduced spacing
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${stat.active}",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10), // Reduced spacing
                Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${stat.inactive}",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, List<QuickActionData> actions) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quick Actions",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement view all
              },
              child: Text(
                "View All",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Reduced spacing
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10, // Reduced spacing
            mainAxisSpacing: 10, // Reduced spacing
            childAspectRatio: 1.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            return _buildQuickActionCard(context, actions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(BuildContext context, QuickActionData action) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), // Increased opacity
          width: 1.5, // Added border width
        ),
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
          onTap: () {
            // TODO: Implement quick action
          },
          child: Padding(
            padding: const EdgeInsets.all(14), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, // Slightly smaller
                  height: 44, // Slightly smaller
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    action.icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22, // Slightly smaller
                  ),
                ),
                const SizedBox(height: 10), // Reduced spacing
                Text(
                  action.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceOverview(BuildContext context) {
    final List<Map<String, dynamic>> days = [
      {"day": "Monday", "percentage": 92},
      {"day": "Tuesday", "percentage": 88},
      {"day": "Wednesday", "percentage": 85},
      {"day": "Thursday", "percentage": 90},
      {"day": "Friday", "percentage": 87},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), // Increased opacity
          width: 1.5, // Added border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16), // Reduced padding
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attendance Overview",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Reduced padding
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest, // Changed to surfaceVariant
                  borderRadius: BorderRadius.circular(10), // Smaller radius
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "This Week",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14), // Reduced spacing
          Column(
            children: days.map((dayData) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14), // Reduced spacing
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dayData["day"],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${dayData["percentage"]}%",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6), // Reduced spacing
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest, // Changed for better contrast
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: dayData["percentage"] / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
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

  Widget _buildRecentActivitySection(BuildContext context, List<ActivityData> activities) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), // Increased opacity
          width: 1.5, // Added border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16), // Reduced padding
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Activity",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Implement view all activities
                },
                child: Text(
                  "View All",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14), // Reduced spacing
          Column(
            children: activities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10), // Reduced spacing
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest, // Changed for better contrast
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), // Increased opacity
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getActivityIcon(activity.type),
                        size: 16,
                        color: _getActivityColor(context, activity.type),
                      ),
                      const SizedBox(width: 10), // Reduced spacing
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.message,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 3), // Reduced spacing
                            Text(
                              activity.time,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.success:
        return Icons.check_circle;
      case ActivityType.warning:
        return Icons.access_time;
      case ActivityType.info:
        return Icons.info;
    }
  }

  Color _getActivityColor(BuildContext context, ActivityType type) {
    switch (type) {
      case ActivityType.success:
        return Colors.green.shade600;
      case ActivityType.warning:
      case ActivityType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

// Data Models (unchanged)
class StatCardData {
  final String title;
  final String value;
  final String change;
  final int active;
  final int inactive;
  final IconData icon;

  StatCardData({
    required this.title,
    required this.value,
    required this.change,
    this.active = 0,
    this.inactive = 0,
    required this.icon,
  });
}

class QuickActionData {
  final String title;
  final IconData icon;

  QuickActionData({
    required this.title,
    required this.icon,
  });
}

enum ActivityType { success, warning, info }

class ActivityData {
  final ActivityType type;
  final String message;
  final String time;

  ActivityData({
    required this.type,
    required this.message,
    required this.time,
  });
}