import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';
import '../../providers/providers.dart';

/// Saved screen showing the user's Knowledge Bank (favorited words).
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70), // Space for header
            // Header with bookmark icon
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Knowledge Bank',
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: 4),
                      favoritesAsync.when(
                        data: (grouped) {
                          final count = grouped.values.fold<int>(
                            0,
                            (sum, list) => sum + list.length,
                          );
                          return Text(
                            '$count SAVED TERMS',
                            style: AppTypography.subtitle,
                          );
                        },
                        loading: () => Text(
                          'LOADING...',
                          style: AppTypography.subtitle,
                        ),
                        error: (_, __) => Text(
                          '0 SAVED TERMS',
                          style: AppTypography.subtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.emeraldPrimary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    LucideIcons.bookmark,
                    size: 24,
                    color: AppColors.emeraldPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: favoritesAsync.when(
                data: (grouped) {
                  if (grouped.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _FavoritesList(grouped: grouped);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.emeraldPrimary,
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Error loading favorites',
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
            LucideIcons.bookmarkMinus,
            size: 48,
            color: AppColors.textPrimary.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No saved terms yet',
            style: AppTypography.bodyText,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the bookmark icon on any word to save it here',
            style: AppTypography.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Favorites list widget
class _FavoritesList extends ConsumerWidget {
  final Map<String, List<WordModel>> grouped;

  const _FavoritesList({required this.grouped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
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
                    color: AppColors.emeraldPrimary.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.key.toUpperCase(),
                    style: AppTypography.groupHeader,
                  ),
                ],
              ),
            ),
            // Words in group
            ...entry.value.asMap().entries.map((wordEntry) {
              return _FavoriteWordTile(
                word: wordEntry.value,
                onTap: () {
                  // Get all favorited words as a flat list for swipeable navigation
                  final allFavorites = grouped.values.expand((list) => list).toList();
                  final globalIndex = allFavorites.indexOf(wordEntry.value);
                  ref.read(swipeableWordsProvider.notifier).state = allFavorites;
                  ref.read(selectedWordIndexProvider.notifier).state = globalIndex >= 0 ? globalIndex : 0;
                  ref.read(selectedWordProvider.notifier).state = wordEntry.value;
                },
                onDelete: () async {
                  final repository = ref.read(masteryRepositoryProvider);
                  await repository.toggleFavorite(wordEntry.value.id);
                  // Update stats
                  final statsRepo = ref.read(statsRepositoryProvider);
                  await statsRepo.updateWordsFavorited();
                  ref.invalidate(favoritesProvider);
                  ref.invalidate(userStatsProvider);
                },
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: wordEntry.key * 30),
                    duration: 200.ms,
                  );
            }),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

/// Favorite word tile widget
class _FavoriteWordTile extends StatelessWidget {
  final WordModel word;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FavoriteWordTile({
    required this.word,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
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
            Expanded(
              child: Text(
                word.word,
                style: AppTypography.chapterTitle.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: AppColors.textPrimary.withOpacity(0.3),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                LucideIcons.trash2,
                size: 16,
                color: AppColors.textPrimary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
