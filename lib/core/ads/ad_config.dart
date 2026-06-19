import 'package:flutter/foundation.dart';

import '../../config/env.dart';

class AppConfig {
  const AppConfig._();

  static const bool enableAds = Env.enableAds;
}

class AdConfig {
  const AdConfig._();

  static const String androidTestAppId =
      'ca-app-pub-3940256099942544~3347511713';
  static const String iosTestAppId = 'ca-app-pub-3940256099942544~1458002511';

  static const String androidTestBannerId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String androidTestInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String androidTestRewardedId =
      'ca-app-pub-3940256099942544/5224354917';

  static const String iosTestBannerId =
      'ca-app-pub-3940256099942544/2934735716';
  static const String iosTestInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String iosTestRewardedId =
      'ca-app-pub-3940256099942544/1712485313';

  static const String androidProdBannerId = 'REPLACE_WITH_ANDROID_BANNER_ID';
  static const String androidProdInterstitialId =
      'REPLACE_WITH_ANDROID_INTERSTITIAL_ID';
  static const String androidProdRewardedId =
      'REPLACE_WITH_ANDROID_REWARDED_ID';

  static const String iosProdBannerId = 'REPLACE_WITH_IOS_BANNER_ID';
  static const String iosProdInterstitialId =
      'REPLACE_WITH_IOS_INTERSTITIAL_ID';
  static const String iosProdRewardedId = 'REPLACE_WITH_IOS_REWARDED_ID';

  static bool get useProductionIds => Env.appEnvironment == AppEnvironment.prod;

  static String get bannerId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return useProductionIds ? iosProdBannerId : iosTestBannerId;
    }
    return useProductionIds ? androidProdBannerId : androidTestBannerId;
  }

  static String get interstitialId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return useProductionIds ? iosProdInterstitialId : iosTestInterstitialId;
    }
    return useProductionIds
        ? androidProdInterstitialId
        : androidTestInterstitialId;
  }

  static String get rewardedId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return useProductionIds ? iosProdRewardedId : iosTestRewardedId;
    }
    return useProductionIds ? androidProdRewardedId : androidTestRewardedId;
  }
}
