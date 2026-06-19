import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/models/user_progress.dart';
import '../domain/progress_repository.dart';

class LocalProgressRepository implements ProgressRepository {
  LocalProgressRepository();

  static final _controllers = <String, StreamController<UserProgress>>{};

  @override
  Stream<UserProgress> watchProgress(String userId) async* {
    final controller = _controllers.putIfAbsent(
      userId,
      () => StreamController<UserProgress>.broadcast(),
    );
    yield await getProgress(userId);
    yield* controller.stream;
  }

  @override
  Future<UserProgress> getProgress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null) return UserProgress.starter(userId);
    return UserProgress.fromJson(
      userId,
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final json = progress.toJson();
    json['lastActivityAt'] = progress.lastActivityAt?.toIso8601String();
    await prefs.setString(_key(progress.userId), jsonEncode(json));
    _controllers[progress.userId]?.add(progress);
  }

  String _key(String userId) => 'local_user_progress_$userId';
}
