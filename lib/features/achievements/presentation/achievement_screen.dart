import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/level_system.dart';
import '../../../shared/models/achievement.dart';
import '../../../shared/models/user_progress.dart';
import '../../../shared/widgets/app_state_widgets.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/child_comic_widgets.dart';
import '../../../shared/widgets/comic_widgets.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import 'achievement_providers.dart';

class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final userId = ref.watch(currentUserIdProvider) ?? 'guest';
    final progress = ref.watch(userProgressProvider(userId));
    return ChildCardScreen(
      title: 'My Trophies',
      backRoute: '/dashboard',
      child: AsyncValueView(
        value: achievements,
        isEmpty: (items) => items.isEmpty,
        emptyEmoji: '🤖🏚️',
        emptyMessage:
            'No badges yet hero! Complete a lesson to earn your first! ⚡',
        emptySubtitle: 'Shiv is saving space on the trophy shelf.',
        emptyButtonLabel: 'Start Learning 📚',
        onRetry: () => context.go('/learning-path'),
        loading: const BadgeGridShimmer(),
        data: (items) {
          final current = progress.valueOrNull ?? UserProgress.starter(userId);
          final earned = items
              .where((item) =>
                  current.badges.contains(item.id) ||
                  current.xp >= item.requiredXp)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TrophyHeader(earned: earned.length),
              const SizedBox(height: 16),
              _StatsRow(progress: current),
              const SizedBox(height: 18),
              _BadgeGrid(achievements: items, progress: current),
              const SizedBox(height: 22),
              _LevelPath(progress: current),
              const SizedBox(height: 22),
              _RecentWins(progress: current),
            ],
          );
        },
      ),
    );
  }
}

class _TrophyHeader extends StatefulWidget {
  const _TrophyHeader({required this.earned});

  final int earned;

  @override
  State<_TrophyHeader> createState() => _TrophyHeaderState();
}

class _TrophyHeaderState extends State<_TrophyHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ComicColors.red,
        border: Border.all(color: ComicColors.ink, width: 4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: ComicColors.ink, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
              child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => CustomPaint(
              painter: _SparklePainter(_controller.value),
            ),
          )),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🏆 My Trophy Room',
                  textAlign: TextAlign.center,
                  style: comicDisplay(
                    context,
                    fontSize: 38,
                    color: ComicColors.cream,
                  ),
                ),
                Text(
                  '${widget.earned} badges earned! Keep going hero! ⚡',
                  textAlign: TextAlign.center,
                  style: comicBody(context,
                      fontSize: 18, color: ComicColors.cream),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.progress});

  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _StatCard(
                emoji: '⚡', value: '${progress.xp}', label: 'Total XP')),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                emoji: '🪙', value: '${progress.coins}', label: 'Coins')),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                emoji: '🔥', value: '${progress.streakDays}', label: 'Streak')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.emoji, required this.value, required this.label});

  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ComicColors.yellow,
        border: Border.all(color: ComicColors.ink, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          Text(value, style: comicNumber(context, fontSize: 32)),
          Text(label,
              textAlign: TextAlign.center,
              style: comicBody(context, fontSize: 13)),
        ],
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.achievements, required this.progress});

  final List<Achievement> achievements;
  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final earned = progress.badges.contains(achievement.id) ||
            progress.xp >= achievement.requiredXp;
        return GestureDetector(
          onTap: () => _showBadgeSheet(context, achievement, progress, earned),
          child: _BadgeCard(
            achievement: achievement,
            earned: earned,
            color: _badgeColors[index % _badgeColors.length],
          ),
        );
      },
    );
  }

  void _showBadgeSheet(
    BuildContext context,
    Achievement item,
    UserProgress progress,
    bool earned,
  ) {
    final needed = (item.requiredXp - progress.xp).clamp(0, item.requiredXp);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ComicColors.cream,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: ComicColors.ink, width: 4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_emojiFor(item.icon), style: const TextStyle(fontSize: 64)),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style:
                    comicDisplay(context, fontSize: 38, color: ComicColors.red),
              ),
              const SizedBox(height: 8),
              Text(
                earned
                    ? 'Shabash! You earned this by ${item.description.toLowerCase()} 🌟'
                    : 'Keep learning to unlock this! 💪\n$needed more XP needed',
                textAlign: TextAlign.center,
                style: comicBody(context, fontSize: 18),
              ),
              if (earned)
                Text(
                  'Earned: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: comicBody(context, fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.achievement,
    required this.earned,
    required this.color,
  });

  final Achievement achievement;
  final bool earned;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: earned ? color : Colors.grey.shade300,
        border: Border.all(
          color: earned ? ComicColors.yellow : Colors.grey,
          width: earned ? 5 : 3,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (earned)
            BoxShadow(
              color: ComicColors.yellow.withValues(alpha: 0.7),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                earned ? _emojiFor(achievement.icon) : '🔒',
                style: const TextStyle(fontSize: 42),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: comicBody(
              context,
              fontSize: 14,
              color: earned ? ComicColors.ink : Colors.grey.shade700,
            ),
          ),
          Text(
            earned ? 'Earned! ✅' : '???',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: comicBody(
              context,
              fontSize: 13,
              color: earned ? ComicColors.green : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelPath extends StatelessWidget {
  const _LevelPath({required this.progress});

  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    final levelInfo = LevelSystem.infoForXp(progress.xp);
    return WhiteComicItemCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Hero Level: ${levelInfo.level}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: comicDisplay(context, fontSize: 34, color: ComicColors.red),
          ),
          Text(
            levelInfo.title,
            style: comicBody(context, fontSize: 17),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 1; i <= LevelSystem.thresholds.length; i++) ...[
                Text(i == levelInfo.level ? '🤖' : '⭐',
                    style: const TextStyle(fontSize: 28)),
                if (i < LevelSystem.thresholds.length)
                  Expanded(child: Container(height: 5, color: ComicColors.ink)),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            levelInfo.isMaxLevel
                ? 'Cosmic level unlocked! ⚡'
                : '${levelInfo.xpToNextLevel} XP to next level',
            style: comicBody(context, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _RecentWins extends StatelessWidget {
  const _RecentWins({required this.progress});

  final UserProgress progress;

  @override
  Widget build(BuildContext context) {
    final lesson = progress.completedLessons.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Wins 🌟',
            style: comicDisplay(context, fontSize: 34, color: ComicColors.red)),
        const SizedBox(height: 10),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _WinCard(text: '✅ Completed Lesson $lesson · +25 XP · Today'),
              const SizedBox(width: 10),
              const _WinCard(text: '⚡ Quiz Score · Bonus XP · Keep going'),
            ],
          ),
        ),
      ],
    );
  }
}

class _WinCard extends StatelessWidget {
  const _WinCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: WhiteComicItemCard(
        child: Center(
          child: Text(text, style: comicBody(context, fontSize: 14)),
        ),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ComicColors.yellow.withValues(alpha: 0.75);
    for (var i = 0; i < 14; i++) {
      final x = (i * 41 + value * 80) % size.width;
      final y = (math.sin(value * math.pi * 2 + i) * 18) + size.height / 2;
      canvas.drawCircle(Offset(x, y), i.isEven ? 3 : 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.value != value;
}

const _badgeColors = [
  ComicColors.yellow,
  ComicColors.green,
  ComicColors.blue,
  ComicColors.saffron,
  ComicColors.cream,
];

String _emojiFor(String icon) {
  return switch (icon) {
    'bolt' => '⚡',
    'school' => '📚',
    'search' => '🔎',
    'shield' => '🛡️',
    'emoji_events' => '🏆',
    'edit' => '✏️',
    'science' => '🔬',
    _ => '🏅',
  };
}
