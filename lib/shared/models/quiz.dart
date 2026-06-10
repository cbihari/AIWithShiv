class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.explanation,
    this.correctAnswerIndexes,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int answerIndex;
  final String explanation;
  final List<int>? correctAnswerIndexes;

  List<int> get acceptedAnswers => correctAnswerIndexes ?? [answerIndex];
  bool get allowsMultipleAnswers => acceptedAnswers.length > 1;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json['id'] as String,
        prompt: json['prompt'] as String,
        options: List<String>.from(json['options'] as List),
        answerIndex: json['answerIndex'] as int,
        explanation: json['explanation'] as String,
        correctAnswerIndexes: json['correctAnswerIndexes'] == null
            ? null
            : List<int>.from(json['correctAnswerIndexes'] as List),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'prompt': prompt,
        'options': options,
        'answerIndex': answerIndex,
        'correctAnswerIndexes': correctAnswerIndexes,
        'explanation': explanation,
      };
}

class Quiz {
  const Quiz({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.questions,
  });

  final String id;
  final String lessonId;
  final String title;
  final List<QuizQuestion> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['id'] as String,
        lessonId: json['lessonId'] as String,
        title: json['title'] as String,
        questions: (json['questions'] as List)
            .map((item) => QuizQuestion.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'title': title,
        'questions': questions.map((question) => question.toJson()).toList(),
      };
}
