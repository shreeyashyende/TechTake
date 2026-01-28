import '../datasources/database_helper.dart';
import '../models/word_model.dart';
import '../models/phase_model.dart';
import '../models/chapter_model.dart';

/// Repository for word-related database operations.
class WordRepository {
  final DatabaseHelper _db;

  WordRepository(this._db);

  /// Get a random word for the home screen
  Future<WordModel?> getRandomWord() => _db.getRandomWord();

  /// Get word by ID
  Future<WordModel?> getWordById(String id) => _db.getWordById(id);

  /// Search words by query
  Future<List<WordModel>> searchWords(String query) => _db.searchWords(query);

  /// Get all words in a chapter
  Future<List<WordModel>> getWordsByChapter(String chapterName) =>
      _db.getWordsByChapter(chapterName);

  /// Get all phases with progress information
  Future<List<PhaseModel>> getPhasesWithProgress() async {
    final phases = await _db.getPhases();
    final result = <PhaseModel>[];

    for (final phaseName in phases) {
      final total = await _db.getWordCountByPhase(phaseName);
      final mastered = await _db.getMasteredCountByPhase(phaseName);

      // Extract phase number and title from name like "Phase 1: The Foundation"
      final match = RegExp(r'Phase (\d+): (.+)').firstMatch(phaseName);
      final number = match != null ? int.parse(match.group(1)!) : 0;
      final title = match?.group(2) ?? phaseName;

      result.add(PhaseModel(
        number: number,
        title: title,
        fullName: phaseName,
        description: phaseDescriptions[number] ?? '',
        totalWords: total,
        masteredWords: mastered,
      ));
    }

    // Sort by phase number
    result.sort((a, b) => a.number.compareTo(b.number));
    return result;
  }

  /// Get chapters for a phase with progress information
  Future<List<ChapterModel>> getChaptersWithProgress(String phaseName) async {
    final chapters = await _db.getChaptersByPhase(phaseName);
    final result = <ChapterModel>[];

    // Extract phase number
    final phaseMatch = RegExp(r'Phase (\d+)').firstMatch(phaseName);
    final phaseNumber = phaseMatch != null ? int.parse(phaseMatch.group(1)!) : 0;

    for (final chapterName in chapters) {
      final total = await _db.getWordCountByChapter(chapterName);
      final mastered = await _db.getMasteredCountByChapter(chapterName);

      result.add(ChapterModel(
        name: chapterName,
        phaseName: phaseName,
        phaseNumber: phaseNumber,
        totalWords: total,
        masteredWords: mastered,
      ));
    }

    return result;
  }

  /// Get word count for a chapter
  Future<int> getWordCountByChapter(String chapterName) =>
      _db.getWordCountByChapter(chapterName);
}
