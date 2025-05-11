import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmative_sentence/screens/home_screen.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  String _fontSize = 'medium';

  String get fontSize => _fontSize;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load language
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }

    // Load theme
    final themeMode = prefs.getString('themeMode');
    if (themeMode != null) {
      setState(() {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.toString() == 'ThemeMode.$themeMode',
          orElse: () => ThemeMode.system,
        );
      });
    }

    // Load font size
    final fontSize = prefs.getString('fontSize');
    if (fontSize != null) {
      setState(() {
        _fontSize = fontSize;
      });
    }
  }

  void changeFontSize(String fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontSize', fontSize);
    setState(() {
      _fontSize = fontSize;
    });
  }

  void changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  void changeTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.toString().split('.').last);
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '肯定語句',
      locale: _locale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: _fontSize == 'small' ? 14 : _fontSize == 'medium' ? 16 : 18),
          bodyMedium: TextStyle(fontSize: _fontSize == 'small' ? 12 : _fontSize == 'medium' ? 14 : 16),
          titleLarge: TextStyle(fontSize: _fontSize == 'small' ? 18 : _fontSize == 'medium' ? 20 : 22),
          titleMedium: TextStyle(fontSize: _fontSize == 'small' ? 16 : _fontSize == 'medium' ? 18 : 20),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: _fontSize == 'small' ? 14 : _fontSize == 'medium' ? 16 : 18),
          bodyMedium: TextStyle(fontSize: _fontSize == 'small' ? 12 : _fontSize == 'medium' ? 14 : 16),
          titleLarge: TextStyle(fontSize: _fontSize == 'small' ? 18 : _fontSize == 'medium' ? 20 : 22),
          titleMedium: TextStyle(fontSize: _fontSize == 'small' ? 16 : _fontSize == 'medium' ? 18 : 20),
        ),
      ),
      themeMode: _themeMode,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
