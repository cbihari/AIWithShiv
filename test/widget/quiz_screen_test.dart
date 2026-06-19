import 'package:aiwithshiv/features/dashboard/presentation/dashboard_providers.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_providers.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_screen.dart';
import 'package:aiwithshiv/shared/models/lesson.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
