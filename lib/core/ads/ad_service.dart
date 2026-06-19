import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';
import 'ad_stats_service.dart';

class AdService {
  AdService._();

  static final instance = AdService._();

  Future<void>? _initializing;
  bool _initialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool get adsEnabled => AppConfig.enableAds && !kIsWeb && !_runningInTest;

  bool get _runningInTest {
    return WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding');
  }

  Future<void> initialize() async {
    if (!adsEnabled) return;
    if (_initialized) return;
    _initializing ??= MobileAds.instance.initialize().then((_) {
      _initialized = true;
    }).catchError((Object _) {
      _initialized = false;
    });
    await _initializing;
  }

  Future<BannerAd?> loadBannerAd({AdSize size = AdSize.banner}) async {
    if (!adsEnabled) return null;
    await initialize();
    if (!_initialized) return null;

    final completer = Completer<BannerAd?>();
    late final BannerAd ad;
    ad = BannerAd(
      adUnitId: AdConfig.bannerId,
      size: size,
      request: const AdRequest(
        nonPersonalizedAds: true,
        keywords: ['education', 'kids learning', 'child safe'],
      ),
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          AdStatsService.instance.recordAdShown();
          completer.complete(loadedAd as BannerAd);
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );
    await ad.load();
    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        ad.dispose();
        return null;
      },
    );
  }

  Future<void> preloadInterstitial() async {
    if (!adsEnabled || _interstitialAd != null) return;
    await initialize();
    if (!_initialized) return;
    await InterstitialAd.load(
      adUnitId: AdConfig.interstitialId,
      request: const AdRequest(nonPersonalizedAds: true),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => _interstitialAd = null,
      ),
    );
  }

  Future<void> showInterstitialAd({required String placement}) async {
    if (!adsEnabled) return;
    await preloadInterstitial();
    final ad = _interstitialAd;
    if (ad == null) return;
    _interstitialAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        AdStatsService.instance.recordAdShown();
      },
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        shownAd.dispose();
        preloadInterstitial();
      },
    );
    await ad.show();
  }

  Future<void> preloadRewarded() async {
    if (!adsEnabled || _rewardedAd != null) return;
    await initialize();
    if (!_initialized) return;
    await RewardedAd.load(
      adUnitId: AdConfig.rewardedId,
      request: const AdRequest(nonPersonalizedAds: true),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (_) => _rewardedAd = null,
      ),
    );
  }

  Future<bool> showRewardedAd({
    required String rewardKey,
    required VoidCallback onRewardEarned,
  }) async {
    if (!adsEnabled) return false;
    final alreadyClaimed =
        await AdStatsService.instance.isRewardClaimed(rewardKey);
    if (alreadyClaimed) return false;
    await preloadRewarded();
    final ad = _rewardedAd;
    if (ad == null) return false;
    _rewardedAd = null;
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        AdStatsService.instance.recordAdShown();
      },
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        preloadRewarded();
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        shownAd.dispose();
        preloadRewarded();
      },
    );
    await ad.show(
      onUserEarnedReward: (_, __) {
        earned = true;
        AdStatsService.instance.markRewardClaimed(rewardKey);
        onRewardEarned();
      },
    );
    return earned;
  }

  void disposeLoadedAds() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }
}
