import 'dart:io';

import '../../../shared/models/course.dart';
import '../../../shared/models/lesson.dart';
import '../../../shared/models/quiz.dart';

abstract interface class AdminRepository {
  Future<void> addCourse(Course course);
  Future<void> addLesson(Lesson lesson);
  Future<void> addQuiz(Quiz quiz);
  Future<String> uploadImage(File file, String path);
  Future<String> uploadVideo(File file, String path);
  Future<int> countUsers();
}
