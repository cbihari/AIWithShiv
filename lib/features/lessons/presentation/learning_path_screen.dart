import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/feature_card.dart';
import 'lesson_providers.dart';

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
    return AppScaffold(
      title: 'Learning Path',
      child: AsyncValueView(
        value: courses,
        isEmpty: (items) => items.isEmpty,
        emptyMessage: 'No courses are published yet.',
        onRetry: () => ref.invalidate(coursesProvider),
        data: (items) => Column(
          children: [
            for (final course in items)
              FeatureCard(
                title: course.title,
                subtitle: course.description,
                icon: Icons.route,
                onTap: course.lessonIds.isEmpty
                    ? null
                    : () => context.go('/lesson/${course.lessonIds.first}'),
              ),
          ],
        ),
      ),
    );
  }
}
