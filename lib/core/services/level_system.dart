class LevelInfo {
  const LevelInfo({
    required this.level,
    required this.title,
    required this.levelStartXp,
    required this.nextLevelXp,
    required this.xp,
  });

  final int level;
  final String title;
  final int levelStartXp;
  final int? nextLevelXp;
  final int xp;

  bool get isMaxLevel => nextLevelXp == null;

  int get xpIntoLevel => xp - levelStartXp;

  int get levelSpan => nextLevelXp == null ? 0 : nextLevelXp! - levelStartXp;

  int get xpToNextLevel =>
      nextLevelXp == null ? 0 : (nextLevelXp! - xp).clamp(0, levelSpan);

  double get progressFraction {
    if (nextLevelXp == null) return 1;
    if (levelSpan <= 0) return 1;
    return (xpIntoLevel / levelSpan).clamp(0, 1);
  }
}

class LevelSystem {
  const LevelSystem._();

  static const thresholds = <int>[0, 100, 250, 500, 800, 1200, 1700];
  static const titles = <String>[
    'New Hero',
    'AI Explorer',
    'Pattern Detective',
    'Robot Trainer',
    'Safety Hero',
    'AI Champion',
    'Cosmic Shiv Hero',
  ];

  static int levelForXp(int xp) => infoForXp(xp).level;

  static LevelInfo infoForXp(int xp) {
    final safeXp = xp < 0 ? 0 : xp;
    var index = 0;
    for (var i = 0; i < thresholds.length; i++) {
      if (safeXp >= thresholds[i]) {
        index = i;
      }
    }
    return LevelInfo(
      level: index + 1,
      title: titles[index],
      levelStartXp: thresholds[index],
      nextLevelXp: index + 1 < thresholds.length ? thresholds[index + 1] : null,
      xp: safeXp,
    );
  }
}
