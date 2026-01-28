import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/word_model.dart';
import '../models/mastery_model.dart';
import 'curriculum_data.dart';

/// SQLite database helper for TechTake.
/// Manages database initialization, schema, and seeding.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static const String _dbName = 'techtake.db';
  static const int _dbVersion = 2; // Upgraded for needs_revision column

  // Table names
  static const String tableWords = 'words';
  static const String tableMastery = 'mastery';
  static const String tableUserStats = 'user_stats';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add needs_revision column
      await db.execute(
        'ALTER TABLE $tableMastery ADD COLUMN needs_revision INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Words table - stores all vocabulary
    await db.execute('''
      CREATE TABLE $tableWords (
        id TEXT PRIMARY KEY,
        word TEXT NOT NULL,
        theTake TEXT NOT NULL,
        howToUse TEXT NOT NULL,
        story TEXT NOT NULL,
        whyItExists TEXT NOT NULL,
        useAvoid TEXT NOT NULL,
        category TEXT NOT NULL,
        conceptId TEXT NOT NULL,
        conversationQ TEXT NOT NULL,
        conversationA TEXT NOT NULL
      )
    ''');

    // Create indexes for search and filtering
    await db.execute('CREATE INDEX idx_word ON $tableWords(word)');
    await db.execute('CREATE INDEX idx_category ON $tableWords(category)');
    await db.execute('CREATE INDEX idx_conceptId ON $tableWords(conceptId)');

    // User stats table - key-value store for stats
    await db.execute('''
      CREATE TABLE $tableUserStats (
        key TEXT PRIMARY KEY,
        value INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Mastery table - tracks user progress per word
    await db.execute('''
      CREATE TABLE $tableMastery (
        word_id TEXT PRIMARY KEY,
        is_mastered INTEGER NOT NULL DEFAULT 0,
        needs_revision INTEGER NOT NULL DEFAULT 0,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        last_viewed TEXT,
        FOREIGN KEY (word_id) REFERENCES $tableWords(id)
      )
    ''');

    // Seed initial data
    await _seedCurriculum(db);
    await _initializeUserStats(db);
  }

  /// Seed curriculum data into the database
  Future<void> _seedCurriculum(Database db) async {
    final batch = db.batch();

    for (final word in curriculumData) {
      batch.insert(tableWords, word.toMap());
    }

    await batch.commit(noResult: true);
  }

  /// Initialize user stats with default values
  Future<void> _initializeUserStats(Database db) async {
    final stats = {
      'streak': 0,
      'words_learned': 0,
      'words_favorited': 0,
      'last_active_date': 0, // Will store date as yyyyMMdd integer
    };

    for (final entry in stats.entries) {
      await db.insert(tableUserStats, {
        'key': entry.key,
        'value': entry.value,
      });
    }
  }

  // ========== WORD OPERATIONS ==========

  /// Get a random word from the database
  Future<WordModel?> getRandomWord() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT * FROM $tableWords ORDER BY RANDOM() LIMIT 1',
    );
    if (result.isEmpty) return null;
    return WordModel.fromMap(result.first);
  }

  /// Get all words from the database
  Future<List<WordModel>> getAllWords() async {
    final db = await database;
    final result = await db.query(tableWords);
    return result.map((e) => WordModel.fromMap(e)).toList();
  }

  /// Get word by ID
  Future<WordModel?> getWordById(String id) async {
    final db = await database;
    final result = await db.query(
      tableWords,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return WordModel.fromMap(result.first);
  }

  /// Search words by name (case-insensitive)
  Future<List<WordModel>> searchWords(String query) async {
    final db = await database;
    final result = await db.query(
      tableWords,
      where: 'word LIKE ?',
      whereArgs: ['%$query%'],
      limit: 20,
    );
    return result.map((e) => WordModel.fromMap(e)).toList();
  }

  /// Get all words in a specific phase
  Future<List<WordModel>> getWordsByPhase(String phaseName) async {
    final db = await database;
    final result = await db.query(
      tableWords,
      where: 'category = ?',
      whereArgs: [phaseName],
    );
    return result.map((e) => WordModel.fromMap(e)).toList();
  }

  /// Get all words in a specific chapter
  Future<List<WordModel>> getWordsByChapter(String chapterName) async {
    final db = await database;
    final result = await db.query(
      tableWords,
      where: 'conceptId = ?',
      whereArgs: [chapterName],
    );
    return result.map((e) => WordModel.fromMap(e)).toList();
  }

  /// Get distinct phases
  Future<List<String>> getPhases() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT DISTINCT category FROM $tableWords ORDER BY category',
    );
    return result.map((e) => e['category'] as String).toList();
  }

  /// Get chapters by phase
  Future<List<String>> getChaptersByPhase(String phaseName) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT DISTINCT conceptId FROM $tableWords WHERE category = ?',
      [phaseName],
    );
    return result.map((e) => e['conceptId'] as String).toList();
  }

  /// Get word count by phase
  Future<int> getWordCountByPhase(String phaseName) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableWords WHERE category = ?',
      [phaseName],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get word count by chapter
  Future<int> getWordCountByChapter(String chapterName) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableWords WHERE conceptId = ?',
      [chapterName],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ========== MASTERY OPERATIONS ==========

  /// Get mastery status for a word
  Future<MasteryModel?> getMastery(String wordId) async {
    final db = await database;
    final result = await db.query(
      tableMastery,
      where: 'word_id = ?',
      whereArgs: [wordId],
    );
    if (result.isEmpty) return null;
    return MasteryModel.fromMap(result.first);
  }

  /// Update or create mastery record
  Future<void> updateMastery(MasteryModel mastery) async {
    final db = await database;
    await db.insert(
      tableMastery,
      mastery.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Toggle favorite status for a word
  Future<bool> toggleFavorite(String wordId) async {
    final db = await database;
    final existing = await getMastery(wordId);

    final newFavorite = !(existing?.isFavorite ?? false);
    final mastery = MasteryModel(
      wordId: wordId,
      isMastered: existing?.isMastered ?? false,
      needsRevision: existing?.needsRevision ?? false,
      isFavorite: newFavorite,
      lastViewed: DateTime.now(),
    );

    await updateMastery(mastery);
    return newFavorite;
  }

  /// Mark word as mastered
  Future<void> markAsMastered(String wordId) async {
    final db = await database;
    final existing = await getMastery(wordId);

    final mastery = MasteryModel(
      wordId: wordId,
      isMastered: true,
      needsRevision: false, // Clear needs revision when mastered
      isFavorite: existing?.isFavorite ?? false,
      lastViewed: DateTime.now(),
    );

    await updateMastery(mastery);
  }

  /// Mark word as needs revision
  Future<void> markAsNeedsRevision(String wordId) async {
    final db = await database;
    final existing = await getMastery(wordId);

    final mastery = MasteryModel(
      wordId: wordId,
      isMastered: false, // Clear mastered when needs revision
      needsRevision: true,
      isFavorite: existing?.isFavorite ?? false,
      lastViewed: DateTime.now(),
    );

    await updateMastery(mastery);
  }

  /// Get all favorited words with their full data
  Future<List<WordModel>> getFavoriteWords() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT w.* FROM $tableWords w
      INNER JOIN $tableMastery m ON w.id = m.word_id
      WHERE m.is_favorite = 1
      ORDER BY w.conceptId, w.word
    ''');
    return result.map((e) => WordModel.fromMap(e)).toList();
  }

  /// Get all words needing revision
  Future<List<WordModel>> getNeedsRevisionWords() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT w.* FROM $tableWords w
      INNER JOIN $tableMastery m ON w.id = m.word_id
      WHERE m.needs_revision = 1
      ORDER BY w.conceptId, w.word
    ''');
    return result.map((e) => WordModel.fromMap(e)).toList();
  }

  /// Get all mastered words
  Future<List<WordModel>> getMasteredWords() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT w.* FROM $tableWords w
      INNER JOIN $tableMastery m ON w.id = m.word_id
      WHERE m.is_mastered = 1
      ORDER BY w.conceptId, w.word
    ''');
    return result.map((e) => WordModel.fromMap(e)).toList();
  }

  /// Get mastered word count by phase
  Future<int> getMasteredCountByPhase(String phaseName) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM $tableWords w
      INNER JOIN $tableMastery m ON w.id = m.word_id
      WHERE w.category = ? AND m.is_mastered = 1
    ''', [phaseName]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get mastered word count by chapter
  Future<int> getMasteredCountByChapter(String chapterName) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM $tableWords w
      INNER JOIN $tableMastery m ON w.id = m.word_id
      WHERE w.conceptId = ? AND m.is_mastered = 1
    ''', [chapterName]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Check if a word is mastered
  Future<bool> isWordMastered(String wordId) async {
    final mastery = await getMastery(wordId);
    return mastery?.isMastered ?? false;
  }

  /// Check if a word needs revision
  Future<bool> isWordNeedsRevision(String wordId) async {
    final mastery = await getMastery(wordId);
    return mastery?.needsRevision ?? false;
  }

  /// Check if a word is favorited
  Future<bool> isWordFavorited(String wordId) async {
    final mastery = await getMastery(wordId);
    return mastery?.isFavorite ?? false;
  }

  // ========== USER STATS OPERATIONS ==========

  /// Get a user stat value
  Future<int> getStat(String key) async {
    final db = await database;
    final result = await db.query(
      tableUserStats,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return 0;
    return result.first['value'] as int;
  }

  /// Set a user stat value
  Future<void> setStat(String key, int value) async {
    final db = await database;
    await db.update(
      tableUserStats,
      {'value': value},
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  /// Increment a user stat
  Future<int> incrementStat(String key, [int amount = 1]) async {
    final current = await getStat(key);
    final newValue = current + amount;
    await setStat(key, newValue);
    return newValue;
  }

  /// Get all user stats as a map
  Future<Map<String, int>> getAllStats() async {
    final db = await database;
    final result = await db.query(tableUserStats);
    return {for (var row in result) row['key'] as String: row['value'] as int};
  }

  /// Get total words learned count
  Future<int> getTotalWordsLearned() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableMastery WHERE is_mastered = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get total words needing revision
  Future<int> getTotalNeedsRevision() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableMastery WHERE needs_revision = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get total favorited words count
  Future<int> getTotalFavorited() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableMastery WHERE is_favorite = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get total words count in the database
  Future<int> getTotalWordsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableWords',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Reset all progress (mastery and stats)
  Future<void> resetAllProgress() async {
    final db = await database;

    // Clear all mastery records
    await db.delete(tableMastery);

    // Reset all stats to 0
    await db.update(
      tableUserStats,
      {'value': 0},
    );
  }
}
