import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/providers.dart';
import '../../widgets/word_card/word_card.dart';

/// Home screen displaying the daily discovery word card with swipeable gestures.
/// Swipe right to mark as mastered, swipe left to mark as needs revision.
/// Swipe down for new word.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _horizontalDragOffset = 0;
  bool _isSwipingRight = false;
  bool _isSwipingLeft = false;
  bool _showFeedback = false;
  String _feedbackText = '';
  Color _feedbackColor = AppColors.emeraldPrimary;
  IconData _feedbackIcon = LucideIcons.checkCircle;
  bool _isAnimatingNewWord = false;
  double _newWordAnimationOffset = 0;
  bool _justAnimatedIn = false;

  Future<void> _markAsMastered() async {
    final notifier = ref.read(homeWordHistoryProvider.notifier);
    final word = notifier.currentWord;
    if (word == null) return;

    final repository = ref.read(masteryRepositoryProvider);

    // Mark as mastered
    await repository.markAsMastered(word.id);

    // Update stats
    final statsRepo = ref.read(statsRepositoryProvider);
    await statsRepo.updateWordsLearned();

    // Invalidate providers to refresh UI
    ref.invalidate(wordMasteryProvider(word.id));
    ref.invalidate(wordNeedsRevisionProvider(word.id));
    ref.invalidate(chaptersProvider);
    ref.invalidate(phasesProvider);
    ref.invalidate(userStatsProvider);
    ref.invalidate(masteredWordsProvider);
    ref.invalidate(needsRevisionProvider);

    // Show feedback
    setState(() {
      _showFeedback = true;
      _feedbackText = 'MASTERED!';
      _feedbackColor = AppColors.emeraldPrimary;
      _feedbackIcon = LucideIcons.checkCircle;
    });

    await _showFeedbackAndLoadNext();
  }

  Future<void> _markAsNeedsRevision() async {
    final notifier = ref.read(homeWordHistoryProvider.notifier);
    final word = notifier.currentWord;
    if (word == null) return;

    final repository = ref.read(masteryRepositoryProvider);

    // Mark as needs revision
    await repository.markAsNeedsRevision(word.id);

    // Update stats
    final statsRepo = ref.read(statsRepositoryProvider);
    await statsRepo.updateNeedsRevision();

    // Invalidate providers to refresh UI
    ref.invalidate(wordMasteryProvider(word.id));
    ref.invalidate(wordNeedsRevisionProvider(word.id));
    ref.invalidate(chaptersProvider);
    ref.invalidate(phasesProvider);
    ref.invalidate(userStatsProvider);
    ref.invalidate(masteredWordsProvider);
    ref.invalidate(needsRevisionProvider);

    // Show feedback
    setState(() {
      _showFeedback = true;
      _feedbackText = 'NEEDS REVISION';
      _feedbackColor = Colors.orange;
      _feedbackIcon = LucideIcons.alertCircle;
    });

    await _showFeedbackAndLoadNext();
  }

  Future<void> _showFeedbackAndLoadNext() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _showFeedback = false;
      });

      // Load next word and animate it in from bottom
      await ref.read(homeWordHistoryProvider.notifier).loadNextWord();

      if (mounted) {
        setState(() {
          _isAnimatingNewWord = true;
          _newWordAnimationOffset = MediaQuery.of(context).size.height;
        });

        // Animate the offset to 0
        _animateNewWordIn();
      }
    }
  }

  void _animateNewWordIn() async {
    const duration = Duration(milliseconds: 300);
    const steps = 30;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final startOffset = _newWordAnimationOffset;

    for (int i = 0; i <= steps; i++) {
      if (!mounted) return;
      await Future.delayed(Duration(milliseconds: stepDuration));
      if (!mounted) return;

      // Ease out curve
      final t = i / steps;
      final easeOut = 1 - (1 - t) * (1 - t);

      setState(() {
        _newWordAnimationOffset = startOffset * (1 - easeOut);
      });
    }

    if (mounted) {
      setState(() {
        _isAnimatingNewWord = false;
        _newWordAnimationOffset = 0;
        _justAnimatedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(homeWordHistoryProvider);
    final notifier = ref.read(homeWordHistoryProvider.notifier);
    final currentWord = notifier.currentWord;

    return Stack(
      children: [
        // Emerald glow in top-right
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.emeraldGlow.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Main content with gesture detection
        SafeArea(
          child: GestureDetector(
            onHorizontalDragStart: (_) {
              _isSwipingRight = false;
              _isSwipingLeft = false;
              _justAnimatedIn = false;
            },
            onHorizontalDragUpdate: (details) {
              if (_isAnimatingNewWord || _showFeedback) return;
              setState(() {
                _horizontalDragOffset += details.delta.dx;
                if (_horizontalDragOffset > 50) {
                  _isSwipingRight = true;
                  _isSwipingLeft = false;
                } else if (_horizontalDragOffset < -50) {
                  _isSwipingLeft = true;
                  _isSwipingRight = false;
                }
              });
            },
            onHorizontalDragEnd: (details) async {
              if (_isAnimatingNewWord || _showFeedback) return;

              if (_isSwipingRight && _horizontalDragOffset > 100) {
                await _markAsMastered();
              } else if (_isSwipingLeft && _horizontalDragOffset < -100) {
                await _markAsNeedsRevision();
              }

              setState(() {
                _horizontalDragOffset = 0;
                _isSwipingRight = false;
                _isSwipingLeft = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 70), // Space for header
                  Expanded(
                    child: history.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.emeraldPrimary,
                            ),
                          )
                        : currentWord == null
                            ? const Center(
                                child: Text(
                                  'No words available',
                                  style: TextStyle(color: AppColors.textMuted),
                                ),
                              )
                            : _isAnimatingNewWord
                                ? Center(
                                    child: Transform.translate(
                                      offset: Offset(0, _newWordAnimationOffset),
                                      child: WordCard(word: currentWord),
                                    ),
                                  )
                                : Center(
                                    child: Transform.translate(
                                      offset: Offset(_horizontalDragOffset * 0.3, 0),
                                      child: Transform.rotate(
                                        angle: _horizontalDragOffset * 0.0005,
                                        child: _justAnimatedIn
                                            ? WordCard(word: currentWord)
                                            : WordCard(word: currentWord)
                                                .animate()
                                                .fadeIn(duration: 300.ms)
                                                .scale(
                                                  begin: const Offset(0.95, 0.95),
                                                  end: const Offset(1, 1),
                                                  duration: 300.ms,
                                                ),
                                      ),
                                    ),
                                  ),
                  ),
                  const SizedBox(height: 16),
                  _buildSwipeHint(currentWord),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ),

        // Swipe indicators on sides
        if (_isSwipingRight)
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.emeraldPrimary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.checkCircle,
                  size: 32,
                  color: AppColors.emeraldPrimary,
                ),
              ),
            ),
          ),
        if (_isSwipingLeft)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.alertCircle,
                  size: 32,
                  color: Colors.orange,
                ),
              ),
            ),
          ),

        // Feedback overlay
        if (_showFeedback) _buildFeedback(),
      ],
    );
  }

  Widget _buildSwipeHint(word) {
    if (word == null) return const SizedBox(height: 48);

    final isMasteredAsync = ref.watch(wordMasteryProvider(word.id));
    final needsRevisionAsync = ref.watch(wordNeedsRevisionProvider(word.id));

    return isMasteredAsync.when(
      data: (isMastered) {
        return needsRevisionAsync.when(
          data: (needsRevision) {
            if (isMastered) {
              return _buildStatusBadge('MASTERED', AppColors.emeraldPrimary, LucideIcons.checkCircle);
            }
            if (needsRevision) {
              return _buildStatusBadge('NEEDS REVISION', Colors.orange, LucideIcons.alertCircle);
            }
            return _buildSwipeInstructions();
          },
          loading: () => _buildSwipeInstructions(),
          error: (_, __) => _buildSwipeInstructions(),
        );
      },
      loading: () => const SizedBox(height: 48),
      error: (_, __) => _buildSwipeInstructions(),
    );
  }

  Widget _buildStatusBadge(String text, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTypography.subtitle.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left indicator
          Row(
            children: [
              Icon(
                LucideIcons.chevronLeft,
                size: 16,
                color: _isSwipingLeft ? Colors.orange : AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                'REVISION',
                style: AppTypography.subtitle.copyWith(
                  fontSize: 10,
                  color: _isSwipingLeft ? Colors.orange : AppColors.textMuted,
                ),
              ),
            ],
          ),
          // Right indicator
          Row(
            children: [
              Text(
                'MASTERED',
                style: AppTypography.subtitle.copyWith(
                  fontSize: 10,
                  color: _isSwipingRight ? AppColors.emeraldPrimary : AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: _isSwipingRight ? AppColors.emeraldPrimary : AppColors.textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return Container(
      color: AppColors.background.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _feedbackColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _feedbackIcon,
                size: 64,
                color: _feedbackColor,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: 300.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 24),
            Text(
              _feedbackText,
              style: AppTypography.screenTitle.copyWith(
                color: _feedbackColor,
              ),
            )
                .animate()
                .fadeIn(delay: 150.ms, duration: 200.ms),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms);
  }
}
