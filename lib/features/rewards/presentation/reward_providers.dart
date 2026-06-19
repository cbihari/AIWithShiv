import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/reward.dart';
import '../data/asset_reward_repository.dart';
import '../domain/reward_repository.dart';

final rewardRepositoryProvider = Provider<RewardRepository>((ref) {
  return const AssetRewardRepository();
});

final rewardsProvider = FutureProvider<List<Reward>>((ref) {
  return ref.watch(rewardRepositoryProvider).getRewards();
});
