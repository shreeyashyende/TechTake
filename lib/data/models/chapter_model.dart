/// Model representing a chapter within a phase.
class ChapterModel {
  final String name;
  final String phaseName;
  final int phaseNumber;
  final int totalWords;
  final int masteredWords;

  const ChapterModel({
    required this.name,
    required this.phaseName,
    required this.phaseNumber,
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

  /// Whether the chapter is complete
  bool get isComplete => totalWords > 0 && masteredWords >= totalWords;

  /// Progress display string (e.g., "5 / 12 TERMS MASTERED")
  String get progressDisplay =>
      '$masteredWords / $totalWords TERMS MASTERED';

  /// Create a copy with updated progress
  ChapterModel copyWith({
    String? name,
    String? phaseName,
    int? phaseNumber,
    int? totalWords,
    int? masteredWords,
  }) {
    return ChapterModel(
      name: name ?? this.name,
      phaseName: phaseName ?? this.phaseName,
      phaseNumber: phaseNumber ?? this.phaseNumber,
      totalWords: totalWords ?? this.totalWords,
      masteredWords: masteredWords ?? this.masteredWords,
    );
  }

  @override
  String toString() =>
      'ChapterModel(name: $name, progress: ${progressPercent.toStringAsFixed(0)}%)';
}
