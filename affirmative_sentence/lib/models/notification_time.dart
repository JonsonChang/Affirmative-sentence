import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'notification_time.g.dart';

@HiveType(typeId: 1)
class NotificationTime {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final int hour;
  
  @HiveField(2)
  final int minute;
  
  @HiveField(3)
  bool enabled;

  NotificationTime({
    required this.id,
    required this.hour,
    required this.minute,
    this.enabled = true,
  });

  factory NotificationTime.fromTime({
    required String id,
    required TimeOfDay time,
    bool enabled = true,
  }) {
    return NotificationTime(
      id: id,
      hour: time.hour,
      minute: time.minute,
      enabled: enabled,
    );
  }

  factory NotificationTime.fromHive({
    required String id,
    required int hour,
    required int minute,
    bool enabled = true,
  }) {
    return NotificationTime(
      id: id,
      hour: hour,
      minute: minute,
      enabled: enabled,
    );
  }

  factory NotificationTime.fromMap(Map<String, dynamic> map) {
    return NotificationTime(
      id: map['id'],
      hour: map['hour'],
      minute: map['minute'],
      enabled: map['enabled'] ?? true,
    );
  }

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  String formatTime(BuildContext context) {
    return time.format(context);
  }
}
