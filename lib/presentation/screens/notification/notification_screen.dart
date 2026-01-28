import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/providers.dart';

/// Notification screen showing user stats and progress.
class NotificationScreen extends ConsumerWidget {
  final VoidCallback onClose;

  const NotificationScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingScreen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Your Progress',
                    style: AppTypography.screenTitle,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Stats
              statsAsync.when(
                data: (stats) => Column(
                  children: [
                    _StatCard(
                      icon: LucideIcons.flame,
                      label: 'Current Streak',
                      value: '${stats.streak} days',
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      icon: LucideIcons.graduationCap,
                      label: 'Words Learned',
                      value: '${stats.wordsLearned} / ${stats.totalWords}',
                      color: AppColors.emeraldPrimary,
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      icon: LucideIcons.bookmark,
                      label: 'Words Saved',
                      value: stats.wordsFavorited.toString(),
                      color: Colors.purple,
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.emeraldPrimary,
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Error loading stats',
                    style: AppTypography.bodyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.description,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.phaseTitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
