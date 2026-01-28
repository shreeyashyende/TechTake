import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/providers.dart';
import 'presentation/widgets/app_header.dart';
import 'presentation/widgets/bottom_nav_bar.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/phases/phases_screen.dart';
import 'presentation/screens/chapters/chapters_screen.dart';
import 'presentation/screens/word_list/word_list_screen.dart';
import 'presentation/screens/find/find_screen.dart';
import 'presentation/screens/saved/saved_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/word_detail/swipeable_word_screen.dart';

/// Main TechTake application widget.
class TechTakeApp extends StatelessWidget {
  const TechTakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechTake',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShell(),
    );
  }
}

/// Main app shell containing navigation and screens.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    // Check and update streak when app starts
    Future.microtask(() {
      ref.read(statsRepositoryProvider).checkAndUpdateStreak().then((_) {
        ref.invalidate(userStatsProvider);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavIndex = ref.watch(bottomNavIndexProvider);
    final selectedPhase = ref.watch(selectedPhaseProvider);
    final selectedChapter = ref.watch(selectedChapterProvider);
    final selectedWord = ref.watch(selectedWordProvider);
    final isSettingsOpen = ref.watch(isSettingsOpenProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content or Settings content
          if (isSettingsOpen)
            _buildSettingsContent()
          else
            _buildMainContent(
              bottomNavIndex,
              selectedPhase,
              selectedChapter,
            ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(
              isSettingsActive: isSettingsOpen,
              onSettingsTap: () {
                ref.read(isSettingsOpenProvider.notifier).state = !isSettingsOpen;
              },
            ),
          ),

          // Bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomNavBar(),
          ),

          // Word detail overlay (from word list or search) - on top of everything
          if (selectedWord != null) _buildWordDetailOverlay(selectedWord),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return SettingsScreen(
      onClose: () => ref.read(isSettingsOpenProvider.notifier).state = false,
    );
  }

  Widget _buildMainContent(
    int bottomNavIndex,
    phase,
    chapter,
  ) {
    // Handle nested navigation for Phases tab
    if (bottomNavIndex == 1) {
      if (chapter != null) {
        return const WordListScreen();
      }
      if (phase != null) {
        return const ChaptersScreen();
      }
      return const PhasesScreen();
    }

    // Main tabs
    switch (bottomNavIndex) {
      case 0:
        return const HomeScreen();
      case 2:
        return const FindScreen();
      case 3:
        return const SavedScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget _buildWordDetailOverlay(word) {
    final swipeableWords = ref.watch(swipeableWordsProvider);
    final initialIndex = ref.watch(selectedWordIndexProvider);

    // Use swipeable screen if we have a list of words
    if (swipeableWords.isNotEmpty) {
      return SwipeableWordScreen(
        words: swipeableWords,
        initialIndex: initialIndex,
        onClose: () {
          ref.read(selectedWordProvider.notifier).state = null;
          ref.read(swipeableWordsProvider.notifier).state = [];
        },
      );
    }

    // Fallback for single word view (from search)
    return SwipeableWordScreen(
      words: [word],
      initialIndex: 0,
      onClose: () {
        ref.read(selectedWordProvider.notifier).state = null;
      },
    );
  }
}
