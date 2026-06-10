enum AgeGroup {
  tinyExplorers('Tiny Explorers', 5, 10),
  youngInnovators('Young Innovators', 10, 15),
  futureBuilders('Future Builders', 15, 20),
  adults('Adults', 20, 120);

  const AgeGroup(this.label, this.minAge, this.maxAge);

  final String label;
  final int minAge;
  final int maxAge;
}
