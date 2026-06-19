import 'package:aiwithshiv/core/localization/language_service.dart';
import 'package:aiwithshiv/features/games/domain/game_repository.dart';
import 'package:aiwithshiv/features/games/presentation/game_providers.dart';
import 'package:aiwithshiv/features/games/presentation/games_screen.dart';
import 'package:aiwithshiv/shared/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  tearDown(() {
    LanguageService.language.value = AppLanguage.english;
  });

  for (final size in const [Size(320, 568), Size(393, 852)]) {
    testWidgets('Hindi AI Games cards fit compact screen $size', (
      tester,
    ) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      LanguageService.language.value = AppLanguage.hindi;

      await tester.pumpWidget(_testApp());
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.takeException(), isNull);
      expect(find.text('🎮 AI Games'), findsOneWidget);
      expect(find.text('Robot को Train करें'), findsOneWidget);
      expect(find.text('AI की तरह Sort करें'), findsOneWidget);
      expect(find.text('AI Mistake पकड़ो'), findsOneWidget);
    });
  }

  for (final game in _games) {
    testWidgets('Game route ${game.route} renders and backs to games list', (
      tester,
    ) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      tester.view
        ..physicalSize = const Size(320, 568)
        ..devicePixelRatio = 1;

      await tester.pumpWidget(_testApp(initialLocation: game.route));
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.takeException(), isNull);
      expect(find.text(game.title), findsOneWidget);
      expect(find.textContaining(game.concept), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('🎮 AI Games'), findsOneWidget);
    });
  }
}

Widget _testApp({String initialLocation = '/games'}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/games',
        builder: (_, __) => const GamesScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, __) => const Scaffold(body: Text('Dashboard')),
      ),
      GoRoute(
        path: '/games/train-robot',
        builder: (_, __) => const GameDetailScreen(gameId: 'train_robot'),
      ),
      GoRoute(
        path: '/games/ai-detective',
        builder: (_, __) => const GameDetailScreen(gameId: 'ai_detective'),
      ),
      GoRoute(
        path: '/games/sort-like-ai',
        builder: (_, __) => const GameDetailScreen(gameId: 'sort_like_ai'),
      ),
      GoRoute(
        path: '/games/robot-treasure-hunt',
        builder: (_, __) =>
            const GameDetailScreen(gameId: 'robot_treasure_hunt'),
      ),
      GoRoute(
        path: '/games/spot-ai-mistake',
        builder: (_, __) => const GameDetailScreen(
          gameId: 'spot_ai_mistake',
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      gameRepositoryProvider.overrideWithValue(const _FakeGameRepository()),
      gameProgressProvider.overrideWith(
        (ref) async => GameProgress.starter('guest').copyWith(
          completedGames: const ['train_robot'],
        ),
      ),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

class _FakeGameRepository implements GameRepository {
  const _FakeGameRepository();

  @override
  Future<LearningGame?> getGame(String id) async {
    for (final game in _games) {
      if (game.id == id) return game;
    }
    return null;
  }

  @override
  Future<List<LearningGame>> getGames() async => _games;
}

const _games = [
  LearningGame(
    id: 'train_robot',
    title: 'Train the Robot',
    concept: 'Machine Learning',
    description: 'Teach ShivBot by giving correct examples.',
    ageGroup: '5-10',
    durationMinutes: 4,
    xpReward: 20,
    coinReward: 10,
    route: '/games/train-robot',
    isActive: true,
  ),
  LearningGame(
    id: 'ai_detective',
    title: 'AI Detective',
    concept: 'Pattern Recognition',
    description: 'Find the odd item.',
    ageGroup: '5-10',
    durationMinutes: 3,
    xpReward: 15,
    coinReward: 8,
    route: '/games/ai-detective',
    isActive: true,
  ),
  LearningGame(
    id: 'sort_like_ai',
    title: 'Sort Like AI',
    concept: 'Classification',
    description: 'Sort animals, food, and vehicles.',
    ageGroup: '5-10',
    durationMinutes: 4,
    xpReward: 20,
    coinReward: 10,
    route: '/games/sort-like-ai',
    isActive: true,
  ),
  LearningGame(
    id: 'robot_treasure_hunt',
    title: 'Robot Treasure Hunt',
    concept: 'Algorithm',
    description: 'Move ShivBot with clear steps.',
    ageGroup: '5-10',
    durationMinutes: 5,
    xpReward: 25,
    coinReward: 12,
    route: '/games/robot-treasure-hunt',
    isActive: true,
  ),
  LearningGame(
    id: 'spot_ai_mistake',
    title: 'Spot the AI Mistake',
    concept: 'AI Safety',
    description: 'Check answers and find silly mistakes.',
    ageGroup: '5-10',
    durationMinutes: 4,
    xpReward: 20,
    coinReward: 10,
    route: '/games/spot-ai-mistake',
    isActive: true,
  ),
];
