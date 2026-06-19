import 'dart:convert';

import '../../../core/services/content_cache_service.dart';
import '../../../shared/models/course.dart';
import '../../../shared/models/lesson.dart';
import '../domain/lesson_repository.dart';

class AssetLessonRepository implements LessonRepository {
  const AssetLessonRepository();

  Future<List<Course>> _loadCourses() async {
    final raw = await const ContentCacheService().loadJson(
      'cache_courses',
      'assets/data/courses.json',
    );
    return (jsonDecode(raw) as List)
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Lesson>> _loadLessons() async {
    final raw = await const ContentCacheService().loadJson(
      'cache_lessons',
      'assets/data/lessons.json',
    );
    final lessons = (jsonDecode(raw) as List)
        .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
        .toList();
    lessons.sort((a, b) => a.order.compareTo(b.order));
    return lessons;
  }

  @override
  Future<List<Course>> getCourses() => _loadCourses();

  @override
  Future<List<Lesson>> getLessons(String courseId) async {
    return (await _loadLessons())
        .where((lesson) => lesson.courseId == courseId)
        .toList();
  }

  @override
  Future<Lesson?> getLesson(String lessonId) async {
    for (final lesson in await _loadLessons()) {
      if (lesson.id == lessonId) return lesson;
    }
    return null;
  }

  @override
  Future<Lesson?> getDailyLesson() async {
    final lessons = await _loadLessons();
    return lessons.isEmpty ? null : lessons.first;
  }
}
