import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';
import '../../providers/providers.dart';

/// Word List screen showing all words in a chapter as pill buttons.
class WordListScreen extends ConsumerWidget {
  const WordListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChapter = ref.watch(selectedChapterProvider);
    final wordsAsync = ref.watch(chapterWordsProvider);

    if (selectedChapter == null) {
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
                    ref.read(selectedChapterProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedChapter.name,
                        style: AppTypography.screenTitle.copyWith(fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SELECT A TERM TO DEFINE',
                        style: AppTypography.subtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: wordsAsync.when(
                data: (words) => GridView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return _WordPill(
                      word: words[index],
                      onTap: () {
                        // Set the words list and index for swipeable navigation
                        ref.read(swipeableWordsProvider.notifier).state = words;
                        ref.read(selectedWordIndexProvider.notifier).state = index;
                        ref.read(selectedWordProvider.notifier).state = words[index];
                      },
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: (index % 10) * 30),
                          duration: 200.ms,
                        )
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                          delay: Duration(milliseconds: (index % 10) * 30),
                          duration: 200.ms,
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
                    'Error loading words',
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
        child: const Icon(
          LucideIcons.chevronLeft,
          size: 20,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Word pill button widget
class _WordPill extends ConsumerWidget {
  final WordModel word;
  final VoidCallback onTap;

  const _WordPill({
    required this.word,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMasteredAsync = ref.watch(wordMasteryProvider(word.id));
    final needsRevisionAsync = ref.watch(wordNeedsRevisionProvider(word.id));

    return isMasteredAsync.when(
      data: (isMastered) {
        return needsRevisionAsync.when(
          data: (needsRevision) => _buildPill(isMastered, needsRevision),
          loading: () => _buildPill(isMastered, false),
          error: (_, __) => _buildPill(isMastered, false),
        );
      },
      loading: () => _buildPill(false, false),
      error: (_, __) => _buildPill(false, false),
    );
  }

  Widget _buildPill(bool isMastered, bool needsRevision) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isMastered) {
      backgroundColor = AppColors.emeraldPrimary.withOpacity(0.1);
      borderColor = AppColors.emeraldPrimary.withOpacity(0.3);
      textColor = AppColors.emeraldPrimary;
    } else if (needsRevision) {
      backgroundColor = Colors.orange.withOpacity(0.1);
      borderColor = Colors.orange.withOpacity(0.3);
      textColor = Colors.orange;
    } else {
      backgroundColor = AppColors.textPrimary.withOpacity(0.05);
      borderColor = AppColors.border;
      textColor = AppColors.textMuted;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.pillRadius),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            word.word.toUpperCase(),
            style: AppTypography.wordPill.copyWith(
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
