import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  const AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logLessonStarted(String lessonId) {
    return _analytics.logEvent(
      name: 'lesson_started',
      parameters: {'lesson_id': lessonId},
    );
  }

  Future<void> logQuizCompleted(String quizId, int score) {
    return _analytics.logEvent(
      name: 'quiz_completed',
      parameters: {'quiz_id': quizId, 'score': score},
    );
  }

  Future<void> logShivBotAsked(String ageGroup) {
    return _analytics.logEvent(
      name: 'shivbot_asked',
      parameters: {'age_group': ageGroup},
    );
  }
}
