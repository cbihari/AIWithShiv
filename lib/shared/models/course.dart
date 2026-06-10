class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.ageGroups,
    required this.lessonIds,
    required this.imageUrl,
    required this.xp,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> ageGroups;
  final List<String> lessonIds;
  final String imageUrl;
  final int xp;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        ageGroups: List<String>.from(json['ageGroups'] as List),
        lessonIds: List<String>.from(json['lessonIds'] as List),
        imageUrl: json['imageUrl'] as String,
        xp: json['xp'] as int,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'category': category,
        'ageGroups': ageGroups,
        'lessonIds': lessonIds,
        'imageUrl': imageUrl,
        'xp': xp,
      };
}
