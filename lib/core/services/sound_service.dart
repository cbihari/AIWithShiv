import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  SoundService._();

  static final instance = SoundService._();
  static const _assetSoundsEnabled = bool.fromEnvironment(
    'SOUND_ASSETS_ENABLED',
    defaultValue: false,
  );

  final AudioPlayer _player = AudioPlayer();

  Future<bool> isMuted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sound_muted') ?? false;
  }

  Future<void> setMuted(bool muted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_muted', muted);
  }

  Future<void> tap() async {
    await HapticFeedback.selectionClick();
    await _play('sounds/tap.mp3');
  }

  Future<void> correct() async {
    await HapticFeedback.mediumImpact();
    await _play('sounds/correct.mp3');
  }

  Future<void> wrong() async {
    await HapticFeedback.selectionClick();
    await _play('sounds/wrong.mp3');
  }

  Future<void> levelUp() async {
    await HapticFeedback.mediumImpact();
    await _play('sounds/levelup.mp3');
  }

  Future<void> _play(String assetPath) async {
    if (!_assetSoundsEnabled) return;
    if (await isMuted()) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Sound files are optional in early builds.
    }
  }
}
