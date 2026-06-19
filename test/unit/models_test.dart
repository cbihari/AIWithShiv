import 'package:aiwithshiv/shared/models/achievement.dart';
import 'package:aiwithshiv/shared/models/course.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
import 'package:aiwithshiv/shared/models/quiz_result.dart';
import 'package:aiwithshiv/shared/models/reward.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Course serializes from and to JSON shape', () {
    final course = Course.fromJson(const {
      'id': 'ai-foundations',
      'title': 'AI Foundations',
      'description': 'Learn AI',
      'category': 'AI',
      'ageGroups': ['tinyExplorers'],
      'lessonIds': ['lesson-1'],
      'imageUrl': 'gs://image',
      'xp': 100,
    });

    expect(course.id, 'ai-foundations');
    expect(course.toJson()['lessonIds'], ['lesson-1']);
  });

  test('Lesson serializes with order', () {
    final lesson = Lesson.fromJson(const {
      'id': 'lesson-1',
      'courseId': 'course-1',
      'title': 'Robots',
      'story': 'A robot follows commands.',
      'concepts': ['commands'],
      'durationMinutes': 8,
      'xp': 50,
      'order': 2,
    });

    expect(lesson.order, 2);
    expect(lesson.toJson()['order'], 2);
  });

  test('Quiz supports single and multiple answers', () {
    final quiz = Quiz.fromJson(const {
      'id': 'quiz-1',
      'lessonId': 'lesson-1',
      'title': 'Quiz',
      'questions': [
        {
          'id': 'q1',
          'prompt': 'Pick AI examples',
          'options': ['Game recommendation', 'Pencil', 'Vision app'],
          'answerIndex': 0,
          'correctAnswerIndexes': [0, 2],
          'explanation': 'Both use patterns.',
        }
      ],
    });

    expect(quiz.questions.first.allowsMultipleAnswers, isTrue);
    expect(quiz.toJson()['questions'], isA<List<dynamic>>());
  });

  test('Reward and Achievement serialize', () {
    final reward = Reward.fromJson(const {
      'id': 'daily',
      'title': 'Daily',
      'coins': 25,
      'trigger': 'daily_login',
    });
    final achievement = Achievement.fromJson(const {
      'id': 'first',
      'title': 'First',
      'description': 'First badge',
      'icon': 'spark',
      'requiredXp': 20,
    });

    expect(reward.toJson()['coins'], 25);
    expect(achievement.toJson()['requiredXp'], 20);
  });

  test('UserProgress copyWith and QuizResult serialize', () {
    final progress = UserProgress.starter('user-1').copyWith(
      xp: 40,
      coins: 80,
      badges: ['first'],
      lastActivityAt: DateTime(2026, 1, 1),
    );
    final result = QuizResult(
      id: 'result-1',
      userId: 'user-1',
      quizId: 'quiz-1',
      lessonId: 'lesson-1',
      score: 1,
      totalQuestions: 2,
      earnedXp: 20,
      earnedCoins: 10,
      completedAt: DateTime(2026, 1, 1),
    );

    expect(progress.toJson()['badges'], ['first']);
    expect(result.toJson()['score'], 1);
  });
}
