import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../shared/models/game.dart';
import '../../achievements/presentation/achievement_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../dashboard/presentation/dashboard_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import '../data/asset_game_repository.dart';
import '../data/local_game_progress_repository.dart';
import '../domain/game_repository.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return const AssetGameRepository();
});

final gameProgressRepositoryProvider = Provider<GameProgressRepository>((ref) {
  return const LocalGameProgressRepository();
});

final gamesProvider = FutureProvider<List<LearningGame>>((ref) {
  return ref.watch(gameRepositoryProvider).getGames();
});

final gameProvider = FutureProvider.family<LearningGame?, String>((ref, id) {
  return ref.watch(gameRepositoryProvider).getGame(id);
});

final gameProgressProvider = FutureProvider<GameProgress>((ref) {
  final userId = ref.watch(currentUserIdProvider) ?? 'guest';
  return ref.watch(gameProgressRepositoryProvider).getProgress(userId);
});

final gameCompletionProvider =
    StateNotifierProvider<GameCompletionNotifier, AsyncValue<GameCompletion?>>(
  (ref) => GameCompletionNotifier(ref),
);

class GameCompletion {
  const GameCompletion({
    required this.gameId,
    required this.rewarded,
    required this.score,
    required this.xp,
    required this.coins,
  });

  final String gameId;
  final bool rewarded;
  final int score;
  final int xp;
  final int coins;
}

class GameCompletionNotifier
    extends StateNotifier<AsyncValue<GameCompletion?>> {
  GameCompletionNotifier(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<GameCompletion> completeGame({
    required LearningGame game,
    required int score,
  }) async {
    state = const AsyncLoading();
    try {
      final userId = _ref.read(currentUserIdProvider) ?? 'guest';
      final gameProgressRepository = _ref.read(gameProgressRepositoryProvider);
      final progressRepository = _ref.read(progressRepositoryProvider);
      final gameProgress = await gameProgressRepository.getProgress(userId);
      final alreadyCompleted = gameProgress.completedGames.contains(game.id);
      final attempts = Map<String, int>.from(gameProgress.gameAttempts);
      final bestScore = Map<String, int>.from(gameProgress.bestScore);
      attempts[game.id] = (attempts[game.id] ?? 0) + 1;
      bestScore[game.id] =
          score > (bestScore[game.id] ?? 0) ? score : (bestScore[game.id] ?? 0);

      var updatedGameProgress = gameProgress.copyWith(
        gameAttempts: attempts,
        bestScore: bestScore,
      );

      var awardedXp = 0;
      var awardedCoins = 0;
      final gameBadges = _gameBadgesFor(
        alreadyCompleted
            ? gameProgress.completedGames
            : {...updatedGameProgress.completedGames, game.id}.toList(),
      );
      if (!alreadyCompleted) {
        awardedXp = game.xpReward;
        awardedCoins = game.coinReward;
        updatedGameProgress = updatedGameProgress.copyWith(
          completedGames:
              {...updatedGameProgress.completedGames, game.id}.toList(),
          totalGameXp: updatedGameProgress.totalGameXp + awardedXp,
          totalGameCoins: updatedGameProgress.totalGameCoins + awardedCoins,
        );

        final progress = await progressRepository.getProgress(userId);
        final nextXp = progress.xp + awardedXp;
        final gamification = _ref.read(gamificationServiceProvider);
        var updatedProgress = progress.copyWith(
          xp: nextXp,
          coins: progress.coins + awardedCoins,
          level: (nextXp ~/ 250) + 1,
          streakDays: _nextStreak(progress.lastActivityAt, progress.streakDays),
          lastActivityAt: DateTime.now(),
        );

        final achievements =
            await _ref.read(achievementRepositoryProvider).getAchievements();
        updatedProgress = updatedProgress.copyWith(
          badges: {
            ...gamification.unlockedBadges(
              xp: updatedProgress.xp,
              currentBadges: updatedProgress.badges,
              achievementRequirements: {
                for (final achievement in achievements)
                  achievement.id: achievement.requiredXp,
              },
            ),
            ...gameBadges,
          }.toList(),
        );
        await progressRepository.saveProgress(updatedProgress);
      } else {
        final progress = await progressRepository.getProgress(userId);
        final missingBadges = gameBadges.difference(progress.badges.toSet());
        if (missingBadges.isNotEmpty) {
          await progressRepository.saveProgress(
            progress.copyWith(
              badges: {...progress.badges, ...missingBadges}.toList(),
            ),
          );
        }
      }

      await gameProgressRepository.saveProgress(updatedGameProgress);
      _ref
        ..invalidate(gameProgressProvider)
        ..invalidate(dashboardProvider)
        ..invalidate(userProgressProvider(userId));

      final completion = GameCompletion(
        gameId: game.id,
        rewarded: !alreadyCompleted,
        score: score,
        xp: awardedXp,
        coins: awardedCoins,
      );
      state = AsyncData(completion);
      return completion;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  int _nextStreak(DateTime? lastActivityAt, int currentStreak) {
    if (lastActivityAt == null) return 1;
    final now = DateTime.now();
    final last = DateTime(
      lastActivityAt.year,
      lastActivityAt.month,
      lastActivityAt.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(last).inDays;
    if (difference == 0) return currentStreak;
    if (difference == 1) return currentStreak + 1;
    return 1;
  }

  Set<String> _gameBadgesFor(List<String> completedGames) {
    final completed = completedGames.toSet();
    return {
      if (completed.isNotEmpty) 'game-starter',
      if (completed.contains('ai_detective')) 'pattern-detective',
      if (completed.contains('train_robot')) 'robot-trainer',
      if (completed.length >= 5) 'ai-games-hero',
    };
  }
}
