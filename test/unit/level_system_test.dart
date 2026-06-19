import 'package:aiwithshiv/core/services/level_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps XP to documented v1 hero levels', () {
    expect(LevelSystem.levelForXp(0), 1);
    expect(LevelSystem.levelForXp(99), 1);
    expect(LevelSystem.levelForXp(100), 2);
    expect(LevelSystem.levelForXp(249), 2);
    expect(LevelSystem.levelForXp(250), 3);
    expect(LevelSystem.levelForXp(499), 3);
    expect(LevelSystem.levelForXp(500), 4);
    expect(LevelSystem.levelForXp(799), 4);
    expect(LevelSystem.levelForXp(800), 5);
    expect(LevelSystem.levelForXp(1199), 5);
    expect(LevelSystem.levelForXp(1200), 6);
    expect(LevelSystem.levelForXp(1699), 6);
    expect(LevelSystem.levelForXp(1700), 7);
  });

  test('reports current level progress to next threshold', () {
    final info = LevelSystem.infoForXp(120);

    expect(info.level, 2);
    expect(info.title, 'AI Explorer');
    expect(info.levelStartXp, 100);
    expect(info.nextLevelXp, 250);
    expect(info.xpIntoLevel, 20);
    expect(info.levelSpan, 150);
    expect(info.xpToNextLevel, 130);
    expect(info.progressFraction, closeTo(0.133, 0.001));
  });

  test('max level stays full and needs no more XP', () {
    final info = LevelSystem.infoForXp(1800);

    expect(info.level, 7);
    expect(info.title, 'Cosmic Shiv Hero');
    expect(info.isMaxLevel, isTrue);
    expect(info.xpToNextLevel, 0);
    expect(info.progressFraction, 1);
  });
}
