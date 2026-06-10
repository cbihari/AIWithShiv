class UserProgress {
  const UserProgress({
    required this.userId,
    required this.xp,
    required this.coins,
    required this.level,
    required this.streakDays,
    required this.completedLessons,
    required this.badges,
    required this.lastActivityAt,
  });

  final String userId;
  final int xp;
  final int coins;
  final int level;
  final int streakDays;
  final List<String> completedLessons;
  final List<String> badges;
  final DateTime? lastActivityAt;

  factory UserProgress.starter(String userId) => UserProgress(
        userId: userId,
        xp: 0,
        coins: 50,
        level: 1,
        streakDays: 0,
        completedLessons: const [],
        badges: const [],
        lastActivityAt: null,
      );

  factory UserProgress.fromJson(String userId, Map<String, dynamic> json) {
    final rawLastActivity = json['lastActivityAt'];
    return UserProgress(
      userId: userId,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 50,
      level: (json['level'] as num?)?.toInt() ?? 1,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      completedLessons: List<String>.from(
        json['completedLessons'] as List? ?? const [],
      ),
      badges: List<String>.from(json['badges'] as List? ?? const []),
      lastActivityAt: rawLastActivity is DateTime
          ? rawLastActivity
          : rawLastActivity?.toDate() as DateTime?,
    );
  }

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'coins': coins,
        'level': level,
        'streakDays': streakDays,
        'completedLessons': completedLessons,
        'badges': badges,
        'lastActivityAt': lastActivityAt,
      };

  UserProgress copyWith({
    int? xp,
    int? coins,
    int? level,
    int? streakDays,
    List<String>? completedLessons,
    List<String>? badges,
    DateTime? lastActivityAt,
  }) {
    return UserProgress(
      userId: userId,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      completedLessons: completedLessons ?? this.completedLessons,
      badges: badges ?? this.badges,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }
}
