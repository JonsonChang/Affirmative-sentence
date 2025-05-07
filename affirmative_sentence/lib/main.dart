import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/phrase.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final databaseService = DatabaseService();
  final notificationService = NotificationService();
  
  await databaseService.initialize();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => databaseService),
        ChangeNotifierProvider(create: (_) => notificationService),
      ],
      child: const AffirmativeApp(),
    ),
  );
}

class AffirmativeApp extends StatelessWidget {
  const AffirmativeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '肯定語句',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
