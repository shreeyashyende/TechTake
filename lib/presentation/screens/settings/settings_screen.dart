import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/providers.dart';
import '../mastered/mastered_words_screen.dart';
import '../revision/revision_words_screen.dart';

/// Settings screen showing user stats and reset progress option.
class SettingsScreen extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const SettingsScreen({super.key, required this.onClose});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showMasteredWords = false;
  bool _showRevisionWords = false;

  @override
  Widget build(BuildContext context) {
    // Show mastered words screen
    if (_showMasteredWords) {
      return MasteredWordsScreen(
        onClose: () => setState(() => _showMasteredWords = false),
      );
    }

    // Show revision words screen
    if (_showRevisionWords) {
      return RevisionWordsScreen(
        onClose: () => setState(() => _showRevisionWords = false),
      );
    }

    final statsAsync = ref.watch(userStatsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70), // Space for header
            // Title
            Text(
              'Settings',
              style: AppTypography.screenTitle,
            ),
            const SizedBox(height: 24),
            // Stats section
            Text(
              'Your Progress',
              style: AppTypography.phaseTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
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
                  _TappableStatCard(
                    icon: LucideIcons.checkCircle,
                    label: 'Words Mastered',
                    value: '${stats.wordsLearned} / ${stats.totalWords}',
                    color: AppColors.emeraldPrimary,
                    onTap: () => setState(() => _showMasteredWords = true),
                  ),
                  const SizedBox(height: 12),
                  _TappableStatCard(
                    icon: LucideIcons.alertCircle,
                    label: 'Needs Revision',
                    value: stats.wordsNeedsRevision.toString(),
                    color: Colors.orange,
                    onTap: () => setState(() => _showRevisionWords = true),
                  ),
                  const SizedBox(height: 12),
                  _TappableStatCard(
                    icon: LucideIcons.bookmark,
                    label: 'Words Saved',
                    value: stats.wordsFavorited.toString(),
                    color: Colors.purple,
                    onTap: () {
                      // Navigate to Saved tab
                      ref.read(bottomNavIndexProvider.notifier).state = 3;
                      widget.onClose();
                    },
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
            const Spacer(),
            // Reset Progress Button
            _ResetProgressButton(onClose: widget.onClose),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }
}

/// Individual stat card widget (non-tappable)
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

/// Tappable stat card widget with chevron
class _TappableStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _TappableStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: AppColors.textPrimary.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reset progress button with confirmation dialog
class _ResetProgressButton extends ConsumerWidget {
  final VoidCallback onClose;

  const _ResetProgressButton({required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showResetConfirmation(context, ref),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.refreshCcw,
              size: 20,
              color: Colors.red,
            ),
            const SizedBox(width: 12),
            Text(
              'Reset All Progress',
              style: AppTypography.bodyText.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardGradientStart,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Reset Progress?',
          style: AppTypography.phaseTitle.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'This will reset all your mastered words, needs revision, favorites, and streak. This action cannot be undone.',
          style: AppTypography.bodyText.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.bodyText.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _resetProgress(ref);
              onClose();
            },
            child: Text(
              'Reset',
              style: AppTypography.bodyText.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetProgress(WidgetRef ref) async {
    final masteryRepo = ref.read(masteryRepositoryProvider);
    await masteryRepo.resetAllProgress();

    // Invalidate all relevant providers to refresh UI
    ref.invalidate(userStatsProvider);
    ref.invalidate(phasesProvider);
    ref.invalidate(chaptersProvider);
    ref.invalidate(favoritesProvider);
    ref.invalidate(needsRevisionProvider);
    ref.invalidate(masteredWordsProvider);
  }
}
