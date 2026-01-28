import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/word_model.dart';

/// "Story" tab showing the analogy/mental model.
class TabStory extends StatelessWidget {
  final WordModel word;

  const TabStory({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'MENTAL MODEL',
            style: AppTypography.sectionHeader,
          ),
          const SizedBox(height: 16),
          // Story container with left border
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.emeraldPrimary.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            child: Text(
              word.story,
              style: AppTypography.storyText,
            ),
          ),
        ],
      ),
    );
  }
}
