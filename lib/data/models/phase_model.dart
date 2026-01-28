/// Model representing a learning phase with progress information.
class PhaseModel {
  final int number;
  final String title;
  final String fullName; // e.g., "Phase 1: The Foundation"
  final String description;
  final int totalWords;
  final int masteredWords;

  const PhaseModel({
    required this.number,
    required this.title,
    required this.fullName,
    required this.description,
    this.totalWords = 0,
    this.masteredWords = 0,
  });

  /// Progress percentage (0-100)
  double get progressPercent {
    if (totalWords == 0) return 0;
    return (masteredWords / totalWords) * 100;
  }

  /// Progress as decimal (0-1)
  double get progressDecimal {
    if (totalWords == 0) return 0;
    return masteredWords / totalWords;
  }

  /// Whether the phase is complete
  bool get isComplete => totalWords > 0 && masteredWords >= totalWords;

  /// Create a copy with updated progress
  PhaseModel copyWith({
    int? number,
    String? title,
    String? fullName,
    String? description,
    int? totalWords,
    int? masteredWords,
  }) {
    return PhaseModel(
      number: number ?? this.number,
      title: title ?? this.title,
      fullName: fullName ?? this.fullName,
      description: description ?? this.description,
      totalWords: totalWords ?? this.totalWords,
      masteredWords: masteredWords ?? this.masteredWords,
    );
  }

  @override
  String toString() =>
      'PhaseModel(number: $number, title: $title, progress: ${progressPercent.toStringAsFixed(0)}%)';
}

/// Phase descriptions as defined in the curriculum
const Map<int, String> phaseDescriptions = {
  1: 'Hardware, OS, and fundamental computer connectivity.',
  2: 'CS fundamentals: organizing data and solving problems.',
  3: 'High-level theories and engineering philosophies.',
  4: 'Applying concepts to build user-facing software.',
  5: 'Data persistence and storage systems.',
  6: 'Infrastructure, deployment, and DevOps.',
  7: 'Modern data layers and Artificial Intelligence.',
  8: 'Protecting the stack and identity.',
  9: 'Human collaboration and product lifecycles.',
};

/// Phase titles as defined in the curriculum
const Map<int, String> phaseTitles = {
  1: 'The Foundation',
  2: 'The Logic',
  3: 'The Concepts',
  4: 'The Application',
  5: 'The Memory',
  6: 'The Factory',
  7: 'The Brain',
  8: 'The Shield',
  9: 'The Process',
};
