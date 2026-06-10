import '../../../shared/models/quiz.dart';
import '../../../shared/models/quiz_result.dart';

abstract interface class QuizRepository {
  Future<Quiz?> getDailyQuiz();
  Future<Quiz?> getQuizForLesson(String lessonId);
  Future<void> saveResult(QuizResult result);
}
