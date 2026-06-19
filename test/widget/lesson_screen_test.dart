import 'package:aiwithshiv/features/lessons/presentation/lesson_providers.dart';
import 'package:aiwithshiv/features/lessons/presentation/lesson_screen.dart';
import 'package:aiwithshiv/core/localization/language_service.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  tearDown(() {
    LanguageService.language.value = AppLanguage.english;
  });

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

  testWidgets('Hindi lesson screen renders Course 2 content on small phone', (
    tester,
  ) async {
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    LanguageService.language.value = AppLanguage.hindi;

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) =>
              const LessonScreen(id: 'pattern-playground-lesson-01'),
        ),
        GoRoute(
          path: '/quiz/:lessonId',
          builder: (_, __) => const Scaffold(body: Text('Quiz')),
        ),
        GoRoute(
          path: '/learning-path',
          builder: (_, __) => const Scaffold(body: Text('Learning Path')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lessonProvider('pattern-playground-lesson-01').overrideWith((
            ref,
          ) async {
            return const Lesson(
              id: 'pattern-playground-lesson-01',
              courseId: 'pattern-playground',
              title: 'Color Patterns',
              story:
                  'Shiv builds a rangoli color path with red, yellow, red, yellow.',
              concepts: ['Colors', 'Repeating patterns', 'Rangoli'],
              durationMinutes: 5,
              xp: 20,
              order: 1,
            );
          }),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Color Patterns'), findsOneWidget);
    expect(find.text('Shiv कहता है:'), findsWidgets);
    expect(find.textContaining('Shiv rangoli वाला color path'), findsOneWidget);
  });
}
