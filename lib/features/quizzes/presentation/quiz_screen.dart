import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/models/quiz_result.dart';
import 'quiz_providers.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({this.lessonId, super.key});

  final String? lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = lessonId == null
        ? ref.watch(dailyQuizProvider)
        : ref.watch(quizForLessonProvider(lessonId!));
    final quizState = ref.watch(quizViewModelProvider);
    return AppScaffold(
      title: lessonId == null ? 'Daily Quiz' : 'Lesson Quiz',
      child: AsyncValueView(
        value: quiz,
        isEmpty: (item) => item == null,
        emptyMessage: 'No quiz is available yet.',
        onRetry: () => lessonId == null
            ? ref.invalidate(dailyQuizProvider)
            : ref.invalidate(quizForLessonProvider(lessonId!)),
        data: (item) {
          final resolvedQuiz = item!;
          if (quizState.result != null) {
            return _QuizResultPanel(
              result: quizState.result!,
              onContinue: () {
                ref.read(quizViewModelProvider.notifier).reset();
                Navigator.of(context).maybePop();
              },
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                resolvedQuiz.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              for (final question in resolvedQuiz.questions) ...[
                Text(
                  question.prompt,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (var index = 0; index < question.options.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AnswerOption(
                      label: question.options[index],
                      selected:
                          quizState.selectedAnswers[question.id]?.contains(
                                index,
                              ) ??
                              false,
                      correct: quizState.submitted &&
                          question.acceptedAnswers.contains(index),
                      incorrect: quizState.submitted &&
                          (quizState.selectedAnswers[question.id]?.contains(
                                index,
                              ) ??
                              false) &&
                          !question.acceptedAnswers.contains(index),
                      onPressed: () => ref
                          .read(quizViewModelProvider.notifier)
                          .toggleAnswer(question, index),
                    ),
                  ),
                if (quizState.submitted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(question.explanation),
                  ),
              ],
              if (quizState.error != null)
                Text(
                  quizState.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              FilledButton(
                onPressed: quizState.saving
                    ? null
                    : () => ref
                        .read(quizViewModelProvider.notifier)
                        .submit(resolvedQuiz),
                child: Text(quizState.saving ? 'Saving...' : 'Submit Quiz'),
              ),
              TextButton(
                onPressed: quizState.saving
                    ? null
                    : () => ref.read(quizViewModelProvider.notifier).reset(),
                child: const Text('Clear answers'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuizResultPanel extends StatelessWidget {
  const _QuizResultPanel({required this.result, required this.onContinue});

  final QuizResult result;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final percent = (result.score / result.totalQuestions * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          percent >= 70 ? Icons.emoji_events : Icons.school,
          size: 84,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Quiz Complete',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '$percent%',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text('${result.score}/${result.totalQuestions} correct'),
                const SizedBox(height: 8),
                Text('+${result.earnedXp} XP'),
                Text('+${result.earnedCoins} coins'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onContinue,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Continue Learning'),
        ),
      ],
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.selected,
    required this.correct,
    required this.incorrect,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final bool correct;
  final bool incorrect;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderColor = correct
        ? Colors.green
        : incorrect
            ? colors.error
            : selected
                ? colors.primary
                : colors.outline;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: borderColor,
          width: selected || correct || incorrect ? 2 : 1,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(14),
      ),
      onPressed: onPressed,
      icon: Icon(
        correct
            ? Icons.check_circle
            : incorrect
                ? Icons.cancel
                : selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
      ),
      label: Text(label),
    );
  }
}
