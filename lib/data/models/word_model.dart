/// Model representing a technical vocabulary word in TechTake.
class WordModel {
  final String id;
  final String word;
  final String theTake;
  final String howToUse;
  final String story;
  final String whyItExists;
  final String useAvoid;
  final String category; // Phase name (e.g., "Phase 1: The Foundation")
  final String conceptId; // Chapter name (e.g., "The Language of Machines")
  final String conversationQ;
  final String conversationA;

  const WordModel({
    required this.id,
    required this.word,
    required this.theTake,
    required this.howToUse,
    required this.story,
    required this.whyItExists,
    required this.useAvoid,
    required this.category,
    required this.conceptId,
    required this.conversationQ,
    required this.conversationA,
  });

  /// Create WordModel from SQLite map
  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] as String,
      word: map['word'] as String,
      theTake: map['theTake'] as String,
      howToUse: map['howToUse'] as String,
      story: map['story'] as String,
      whyItExists: map['whyItExists'] as String,
      useAvoid: map['useAvoid'] as String,
      category: map['category'] as String,
      conceptId: map['conceptId'] as String,
      conversationQ: map['conversationQ'] as String,
      conversationA: map['conversationA'] as String,
    );
  }

  /// Convert WordModel to SQLite map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'theTake': theTake,
      'howToUse': howToUse,
      'story': story,
      'whyItExists': whyItExists,
      'useAvoid': useAvoid,
      'category': category,
      'conceptId': conceptId,
      'conversationQ': conversationQ,
      'conversationA': conversationA,
    };
  }

  /// Extract phase number from category (e.g., "Phase 1: The Foundation" -> 1)
  int get phaseNumber {
    final match = RegExp(r'Phase (\d+)').firstMatch(category);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  /// Extract phase title from category (e.g., "Phase 1: The Foundation" -> "The Foundation")
  String get phaseTitle {
    final parts = category.split(': ');
    return parts.length > 1 ? parts[1] : category;
  }

  @override
  String toString() => 'WordModel(id: $id, word: $word)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
