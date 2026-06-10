class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredXp,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredXp;

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        icon: json['icon'] as String,
        requiredXp: (json['requiredXp'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'icon': icon,
        'requiredXp': requiredXp,
      };
}
