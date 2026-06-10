import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/quiz.dart';
import '../../../shared/models/quiz_result.dart';
import '../domain/quiz_repository.dart';

class FirestoreQuizRepository implements QuizRepository {
  const FirestoreQuizRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Quiz> get _quizzesCollection =>
      _firestore.collection('quizzes').withConverter<Quiz>(
            fromFirestore: (snapshot, _) =>
                Quiz.fromJson({'id': snapshot.id, ...snapshot.data()!}),
            toFirestore: (quiz, _) => quiz.toJson(),
          );

  CollectionReference<QuizResult> get _resultsCollection =>
      _firestore.collection('quizResults').withConverter<QuizResult>(
            fromFirestore: (snapshot, _) =>
                QuizResult.fromJson({'id': snapshot.id, ...snapshot.data()!}),
            toFirestore: (result, _) => result.toJson(),
          );

  @override
  Future<Quiz?> getDailyQuiz() async {
    final snapshot =
        await _quizzesCollection.orderBy('lessonId').limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  @override
  Future<Quiz?> getQuizForLesson(String lessonId) async {
    final snapshot = await _quizzesCollection
        .where('lessonId', isEqualTo: lessonId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  @override
  Future<void> saveResult(QuizResult result) {
    return _resultsCollection.doc(result.id).set(result);
  }
}
