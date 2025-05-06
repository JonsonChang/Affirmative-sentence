import 'package:flutter/material.dart';
import '../models/affirmation.dart';

class AffirmationCard extends StatelessWidget {
  final Affirmation affirmation;

  const AffirmationCard({
    super.key,
    required this.affirmation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              affirmation.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(affirmation.category),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    affirmation.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: affirmation.isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    // TODO: 收藏/取消收藏功能
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
