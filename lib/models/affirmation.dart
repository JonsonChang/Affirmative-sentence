class Affirmation {
  final int? id;
  final String text;
  final bool isFavorite;
  final String category;
  final DateTime createdAt;

  Affirmation({
    this.id,
    required this.text,
    this.isFavorite = false,
    this.category = 'General',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isFavorite': isFavorite ? 1 : 0,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Affirmation.fromMap(Map<String, dynamic> map) {
    return Affirmation(
      id: map['id'],
      text: map['text'],
      isFavorite: map['isFavorite'] == 1,
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Affirmation copyWith({
    int? id,
    String? text,
    bool? isFavorite,
    String? category,
    DateTime? createdAt,
  }) {
    return Affirmation(
      id: id ?? this.id,
      text: text ?? this.text,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
