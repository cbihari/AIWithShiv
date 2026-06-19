import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bundled learning content is internally consistent', () async {
    final courses = _readJsonList('assets/data/courses.json');
    final lessons = _readJsonList('assets/data/lessons.json');
    final quizzes = _readJsonList('assets/data/quizzes.json');
    final games = _readJsonList('assets/data/games.json');
    final achievements = _readJsonList('assets/data/achievements.json');
    final rewards = _readJsonList('assets/data/rewards.json');

    expect(courses, hasLength(3));
    expect(lessons, hasLength(30));
    expect(quizzes, hasLength(30));
    expect(games, hasLength(5));
    expect(achievements, isNotEmpty);
    expect(rewards, isNotEmpty);

    final courseIds = _ids(courses);
    final lessonIds = _ids(lessons);
    final quizIds = _ids(quizzes);
    final gameIds = _ids(games);
    final achievementIds = _ids(achievements);
    final rewardIds = _ids(rewards);

    expect(courseIds, hasLength(courses.length));
    expect(lessonIds, hasLength(lessons.length));
    expect(quizIds, hasLength(quizzes.length));
    expect(gameIds, hasLength(games.length));
    expect(achievementIds, hasLength(achievements.length));
    expect(rewardIds, hasLength(rewards.length));

    for (final course in courses) {
      final courseId = course['id'] as String;
      final lessonIdsInCourse = List<String>.from(course['lessonIds'] as List);
      expect(lessonIdsInCourse, hasLength(10), reason: courseId);
      expect(course['ageGroups'], contains('kids'), reason: courseId);

      final courseLessons =
          lessons.where((lesson) => lesson['courseId'] == courseId).toList();
      expect(courseLessons, hasLength(10), reason: courseId);
      expect(
        courseLessons.fold<int>(
          0,
          (sum, lesson) => sum + (lesson['xp'] as int),
        ),
        course['xp'],
        reason: '$courseId XP must equal lesson XP total',
      );

      for (final lessonId in lessonIdsInCourse) {
        expect(lessonIds, contains(lessonId),
            reason: '$courseId references $lessonId');
      }
    }

    for (final lesson in lessons) {
      final lessonId = lesson['id'] as String;
      final courseId = lesson['courseId'] as String;
      final order = lesson['order'] as int;
      expect(courseIds, contains(courseId), reason: lessonId);
      expect(order, inInclusiveRange(1, 10), reason: lessonId);
      expect(lesson['durationMinutes'], inInclusiveRange(5, 8),
          reason: lessonId);
      expect(lesson['xp'], inInclusiveRange(20, 40), reason: lessonId);
      expect(lesson['concepts'], isNotEmpty, reason: lessonId);
      expect(
        lessonId,
        '$courseId-lesson-${order.toString().padLeft(2, '0')}',
        reason: 'Phase 1 lesson ids should follow course lesson order',
      );
    }

    for (final lessonId in lessonIds) {
      final lessonQuizzes =
          quizzes.where((quiz) => quiz['lessonId'] == lessonId).toList();
      expect(lessonQuizzes, hasLength(1), reason: lessonId);
    }

    for (final quiz in quizzes) {
      final quizId = quiz['id'] as String;
      expect(lessonIds, contains(quiz['lessonId']), reason: quizId);
      final questions = quiz['questions'] as List;
      expect(questions, hasLength(2), reason: quizId);
      for (final rawQuestion in questions) {
        final question = rawQuestion as Map<String, dynamic>;
        final options = question['options'] as List;
        final answerIndex = question['answerIndex'] as int;
        final correctAnswerIndexes =
            List<int>.from(question['correctAnswerIndexes'] as List);
        expect(options, hasLength(4), reason: question['id'] as String);
        expect(answerIndex, inInclusiveRange(0, options.length - 1));
        expect(correctAnswerIndexes, contains(answerIndex));
        for (final index in correctAnswerIndexes) {
          expect(index, inInclusiveRange(0, options.length - 1));
        }
      }
    }

    const registeredGameRoutes = {
      '/games',
      '/games/train-robot',
      '/games/ai-detective',
      '/games/sort-like-ai',
      '/games/robot-treasure-hunt',
      '/games/spot-ai-mistake',
    };
    for (final game in games) {
      expect(game['route'], isA<String>(), reason: game['id'] as String);
      if (game['isActive'] == true) {
        expect(
          registeredGameRoutes,
          contains(game['route']),
          reason: '${game['id']} must point to a registered route',
        );
      }
    }
  });
}

List<Map<String, dynamic>> _readJsonList(String path) {
  final decoded = jsonDecode(File(path).readAsStringSync()) as List<dynamic>;
  return decoded.cast<Map<String, dynamic>>();
}

Set<String> _ids(List<Map<String, dynamic>> items) {
  return items.map((item) => item['id'] as String).toSet();
}
