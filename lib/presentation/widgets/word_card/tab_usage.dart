import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';

/// "Usage" tab showing how to use and use/avoid guidance.
class TabUsage extends StatelessWidget {
  final WordModel word;

  const TabUsage({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // How to use section
          Text(
            'HOW TO USE',
            style: AppTypography.sectionHeader,
          ),
          const SizedBox(height: 12),
          Text(
            word.howToUse,
            style: AppTypography.bodyTextLight,
          ),
          const SizedBox(height: 24),
          // Use / Avoid section
          Text(
            'USE / AVOID',
            style: AppTypography.sectionHeader,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppDimensions.containerRadius),
            ),
            child: Text(
              word.useAvoid,
              style: AppTypography.bodyText.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
