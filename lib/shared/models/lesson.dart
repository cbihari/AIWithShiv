class Lesson {
  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.story,
    required this.concepts,
    required this.durationMinutes,
    required this.xp,
    this.order = 0,
  });

  final String id;
  final String courseId;
  final String title;
  final String story;
  final List<String> concepts;
  final int durationMinutes;
  final int xp;
  final int order;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'] as String,
        courseId: json['courseId'] as String,
        title: json['title'] as String,
        story: json['story'] as String,
        concepts: List<String>.from(json['concepts'] as List),
        durationMinutes: json['durationMinutes'] as int,
        xp: json['xp'] as int,
        order: (json['order'] as int?) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'title': title,
        'story': story,
        'concepts': concepts,
        'durationMinutes': durationMinutes,
        'xp': xp,
        'order': order,
      };
}
