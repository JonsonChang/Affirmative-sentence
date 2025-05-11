import 'package:flutter/material.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';
import 'package:affirmative_sentence/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late BuildContext _appContext;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  bool _notificationsEnabled = true;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
    }
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
          SwitchListTile(
            title: Text(S.of(context)!.enableNotifications),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text(S.of(context)!.notificationTime),
            subtitle: Text(_notificationTime.format(context)),
            onTap: () => _selectTime(context),
          ),
          const Divider(),
          _buildFontSizeSelector(context),
          _buildThemeSelector(context),
        ],
      ),
    );
  }
}
