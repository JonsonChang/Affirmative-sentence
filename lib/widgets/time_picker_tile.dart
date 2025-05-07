import 'package:flutter/material.dart';

class TimePickerTile extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback? onTap;
  const TimePickerTile({
    super.key,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('通知時間'),
      subtitle: Text(time.format(context)),
      trailing: const Icon(Icons.access_time),
      onTap: onTap,
    );
  }
}
