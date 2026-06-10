import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/stat_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    return AppScaffold(
      title: 'Profile',
      child: Column(
        children: [
          const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 44)),
          const SizedBox(height: 12),
          Text(
            user?.displayName ?? user?.email ?? 'Shiv Learner',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const StatTile(label: 'Level', value: '5', icon: Icons.trending_up),
          const StatTile(label: 'Coins', value: '380', icon: Icons.paid),
          FilledButton(
            onPressed: () => context.go('/parents'),
            child: const Text('Parent Dashboard'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/admin'),
            child: const Text('Admin Dashboard'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
