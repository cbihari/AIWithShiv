import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/course.dart';
import '../../../shared/models/lesson.dart';
import '../../../shared/models/quiz.dart';
import '../domain/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return const LocalDisabledAdminRepository();
});

class LocalDisabledAdminRepository implements AdminRepository {
  const LocalDisabledAdminRepository();

  @override
  Future<void> addCourse(Course course) async {}

  @override
  Future<void> addLesson(Lesson lesson) async {}

  @override
  Future<void> addQuiz(Quiz quiz) async {}

  @override
  Future<int> countUsers() async => 1;

  @override
  Future<String> uploadImage(File file, String path) async => '';

  @override
  Future<String> uploadVideo(File file, String path) async => '';
}
