import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/achievement.dart';
import '../data/asset_achievement_repository.dart';
import '../domain/achievement_repository.dart';

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return const AssetAchievementRepository();
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) {
  return ref.watch(achievementRepositoryProvider).getAchievements();
});
