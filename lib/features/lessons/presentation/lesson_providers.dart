import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../shared/models/course.dart';
import '../../../shared/models/lesson.dart';
import '../data/firestore_lesson_repository.dart';
import '../domain/lesson_repository.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return FirestoreLessonRepository(ref.watch(firestoreProvider));
});

final coursesProvider = FutureProvider<List<Course>>((ref) {
  return ref.watch(lessonRepositoryProvider).getCourses();
});

final lessonsForCourseProvider = FutureProvider.family<List<Lesson>, String>((
  ref,
  courseId,
) {
  return ref.watch(lessonRepositoryProvider).getLessons(courseId);
});

final lessonProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) {
  return ref.watch(lessonRepositoryProvider).getLesson(lessonId);
});
