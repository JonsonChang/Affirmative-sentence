import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:affirmative_sentence/models/notification_time.dart';
import 'package:affirmative_sentence/screens/affirmations_screen.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  late Box<NotificationTime> _notificationBox;
  late Box<AffirmationGroup> _affirmationBox;

  Future<void> initialize() async {
    print('[DEBUG] Initializing notification service');
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    _notificationBox = await Hive.openBox<NotificationTime>('notification_times');
    _affirmationBox = await Hive.openBox<AffirmationGroup>('affirmation_groups');

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Create enhanced notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'affirmation_channel',
      '肯定語句通知',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      showBadge: true,
    );
    
    print('[DEBUG] Creating enhanced notification channel');
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _notificationsPlugin.initialize(
      initializationSettings,
    );
    print('[DEBUG] Notification service initialized successfully');

    _scheduleAllNotifications();
  }

  Future<void> _scheduleAllNotifications() async {
    await _notificationsPlugin.cancelAll();

    for (final notification in _notificationBox.values) {
      if (notification.enabled) {
        _scheduleNotification(notification);
      }
    }
  }

  Future<void> _scheduleNotification(NotificationTime notification) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notification.hour,
      notification.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final affirmations = _getEnabledAffirmations();
    if (affirmations.isEmpty) return;

    final randomAffirmation = affirmations[DateTime.now().millisecond % affirmations.length];

    await _notificationsPlugin.zonedSchedule(
      notification.hashCode,
      '肯定語句提醒',
      randomAffirmation.text,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'affirmation_channel',
          '肯定語句通知',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  List<Affirmation> _getEnabledAffirmations() {
    final affirmations = <Affirmation>[];
    for (final group in _affirmationBox.values) {
      affirmations.addAll(
        group.affirmations.where((a) => a.isEnabled),
      );
    }
    return affirmations;
  }

  Future<void> rescheduleNotifications() async {
    await _scheduleAllNotifications();
  }

  Future<void> triggerTestNotification() async {
    print('[DEBUG] Test notification triggered');
    
    // 檢查並請求權限
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final bool? granted = await androidPlugin.areNotificationsEnabled();
      
      if (granted != true) {
        print('[DEBUG] Requesting notification permission');
        final bool? result = await androidPlugin.requestNotificationsPermission();
        if (result != true) {
          print('[DEBUG] User denied notification permission');
          throw Exception('請開啟系統通知權限');
        }
      }
    }

    final affirmations = _getEnabledAffirmations();
    if (affirmations.isEmpty) {
      print('[DEBUG] No enabled affirmations found');
      throw Exception('沒有啟用的肯定句');
    }

    final randomAffirmation = 
      affirmations[DateTime.now().millisecond % affirmations.length];
    
    print('[DEBUG] Showing notification with affirmation: ${randomAffirmation.text}');
    await _notificationsPlugin.show(
      9999,
      '測試通知',
      randomAffirmation.text,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'affirmation_channel',
          '肯定語句通知',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
    );
    print('[DEBUG] Notification shown successfully');
  }
}
