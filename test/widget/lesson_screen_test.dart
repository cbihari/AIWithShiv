import 'package:aiwithshiv/features/lessons/presentation/lesson_providers.dart';
import 'package:aiwithshiv/features/lessons/presentation/lesson_screen.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Lesson screen renders story and quiz action', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const LessonScreen(id: 'ml-basics'),
        ),
        GoRoute(
          path: '/quiz',
          builder: (_, __) => const Scaffold(body: Text('Quiz')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lessonProvider('ml-basics').overrideWith((ref) async {
            return const Lesson(
              id: 'ml-basics',
              courseId: 'ai-foundations',
              title: 'ML Basics',
              story: 'A game learns from examples.',
              concepts: ['training'],
              durationMinutes: 10,
              xp: 70,
            );
          }),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ML Basics'), findsOneWidget);
    expect(find.text('Shiv says:'), findsWidgets);
    expect(find.textContaining('A game learns from examples.'), findsOneWidget);
    expect(find.text('Keep Reading... 📖'), findsOneWidget);
  });
}
