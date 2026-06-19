import 'package:aiwithshiv/features/dashboard/presentation/dashboard_screen.dart';
import 'package:aiwithshiv/features/dashboard/presentation/dashboard_providers.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Dashboard shows core gamification actions', (tester) async {
    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, __) => const DashboardScreen())],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardProvider.overrideWith((ref) async {
            return DashboardState(
              progress: UserProgress.starter(
                'test-user',
              ).copyWith(xp: 120, coins: 70, streakDays: 3),
              dailyLesson: const Lesson(
                id: 'ml-basics',
                courseId: 'ai-foundations',
                title: 'Machine Learning Basics',
                story: 'A game learns from examples.',
                concepts: ['examples'],
                durationMinutes: 10,
                xp: 70,
              ),
              dailyQuiz: const Quiz(
                id: 'quiz-1',
                lessonId: 'ml-basics',
                title: 'Daily Quiz',
                questions: [],
              ),
              continueLesson: null,
            );
          }),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Start Learning'), findsOneWidget);
    expect(find.textContaining('Hey'), findsOneWidget);
    expect(find.text('Ask Shiv'), findsOneWidget);
    expect(find.text('AI Games'), findsOneWidget);
    expect(find.text('Daily Quiz'), findsWidgets);
    expect(find.text('My Trophies'), findsOneWidget);
  });
}
