import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/async_value_view.dart';
import 'achievement_providers.dart';

class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    return AppScaffold(
      title: 'Achievements',
      child: AsyncValueView(
        value: achievements,
        isEmpty: (items) => items.isEmpty,
        emptyMessage: 'No achievements are configured yet.',
        onRetry: () => ref.invalidate(achievementsProvider),
        data: (items) => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: 150,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.workspace_premium, size: 42),
                        const SizedBox(height: 8),
                        Text(item.title, textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(
                          '${item.requiredXp} XP',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
