import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_scaffold.dart';
import 'auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    await action();
    final state = ref.read(authViewModelProvider);
    if (!mounted) return;
    state.whenOrNull(
      data: (_) => context.go('/dashboard'),
      error: (error, _) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString()))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;
    return AppScaffold(
      title: 'Login',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: isLoading
                ? null
                : () => _runAuthAction(
                      () => ref.read(authViewModelProvider.notifier).signIn(
                            _emailController.text,
                            _passwordController.text,
                          ),
                    ),
            child: Text(isLoading ? 'Signing in...' : 'Login'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () => _runAuthAction(
                      ref.read(authViewModelProvider.notifier).signInWithGoogle,
                    ),
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Continue with Google'),
          ),
          OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () => _runAuthAction(
                      ref.read(authViewModelProvider.notifier).signInWithApple,
                    ),
            icon: const Icon(Icons.apple),
            label: const Text('Continue with Apple'),
          ),
          TextButton(
            onPressed: isLoading
                ? null
                : () => ref
                    .read(authViewModelProvider.notifier)
                    .resetPassword(_emailController.text),
            child: const Text('Reset password'),
          ),
          TextButton(
            onPressed: () => context.go('/signup'),
            child: const Text('Create account'),
          ),
        ],
      ),
    );
  }
}
