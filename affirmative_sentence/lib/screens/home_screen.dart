import 'package:flutter/material.dart';
import 'package:affirmative_sentence/screens/affirmations_screen.dart';
import 'package:affirmative_sentence/screens/settings_screen.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const _HomeContent(),
    const AffirmationsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: S.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_quote),
          label: S.of(context)!.affirmations,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: S.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.dailyAffirmations),
      ),
      body: Center(
        child: Text(S.of(context)!.todaysAffirmation),
      ),
    );
  }
}
