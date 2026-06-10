import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../shared/models/achievement.dart';
import '../data/firestore_achievement_repository.dart';
import '../domain/achievement_repository.dart';

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return FirestoreAchievementRepository(ref.watch(firestoreProvider));
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) {
  return ref.watch(achievementRepositoryProvider).getAchievements();
});
