import 'package:aiwithshiv/core/ads/ad_config.dart';
import 'package:aiwithshiv/core/ads/ad_service.dart';
import 'package:aiwithshiv/core/ads/ad_stats_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ad feature flag is safe under tests', () {
    expect(AppConfig.enableAds, isA<bool>());
    expect(AdService.instance.adsEnabled, isFalse);
  });

  test('ad stats persist locally and reward keys claim once', () async {
    SharedPreferences.setMockInitialValues({});

    await AdStatsService.instance.recordAdShown();
    await AdStatsService.instance.recordRewardedAdWatched(coinsEarned: 10);

    final stats = await AdStatsService.instance.load();
    expect(stats.adsShown, 1);
    expect(stats.rewardedAdsWatched, 1);
    expect(stats.coinsEarnedFromAds, 10);

    expect(await AdStatsService.instance.claimRewardOnce('bonus'), isTrue);
    expect(await AdStatsService.instance.claimRewardOnce('bonus'), isFalse);
  });
}
