/// Model representing user's mastery status for a word.
class MasteryModel {
  final String wordId;
  final bool isMastered;
  final bool needsRevision;
  final bool isFavorite;
  final DateTime? lastViewed;

  const MasteryModel({
    required this.wordId,
    this.isMastered = false,
    this.needsRevision = false,
    this.isFavorite = false,
    this.lastViewed,
  });

  /// Create MasteryModel from SQLite map
  factory MasteryModel.fromMap(Map<String, dynamic> map) {
    return MasteryModel(
      wordId: map['word_id'] as String,
      isMastered: (map['is_mastered'] as int?) == 1,
      needsRevision: (map['needs_revision'] as int?) == 1,
      isFavorite: (map['is_favorite'] as int?) == 1,
      lastViewed: map['last_viewed'] != null
          ? DateTime.parse(map['last_viewed'] as String)
          : null,
    );
  }

  /// Convert MasteryModel to SQLite map
  Map<String, dynamic> toMap() {
    return {
      'word_id': wordId,
      'is_mastered': isMastered ? 1 : 0,
      'needs_revision': needsRevision ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'last_viewed': lastViewed?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  MasteryModel copyWith({
    String? wordId,
    bool? isMastered,
    bool? needsRevision,
    bool? isFavorite,
    DateTime? lastViewed,
  }) {
    return MasteryModel(
      wordId: wordId ?? this.wordId,
      isMastered: isMastered ?? this.isMastered,
      needsRevision: needsRevision ?? this.needsRevision,
      isFavorite: isFavorite ?? this.isFavorite,
      lastViewed: lastViewed ?? this.lastViewed,
    );
  }

  @override
  String toString() =>
      'MasteryModel(wordId: $wordId, mastered: $isMastered, needsRevision: $needsRevision, favorite: $isFavorite)';
}
