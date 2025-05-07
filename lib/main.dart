import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AffirmativeApp());
}

class AffirmativeApp extends StatelessWidget {
  const AffirmativeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '肯定語句',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}
