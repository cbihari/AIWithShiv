import 'package:aiwithshiv/features/achievements/domain/achievement_repository.dart';
import 'package:aiwithshiv/features/achievements/presentation/achievement_providers.dart';
import 'package:aiwithshiv/features/auth/presentation/auth_providers.dart';
import 'package:aiwithshiv/features/games/domain/game_repository.dart';
import 'package:aiwithshiv/features/games/presentation/game_providers.dart';
import 'package:aiwithshiv/features/progress/domain/progress_repository.dart';
import 'package:aiwithshiv/features/progress/presentation/progress_providers.dart';
import 'package:aiwithshiv/shared/models/achievement.dart';
import 'package:aiwithshiv/shared/models/game.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProgressRepository implements ProgressRepository {
  UserProgress progress = UserProgress.starter('local-child');

  @override
  Future<UserProgress> getProgress(String userId) async => progress;

  @override
  Future<void> saveProgress(UserProgress progress) async {
    this.progress = progress;
  }

  @override
  Stream<UserProgress> watchProgress(String userId) => Stream.value(progress);
}

class FakeGameProgressRepository implements GameProgressRepository {
  GameProgress progress = GameProgress.starter('local-child');

  @override
  Future<GameProgress> getProgress(String userId) async => progress;

  @override
  Future<void> saveProgress(GameProgress progress) async {
    this.progress = progress;
  }
}

class FakeAchievementRepository implements AchievementRepository {
  @override
  Future<List<Achievement>> getAchievements() async => const [
        Achievement(
          id: 'game-starter',
          title: 'Game Starter',
          description: 'Complete one game.',
          icon: 'sports_esports',
          requiredXp: 99999,
        ),
      ];
}

class FakeGameRepository implements GameRepository {
  const FakeGameRepository(this.games);

  final List<LearningGame> games;

  @override
  Future<LearningGame?> getGame(String id) async {
    for (final game in games) {
      if (game.id == id) return game;
    }
    return null;
  }

  @override
  Future<List<LearningGame>> getGames() async => games;
}

void main() {
  test('completing game updates local progress and rewards once', () async {
    final progressRepository = FakeProgressRepository();
    final gameProgressRepository = FakeGameProgressRepository();
    const game = LearningGame(
      id: 'train_robot',
      title: 'Train the Robot',
      concept: 'Machine Learning',
      description: 'Teach with examples.',
      ageGroup: '5-10',
      durationMinutes: 4,
      xpReward: 20,
      coinReward: 10,
      route: '/games/train-robot',
      isActive: true,
    );
    final container = ProviderContainer(
      overrides: [
        currentUserIdProvider.overrideWithValue('local-child'),
        progressRepositoryProvider.overrideWithValue(progressRepository),
        gameProgressRepositoryProvider
            .overrideWithValue(gameProgressRepository),
        gameRepositoryProvider.overrideWithValue(const FakeGameRepository([
          game,
        ])),
        achievementRepositoryProvider.overrideWithValue(
          FakeAchievementRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(gameCompletionProvider.notifier);
    final first = await notifier.completeGame(game: game, score: 6);
    final second = await notifier.completeGame(game: game, score: 5);

    expect(first.rewarded, isTrue);
    expect(second.rewarded, isFalse);
    expect(progressRepository.progress.xp, 20);
    expect(progressRepository.progress.coins, 60);
    expect(progressRepository.progress.badges, contains('game-starter'));
    expect(progressRepository.progress.badges, contains('robot-trainer'));
    expect(progressRepository.progress.badges, contains('ai-games-hero'));
    expect(gameProgressRepository.progress.completedGames, ['train_robot']);
    expect(gameProgressRepository.progress.totalGameXp, 20);
    expect(gameProgressRepository.progress.totalGameCoins, 10);
    expect(gameProgressRepository.progress.gameAttempts['train_robot'], 2);
    expect(gameProgressRepository.progress.bestScore['train_robot'], 6);
  });

  test('game achievements unlock for detective and all games', () async {
    final progressRepository = FakeProgressRepository();
    final gameProgressRepository = FakeGameProgressRepository();
    const games = [
      LearningGame(
        id: 'train_robot',
        title: 'Train the Robot',
        concept: 'Machine Learning',
        description: 'Teach with examples.',
        ageGroup: '5-10',
        durationMinutes: 4,
        xpReward: 20,
        coinReward: 10,
        route: '/games/train-robot',
        isActive: true,
      ),
      LearningGame(
        id: 'ai_detective',
        title: 'AI Detective',
        concept: 'Pattern Recognition',
        description: 'Find odd item.',
        ageGroup: '5-10',
        durationMinutes: 3,
        xpReward: 15,
        coinReward: 8,
        route: '/games/ai-detective',
        isActive: true,
      ),
      LearningGame(
        id: 'sort_like_ai',
        title: 'Sort Like AI',
        concept: 'Classification',
        description: 'Sort items.',
        ageGroup: '5-10',
        durationMinutes: 4,
        xpReward: 20,
        coinReward: 10,
        route: '/games/sort-like-ai',
        isActive: true,
      ),
      LearningGame(
        id: 'robot_treasure_hunt',
        title: 'Robot Treasure Hunt',
        concept: 'Algorithm',
        description: 'Move robot.',
        ageGroup: '5-10',
        durationMinutes: 5,
        xpReward: 25,
        coinReward: 12,
        route: '/games/robot-treasure-hunt',
        isActive: true,
      ),
      LearningGame(
        id: 'spot_ai_mistake',
        title: 'Spot the AI Mistake',
        concept: 'AI Safety',
        description: 'Check answers.',
        ageGroup: '5-10',
        durationMinutes: 4,
        xpReward: 20,
        coinReward: 10,
        route: '/games/spot-ai-mistake',
        isActive: true,
      ),
    ];
    final container = ProviderContainer(
      overrides: [
        currentUserIdProvider.overrideWithValue('local-child'),
        progressRepositoryProvider.overrideWithValue(progressRepository),
        gameProgressRepositoryProvider
            .overrideWithValue(gameProgressRepository),
        gameRepositoryProvider
            .overrideWithValue(const FakeGameRepository(games)),
        achievementRepositoryProvider.overrideWithValue(
          FakeAchievementRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(gameCompletionProvider.notifier);
    for (final game in games) {
      await notifier.completeGame(game: game, score: 5);
    }

    expect(progressRepository.progress.badges, contains('game-starter'));
    expect(progressRepository.progress.badges, contains('pattern-detective'));
    expect(progressRepository.progress.badges, contains('robot-trainer'));
    expect(progressRepository.progress.badges, contains('ai-games-hero'));
    expect(progressRepository.progress.xp, 100);
    expect(progressRepository.progress.coins, 100);
  });

  test('AI Games Hero uses active game count instead of fixed threshold',
      () async {
    final progressRepository = FakeProgressRepository();
    final gameProgressRepository = FakeGameProgressRepository();
    const games = [
      LearningGame(
        id: 'train_robot',
        title: 'Train the Robot',
        concept: 'Machine Learning',
        description: 'Teach with examples.',
        ageGroup: '5-10',
        durationMinutes: 4,
        xpReward: 20,
        coinReward: 10,
        route: '/games/train-robot',
        isActive: true,
      ),
      LearningGame(
        id: 'sort_like_ai',
        title: 'Sort Like AI',
        concept: 'Classification',
        description: 'Sort items.',
        ageGroup: '5-10',
        durationMinutes: 4,
        xpReward: 20,
        coinReward: 10,
        route: '/games/sort-like-ai',
        isActive: true,
      ),
    ];
    final container = ProviderContainer(
      overrides: [
        currentUserIdProvider.overrideWithValue('local-child'),
        progressRepositoryProvider.overrideWithValue(progressRepository),
        gameProgressRepositoryProvider
            .overrideWithValue(gameProgressRepository),
        gameRepositoryProvider
            .overrideWithValue(const FakeGameRepository(games)),
        achievementRepositoryProvider.overrideWithValue(
          FakeAchievementRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(gameCompletionProvider.notifier);
    await notifier.completeGame(game: games.first, score: 5);
    expect(
        progressRepository.progress.badges, isNot(contains('ai-games-hero')));

    await notifier.completeGame(game: games.last, score: 5);
    expect(progressRepository.progress.badges, contains('ai-games-hero'));
  });
}
