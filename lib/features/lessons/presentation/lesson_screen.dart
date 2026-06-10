import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/async_value_view.dart';
import 'lesson_providers.dart';

class LessonScreen extends ConsumerWidget {
  const LessonScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider(id));
    return AppScaffold(
      title: 'Lesson',
      child: AsyncValueView(
        value: lesson,
        emptyMessage: 'Lesson not found.',
        isEmpty: (item) => item == null,
        onRetry: () => ref.invalidate(lessonProvider(id)),
        data: (item) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.auto_stories,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(item!.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('Story: ${item.story}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final concept in item.concepts) Chip(label: Text(concept)),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: 0.45,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.go('/quiz/${item.id}'),
              icon: const Icon(Icons.quiz),
              label: const Text('Take Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
