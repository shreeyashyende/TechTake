import '../datasources/database_helper.dart';
import '../models/user_stats_model.dart';

/// Repository for user statistics operations.
class StatsRepository {
  final DatabaseHelper _db;

  StatsRepository(this._db);

  /// Get all user stats
  Future<UserStatsModel> getUserStats() async {
    final stats = await _db.getAllStats();
    final totalWords = await _db.getTotalWordsCount();
    final wordsLearned = await _db.getTotalWordsLearned();
    final wordsNeedsRevision = await _db.getTotalNeedsRevision();
    final wordsFavorited = await _db.getTotalFavorited();

    return UserStatsModel(
      streak: stats['streak'] ?? 0,
      wordsLearned: wordsLearned,
      wordsNeedsRevision: wordsNeedsRevision,
      wordsFavorited: wordsFavorited,
      totalWords: totalWords,
    );
  }

  /// Get streak value
  Future<int> getStreak() => _db.getStat('streak');

  /// Check and update streak based on last active date
  /// Should be called when the app starts or when user learns a word
  Future<void> checkAndUpdateStreak() async {
    final now = DateTime.now();
    final todayInt = _dateToInt(now);
    final lastActiveDate = await _db.getStat('last_active_date');

    if (lastActiveDate == 0) {
      // First time user - start streak at 1
      await _db.setStat('streak', 1);
      await _db.setStat('last_active_date', todayInt);
      return;
    }

    if (lastActiveDate == todayInt) {
      // Already active today - no change needed
      return;
    }

    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final yesterdayInt = _dateToInt(yesterday);

    if (lastActiveDate == yesterdayInt) {
      // User was active yesterday - increment streak
      await _db.incrementStat('streak');
      await _db.setStat('last_active_date', todayInt);
    } else {
      // User missed a day - reset streak to 1
      await _db.setStat('streak', 1);
      await _db.setStat('last_active_date', todayInt);
    }
  }

  /// Convert DateTime to integer in yyyyMMdd format
  int _dateToInt(DateTime date) {
    return date.year * 10000 + date.month * 100 + date.day;
  }

  /// Reset streak
  Future<void> resetStreak() => _db.setStat('streak', 0);

  /// Update words learned count
  Future<void> updateWordsLearned() async {
    final count = await _db.getTotalWordsLearned();
    await _db.setStat('words_learned', count);
    // Also check streak when user learns a word
    await checkAndUpdateStreak();
  }

  /// Update words needing revision count
  Future<void> updateNeedsRevision() async {
    final count = await _db.getTotalNeedsRevision();
    await _db.setStat('words_needs_revision', count);
  }

  /// Update words favorited count
  Future<void> updateWordsFavorited() async {
    final count = await _db.getTotalFavorited();
    await _db.setStat('words_favorited', count);
  }
}
