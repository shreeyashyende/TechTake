import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';

/// "The Take" tab showing definition and why it exists.
class TabTheTake extends StatelessWidget {
  final WordModel word;

  const TabTheTake({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'THE DEFINITION',
            style: AppTypography.sectionHeader,
          ),
          const SizedBox(height: 12),
          // Definition text
          Text(
            word.theTake,
            style: AppTypography.definition,
          ),
          const SizedBox(height: 24),
          // Why it exists section
          Text(
            'WHY IT EXISTS',
            style: AppTypography.sectionHeader,
          ),
          const SizedBox(height: 12),
          Text(
            word.whyItExists,
            style: AppTypography.bodyText.copyWith(
              color: AppColors.textPrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
