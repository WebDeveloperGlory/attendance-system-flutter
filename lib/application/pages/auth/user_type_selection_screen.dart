import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                  bottom: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: const Icon(LucideIcons.fingerprint, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Smart Attendance',
                          style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                      Text('System',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),

            // Main body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Column(
                  children: [
                    // Hero
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.1),
                                colorScheme.primary.withValues(alpha: 0.2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(LucideIcons.fingerprint,
                              color: colorScheme.primary, size: 28),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Smart Attendance System',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Secure biometric attendance management for universities.\nFast, reliable, and proxy-proof.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Features
                    Column(
                      children: [
                        _FeatureItem(
                            icon: LucideIcons.lock, text: 'Biometric Verification', colorScheme: colorScheme),
                        _FeatureItem(
                            icon: LucideIcons.shield, text: 'Secure & Encrypted', colorScheme: colorScheme),
                        _FeatureItem(
                            icon: LucideIcons.users, text: 'Real-Time Analytics', colorScheme: colorScheme),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Portal Cards
                    _PortalCard(
                      title: 'Admin Portal',
                      subtitle: 'Manage users and system',
                      icon: LucideIcons.shield,
                      points: const [
                        'Register students & lecturers',
                        'Manage faculties & departments',
                        'Oversee fingerprint enrollment'
                      ],
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: 16),
                    _PortalCard(
                      title: 'Lecturer Portal',
                      subtitle: 'Record & manage attendance',
                      icon: LucideIcons.users,
                      points: const [
                        'Create classes & groups',
                        'Capture biometric attendance',
                        'View real-time analytics'
                      ],
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),

                    const SizedBox(height: 24),

                    // Footer
                    Text('Secure • Reliable • Efficient',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable widgets ---

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> points;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _PortalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.points,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.go('/${title.toLowerCase().split(' ').first}-login');
      },
      child: Ink(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 24),
                ),
                Icon(LucideIcons.arrowRight, color: colorScheme.primary, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(title,
                style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            Text(subtitle,
                style:
                    textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            ...points
                .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text('• ', style: TextStyle(color: colorScheme.primary)),
                          Expanded(
                              child: Text(p,
                                  style: textTheme.bodySmall
                                      ?.copyWith(color: colorScheme.onSurfaceVariant))),
                        ],
                      ),
                    )),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Sign In',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Icon(LucideIcons.arrowRight, color: colorScheme.primary, size: 16),
              ],
            )
          ],
        ),
      ),
    );
  }
}
