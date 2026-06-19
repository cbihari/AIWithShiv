import 'dart:convert';

import '../../../core/services/content_cache_service.dart';
import '../../../shared/models/achievement.dart';
import '../domain/achievement_repository.dart';

class AssetAchievementRepository implements AchievementRepository {
  const AssetAchievementRepository();

  @override
  Future<List<Achievement>> getAchievements() async {
    final raw = await const ContentCacheService().loadJson(
      'cache_achievements',
      'assets/data/achievements.json',
    );
    final achievements = (jsonDecode(raw) as List)
        .map((item) => Achievement.fromJson(item as Map<String, dynamic>))
        .toList();
    achievements.sort((a, b) => a.requiredXp.compareTo(b.requiredXp));
    return achievements;
  }
}
