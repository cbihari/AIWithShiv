import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../shared/models/reward.dart';
import '../data/firestore_reward_repository.dart';
import '../domain/reward_repository.dart';

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  return FirestoreRewardRepository(ref.watch(firestoreProvider));
});

final rewardsProvider = FutureProvider<List<Reward>>((ref) {
  return ref.watch(rewardRepositoryProvider).getRewards();
});
