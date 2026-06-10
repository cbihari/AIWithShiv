import '../../../shared/models/course.dart';
import '../../../shared/models/lesson.dart';

abstract interface class LessonRepository {
  Future<List<Course>> getCourses();
  Future<List<Lesson>> getLessons(String courseId);
  Future<Lesson?> getLesson(String lessonId);
  Future<Lesson?> getDailyLesson();
}
