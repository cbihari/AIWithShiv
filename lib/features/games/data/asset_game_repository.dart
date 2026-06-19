import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../shared/models/game.dart';
import '../domain/game_repository.dart';

class AssetGameRepository implements GameRepository {
  const AssetGameRepository();

  @override
  Future<List<LearningGame>> getGames() async {
    final raw = await rootBundle.loadString('assets/data/games.json');
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((item) => LearningGame.fromJson(item as Map<String, dynamic>))
        .where((game) => game.isActive)
        .toList();
  }

  @override
  Future<LearningGame?> getGame(String id) async {
    final games = await getGames();
    for (final game in games) {
      if (game.id == id) return game;
    }
    return null;
  }
}
