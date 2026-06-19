import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentCacheService {
  const ContentCacheService();

  static const _files = {
    'cache_courses': 'assets/data/courses.json',
    'cache_lessons': 'assets/data/lessons.json',
    'cache_quizzes': 'assets/data/quizzes.json',
    'cache_achievements': 'assets/data/achievements.json',
    'cache_rewards': 'assets/data/rewards.json',
  };

  Future<void> warmCache() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _files.entries) {
      final raw = await rootBundle.loadString(entry.value);
      await prefs.setString(entry.key, raw);
    }
    await prefs.setString('cache_timestamp', DateTime.now().toIso8601String());
  }

  Future<String> loadJson(String cacheKey, String assetPath) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKey);
    if (cached != null && cached.isNotEmpty) return cached;
    final raw = await rootBundle.loadString(assetPath);
    await prefs.setString(cacheKey, raw);
    await prefs.setString('cache_timestamp', DateTime.now().toIso8601String());
    return raw;
  }
}
