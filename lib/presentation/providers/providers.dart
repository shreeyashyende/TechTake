import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/database_helper.dart';
import '../../data/repositories/word_repository.dart';
import '../../data/repositories/mastery_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../data/models/word_model.dart';
import '../../data/models/phase_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/user_stats_model.dart';

// ========== CORE PROVIDERS ==========

/// Database helper provider
final databaseProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper());

/// Word repository provider
final wordRepositoryProvider = Provider<WordRepository>((ref) {
  return WordRepository(ref.watch(databaseProvider));
});

/// Mastery repository provider
final masteryRepositoryProvider = Provider<MasteryRepository>((ref) {
  return MasteryRepository(ref.watch(databaseProvider));
});

/// Stats repository provider
final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(databaseProvider));
});

// ========== NAVIGATION STATE ==========

/// Current bottom navigation index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

/// Whether settings screen is currently shown
final isSettingsOpenProvider = StateProvider<bool>((ref) => false);

/// Selected phase for chapters view
final selectedPhaseProvider = StateProvider<PhaseModel?>((ref) => null);

/// Selected chapter for word list view
final selectedChapterProvider = StateProvider<ChapterModel?>((ref) => null);

// ========== WORD STATE ==========

/// Current word displayed on home screen - now tracks history for back navigation
final homeWordHistoryProvider = StateNotifierProvider<HomeWordHistoryNotifier, List<WordModel>>(
  (ref) => HomeWordHistoryNotifier(ref.watch(wordRepositoryProvider)),
);

class HomeWordHistoryNotifier extends StateNotifier<List<WordModel>> {
  final WordRepository _repository;
  int _currentIndex = 0;

  HomeWordHistoryNotifier(this._repository) : super([]) {
    loadInitialWord();
  }

  int get currentIndex => _currentIndex;
  WordModel? get currentWord => state.isNotEmpty && _currentIndex < state.length
      ? state[_currentIndex]
      : null;

  Future<void> loadInitialWord() async {
    try {
      final word = await _repository.getRandomWord();
      if (word != null) {
        state = [word];
        _currentIndex = 0;
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> loadNextWord() async {
    // If we're not at the end of history, move forward
    if (_currentIndex < state.length - 1) {
      _currentIndex++;
      state = [...state]; // Trigger update
      return;
    }

    // Otherwise, load a new random word
    try {
      final word = await _repository.getRandomWord();
      if (word != null) {
        state = [...state, word];
        _currentIndex = state.length - 1;
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void goToPreviousWord() {
    if (_currentIndex > 0) {
      _currentIndex--;
      state = [...state]; // Trigger update
    }
  }

  bool get canGoBack => _currentIndex > 0;
  bool get canGoForward => _currentIndex < state.length - 1;
}

/// Current word displayed on home screen (for backward compatibility)
final currentWordProvider =
    StateNotifierProvider<CurrentWordNotifier, AsyncValue<WordModel?>>(
  (ref) => CurrentWordNotifier(ref.watch(wordRepositoryProvider)),
);

class CurrentWordNotifier extends StateNotifier<AsyncValue<WordModel?>> {
  final WordRepository _repository;

  CurrentWordNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRandomWord();
  }

  Future<void> loadRandomWord() async {
    state = const AsyncValue.loading();
    try {
      final word = await _repository.getRandomWord();
      state = AsyncValue.data(word);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Selected word for detail view
final selectedWordProvider = StateProvider<WordModel?>((ref) => null);

/// Selected word index in the current word list (for swipeable navigation)
final selectedWordIndexProvider = StateProvider<int>((ref) => 0);

/// Words list for swipeable view (from chapter, search, or favorites)
final swipeableWordsProvider = StateProvider<List<WordModel>>((ref) => []);

// ========== PHASES & CHAPTERS ==========

/// All phases with progress
final phasesProvider = FutureProvider<List<PhaseModel>>((ref) async {
  final repository = ref.watch(wordRepositoryProvider);
  return repository.getPhasesWithProgress();
});

/// Chapters for selected phase
final chaptersProvider = FutureProvider<List<ChapterModel>>((ref) async {
  final selectedPhase = ref.watch(selectedPhaseProvider);
  if (selectedPhase == null) return [];

  final repository = ref.watch(wordRepositoryProvider);
  return repository.getChaptersWithProgress(selectedPhase.fullName);
});

/// Words for selected chapter
final chapterWordsProvider = FutureProvider<List<WordModel>>((ref) async {
  final selectedChapter = ref.watch(selectedChapterProvider);
  if (selectedChapter == null) return [];

  final repository = ref.watch(wordRepositoryProvider);
  return repository.getWordsByChapter(selectedChapter.name);
});

// ========== SEARCH ==========

/// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Search results
final searchResultsProvider = FutureProvider<List<WordModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final repository = ref.watch(wordRepositoryProvider);
  return repository.searchWords(query);
});

/// Is searching
final isSearchingProvider = StateProvider<bool>((ref) => false);

// ========== FAVORITES ==========

/// Favorite words grouped by chapter
final favoritesProvider =
    FutureProvider<Map<String, List<WordModel>>>((ref) async {
  final repository = ref.watch(masteryRepositoryProvider);
  return repository.getFavoriteWordsGrouped();
});

/// Refresh trigger for favorites
final favoritesRefreshProvider = StateProvider<int>((ref) => 0);

// ========== NEEDS REVISION ==========

/// Needs revision words grouped by chapter
final needsRevisionProvider =
    FutureProvider<Map<String, List<WordModel>>>((ref) async {
  final repository = ref.watch(masteryRepositoryProvider);
  return repository.getNeedsRevisionWordsGrouped();
});

/// Mastered words grouped by chapter
final masteredWordsProvider =
    FutureProvider<Map<String, List<WordModel>>>((ref) async {
  final repository = ref.watch(masteryRepositoryProvider);
  return repository.getMasteredWordsGrouped();
});

// ========== MASTERY STATE ==========

/// Check if current word is favorited
final isCurrentWordFavoritedProvider = FutureProvider<bool>((ref) async {
  final word = ref.watch(currentWordProvider).valueOrNull;
  if (word == null) return false;

  final repository = ref.watch(masteryRepositoryProvider);
  return repository.isWordFavorited(word.id);
});

/// Check if current word is mastered
final isCurrentWordMasteredProvider = FutureProvider<bool>((ref) async {
  final word = ref.watch(currentWordProvider).valueOrNull;
  if (word == null) return false;

  final repository = ref.watch(masteryRepositoryProvider);
  return repository.isWordMastered(word.id);
});

// ========== USER STATS ==========

/// User statistics
final userStatsProvider = FutureProvider<UserStatsModel>((ref) async {
  final repository = ref.watch(statsRepositoryProvider);
  return repository.getUserStats();
});

/// Has new XP notification (kept for backward compatibility, but no longer used)
final hasNewXpProvider = StateProvider<bool>((ref) => false);

// ========== WORD MASTERY HELPERS ==========

/// Provider to check if a specific word is mastered
final wordMasteryProvider =
    FutureProvider.family<bool, String>((ref, wordId) async {
  final repository = ref.watch(masteryRepositoryProvider);
  return repository.isWordMastered(wordId);
});

/// Provider to check if a specific word needs revision
final wordNeedsRevisionProvider =
    FutureProvider.family<bool, String>((ref, wordId) async {
  final repository = ref.watch(masteryRepositoryProvider);
  return repository.isWordNeedsRevision(wordId);
});

/// Provider to check if a specific word is favorited
final wordFavoriteProvider =
    FutureProvider.family<bool, String>((ref, wordId) async {
  final repository = ref.watch(masteryRepositoryProvider);
  return repository.isWordFavorited(wordId);
});
