import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/notification_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<NotificationSettings> _settingsFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _settingsFuture = _loadSettings();
  }

  Future<NotificationSettings> _loadSettings() async {
    // TODO: 實作讀取設定
    return NotificationSettings(id: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: FutureBuilder<NotificationSettings>(
        future: _settingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                title: const Text('啟用通知'),
                value: snapshot.data?.isEnabled ?? true,
                onChanged: (value) {
                  // TODO: 更新設定
                },
              ),
              // 更多設定選項...
            ],
          );
        },
      ),
    );
  }
}
