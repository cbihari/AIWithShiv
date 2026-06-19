import 'package:aiwithshiv/features/games/data/asset_game_repository.dart';
import 'package:aiwithshiv/features/games/data/local_game_progress_repository.dart';
import 'package:aiwithshiv/shared/models/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('games.json loads active AI games', () async {
    const repository = AssetGameRepository();

    final games = await repository.getGames();

    expect(games, hasLength(5));
    expect(games.map((game) => game.id), contains('train_robot'));
    expect(games.every((game) => game.isActive), isTrue);
    expect(games.every((game) => game.route.startsWith('/games/')), isTrue);
  });

  test('game progress persists with SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({});
    const repository = LocalGameProgressRepository();
    const progress = GameProgress(
      userId: 'local-child',
      completedGames: ['train_robot'],
      totalGameXp: 20,
      totalGameCoins: 10,
      gameAttempts: {'train_robot': 2},
      bestScore: {'train_robot': 6},
    );

    await repository.saveProgress(progress);
    final loaded = await repository.getProgress('local-child');

    expect(loaded.completedGames, ['train_robot']);
    expect(loaded.totalGameXp, 20);
    expect(loaded.totalGameCoins, 10);
    expect(loaded.gameAttempts['train_robot'], 2);
    expect(loaded.bestScore['train_robot'], 6);
  });
}
