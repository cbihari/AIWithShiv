import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/models/game.dart';
import '../domain/game_repository.dart';

class LocalGameProgressRepository implements GameProgressRepository {
  const LocalGameProgressRepository();

  @override
  Future<GameProgress> getProgress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null) return GameProgress.starter(userId);
    return GameProgress.fromJson(
      userId,
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveProgress(GameProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(progress.userId), jsonEncode(progress.toJson()));
  }

  String _key(String userId) => 'local_game_progress_$userId';
}
