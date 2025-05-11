import 'package:flutter/material.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.settings),
      ),
      body: ListView(
        children: [
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
