import '../../../shared/models/reward.dart';

abstract interface class RewardRepository {
  Future<List<Reward>> getRewards();
}
