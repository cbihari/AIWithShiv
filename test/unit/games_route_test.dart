import 'package:aiwithshiv/core/routing/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('games routes are registered', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    final paths = router.configuration.routes
        .whereType<GoRoute>()
        .map((route) => route.path)
        .toSet();

    expect(paths, contains('/games'));
    expect(paths, contains('/games/train-robot'));
    expect(paths, contains('/games/ai-detective'));
    expect(paths, contains('/games/sort-like-ai'));
    expect(paths, contains('/games/robot-treasure-hunt'));
    expect(paths, contains('/games/spot-ai-mistake'));
  });
}
