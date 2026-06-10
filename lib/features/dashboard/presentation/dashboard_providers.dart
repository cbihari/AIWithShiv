import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/lesson.dart';
import '../../../shared/models/quiz.dart';
import '../../../shared/models/user_progress.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../lessons/presentation/lesson_providers.dart';
import '../../progress/presentation/progress_providers.dart';
import '../../quizzes/presentation/quiz_providers.dart';

class DashboardState {
  const DashboardState({
    required this.progress,
    required this.dailyLesson,
    required this.dailyQuiz,
    required this.continueLesson,
  });

  final UserProgress progress;
  final Lesson? dailyLesson;
  final Quiz? dailyQuiz;
  final Lesson? continueLesson;
}

final dashboardProvider = FutureProvider<DashboardState>((ref) async {
  final userId = ref.watch(currentUserIdProvider) ?? 'guest';
  final progress =
      await ref.watch(progressRepositoryProvider).getProgress(userId);
  final dailyLesson =
      await ref.watch(lessonRepositoryProvider).getDailyLesson();
  final dailyQuiz = await ref.watch(quizRepositoryProvider).getDailyQuiz();
  var continueLesson = dailyLesson;
  var foundNextLesson = false;
  final courses = await ref.watch(lessonRepositoryProvider).getCourses();
  for (final course in courses) {
    final lessons = await ref.watch(lessonRepositoryProvider).getLessons(
          course.id,
        );
    for (final lesson in lessons) {
      if (!progress.completedLessons.contains(lesson.id)) {
        continueLesson = lesson;
        foundNextLesson = true;
        break;
      }
    }
    if (foundNextLesson) break;
  }

  return DashboardState(
    progress: progress,
    dailyLesson: dailyLesson,
    dailyQuiz: dailyQuiz,
    continueLesson: continueLesson,
  );
});
