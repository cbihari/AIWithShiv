import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../shared/models/course.dart';
import '../../../shared/models/lesson.dart';
import '../../../shared/models/quiz.dart';
import '../domain/admin_repository.dart';

class FirebaseAdminRepository implements AdminRepository {
  const FirebaseAdminRepository(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<void> addCourse(Course course) {
    return _firestore.collection('courses').doc(course.id).set({
      'title': course.title,
      'description': course.description,
      'category': course.category,
      'ageGroups': course.ageGroups,
      'lessonIds': course.lessonIds,
      'imageUrl': course.imageUrl,
      'xp': course.xp,
    });
  }

  @override
  Future<void> addLesson(Lesson lesson) {
    return _firestore.collection('lessons').doc(lesson.id).set({
      'courseId': lesson.courseId,
      'title': lesson.title,
      'story': lesson.story,
      'concepts': lesson.concepts,
      'durationMinutes': lesson.durationMinutes,
      'xp': lesson.xp,
      'order': lesson.order,
    });
  }

  @override
  Future<void> addQuiz(Quiz quiz) {
    return _firestore.collection('quizzes').doc(quiz.id).set({
      'lessonId': quiz.lessonId,
      'title': quiz.title,
      'questions': quiz.questions
          .map(
            (question) => {
              'id': question.id,
              'prompt': question.prompt,
              'options': question.options,
              'answerIndex': question.answerIndex,
              'correctAnswerIndexes': question.correctAnswerIndexes,
              'explanation': question.explanation,
            },
          )
          .toList(),
    });
  }

  @override
  Future<String> uploadImage(File file, String path) => _upload(file, path);

  @override
  Future<String> uploadVideo(File file, String path) => _upload(file, path);

  @override
  Future<int> countUsers() async {
    final aggregate = await _firestore.collection('users').count().get();
    return aggregate.count ?? 0;
  }

  Future<String> _upload(File file, String path) async {
    final ref = _storage.ref(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
