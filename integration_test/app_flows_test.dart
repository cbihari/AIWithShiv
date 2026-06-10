import 'package:aiwithshiv/features/dashboard/presentation/dashboard_providers.dart';
import 'package:aiwithshiv/features/dashboard/presentation/dashboard_screen.dart';
import 'package:aiwithshiv/features/lessons/presentation/lesson_providers.dart';
import 'package:aiwithshiv/features/lessons/presentation/lesson_screen.dart';
import 'package:aiwithshiv/features/onboarding/presentation/age_selection_screen.dart';
import 'package:aiwithshiv/features/parents/presentation/parent_dashboard_screen.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_providers.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding, lesson, quiz, and parent surfaces render', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const AgeSelectionScreen()),
        GoRoute(
          path: '/dashboard',
          builder: (_, __) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/lesson/:id',
          builder: (_, state) => LessonScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(path: '/quiz', builder: (_, __) => const QuizScreen()),
        GoRoute(
          path: '/parents',
          builder: (_, __) => const ParentDashboardScreen(),
        ),
        GoRoute(
          path: '/consent',
          builder: (_, __) => const Scaffold(body: Text('Consent')),
        ),
        GoRoute(
          path: '/signup',
          builder: (_, __) => const Scaffold(body: Text('Signup')),
        ),
      ],
    );

    const lesson = Lesson(
      id: 'ml-basics',
      courseId: 'ai-foundations',
      title: 'ML Basics',
      story: 'A game learns from examples.',
      concepts: ['training'],
      durationMinutes: 10,
      xp: 70,
    );
    const quiz = Quiz(
      id: 'quiz-1',
      lessonId: 'ml-basics',
      title: 'Daily Quiz',
      questions: [
        QuizQuestion(
          id: 'q1',
          prompt: 'Which one is AI?',
          options: ['A pencil', 'A game suggesting your next level'],
          answerIndex: 1,
          explanation: 'The game learns from behavior.',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lessonProvider('ml-basics').overrideWith((ref) async => lesson),
          dailyQuizProvider.overrideWith((ref) async => quiz),
          dashboardProvider.overrideWith((ref) async {
            return DashboardState(
              progress: UserProgress.starter('test-user'),
              dailyLesson: lesson,
              dailyQuiz: quiz,
              continueLesson: lesson,
            );
          }),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    expect(find.text('Tiny Explorers'), findsOneWidget);

    router.go('/lesson/ml-basics');
    await tester.pumpAndSettle();
    expect(find.text('Take Quiz'), findsOneWidget);

    router.go('/quiz');
    await tester.pumpAndSettle();
    expect(find.text('Submit Answer'), findsOneWidget);

    router.go('/parents');
    await tester.pumpAndSettle();
    expect(find.text('Progress Tracking'), findsOneWidget);
  });
}
