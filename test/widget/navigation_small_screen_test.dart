import 'package:aiwithshiv/features/dashboard/presentation/dashboard_providers.dart';
import 'package:aiwithshiv/features/dashboard/presentation/dashboard_screen.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_providers.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_screen.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const smallScreens = <Size>[
    Size(320, 568), // iPhone SE class
    Size(360, 640), // small Android class
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  for (final size in smallScreens) {
    testWidgets('Dashboard and Daily Quiz fit ${size.width}x${size.height}', (
      tester,
    ) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;

      await tester.pumpWidget(_testApp(const DashboardScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      expect(find.text('Start Learning'), findsOneWidget);

      await tester.pumpWidget(_testApp(const QuizScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      expect(find.text('Daily Quiz'), findsOneWidget);
      expect(find.text('START MISSION 🚀'), findsOneWidget);
    });
  }
}

Widget _testApp(Widget child) {
  return ProviderScope(
    overrides: [
      dashboardProvider.overrideWith((ref) async {
        return DashboardState(
          progress: UserProgress.starter(
            'test-user',
          ).copyWith(xp: 120, coins: 70, streakDays: 3),
          dailyLesson: _lesson,
          dailyQuiz: _quiz,
          continueLesson: _lesson,
        );
      }),
      dailyQuizProvider.overrideWith((ref) async => _quiz),
    ],
    child: MaterialApp(home: child),
  );
}

const _lesson = Lesson(
  id: 'ai-masti-missions-lesson-01',
  courseId: 'ai-masti-missions',
  title: 'Meet Shiv the AI Hero',
  story: 'Shiv helps children learn AI safely.',
  concepts: ['AI helper'],
  durationMinutes: 5,
  xp: 25,
  order: 1,
);

const _quiz = Quiz(
  id: 'daily-quiz',
  lessonId: 'ai-masti-missions-lesson-01',
  title: 'Daily Quiz',
  questions: [
    QuizQuestion(
      id: 'q1',
      prompt: 'Which one is AI?',
      options: ['A pencil', 'A game suggesting your next level'],
      answerIndex: 1,
      explanation: 'The game learns from examples.',
    ),
  ],
);
