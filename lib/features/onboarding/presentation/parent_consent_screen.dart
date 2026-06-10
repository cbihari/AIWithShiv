import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_scaffold.dart';

class ParentConsentScreen extends StatelessWidget {
  const ParentConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Parent Consent',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.family_restroom, size: 72),
          const SizedBox(height: 16),
          Text(
            'A parent or guardian must approve learning access for younger children.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Parent email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: true,
            onChanged: (_) {},
            title: const Text(
              'I agree to supervised, safe learning for my child.',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/signup'),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
