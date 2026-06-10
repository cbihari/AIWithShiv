import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/feature_card.dart';
import '../../../shared/widgets/stat_tile.dart';
import 'dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AIWithShiv'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Today’s AI Quest',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              AsyncValueView(
                value: dashboard,
                onRetry: () => ref.invalidate(dashboardProvider),
                data: (state) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            label: 'XP',
                            value: '${state.progress.xp}',
                            icon: Icons.bolt,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StatTile(
                            label: 'Coins',
                            value: '${state.progress.coins}',
                            icon: Icons.paid,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            label: 'Streak',
                            value: '${state.progress.streakDays} days',
                            icon: Icons.local_fire_department,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StatTile(
                            label: 'Level',
                            value: '${state.progress.level}',
                            icon: Icons.trending_up,
                          ),
                        ),
                      ],
                    ),
                    FeatureCard(
                      title: 'Daily AI Lesson',
                      subtitle:
                          state.dailyLesson?.title ?? 'No lesson assigned yet',
                      icon: Icons.school,
                      onTap: state.dailyLesson == null
                          ? null
                          : () =>
                              context.go('/lesson/${state.dailyLesson!.id}'),
                    ),
                    FeatureCard(
                      title: 'Continue Learning',
                      subtitle: state.continueLesson?.title ??
                          'Start your first lesson',
                      icon: Icons.play_circle,
                      onTap: () => state.continueLesson == null
                          ? context.go('/learning-path')
                          : context.go('/lesson/${state.continueLesson!.id}'),
                    ),
                    FeatureCard(
                      title: 'ShivBot',
                      subtitle: 'Ask your AI buddy',
                      icon: Icons.smart_toy,
                      onTap: () => context.go('/ai-buddy'),
                    ),
                    FeatureCard(
                      title: 'Daily Quiz',
                      subtitle:
                          state.dailyQuiz?.title ?? 'No quiz available yet',
                      icon: Icons.quiz,
                      onTap: state.dailyQuiz == null
                          ? null
                          : () => context.go('/quiz'),
                    ),
                    FeatureCard(
                      title: 'Leaderboard',
                      subtitle: 'See friendly class rankings',
                      icon: Icons.leaderboard,
                      onTap: () {},
                    ),
                    FeatureCard(
                      title: 'Badges',
                      subtitle: 'View achievements',
                      icon: Icons.emoji_events,
                      onTap: () => context.go('/achievements'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
