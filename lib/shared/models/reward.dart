class Reward {
  const Reward({
    required this.id,
    required this.title,
    required this.coins,
    required this.trigger,
  });

  final String id;
  final String title;
  final int coins;
  final String trigger;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json['id'] as String,
        title: json['title'] as String,
        coins: (json['coins'] as num).toInt(),
        trigger: json['trigger'] as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'coins': coins,
        'trigger': trigger,
      };
}
