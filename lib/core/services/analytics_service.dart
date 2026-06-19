class AnalyticsService {
  const AnalyticsService();

  static const instance = AnalyticsService();

  Future<void> appOpened({required String ageGroup}) =>
      _log('app_opened', {'age_group': ageGroup});

  Future<void> lessonStarted(String lessonId) =>
      _log('lesson_started', {'lesson_id': lessonId});

  Future<void> lessonCompleted(String lessonId, int durationSeconds) => _log(
        'lesson_completed',
        {'lesson_id': lessonId, 'duration_seconds': durationSeconds},
      );

  Future<void> quizCompleted(String quizId, int score) =>
      _log('quiz_completed', {'quiz_id': quizId, 'score': score});

  Future<void> dailyQuizCompleted(int streakCount) =>
      _log('daily_quiz_completed', {'streak_count': streakCount});

  Future<void> badgeUnlocked(String badgeId) =>
      _log('badge_unlocked', {'badge_id': badgeId});

  Future<void> shivBotOpened() => _log('shivbot_opened', const {});

  Future<void> _log(String name, Map<String, Object> parameters) async {
    // No-op in the Android/iOS local-first build.
    // Keep the wrapper so privacy-safe analytics can be added
    // later without touching child-facing screens.
  }
}
