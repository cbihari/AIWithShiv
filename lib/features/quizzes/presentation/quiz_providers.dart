import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../shared/models/quiz.dart';
import '../../../shared/models/quiz_result.dart';
import '../../achievements/presentation/achievement_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import '../data/firestore_quiz_repository.dart';
import '../domain/quiz_repository.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return FirestoreQuizRepository(ref.watch(firestoreProvider));
});

final dailyQuizProvider = FutureProvider<Quiz?>((ref) {
  return ref.watch(quizRepositoryProvider).getDailyQuiz();
});

final quizForLessonProvider = FutureProvider.family<Quiz?, String>((
  ref,
  lessonId,
) {
  return ref.watch(quizRepositoryProvider).getQuizForLesson(lessonId);
});

final quizViewModelProvider = StateNotifierProvider<QuizViewModel, QuizUiState>(
  (ref) {
    return QuizViewModel(ref);
  },
);

class QuizUiState {
  const QuizUiState({
    this.selectedAnswers = const {},
    this.submitted = false,
    this.saving = false,
    this.result,
    this.error,
  });

  final Map<String, Set<int>> selectedAnswers;
  final bool submitted;
  final bool saving;
  final QuizResult? result;
  final String? error;

  QuizUiState copyWith({
    Map<String, Set<int>>? selectedAnswers,
    bool? submitted,
    bool? saving,
    QuizResult? result,
    String? error,
  }) {
    return QuizUiState(
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      submitted: submitted ?? this.submitted,
      saving: saving ?? this.saving,
      result: result ?? this.result,
      error: error,
    );
  }
}

class QuizViewModel extends StateNotifier<QuizUiState> {
  QuizViewModel(this._ref) : super(const QuizUiState());

  final Ref _ref;

  void toggleAnswer(QuizQuestion question, int index) {
    if (state.submitted) return;
    final updated = Map<String, Set<int>>.from(state.selectedAnswers);
    final current = <int>{...?updated[question.id]};
    if (question.allowsMultipleAnswers) {
      current.contains(index) ? current.remove(index) : current.add(index);
    } else {
      current
        ..clear()
        ..add(index);
    }
    updated[question.id] = current;
    state = state.copyWith(selectedAnswers: updated);
  }

  Future<void> submit(Quiz quiz) async {
    if (quiz.questions.any(
      (question) => (state.selectedAnswers[question.id] ?? <int>{}).isEmpty,
    )) {
      state = state.copyWith(error: 'Answer every question before submitting.');
      return;
    }
    state = state.copyWith(saving: true);
    try {
      final userId = _ref.read(currentUserIdProvider) ?? 'guest';
      final score = quiz.questions.where((question) {
        final selected = state.selectedAnswers[question.id] ?? <int>{};
        return selected.length == question.acceptedAnswers.length &&
            selected.containsAll(question.acceptedAnswers);
      }).length;
      final earnedXp = score * 20;
      final earnedCoins = score * 10;
      final result = QuizResult(
        id: '${userId}_${quiz.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        quizId: quiz.id,
        lessonId: quiz.lessonId,
        score: score,
        totalQuestions: quiz.questions.length,
        earnedXp: earnedXp,
        earnedCoins: earnedCoins,
        completedAt: DateTime.now(),
      );

      await _ref.read(quizRepositoryProvider).saveResult(result);
      final progressRepository = _ref.read(progressRepositoryProvider);
      final progress = await progressRepository.getProgress(userId);
      final gamification = _ref.read(gamificationServiceProvider);
      var updatedProgress = gamification.awardQuizCompletion(
        progress,
        lessonId: quiz.lessonId,
        earnedXp: earnedXp,
        earnedCoins: earnedCoins,
      );
      final achievements =
          await _ref.read(achievementRepositoryProvider).getAchievements();
      updatedProgress = updatedProgress.copyWith(
        badges: gamification.unlockedBadges(
          xp: updatedProgress.xp,
          currentBadges: updatedProgress.badges,
          achievementRequirements: {
            for (final achievement in achievements)
              achievement.id: achievement.requiredXp,
          },
        ),
      );
      await progressRepository.saveProgress(updatedProgress);
      state = state.copyWith(submitted: true, saving: false, result: result);
    } catch (error) {
      state = state.copyWith(saving: false, error: error.toString());
    }
  }

  void reset() {
    state = const QuizUiState();
  }
}
