import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/course.dart';
import '../../../shared/models/lesson.dart';
import '../domain/lesson_repository.dart';

class FirestoreLessonRepository implements LessonRepository {
  const FirestoreLessonRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Course> get _coursesCollection =>
      _firestore.collection('courses').withConverter<Course>(
            fromFirestore: (snapshot, _) =>
                Course.fromJson({'id': snapshot.id, ...snapshot.data()!}),
            toFirestore: (course, _) => course.toJson(),
          );

  CollectionReference<Lesson> get _lessonsCollection =>
      _firestore.collection('lessons').withConverter<Lesson>(
            fromFirestore: (snapshot, _) =>
                Lesson.fromJson({'id': snapshot.id, ...snapshot.data()!}),
            toFirestore: (lesson, _) => lesson.toJson(),
          );

  @override
  Future<List<Course>> getCourses() async {
    final snapshot = await _coursesCollection.orderBy('title').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<Lesson>> getLessons(String courseId) async {
    final snapshot = await _lessonsCollection
        .where('courseId', isEqualTo: courseId)
        .orderBy('order')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<Lesson?> getLesson(String lessonId) async {
    final doc = await _lessonsCollection.doc(lessonId).get();
    return doc.data();
  }

  @override
  Future<Lesson?> getDailyLesson() async {
    final snapshot = await _lessonsCollection.orderBy('order').limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }
}
