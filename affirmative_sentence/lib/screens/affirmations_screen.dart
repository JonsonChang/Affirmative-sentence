import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';
import 'dart:convert';

class AffirmationsScreen extends StatefulWidget {
  const AffirmationsScreen({super.key});

  @override
  State<AffirmationsScreen> createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  Future<List<dynamic>> _loadAffirmations(BuildContext context) async {
    final locale = Localizations.localeOf(context);
    final file = locale.languageCode == 'zh' 
        ? 'assets/affirmations_zh.json'
        : 'assets/affirmations.json';
        
    final data = await rootBundle.loadString(file);
    return json.decode(data)['categories'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.myAffirmations),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadAffirmations(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;
          
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ExpansionTile(
                title: Text(category['name']),
                children: category['affirmations'].map<Widget>((affirmation) {
                  return ListTile(
                    title: Text(affirmation),
                  );
                }).toList(),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
