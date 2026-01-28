/// Model representing user statistics and progress.
class UserStatsModel {
  final int streak;
  final int wordsLearned;
  final int wordsNeedsRevision;
  final int wordsFavorited;
  final int totalWords;

  const UserStatsModel({
    this.streak = 0,
    this.wordsLearned = 0,
    this.wordsNeedsRevision = 0,
    this.wordsFavorited = 0,
    this.totalWords = 0,
  });

  /// Create UserStatsModel from a map of key-value pairs
  factory UserStatsModel.fromKeyValueMap(Map<String, int> map) {
    return UserStatsModel(
      streak: map['streak'] ?? 0,
      wordsLearned: map['words_learned'] ?? 0,
      wordsNeedsRevision: map['words_needs_revision'] ?? 0,
      wordsFavorited: map['words_favorited'] ?? 0,
      totalWords: map['total_words'] ?? 0,
    );
  }

  /// Convert to key-value map for storage
  Map<String, int> toKeyValueMap() {
    return {
      'streak': streak,
      'words_learned': wordsLearned,
      'words_needs_revision': wordsNeedsRevision,
      'words_favorited': wordsFavorited,
      'total_words': totalWords,
    };
  }

  /// Create a copy with updated fields
  UserStatsModel copyWith({
    int? streak,
    int? wordsLearned,
    int? wordsNeedsRevision,
    int? wordsFavorited,
    int? totalWords,
  }) {
    return UserStatsModel(
      streak: streak ?? this.streak,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      wordsNeedsRevision: wordsNeedsRevision ?? this.wordsNeedsRevision,
      wordsFavorited: wordsFavorited ?? this.wordsFavorited,
      totalWords: totalWords ?? this.totalWords,
    );
  }

  @override
  String toString() =>
      'UserStatsModel(streak: $streak, learned: $wordsLearned, needsRevision: $wordsNeedsRevision, total: $totalWords)';
}
