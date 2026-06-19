class LearningGame {
  const LearningGame({
    required this.id,
    required this.title,
    required this.concept,
    required this.description,
    required this.ageGroup,
    required this.durationMinutes,
    required this.xpReward,
    required this.coinReward,
    required this.route,
    required this.isActive,
  });

  final String id;
  final String title;
  final String concept;
  final String description;
  final String ageGroup;
  final int durationMinutes;
  final int xpReward;
  final int coinReward;
  final String route;
  final bool isActive;

  factory LearningGame.fromJson(Map<String, dynamic> json) => LearningGame(
        id: json['id'] as String,
        title: json['title'] as String,
        concept: json['concept'] as String,
        description: json['description'] as String,
        ageGroup: json['ageGroup'] as String,
        durationMinutes: (json['durationMinutes'] as num).toInt(),
        xpReward: (json['xpReward'] as num).toInt(),
        coinReward: (json['coinReward'] as num).toInt(),
        route: json['route'] as String,
        isActive: json['isActive'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'concept': concept,
        'description': description,
        'ageGroup': ageGroup,
        'durationMinutes': durationMinutes,
        'xpReward': xpReward,
        'coinReward': coinReward,
        'route': route,
        'isActive': isActive,
      };
}

class GameProgress {
  const GameProgress({
    required this.userId,
    required this.completedGames,
    required this.totalGameXp,
    required this.totalGameCoins,
    required this.gameAttempts,
    required this.bestScore,
  });

  final String userId;
  final List<String> completedGames;
  final int totalGameXp;
  final int totalGameCoins;
  final Map<String, int> gameAttempts;
  final Map<String, int> bestScore;

  factory GameProgress.starter(String userId) => GameProgress(
        userId: userId,
        completedGames: const [],
        totalGameXp: 0,
        totalGameCoins: 0,
        gameAttempts: const {},
        bestScore: const {},
      );

  factory GameProgress.fromJson(String userId, Map<String, dynamic> json) {
    return GameProgress(
      userId: userId,
      completedGames: List<String>.from(
        json['completedGames'] as List? ?? const [],
      ),
      totalGameXp: (json['totalGameXp'] as num?)?.toInt() ?? 0,
      totalGameCoins: (json['totalGameCoins'] as num?)?.toInt() ?? 0,
      gameAttempts: (json['gameAttempts'] as Map? ?? const {}).map(
        (key, value) => MapEntry('$key', (value as num).toInt()),
      ),
      bestScore: (json['bestScore'] as Map? ?? const {}).map(
        (key, value) => MapEntry('$key', (value as num).toInt()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'completedGames': completedGames,
        'totalGameXp': totalGameXp,
        'totalGameCoins': totalGameCoins,
        'gameAttempts': gameAttempts,
        'bestScore': bestScore,
      };

  GameProgress copyWith({
    List<String>? completedGames,
    int? totalGameXp,
    int? totalGameCoins,
    Map<String, int>? gameAttempts,
    Map<String, int>? bestScore,
  }) {
    return GameProgress(
      userId: userId,
      completedGames: completedGames ?? this.completedGames,
      totalGameXp: totalGameXp ?? this.totalGameXp,
      totalGameCoins: totalGameCoins ?? this.totalGameCoins,
      gameAttempts: gameAttempts ?? this.gameAttempts,
      bestScore: bestScore ?? this.bestScore,
    );
  }
}
