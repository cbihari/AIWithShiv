import 'package:shared_preferences/shared_preferences.dart';

class AdStats {
  const AdStats({
    required this.adsShown,
    required this.rewardedAdsWatched,
    required this.coinsEarnedFromAds,
  });

  final int adsShown;
  final int rewardedAdsWatched;
  final int coinsEarnedFromAds;
}

class AdStatsService {
  const AdStatsService();

  static const instance = AdStatsService();

  Future<AdStats> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AdStats(
      adsShown: prefs.getInt('ad_stats_ads_shown') ?? 0,
      rewardedAdsWatched: prefs.getInt('ad_stats_rewarded_watched') ?? 0,
      coinsEarnedFromAds: prefs.getInt('ad_stats_coins_earned') ?? 0,
    );
  }

  Future<void> recordAdShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'ad_stats_ads_shown',
      (prefs.getInt('ad_stats_ads_shown') ?? 0) + 1,
    );
  }

  Future<void> recordRewardedAdWatched({required int coinsEarned}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'ad_stats_rewarded_watched',
      (prefs.getInt('ad_stats_rewarded_watched') ?? 0) + 1,
    );
    await prefs.setInt(
      'ad_stats_coins_earned',
      (prefs.getInt('ad_stats_coins_earned') ?? 0) + coinsEarned,
    );
  }

  Future<bool> isRewardClaimed(String rewardKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('ad_reward_claimed_$rewardKey') ?? false;
  }

  Future<void> markRewardClaimed(String rewardKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ad_reward_claimed_$rewardKey', true);
  }

  Future<bool> claimRewardOnce(String rewardKey) async {
    if (await isRewardClaimed(rewardKey)) return false;
    await markRewardClaimed(rewardKey);
    return true;
  }
}
