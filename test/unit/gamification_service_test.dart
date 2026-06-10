import 'package:aiwithshiv/core/services/gamification_service.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('awards XP, coins, level, and completed lesson once', () {
    const service = GamificationService();
    final start = UserProgress.starter('user-1');

    final result = service.awardLessonCompletion(start, 'lesson-1', 260);

    expect(result.xp, 260);
    expect(result.coins, 65);
    expect(result.level, 2);
    expect(result.completedLessons, ['lesson-1']);
  });
}
