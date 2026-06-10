import '../../../shared/models/achievement.dart';

abstract interface class AchievementRepository {
  Future<List<Achievement>> getAchievements();
}
