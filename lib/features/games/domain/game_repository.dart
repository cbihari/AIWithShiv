import '../../../shared/models/game.dart';

abstract class GameRepository {
  Future<List<LearningGame>> getGames();
  Future<LearningGame?> getGame(String id);
}

abstract class GameProgressRepository {
  Future<GameProgress> getProgress(String userId);
  Future<void> saveProgress(GameProgress progress);
}
