import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/chapter_model.dart';
import '../../providers/providers.dart';

/// Chapters screen showing domain modules within a phase.
class ChaptersScreen extends ConsumerWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPhase = ref.watch(selectedPhaseProvider);
    final chaptersAsync = ref.watch(chaptersProvider);

    if (selectedPhase == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70), // Space for header
            // Navigation header
            Row(
              children: [
                _BackButton(
                  onTap: () {
                    ref.read(selectedPhaseProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapters',
                        style: AppTypography.screenTitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: chaptersAsync.when(
                data: (chapters) => ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    return _ChapterCard(
                      chapter: chapters[index],
                      onTap: () {
                        ref.read(selectedChapterProvider.notifier).state = chapters[index];
                      },
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: index * 50),
                          duration: 300.ms,
                        )
                        .slideX(
                          begin: 0.1,
                          end: 0,
                          delay: Duration(milliseconds: index * 50),
                          duration: 300.ms,
                        );
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.emeraldPrimary,
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Error loading chapters',
                    style: AppTypography.bodyText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Back button widget
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          LucideIcons.chevronLeft,
          size: 20,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Individual chapter card widget
class _ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final VoidCallback onTap;

  const _ChapterCard({
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = chapter.isComplete;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.name,
                    style: AppTypography.chapterTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chapter.progressDisplay,
                    style: AppTypography.progressText.copyWith(
                      color: isComplete
                          ? AppColors.emeraldPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isComplete
                    ? AppColors.emeraldPrimary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.arrowRight,
                size: 20,
                color: isComplete
                    ? AppColors.emeraldPrimary
                    : AppColors.textPrimary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
