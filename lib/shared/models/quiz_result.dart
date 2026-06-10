class QuizResult {
  const QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.lessonId,
    required this.score,
    required this.totalQuestions,
    required this.earnedXp,
    required this.earnedCoins,
    required this.completedAt,
  });

  final String id;
  final String userId;
  final String quizId;
  final String lessonId;
  final int score;
  final int totalQuestions;
  final int earnedXp;
  final int earnedCoins;
  final DateTime completedAt;

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    final rawCompletedAt = json['completedAt'];
    return QuizResult(
      id: json['id'] as String,
      userId: json['userId'] as String,
      quizId: json['quizId'] as String,
      lessonId: json['lessonId'] as String,
      score: (json['score'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      earnedXp: (json['earnedXp'] as num).toInt(),
      earnedCoins: (json['earnedCoins'] as num).toInt(),
      completedAt: rawCompletedAt is DateTime
          ? rawCompletedAt
          : rawCompletedAt.toDate() as DateTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'quizId': quizId,
        'lessonId': lessonId,
        'score': score,
        'totalQuestions': totalQuestions,
        'earnedXp': earnedXp,
        'earnedCoins': earnedCoins,
        'completedAt': completedAt,
      };
}
