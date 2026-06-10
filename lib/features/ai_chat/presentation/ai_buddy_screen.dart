import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/age_group.dart';
import '../../../shared/widgets/app_scaffold.dart';
import 'ai_chat_providers.dart';

class AiBuddyScreen extends ConsumerStatefulWidget {
  const AiBuddyScreen({super.key});

  @override
  ConsumerState<AiBuddyScreen> createState() => _AiBuddyScreenState();
}

class _AiBuddyScreenState extends ConsumerState<AiBuddyScreen> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatViewModelProvider);
    return AppScaffold(
      title: 'ShivBot',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CircleAvatar(
            radius: 44,
            child: Icon(Icons.smart_toy, size: 48),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Hi! I am ShivBot. Ask me about AI, robots, coding, space tech, or future jobs.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _promptController,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Ask ShivBot',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: chatState.isLoading
                ? null
                : () => ref.read(aiChatViewModelProvider.notifier).ask(
                      message: _promptController.text,
                      ageGroup: AgeGroup.tinyExplorers,
                    ),
            icon: const Icon(Icons.send),
            label: Text(chatState.isLoading ? 'Thinking...' : 'Ask'),
          ),
          const SizedBox(height: 12),
          chatState.when(
            data: (reply) => reply == null
                ? const SizedBox.shrink()
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(reply),
                    ),
                  ),
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text(
              error.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
