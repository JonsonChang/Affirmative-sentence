class Sentence {
  final String id;
  final String content;
  final String category;
  bool isFavorite;

  Sentence({
    required this.id,
    required this.content,
    required this.category,
    this.isFavorite = false,
  });
}
