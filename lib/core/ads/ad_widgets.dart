import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../shared/widgets/comic_widgets.dart';
import 'ad_service.dart';

class AdBannerSlot extends StatefulWidget {
  const AdBannerSlot({super.key});

  @override
  State<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends State<AdBannerSlot> {
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    if (AdService.instance.adsEnabled) _load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!AdService.instance.adsEnabled || ad == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ComicColors.cream,
          border: Border.all(color: ComicColors.ink, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }

  Future<void> _load() async {
    final ad = await AdService.instance.loadBannerAd();
    if (!mounted) {
      ad?.dispose();
      return;
    }
    setState(() => _ad = ad);
  }
}

class RewardedAdBonusButton extends StatefulWidget {
  const RewardedAdBonusButton({
    required this.rewardKey,
    required this.label,
    required this.onRewardEarned,
    super.key,
  });

  final String rewardKey;
  final String label;
  final Future<void> Function() onRewardEarned;

  @override
  State<RewardedAdBonusButton> createState() => _RewardedAdBonusButtonState();
}

class _RewardedAdBonusButtonState extends State<RewardedAdBonusButton> {
  bool _loading = false;
  bool _claimed = false;

  @override
  Widget build(BuildContext context) {
    if (!AdService.instance.adsEnabled || _claimed) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ComicButton(
        label: _loading ? 'Loading...' : widget.label,
        color: ComicColors.yellow,
        expand: true,
        onPressed: _loading ? null : _watch,
      ),
    );
  }

  Future<void> _watch() async {
    setState(() => _loading = true);
    final earned = await AdService.instance.showRewardedAd(
      rewardKey: widget.rewardKey,
      onRewardEarned: () {},
    );
    if (earned) {
      await widget.onRewardEarned();
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
      _claimed = earned;
    });
  }
}
