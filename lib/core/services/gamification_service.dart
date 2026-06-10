import '../../shared/models/user_progress.dart';

class GamificationService {
  const GamificationService();

  UserProgress awardLessonCompletion(
    UserProgress progress,
    String lessonId,
    int xp,
  ) {
    final nextXp = progress.xp + xp;
    final nextLevel = (nextXp ~/ 250) + 1;
    return progress.copyWith(
      xp: nextXp,
      coins: progress.coins + 15,
      level: nextLevel,
      completedLessons: {...progress.completedLessons, lessonId}.toList(),
      lastActivityAt: DateTime.now(),
    );
  }

  UserProgress awardQuizCompletion(
    UserProgress progress, {
    required String lessonId,
    required int earnedXp,
    required int earnedCoins,
  }) {
    final nextXp = progress.xp + earnedXp;
    return progress.copyWith(
      xp: nextXp,
      coins: progress.coins + earnedCoins,
      level: (nextXp ~/ 250) + 1,
      streakDays: _nextStreak(progress.lastActivityAt, progress.streakDays),
      completedLessons: {...progress.completedLessons, lessonId}.toList(),
      lastActivityAt: DateTime.now(),
    );
  }

  List<String> unlockedBadges({
    required int xp,
    required List<String> currentBadges,
    required Map<String, int> achievementRequirements,
  }) {
    final updated = {...currentBadges};
    for (final entry in achievementRequirements.entries) {
      if (xp >= entry.value) updated.add(entry.key);
    }
    return updated.toList();
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
}
