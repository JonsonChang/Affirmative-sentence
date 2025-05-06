class NotificationSettings {
  final int id;
  final bool isEnabled;
  final List<int> activeDays;
  final List<Time> notificationTimes;
  final bool randomSelection;

  NotificationSettings({
    required this.id,
    this.isEnabled = true,
    this.activeDays = const [1,2,3,4,5],
    this.notificationTimes = const [Time(9,0)],
    this.randomSelection = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isEnabled': isEnabled ? 1 : 0,
      'activeDays': activeDays.join(','),
      'notificationTimes': notificationTimes.map((t) => '${t.hour}:${t.minute}').join(','),
      'randomSelection': randomSelection ? 1 : 0,
    };
  }

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      id: map['id'],
      isEnabled: map['isEnabled'] == 1,
      activeDays: (map['activeDays'] as String).split(',').map(int.parse).toList(),
      notificationTimes: (map['notificationTimes'] as String)
          .split(',')
          .map((e) {
            final parts = e.split(':');
            return Time(int.parse(parts[0]), int.parse(parts[1]));
          })
          .toList(),
      randomSelection: map['randomSelection'] == 1,
    );
  }
}
