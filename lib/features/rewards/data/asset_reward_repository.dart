import 'dart:convert';

import '../../../core/services/content_cache_service.dart';
import '../../../shared/models/reward.dart';
import '../domain/reward_repository.dart';

class AssetRewardRepository implements RewardRepository {
  const AssetRewardRepository();

  @override
  Future<List<Reward>> getRewards() async {
    final raw = await const ContentCacheService().loadJson(
      'cache_rewards',
      'assets/data/rewards.json',
    );
    return (jsonDecode(raw) as List)
        .map((item) => Reward.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
