import 'package:flutter/material.dart';
import 'package:affirmative_sentence/screens/home_screen.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '肯定語句',
      localizationsDelegates: [
        S.delegate,
      ],
      supportedLocales: S.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
