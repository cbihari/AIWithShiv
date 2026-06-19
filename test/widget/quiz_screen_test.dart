import 'package:aiwithshiv/features/dashboard/presentation/dashboard_providers.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_providers.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_screen.dart';
import 'package:aiwithshiv/core/localization/language_service.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    LanguageService.language.value = AppLanguage.english;
  });

  testWidgets('Quiz screen renders question and answer choices', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quizForLessonProvider('lesson-1').overrideWith((ref) async {
            return const Quiz(
              id: 'quiz-1',
              lessonId: 'lesson-1',
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
          }),
          dashboardProvider.overrideWith((ref) async {
            return DashboardState(
              progress: UserProgress.starter('test-user'),
              dailyLesson: const Lesson(
                id: 'lesson-1',
                courseId: 'course-1',
                title: 'Lesson',
                story: 'Story',
                concepts: ['AI'],
                durationMinutes: 5,
                xp: 20,
              ),
              dailyQuiz: const Quiz(
                id: 'quiz-1',
                lessonId: 'lesson-1',
                title: 'Daily Quiz',
                questions: [],
              ),
              continueLesson: null,
            );
          }),
        ],
        child: const MaterialApp(home: QuizScreen(lessonId: 'lesson-1')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1600));

    expect(find.text('Which one is AI?'), findsOneWidget);
    expect(find.text('A game suggesting your next level'), findsOneWidget);
    expect(find.text('Q1 of 1'), findsOneWidget);
  });

  testWidgets('Hindi quiz screen renders Course 3 checkpoint on small phone', (
    tester,
  ) async {
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    LanguageService.language.value = AppLanguage.hindi;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quizForLessonProvider('teach-the-robot-lesson-04').overrideWith((
            ref,
          ) async {
            return const Quiz(
              id: 'teach-the-robot-lesson-04-quiz',
              lessonId: 'teach-the-robot-lesson-04',
              title: 'Good Data Checkpoint',
              questions: [
                QuizQuestion(
                  id: 'teach-the-robot-lesson-04-q1',
                  prompt: 'Which data helps ShivBot most?',
                  options: [
                    'Clear mango card with right label',
                    'Blurry card with wrong label',
                    'Password list',
                    'No label at all',
                  ],
                  answerIndex: 0,
                  correctAnswerIndexes: [0],
                  explanation: 'Good data is clear and correctly labeled.',
                ),
                QuizQuestion(
                  id: 'teach-the-robot-lesson-04-q2',
                  prompt: 'Good data should be what?',
                  options: [
                    'Clear and correct',
                    'Private and secret',
                    'Wrong and confusing',
                    'Always empty',
                  ],
                  answerIndex: 0,
                  correctAnswerIndexes: [0],
                  explanation: 'Good data helps AI learn safely.',
                ),
              ],
            );
          }),
          dashboardProvider.overrideWith((ref) async {
            return DashboardState(
              progress: UserProgress.starter('test-user'),
              dailyLesson: const Lesson(
                id: 'teach-the-robot-lesson-04',
                courseId: 'teach-the-robot',
                title: 'Good Data',
                story: 'Story',
                concepts: ['Good data'],
                durationMinutes: 6,
                xp: 25,
              ),
              dailyQuiz: const Quiz(
                id: 'quiz-1',
                lessonId: 'teach-the-robot-lesson-04',
                title: 'Daily Quiz',
                questions: [],
              ),
              continueLesson: null,
            );
          }),
        ],
        child: const MaterialApp(
          home: QuizScreen(lessonId: 'teach-the-robot-lesson-04'),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1600));

    expect(tester.takeException(), isNull);
    expect(find.text('कौन सा data ShivBot को सबसे ज्यादा help करता है?'),
        findsOneWidget);
    expect(find.text('Clear mango card with right label'), findsOneWidget);
    expect(find.text('Q1 of 2'), findsOneWidget);
  });
}
