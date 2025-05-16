import 'package:flutter/material.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';
import 'package:affirmative_sentence/main.dart';
import 'package:affirmative_sentence/screens/notification_times_screen.dart';
import 'package:affirmative_sentence/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late BuildContext _appContext;

  Future<void> _navigateToNotificationTimes(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationTimesScreen(),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return ListTile(
      title: Text(S.of(context)!.language),
      trailing: DropdownButton<Locale>(
        value: Localizations.localeOf(context),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            (_appContext.findRootAncestorStateOfType<MyAppState>()?.changeLanguage(newLocale));
          }
        },
        items: S.supportedLocales.map((Locale locale) {
          final languageName = locale.languageCode == 'zh' ? '中文' : 'English';
          return DropdownMenuItem<Locale>(
            value: locale,
            child: Text(languageName),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFontSizeSelector(BuildContext context) {
    final currentFontSize = _appContext.findRootAncestorStateOfType<MyAppState>()?.fontSize ?? 'medium';
    
    return ListTile(
      title: Text(S.of(context)!.fontSize),
      trailing: DropdownButton<String>(
        value: currentFontSize,
        onChanged: (String? newSize) {
          if (newSize != null) {
            (_appContext.findRootAncestorStateOfType<MyAppState>()?.changeFontSize(newSize));
          }
        },
        items: [
          DropdownMenuItem<String>(
            value: 'small',
            child: Text(S.of(context)!.small),
          ),
          DropdownMenuItem<String>(
            value: 'medium',
            child: Text(S.of(context)!.medium),
          ),
          DropdownMenuItem<String>(
            value: 'large',
            child: Text(S.of(context)!.large),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    final currentTheme = Theme.of(context).brightness == Brightness.dark 
        ? ThemeMode.dark 
        : ThemeMode.light;
        
    return ListTile(
      title: Text(S.of(context)!.themeColor),
      trailing: DropdownButton<ThemeMode>(
        value: currentTheme,
        onChanged: (ThemeMode? newTheme) {
          if (newTheme != null) {
            (_appContext.findRootAncestorStateOfType<MyAppState>()?.changeTheme(newTheme));
          }
        },
        items: [
          DropdownMenuItem<ThemeMode>(
            value: ThemeMode.system,
            child: Text(S.of(context)!.systemTheme),
          ),
          DropdownMenuItem<ThemeMode>(
            value: ThemeMode.light,
            child: Text(S.of(context)!.lightTheme),
          ),
          DropdownMenuItem<ThemeMode>(
            value: ThemeMode.dark,
            child: Text(S.of(context)!.darkTheme),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _appContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.settings),
      ),
      body: ListView(
        children: [
          _buildLanguageSelector(context),
          ListTile(
            title: Text(S.of(context)!.notificationTimes),
            onTap: () => _navigateToNotificationTimes(context),
          ),
          const Divider(),
          _buildFontSizeSelector(context),
          _buildThemeSelector(context),
          const Divider(),
          ListTile(
            title: Text('測試通知功能'),
            trailing: Icon(Icons.notifications),
            onTap: () async {
              try {
                await NotificationService().triggerTestNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('測試通知已觸發'))
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('測試通知失敗: $e'))
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
