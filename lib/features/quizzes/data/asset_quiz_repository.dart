import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/content_cache_service.dart';
import '../../../shared/models/quiz.dart';
import '../../../shared/models/quiz_result.dart';
import '../domain/quiz_repository.dart';

class AssetQuizRepository implements QuizRepository {
  const AssetQuizRepository();

  Future<List<Quiz>> _loadQuizzes() async {
    final raw = await const ContentCacheService().loadJson(
      'cache_quizzes',
      'assets/data/quizzes.json',
    );
    return (jsonDecode(raw) as List)
        .map((item) => Quiz.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Quiz?> getDailyQuiz() async {
    final quizzes = await _loadQuizzes();
    quizzes.sort((a, b) => a.lessonId.compareTo(b.lessonId));
    return quizzes.isEmpty ? null : quizzes.first;
  }

  @override
  Future<Quiz?> getQuizForLesson(String lessonId) async {
    for (final quiz in await _loadQuizzes()) {
      if (quiz.lessonId == lessonId) return quiz;
    }
    return null;
  }

  @override
  Future<void> saveResult(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('local_quiz_results') ?? const [];
    final json = result.toJson();
    json['id'] = result.id;
    json['completedAt'] = result.completedAt.toIso8601String();
    await prefs.setStringList('local_quiz_results', [
      ...existing,
      jsonEncode(json),
    ]);
  }
}
