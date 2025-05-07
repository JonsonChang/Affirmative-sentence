import 'package:flutter/material.dart';
import '../models/sentence.dart';

class CustomSentenceCard extends StatelessWidget {
  final Sentence sentence;
  final VoidCallback? onFavoriteToggle;
  const CustomSentenceCard({
    super.key,
    required this.sentence,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(sentence.content),
        subtitle: Text(sentence.category),
        trailing: IconButton(
          icon: Icon(
            sentence.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: sentence.isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}
