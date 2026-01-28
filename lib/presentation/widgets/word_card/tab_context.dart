import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';

/// "Context" tab showing conversation perspective Q&A.
class TabContext extends StatelessWidget {
  final WordModel word;

  const TabContext({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'CONVERSATION PERSPECTIVE',
            style: AppTypography.sectionHeader,
          ),
          const SizedBox(height: 16),
          // Question
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.messageSquare,
                  size: 14,
                  color: AppColors.textPrimary.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '"${word.conversationQ}"',
                  style: AppTypography.bodyText.copyWith(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Expert answer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppDimensions.containerRadiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expert indicator
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'EXPERT ANSWER',
                      style: AppTypography.sectionHeader.copyWith(
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  word.conversationA,
                  style: AppTypography.bodyTextLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
