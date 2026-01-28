import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';
import '../../../services/tts_service.dart';
import '../../providers/providers.dart';
import 'tab_the_take.dart';
import 'tab_usage.dart';
import 'tab_story.dart';
import 'tab_context.dart';

/// Main word card widget displaying vocabulary details with 4 tabs.
class WordCard extends ConsumerStatefulWidget {
  final WordModel word;
  final bool showActions;
  final double? height;

  const WordCard({
    super.key,
    required this.word,
    this.showActions = true,
    this.height,
  });

  @override
  ConsumerState<WordCard> createState() => _WordCardState();
}

class _WordCardState extends ConsumerState<WordCard> {
  int _selectedTab = 0;
  final TtsService _tts = TtsService();

  final List<_TabInfo> _tabs = const [
    _TabInfo(LucideIcons.bookOpen, 'THE TAKE'),
    _TabInfo(LucideIcons.target, 'USAGE'),
    _TabInfo(LucideIcons.quote, 'STORY'),
    _TabInfo(LucideIcons.info, 'CONTEXT'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = widget.height ?? screenHeight * AppDimensions.wordCardHeightRatio;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.border,
          width: AppDimensions.cardBorderWidth,
        ),
      ),
      child: Stack(
        children: [
          // Centered top emerald glow accent
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.emeraldPrimary.withOpacity(0.8),
                      AppColors.emeraldPrimary,
                      AppColors.emeraldPrimary.withOpacity(0.8),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.cardRadius),
                    topRight: Radius.circular(AppDimensions.cardRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emeraldGlow.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Glass overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppDimensions.blurRadius,
                sigmaY: AppDimensions.blurRadius,
              ),
              child: Container(
                color: AppColors.glassLayer,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingCard),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                Text(
                  widget.word.word,
                  style: AppTypography.wordTitle,
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildTabContent()),
                const SizedBox(height: 16),
                _buildTabBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phase and Chapter labels
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.word.category.toUpperCase(),
                style: AppTypography.phaseLabel,
              ),
              const SizedBox(height: 4),
              Text(
                widget.word.conceptId.toUpperCase(),
                style: AppTypography.chapterLabel,
              ),
            ],
          ),
        ),
        // Action buttons
        if (widget.showActions) ...[
          _buildActionButton(
            icon: LucideIcons.volume2,
            onTap: () => _tts.speak(widget.word.word),
          ),
          const SizedBox(width: 8),
          _FavoriteButton(wordId: widget.word.id),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: AppDimensions.iconSizeMedium,
          color: AppColors.textPrimary.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return TabTheTake(word: widget.word);
      case 1:
        return TabUsage(word: widget.word);
      case 2:
        return TabStory(word: widget.word);
      case 3:
        return TabContext(word: widget.word);
      default:
        return TabTheTake(word: widget.word);
    }
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabs[index].icon,
                      size: AppDimensions.iconSizeSmall,
                      color: isSelected
                          ? Colors.black
                          : AppColors.textMuted,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tabs[index].label,
                      style: AppTypography.tabLabel.copyWith(
                        color: isSelected
                            ? Colors.black
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabInfo {
  final IconData icon;
  final String label;

  const _TabInfo(this.icon, this.label);
}

/// Favorite button with state management
class _FavoriteButton extends ConsumerWidget {
  final String wordId;

  const _FavoriteButton({required this.wordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorited = ref.watch(wordFavoriteProvider(wordId));

    return GestureDetector(
      onTap: () async {
        final repository = ref.read(masteryRepositoryProvider);
        await repository.toggleFavorite(wordId);
        // Update stats
        final statsRepo = ref.read(statsRepositoryProvider);
        await statsRepo.updateWordsFavorited();
        // Refresh the favorite state
        ref.invalidate(wordFavoriteProvider(wordId));
        ref.invalidate(favoritesProvider);
        ref.invalidate(userStatsProvider);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: isFavorited.when(
          data: (favorited) => Icon(
            favorited ? LucideIcons.bookmarkMinus : LucideIcons.bookmark,
            size: AppDimensions.iconSizeMedium,
            color: favorited
                ? AppColors.emeraldPrimary
                : AppColors.textPrimary.withOpacity(0.6),
          ),
          loading: () => SizedBox(
            width: AppDimensions.iconSizeMedium,
            height: AppDimensions.iconSizeMedium,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.emeraldPrimary,
            ),
          ),
          error: (_, __) => Icon(
            LucideIcons.bookmark,
            size: AppDimensions.iconSizeMedium,
            color: AppColors.textPrimary.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
