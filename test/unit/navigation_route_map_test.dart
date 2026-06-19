import 'dart:convert';
import 'dart:io';

import 'package:aiwithshiv/core/routing/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('child-first route map is complete and has no duplicate paths', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    final paths = router.configuration.routes
        .whereType<GoRoute>()
        .map((route) => route.path)
        .toList();

    expect(paths.length, paths.toSet().length);
    expect(
      paths,
      containsAll(const [
        '/',
        '/welcome',
        '/age',
        '/hero-setup',
        '/dashboard',
        '/learning-path',
        '/lesson/:id',
        '/quiz',
        '/quiz/:lessonId',
        '/games',
        '/games/train-robot',
        '/games/ai-detective',
        '/games/sort-like-ai',
        '/games/robot-treasure-hunt',
        '/games/spot-ai-mistake',
        '/ai-buddy',
        '/achievements',
        '/profile',
        '/shop',
      ]),
    );
  });

  test('AI game asset routes are registered in GoRouter', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    final registeredPaths = router.configuration.routes
        .whereType<GoRoute>()
        .map((route) => route.path)
        .toSet();
    final rawGames = jsonDecode(
      await File('assets/data/games.json').readAsString(),
    ) as List<dynamic>;

    for (final rawGame in rawGames) {
      final route = (rawGame as Map<String, dynamic>)['route'] as String;
      expect(registeredPaths, contains(route));
    }
  });
}
