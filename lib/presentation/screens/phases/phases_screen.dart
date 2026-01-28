import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/phase_model.dart';
import '../../providers/providers.dart';

/// Mastery Phases screen showing the learning roadmap.
class PhasesScreen extends ConsumerWidget {
  const PhasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phasesAsync = ref.watch(phasesProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70), // Space for header
            Text(
              'Mastery Path',
              style: AppTypography.screenTitle,
            ),
            const SizedBox(height: 4),
            Text(
              'SELECT A LEARNING MILESTONE',
              style: AppTypography.subtitle,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: phasesAsync.when(
                data: (phases) => ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: phases.length,
                  itemBuilder: (context, index) {
                    return _PhaseCard(
                      phase: phases[index],
                      onTap: () {
                        ref.read(selectedPhaseProvider.notifier).state = phases[index];
                      },
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: index * 50),
                          duration: 300.ms,
                        )
                        .slideY(
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
                    'Error loading phases',
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

/// Individual phase card widget
class _PhaseCard extends StatelessWidget {
  final PhaseModel phase;
  final VoidCallback onTap;

  const _PhaseCard({
    required this.phase,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.textPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Atmospheric glow
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.emeraldPrimary.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PHASE ${phase.number}',
                      style: AppTypography.sectionHeader.copyWith(
                        fontSize: 9,
                        letterSpacing: 1.8,
                      ),
                    ),
                    Text(
                      '${phase.progressPercent.toStringAsFixed(0)}%',
                      style: AppTypography.progressText.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  phase.title,
                  style: AppTypography.phaseTitle,
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  phase.description,
                  style: AppTypography.description,
                ),
                const SizedBox(height: 16),
                // Progress bar
                Container(
                  height: AppDimensions.progressBarHeight,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: phase.progressDecimal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.emeraldPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
