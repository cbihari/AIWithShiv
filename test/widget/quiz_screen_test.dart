import 'package:aiwithshiv/features/quizzes/presentation/quiz_providers.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_screen.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
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
          dailyQuizProvider.overrideWith((ref) async {
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
        ],
        child: const MaterialApp(home: QuizScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Which one is AI?'), findsOneWidget);
    expect(find.text('A game suggesting your next level'), findsOneWidget);
    expect(find.text('Submit Quiz'), findsOneWidget);
  });
}
