import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:affirmative_sentence/models/notification_time.dart';
import 'package:affirmative_sentence/l10n/app_localizations.dart';

class NotificationTimesScreen extends StatefulWidget {
  const NotificationTimesScreen({super.key});

  @override
  State<NotificationTimesScreen> createState() => _NotificationTimesScreenState();
}

class _NotificationTimesScreenState extends State<NotificationTimesScreen> {
  late Box<NotificationTime> _notificationsBox;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      _notificationsBox = await Hive.openBox<NotificationTime>('notification_times');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addNotificationTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final newNotification = NotificationTime.fromTime(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: time,
      );
      await _notificationsBox.add(newNotification);
    }
  }

  Future<void> _editNotificationTime(NotificationTime notification, int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: notification.time,
    );

    if (time != null) {
      final updatedNotification = NotificationTime.fromTime(
        id: notification.id,
        time: time,
        enabled: notification.enabled,
      );
      await _notificationsBox.putAt(index, updatedNotification);
    }
  }

  Future<void> _toggleNotification(NotificationTime notification, int index) async {
    final updatedNotification = NotificationTime(
      id: notification.id,
      hour: notification.hour,
      minute: notification.minute,
      enabled: !notification.enabled,
    );
    await _notificationsBox.putAt(index, updatedNotification);
  }

  Future<void> _deleteNotificationTime(int index) async {
    await _notificationsBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.notificationTimes),
      ),
      body: ValueListenableBuilder<Box<NotificationTime>>(
        valueListenable: _notificationsBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(S.of(context)!.noNotificationTimes),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final notification = box.getAt(index)!;
              return ListTile(
                title: Text(notification.formatTime(context)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: notification.enabled,
                      onChanged: (_) => _toggleNotification(notification, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNotificationTime(index),
                    ),
                  ],
                ),
                onTap: () => _editNotificationTime(notification, index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNotificationTime,
        child: const Icon(Icons.add),
      ),
    );
  }
}
