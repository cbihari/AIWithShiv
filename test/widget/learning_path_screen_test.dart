import 'package:aiwithshiv/core/localization/language_service.dart';
import 'package:aiwithshiv/features/lessons/presentation/learning_path_screen.dart';
import 'package:aiwithshiv/features/lessons/presentation/lesson_providers.dart';
import 'package:aiwithshiv/features/progress/presentation/progress_providers.dart';
import 'package:aiwithshiv/shared/models/course.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  tearDown(() {
    LanguageService.language.value = AppLanguage.english;
  });

  testWidgets('Hindi Learning Path fits compact phone with Phase 1 courses', (
    tester,
  ) async {
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    LanguageService.language.value = AppLanguage.hindi;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const LearningPathScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (_, __) => const Scaffold(body: Text('Dashboard')),
        ),
        GoRoute(
          path: '/lesson/:id',
          builder: (_, state) => Scaffold(
            body: Text('Lesson ${state.pathParameters['id']}'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coursesProvider.overrideWith((ref) async => _courses),
          lessonsForCourseProvider('ai-masti-missions').overrideWith(
            (ref) async => _lessonsFor('ai-masti-missions'),
          ),
          lessonsForCourseProvider('pattern-playground').overrideWith(
            (ref) async => _lessonsFor('pattern-playground'),
          ),
          lessonsForCourseProvider('teach-the-robot').overrideWith(
            (ref) async => _lessonsFor('teach-the-robot'),
          ),
          userProgressProvider('guest').overrideWith(
            (ref) => Stream.value(UserProgress.starter('guest')),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 250));

    expect(tester.takeException(), isNull);
    expect(find.text('Learning Path'), findsOneWidget);
    expect(find.text('Pattern Playground'), findsOneWidget);
    expect(find.textContaining('Rangoli, cricket'), findsOneWidget);
    expect(find.text('Teach The Robot'), findsOneWidget);
    expect(find.textContaining('ShivBot को examples'), findsOneWidget);
  });
}

final _courses = [
  for (final id in [
    'ai-masti-missions',
    'pattern-playground',
    'teach-the-robot',
  ])
    Course(
      id: id,
      title: _courseTitle(id),
      description: _courseDescription(id),
      category: 'AI',
      ageGroups: const ['kids'],
      lessonIds: [
        for (var i = 1; i <= 10; i++)
          '$id-lesson-${i.toString().padLeft(2, '0')}',
      ],
      imageUrl: '',
      xp: 250,
    ),
];

List<Lesson> _lessonsFor(String courseId) {
  return [
    for (var i = 1; i <= 10; i++)
      Lesson(
        id: '$courseId-lesson-${i.toString().padLeft(2, '0')}',
        courseId: courseId,
        title: _lessonTitle(courseId, i),
        story: 'Story',
        concepts: const ['AI', 'Patterns', 'Safety'],
        durationMinutes: 5,
        xp: 25,
        order: i,
      ),
  ];
}

String _courseTitle(String id) {
  return switch (id) {
    'ai-masti-missions' => 'AI Masti Missions',
    'pattern-playground' => 'Pattern Playground',
    'teach-the-robot' => 'Teach The Robot',
    _ => id,
  };
}

String _courseDescription(String id) {
  return switch (id) {
    'ai-masti-missions' => 'AI basics with Shiv.',
    'pattern-playground' => 'Pattern games with Shiv.',
    'teach-the-robot' => 'Train ShivBot with examples.',
    _ => '',
  };
}

String _lessonTitle(String courseId, int order) {
  if (courseId == 'pattern-playground' && order == 1) {
    return 'Color Patterns';
  }
  if (courseId == 'teach-the-robot' && order == 1) {
    return 'Examples Teach Robots';
  }
  return 'Lesson $order';
}
