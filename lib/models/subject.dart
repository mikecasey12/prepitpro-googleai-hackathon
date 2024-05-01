enum Difficulty { easy, medium, hard }

class Subject {
  final int? id;
  final String? coverImage;
  final String? name;
  final int? color;
  final Difficulty? difficulty;

  const Subject(
      {required this.id,
      required this.name,
      required this.coverImage,
      required this.color,
      this.difficulty = Difficulty.easy});
}
