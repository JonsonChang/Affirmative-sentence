import 'package:flutter/material.dart';

class NotificationSetting {
  final String id;
  final TimeOfDay time;
  final List<int> repeatDays; // 0: Sunday, 1: Monday, ...
  bool enabled;

  NotificationSetting({
    required this.id,
    required this.time,
    required this.repeatDays,
    this.enabled = true,
  });
}
