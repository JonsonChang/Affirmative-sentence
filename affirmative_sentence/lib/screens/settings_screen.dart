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
          ListTile(
            title: Text(S.of(context)!.themeColor),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
