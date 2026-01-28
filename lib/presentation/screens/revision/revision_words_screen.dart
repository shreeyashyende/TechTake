import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';
import '../../providers/providers.dart';

/// Screen showing all words that need revision grouped by chapter.
class RevisionWordsScreen extends ConsumerWidget {
  final VoidCallback onClose;

  const RevisionWordsScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revisionAsync = ref.watch(needsRevisionProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70), // Space for header
            // Header row
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Needs Revision',
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: 2),
                      revisionAsync.when(
                        data: (grouped) {
                          final count = grouped.values.fold<int>(
                            0,
                            (sum, list) => sum + list.length,
                          );
                          return Text(
                            '$count WORDS TO REVIEW',
                            style: AppTypography.subtitle,
                          );
                        },
                        loading: () => Text(
                          'LOADING...',
                          style: AppTypography.subtitle,
                        ),
                        error: (_, __) => Text(
                          '0 WORDS TO REVIEW',
                          style: AppTypography.subtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    LucideIcons.alertCircle,
                    size: 24,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: revisionAsync.when(
                data: (grouped) {
                  if (grouped.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _RevisionWordsList(grouped: grouped);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: AppColors.textPrimary.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No words need revision',
            style: AppTypography.bodyText,
          ),
          const SizedBox(height: 8),
          Text(
            'Great job! Keep learning new words',
            style: AppTypography.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Revision words list widget
class _RevisionWordsList extends ConsumerWidget {
  final Map<String, List<WordModel>> grouped;

  const _RevisionWordsList({required this.grouped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.folder,
                    size: 14,
                    color: Colors.orange.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.key.toUpperCase(),
                    style: AppTypography.groupHeader,
                  ),
                ],
              ),
            ),
            // Words grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: entry.value.length,
              itemBuilder: (context, wordIndex) {
                final word = entry.value[wordIndex];
                return _RevisionWordPill(
                  word: word,
                  onTap: () {
                    // Get all revision words as a flat list for swipeable navigation
                    final allRevision = grouped.values.expand((list) => list).toList();
                    final globalIndex = allRevision.indexOf(word);
                    ref.read(swipeableWordsProvider.notifier).state = allRevision;
                    ref.read(selectedWordIndexProvider.notifier).state = globalIndex >= 0 ? globalIndex : 0;
                    ref.read(selectedWordProvider.notifier).state = word;
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: (wordIndex % 10) * 30),
                      duration: 200.ms,
                    );
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

/// Revision word pill widget
class _RevisionWordPill extends StatelessWidget {
  final WordModel word;
  final VoidCallback onTap;

  const _RevisionWordPill({
    required this.word,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.pillRadius),
          border: Border.all(
            color: Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            word.word.toUpperCase(),
            style: AppTypography.wordPill.copyWith(
              color: Colors.orange,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
