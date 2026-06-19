import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_state_widgets.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.emptyMessage = 'Nothing here yet.',
    this.emptySubtitle,
    this.emptyEmoji = '🤖❓',
    this.emptyButtonLabel = 'Refresh ↻',
    this.loading,
    this.errorMessage = 'Shiv HQ is busy! 🛸 Tap to try again!',
    this.isEmpty,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final bool Function(T data)? isEmpty;
  final String emptyMessage;
  final String? emptySubtitle;
  final String emptyEmoji;
  final String emptyButtonLabel;
  final Widget? loading;
  final String errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: value.when(
        data: (resolved) {
          if (isEmpty?.call(resolved) ?? false) {
            return EmptyStateWidget(
              key: const ValueKey('empty'),
              emoji: emptyEmoji,
              message: emptyMessage,
              subtitle: emptySubtitle,
              buttonLabel: emptyButtonLabel,
              onPressed: onRetry,
            );
          }
          return KeyedSubtree(key: const ValueKey('data'), child: data(resolved));
        },
        loading: () => KeyedSubtree(
          key: const ValueKey('loading'),
          child: loading ??
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
        ),
        error: (error, _) => ErrorStateWidget(
          key: const ValueKey('error'),
          message: errorMessage,
          onRetry: onRetry,
        ),
      ),
    );
  }
}
