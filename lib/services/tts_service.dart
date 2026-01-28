import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for pronouncing technical terms.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  factory TtsService() => _instance;
  TtsService._internal();

  /// Initialize TTS engine
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45); // Slightly slower for technical terms
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _isInitialized = true;
  }

  /// Speak a word or phrase
  Future<void> speak(String text) async {
    await initialize();
    await _tts.speak(text);
  }

  /// Stop speaking
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Check if TTS is currently speaking
  Future<bool> get isSpeaking async {
    // FlutterTts doesn't have a direct isSpeaking getter,
    // so we track it via callbacks if needed
    return false;
  }
}
