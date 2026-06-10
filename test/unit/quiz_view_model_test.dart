import 'package:aiwithshiv/features/auth/presentation/auth_providers.dart';
import 'package:aiwithshiv/features/achievements/domain/achievement_repository.dart';
import 'package:aiwithshiv/features/achievements/presentation/achievement_providers.dart';
import 'package:aiwithshiv/features/progress/domain/progress_repository.dart';
import 'package:aiwithshiv/features/progress/presentation/progress_providers.dart';
import 'package:aiwithshiv/features/quizzes/domain/quiz_repository.dart';
import 'package:aiwithshiv/features/quizzes/presentation/quiz_providers.dart';
import 'package:aiwithshiv/shared/models/quiz.dart';
import 'package:aiwithshiv/shared/models/quiz_result.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:aiwithshiv/shared/models/achievement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeQuizRepository implements QuizRepository {
  QuizResult? savedResult;

  @override
  Future<Quiz?> getDailyQuiz() async => null;

  @override
  Future<Quiz?> getQuizForLesson(String lessonId) async => null;

  @override
  Future<void> saveResult(QuizResult result) async {
    savedResult = result;
  }
}

class FakeProgressRepository implements ProgressRepository {
  UserProgress progress = UserProgress.starter('guest');

  @override
  Future<UserProgress> getProgress(String userId) async => progress;

  @override
  Future<void> saveProgress(UserProgress progress) async {
    this.progress = progress;
  }

  @override
  Stream<UserProgress> watchProgress(String userId) => Stream.value(progress);
}

class FakeAchievementRepository implements AchievementRepository {
  @override
  Future<List<Achievement>> getAchievements() async {
    return const [
      Achievement(
        id: 'first-xp',
        title: 'First XP',
        description: 'Earn your first XP.',
        icon: 'spark',
        requiredXp: 20,
      ),
    ];
  }
}

void main() {
  test('QuizViewModel scores answers and awards progress', () async {
    final quizRepository = FakeQuizRepository();
    final progressRepository = FakeProgressRepository();
    final container = ProviderContainer(
      overrides: [
        currentUserIdProvider.overrideWithValue(null),
        quizRepositoryProvider.overrideWithValue(quizRepository),
        progressRepositoryProvider.overrideWithValue(progressRepository),
        achievementRepositoryProvider.overrideWithValue(
          FakeAchievementRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    const question = QuizQuestion(
      id: 'q1',
      prompt: 'Which one is AI?',
      options: ['A pencil', 'A recommendation engine'],
      answerIndex: 1,
      explanation: 'Recommendation engines learn from patterns.',
    );
    const quiz = Quiz(
      id: 'quiz-1',
      lessonId: 'lesson-1',
      title: 'Daily Quiz',
      questions: [question],
    );

    final viewModel = container.read(quizViewModelProvider.notifier);
    viewModel.toggleAnswer(question, 1);
    await viewModel.submit(quiz);

    expect(container.read(quizViewModelProvider).submitted, isTrue);
    expect(quizRepository.savedResult?.score, 1);
    expect(progressRepository.progress.xp, 20);
    expect(progressRepository.progress.coins, 60);
    expect(progressRepository.progress.badges, contains('first-xp'));
  });
}
