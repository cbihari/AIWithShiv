import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/ads/ad_widgets.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/services/offline_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../shared/widgets/app_state_widgets.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import '../../shop/presentation/shop_providers.dart';
import 'dashboard_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  static const _avatars = ['🤖', '🦸', '🧑‍🚀', '🧙', '🦊', '🐯'];

  String _heroName = 'Hero';
  int _avatarIndex = 0;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final offline = ref.watch(isOfflineProvider);
    final activeTheme = ref.watch(activeThemeProvider).valueOrNull ?? '';
    final capeColor = ref.watch(capeColorProvider).valueOrNull ?? '';
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.language,
      builder: (context, language, _) {
        final strings = AppStrings(language);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.appTitle)),
              );
            }
          },
          child: Scaffold(
            body: ChildComicBackground(
              child: SafeArea(
                child: AsyncValueView(
                  value: dashboard,
                  loading: const DashboardShimmer(),
                  onRetry: () => ref.invalidate(dashboardProvider),
                  data: (state) {
                    final progress = state.progress;
                    final maxXp = (((progress.xp ~/ 100) + 1) * 100);
                    final quizDoneToday = progress.lastActivityAt != null &&
                        _isToday(progress.lastActivityAt!);
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _TopBar(
                          strings: strings,
                          heroName: _heroName,
                          avatar: _avatars[
                              _avatarIndex.clamp(0, _avatars.length - 1)],
                          coins: progress.coins,
                          muted: _muted,
                          offline: offline,
                          onAvatarTap: () => context.go('/profile'),
                          onCoinsTap: () => context.go('/shop'),
                          onMuteToggle: _toggleMute,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                          child: Column(
                            children: [
                              _AnimatedDashboardShiv(
                                capeColor: capeColor,
                                strings: strings,
                              ),
                              const SizedBox(height: 18),
                              _XpPanel(
                                xp: progress.xp,
                                maxXp: maxXp,
                                strings: strings,
                              ),
                              const SizedBox(height: 22),
                              _MenuGrid(
                                strings: strings,
                                quizDoneToday: quizDoneToday,
                                activeTheme: activeTheme,
                              ),
                              const SizedBox(height: 22),
                              _StreakBanner(
                                streak: progress.streakDays,
                                strings: strings,
                              ),
                              const AdBannerSlot(),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final muted = await SoundService.instance.isMuted();
    if (!mounted) return;
    setState(() {
      _heroName = prefs.getString('hero_name') ?? 'Hero';
      _avatarIndex = prefs.getInt('avatar_index') ?? 0;
      _muted = muted;
    });
  }

  Future<void> _toggleMute() async {
    await HapticFeedback.selectionClick();
    final next = !_muted;
    await SoundService.instance.setMuted(next);
    if (mounted) setState(() => _muted = next);
  }

  bool _isToday(DateTime value) {
    final now = DateTime.now();
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day;
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.strings,
    required this.heroName,
    required this.avatar,
    required this.coins,
    required this.muted,
    required this.offline,
    required this.onAvatarTap,
    required this.onCoinsTap,
    required this.onMuteToggle,
  });

  final AppStrings strings;
  final String heroName;
  final String avatar;
  final int coins;
  final bool muted;
  final bool offline;
  final VoidCallback onAvatarTap;
  final VoidCallback onCoinsTap;
  final VoidCallback onMuteToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: ComicColors.red,
        border: Border(bottom: BorderSide(color: ComicColors.ink, width: 5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ComicColors.yellow,
                shape: BoxShape.circle,
                border: Border.all(color: ComicColors.ink, width: 4),
              ),
              child: Text(avatar, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              strings.greeting(heroName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: comicDisplay(
                context,
                fontSize: 32,
                color: ComicColors.cream,
              ),
            ),
          ),
          IconButton(
            tooltip: muted ? strings.unmute : strings.mute,
            onPressed: onMuteToggle,
            icon: Text(
              muted ? '🔇' : '🔊',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          OfflinePill(visible: offline),
          GestureDetector(
            onTap: onCoinsTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: ComicColors.yellow,
                border: Border.all(color: ComicColors.ink, width: 3),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '🪙 $coins',
                style: comicBody(context, fontSize: 16, color: ComicColors.ink),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDashboardShiv extends StatefulWidget {
  const _AnimatedDashboardShiv({
    required this.capeColor,
    required this.strings,
  });

  final String capeColor;
  final AppStrings strings;

  @override
  State<_AnimatedDashboardShiv> createState() => _AnimatedDashboardShivState();
}

class _AnimatedDashboardShivState extends State<_AnimatedDashboardShiv>
    with TickerProviderStateMixin {
  List<String> get _bubbleTexts => widget.strings.isHindi
      ? const [
          'Chalo seekhte hain! ⚡',
          'Shabash dost! 🌟',
          'AI super fun है! 🤖',
          'तुम hero हो! 🦸',
        ]
      : const [
          'Chalo seekhte hain! ⚡',
          'Shabash dost! 🌟',
          'AI is super fun! 🤖',
          'You are a hero! 🦸',
        ];

  late final AnimationController _floatController;
  late final AnimationController _capeController;
  late final AnimationController _spinController;
  Timer? _blinkTimer;
  bool _blink = false;
  String? _bubble;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _capeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (!mounted) return;
      setState(() => _blink = true);
      Timer(const Duration(milliseconds: 150), () {
        if (mounted) setState(() => _blink = false);
      });
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _floatController.dispose();
    _capeController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tapShiv,
      child: SizedBox(
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_bubble != null)
              Positioned(
                top: 0,
                child: SpeechBubble(text: _bubble!, maxWidth: 280),
              ),
            Positioned(
              top: 42,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _floatController,
                  _capeController,
                  _spinController,
                ]),
                builder: (context, child) {
                  final y = math.sin(_floatController.value * math.pi) * -8;
                  final spin = _spinController.value * math.pi * 2;
                  final cape = math.sin(_capeController.value * math.pi) * 0.08;
                  return Transform.translate(
                    offset: Offset(0, y),
                    child: Transform.rotate(
                      angle: spin + cape,
                      child: child,
                    ),
                  );
                },
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: const Size(150, 190),
                    painter: _DashboardShivPainter(
                      blink: _blink,
                      capeColor: _capePaint(widget.capeColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tapShiv() async {
    await SoundService.instance.tap();
    final random = math.Random().nextInt(_bubbleTexts.length);
    final phrase = _bubbleTexts[random];
    setState(() => _bubble = phrase);
    await TtsService.instance.speak(phrase);
    await _spinController.forward(from: 0);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _bubble = null);
    });
  }

  Color _capePaint(String value) {
    return switch (value) {
      'blue' => ComicColors.blue,
      'green' => ComicColors.green,
      'gold' => ComicColors.yellow,
      'rainbow' => ComicColors.purple,
      _ => ComicColors.red,
    };
  }
}

class _DashboardShivPainter extends CustomPainter {
  const _DashboardShivPainter({
    required this.blink,
    required this.capeColor,
  });

  final bool blink;
  final Color capeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = Paint()
      ..color = ComicColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..style = PaintingStyle.fill;

    fill.color = capeColor;
    final cape = Path()
      ..moveTo(s * 0.36, s * 0.74)
      ..lineTo(s * 0.1, s * 1.18)
      ..lineTo(s * 0.58, s * 1.12)
      ..close();
    canvas.drawPath(cape, fill);
    canvas.drawPath(cape, stroke);

    fill.color = const Color(0xFFC9D7DF);
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.32, s * 0.74, s * 0.4, s * 0.36),
      const Radius.circular(18),
    );
    canvas.drawRRect(body, fill);
    canvas.drawRRect(body, stroke);

    fill.color = const Color(0xFFE7EEF2);
    canvas.drawCircle(Offset(s * 0.52, s * 0.38), s * 0.29, fill);
    canvas.drawCircle(Offset(s * 0.52, s * 0.38), s * 0.29, stroke);

    canvas.drawLine(
        Offset(s * 0.52, s * 0.08), Offset(s * 0.52, s * 0.0), stroke);
    fill.color = ComicColors.yellow;
    canvas.drawCircle(Offset(s * 0.52, 0), s * 0.045, fill);
    canvas.drawCircle(Offset(s * 0.52, 0), s * 0.045, stroke);

    fill.color = ComicColors.yellow;
    for (final x in [s * 0.42, s * 0.62]) {
      final eye = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, s * 0.36),
          width: s * 0.09,
          height: blink ? s * 0.012 : s * 0.075,
        ),
        const Radius.circular(8),
      );
      canvas.drawRRect(eye, fill);
      canvas.drawRRect(eye, stroke);
    }

    final smile = Path()
      ..moveTo(s * 0.43, s * 0.5)
      ..quadraticBezierTo(s * 0.52, s * 0.58, s * 0.62, s * 0.5);
    canvas.drawPath(smile, stroke);

    canvas.drawLine(
        Offset(s * 0.34, s * 0.82), Offset(s * 0.16, s * 0.62), stroke);
    canvas.drawLine(
        Offset(s * 0.7, s * 0.82), Offset(s * 0.86, s * 0.58), stroke);
    canvas.drawCircle(Offset(s * 0.88, s * 0.55), s * 0.06, fill);
    canvas.drawCircle(Offset(s * 0.88, s * 0.55), s * 0.06, stroke);

    fill.color = ComicColors.blue;
    canvas.drawCircle(Offset(s * 0.52, s * 0.9), s * 0.07, fill);
    canvas.drawCircle(Offset(s * 0.52, s * 0.9), s * 0.07, stroke);
  }

  @override
  bool shouldRepaint(covariant _DashboardShivPainter oldDelegate) =>
      oldDelegate.blink != blink || oldDelegate.capeColor != capeColor;
}

class _XpPanel extends StatelessWidget {
  const _XpPanel({
    required this.xp,
    required this.maxXp,
    required this.strings,
  });

  final int xp;
  final int maxXp;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final level = (xp ~/ 100) + 1;
    final levelStart = (level - 1) * 100;
    final inLevelXp = xp - levelStart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('⚡ ${strings.xp}', style: comicBody(context, fontSize: 18)),
            const Spacer(),
            Text(strings.level(level), style: comicBody(context, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ComicColors.ink, width: 4),
            borderRadius: BorderRadius.circular(999),
          ),
          clipBehavior: Clip.antiAlias,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: (inLevelXp / 100).clamp(0, 1)),
            duration: const Duration(milliseconds: 750),
            builder: (context, value, child) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: child,
            ),
            child: Container(color: ComicColors.blue),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          strings.xpToNext(inLevelXp),
          textAlign: TextAlign.center,
          style: comicBody(context, fontSize: 16),
        ),
      ],
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({
    required this.strings,
    required this.quizDoneToday,
    required this.activeTheme,
  });

  final AppStrings strings;
  final bool quizDoneToday;
  final String activeTheme;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final cards = [
      _MenuCardData(
        emoji: '📚',
        title: strings.startLearning,
        color: _themeColor(ComicColors.red),
        textColor: ComicColors.cream,
        onTap: () => context.go('/learning-path'),
      ),
      _MenuCardData(
        emoji: '⚡',
        title: strings.dailyQuiz,
        color: _themeColor(ComicColors.yellow),
        textColor: ComicColors.ink,
        badge: quizDoneToday ? null : strings.newBadge,
        onTap: () => context.go('/quiz'),
      ),
      _MenuCardData(
        emoji: '🤖',
        title: strings.askShiv,
        color: _themeColor(ComicColors.blue),
        textColor: ComicColors.cream,
        onTap: () => context.go('/ai-buddy'),
      ),
      _MenuCardData(
        emoji: '🎮',
        title: strings.aiGames,
        color: _themeColor(ComicColors.green),
        textColor: ComicColors.ink,
        onTap: () => context.push('/games'),
      ),
      _MenuCardData(
        emoji: '🏆',
        title: strings.myTrophies,
        color: _themeColor(ComicColors.purple),
        textColor: ComicColors.cream,
        onTap: () => context.go('/achievements'),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: compact ? 150 : 166,
      ),
      itemBuilder: (context, index) => _MenuCard(data: cards[index]),
    );
  }

  Color _themeColor(Color fallback) {
    return switch (activeTheme) {
      'night' =>
        fallback == ComicColors.yellow ? ComicColors.blue : ComicColors.navy,
      'jungle' => fallback == ComicColors.red ? ComicColors.green : fallback,
      'festival' =>
        fallback == ComicColors.blue ? ComicColors.saffron : fallback,
      _ => fallback,
    };
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.data});

  final _MenuCardData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 150;
        return PressableComicCard(
          color: data.color,
          onTap: data.onTap,
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(compact ? 10 : 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.emoji,
                        style: TextStyle(fontSize: compact ? 40 : 48),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: compact ? 58 : 64,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: compact ? 118 : 140,
                            child: Text(
                              data.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: comicDisplay(
                                context,
                                fontSize: compact ? 27 : 30,
                                color: data.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (data.badge != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 58),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ComicColors.red,
                      border: Border.all(color: ComicColors.ink, width: 2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        data.badge!,
                        style: comicBody(
                          context,
                          fontSize: 14,
                          color: ComicColors.cream,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StreakBanner extends StatelessWidget {
  const _StreakBanner({required this.streak, required this.strings});

  final int streak;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ComicColors.yellow,
        border: Border.all(color: ComicColors.ink, width: 4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: ComicColors.ink,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        strings.streakLine(streak),
        textAlign: TextAlign.center,
        style: comicDisplay(context, fontSize: 34, color: ComicColors.ink),
      ),
    );
  }
}

class _MenuCardData {
  const _MenuCardData({
    required this.emoji,
    required this.title,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.badge,
  });

  final String emoji;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final String? badge;
}
