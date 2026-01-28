import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/providers.dart';
import '../../widgets/word_card/word_card.dart';

/// Find screen for searching technical terms.
class FindScreen extends ConsumerStatefulWidget {
  const FindScreen({super.key});

  @override
  ConsumerState<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends ConsumerState<FindScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    ref.read(searchQueryProvider.notifier).state = query;
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70), // Space for header
            Text(
              'Find Knowledge',
              style: AppTypography.screenTitle,
            ),
            const SizedBox(height: 4),
            Text(
              'Search for any technical term to synthesize its definition.',
              style: AppTypography.description,
            ),
            const SizedBox(height: 24),
            // Search input
            _SearchInput(
              controller: _controller,
              focusNode: _focusNode,
              onSearch: _search,
            ),
            const SizedBox(height: 24),
            // Results
            Expanded(
              child: query.isEmpty
                  ? _buildEmptyState()
                  : searchResults.when(
                      data: (words) {
                        if (words.isEmpty) {
                          return _buildNoResults();
                        }
                        if (words.length == 1) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: WordCard(word: words.first)
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .scale(
                                  begin: const Offset(0.95, 0.95),
                                  end: const Offset(1, 1),
                                  duration: 300.ms,
                                ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: words.length,
                          itemBuilder: (context, index) {
                            final word = words[index];
                            return _SearchResultTile(
                              word: word.word,
                              chapter: word.conceptId,
                              onTap: () {
                                // Set the search results for swipeable navigation
                                ref.read(swipeableWordsProvider.notifier).state = words;
                                ref.read(selectedWordIndexProvider.notifier).state = index;
                                ref.read(selectedWordProvider.notifier).state = word;
                              },
                            )
                                .animate()
                                .fadeIn(
                                  delay: Duration(milliseconds: index * 50),
                                  duration: 200.ms,
                                );
                          },
                        );
                      },
                      loading: () => _buildLoading(),
                      error: (e, _) => Center(
                        child: Text(
                          'Error searching',
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
            LucideIcons.search,
            size: 48,
            color: AppColors.textPrimary.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'ENTER A TERM TO START',
            style: AppTypography.loadingStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.searchX,
            size: 48,
            color: AppColors.textPrimary.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'NO RESULTS FOUND',
            style: AppTypography.loadingStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.emeraldPrimary.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.emeraldPrimary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SEARCHING...',
            style: AppTypography.loadingStatus,
          )
              .animate(onPlay: (c) => c.repeat())
              .fadeIn(duration: 500.ms)
              .then()
              .fadeOut(duration: 500.ms),
        ],
      ),
    );
  }
}

/// Search input field
class _SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;

  const _SearchInput({
    required this.controller,
    required this.focusNode,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Docker, Webhook, Recursion...',
                hintStyle: TextStyle(
                  color: AppColors.textPrimary.withOpacity(0.3),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),
          GestureDetector(
            onTap: onSearch,
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.emeraldPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.search,
                size: 20,
                color: AppColors.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search result tile
class _SearchResultTile extends StatelessWidget {
  final String word;
  final String chapter;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.word,
    required this.chapter,
    required this.onTap,
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
          borderRadius: BorderRadius.circular(16),
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
                    word,
                    style: AppTypography.chapterTitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chapter,
                    style: AppTypography.description.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.arrowRight,
              size: 16,
              color: AppColors.textPrimary.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
