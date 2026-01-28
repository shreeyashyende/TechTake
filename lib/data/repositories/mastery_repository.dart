import '../datasources/database_helper.dart';
import '../models/mastery_model.dart';
import '../models/word_model.dart';

/// Repository for mastery and progress tracking operations.
class MasteryRepository {
  final DatabaseHelper _db;

  MasteryRepository(this._db);

  /// Get mastery status for a word
  Future<MasteryModel?> getMastery(String wordId) => _db.getMastery(wordId);

  /// Toggle favorite status for a word
  Future<bool> toggleFavorite(String wordId) => _db.toggleFavorite(wordId);

  /// Mark a word as mastered
  Future<void> markAsMastered(String wordId) => _db.markAsMastered(wordId);

  /// Mark a word as needs revision
  Future<void> markAsNeedsRevision(String wordId) => _db.markAsNeedsRevision(wordId);

  /// Check if a word is mastered
  Future<bool> isWordMastered(String wordId) => _db.isWordMastered(wordId);

  /// Check if a word needs revision
  Future<bool> isWordNeedsRevision(String wordId) => _db.isWordNeedsRevision(wordId);

  /// Check if a word is favorited
  Future<bool> isWordFavorited(String wordId) => _db.isWordFavorited(wordId);

  /// Get all favorited words
  Future<List<WordModel>> getFavoriteWords() => _db.getFavoriteWords();

  /// Get all words needing revision
  Future<List<WordModel>> getNeedsRevisionWords() => _db.getNeedsRevisionWords();

  /// Get all mastered words
  Future<List<WordModel>> getMasteredWords() => _db.getMasteredWords();

  /// Get favorited words grouped by chapter
  Future<Map<String, List<WordModel>>> getFavoriteWordsGrouped() async {
    final words = await _db.getFavoriteWords();
    final grouped = <String, List<WordModel>>{};

    for (final word in words) {
      grouped.putIfAbsent(word.conceptId, () => []).add(word);
    }

    return grouped;
  }

  /// Get needs revision words grouped by chapter
  Future<Map<String, List<WordModel>>> getNeedsRevisionWordsGrouped() async {
    final words = await _db.getNeedsRevisionWords();
    final grouped = <String, List<WordModel>>{};

    for (final word in words) {
      grouped.putIfAbsent(word.conceptId, () => []).add(word);
    }

    return grouped;
  }

  /// Get mastered words grouped by chapter
  Future<Map<String, List<WordModel>>> getMasteredWordsGrouped() async {
    final words = await _db.getMasteredWords();
    final grouped = <String, List<WordModel>>{};

    for (final word in words) {
      grouped.putIfAbsent(word.conceptId, () => []).add(word);
    }

    return grouped;
  }

  /// Get total words learned
  Future<int> getTotalWordsLearned() => _db.getTotalWordsLearned();

  /// Get total words needing revision
  Future<int> getTotalNeedsRevision() => _db.getTotalNeedsRevision();

  /// Get total favorited words
  Future<int> getTotalFavorited() => _db.getTotalFavorited();

  /// Record word view (updates last_viewed timestamp)
  Future<void> recordWordView(String wordId) async {
    final existing = await _db.getMastery(wordId);
    final mastery = MasteryModel(
      wordId: wordId,
      isMastered: existing?.isMastered ?? false,
      needsRevision: existing?.needsRevision ?? false,
      isFavorite: existing?.isFavorite ?? false,
      lastViewed: DateTime.now(),
    );
    await _db.updateMastery(mastery);
  }

  /// Reset all progress
  Future<void> resetAllProgress() => _db.resetAllProgress();
}
