class Phrase {
  final int id;
  final String text;
  final int categoryId;
  bool isFavorite;

  Phrase({
    required this.id,
    required this.text,
    required this.categoryId,
    this.isFavorite = false,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      id: json['id'],
      text: json['text'],
      categoryId: json['categoryId'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'categoryId': categoryId,
      'isFavorite': isFavorite,
    };
  }
}

class PhraseCategory {
  final int id;
  final String name;
  final List<Phrase> phrases;

  PhraseCategory({
    required this.id,
    required this.name,
    required this.phrases,
  });

  factory PhraseCategory.fromJson(Map<String, dynamic> json) {
    return PhraseCategory(
      id: json['id'],
      name: json['name'],
      phrases: (json['phrases'] as List)
          .map((phrase) => Phrase.fromJson(phrase))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phrases': phrases.map((phrase) => phrase.toJson()).toList(),
    };
  }
}
