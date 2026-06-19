import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/language_service.dart';

class TtsService {
  TtsService._();

  static final instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _available = true;

  bool get isAvailable => _available;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    try {
      await _tts.awaitSpeakCompletion(true);
      await _tts.setPitch(1.1);
      await _applySettings();
    } catch (_) {
      _available = false;
    }
  }

  Future<bool> enabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tts_enabled') ?? true;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tts_enabled', value);
    if (!value) await stop();
  }

  Future<double> rate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('tts_rate') ?? 0.85;
  }

  Future<void> setRate(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tts_rate', value);
    await _tts.setSpeechRate(value);
  }

  Future<void> speak(String text, {VoidCallback? onComplete}) async {
    await initialize();
    if (!_available || !await enabled()) return;
    try {
      await _applySettings();
      _tts.setCompletionHandler(() => onComplete?.call());
      await _tts.speak(text.replaceAll('\n', ' '));
    } catch (_) {
      _available = false;
    }
  }

  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (_) {
      await stop();
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      _available = false;
    }
  }

  Future<void> _applySettings() async {
    await _tts.setSpeechRate(await rate());
    await _tts.setPitch(1.1);
    await _applyLanguage();
  }

  Future<void> _applyLanguage() async {
    final preferred = LanguageService.language.value == AppLanguage.hindi
        ? const ['hi-IN', 'hi']
        : const ['en-IN', 'en-US', 'en'];
    final languages = await _tts.getLanguages;
    if (languages is! List) return;
    final available = languages.map((item) => '$item').toSet();
    final match = preferred.cast<String?>().firstWhere(
          (code) => available.contains(code),
          orElse: () => null,
        );
    if (match != null) await _tts.setLanguage(match);
  }
}

typedef VoidCallback = void Function();
