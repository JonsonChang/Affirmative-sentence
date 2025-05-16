import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:affirmative_sentence/models/notification_time.dart';
import 'package:affirmative_sentence/screens/affirmations_screen.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  late Box<NotificationTime> _notificationBox;
  late Box<AffirmationGroup> _affirmationBox;

  Future<bool> _checkDeviceCapability() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin == null) {
      print('[CAPABILITY] 錯誤: 無法獲取Android插件');
      return false;
    }
    
    final notificationsEnabled = await androidPlugin.areNotificationsEnabled();
    print('[CAPABILITY] 系統通知權限: $notificationsEnabled');
    
    final canScheduleExact = await androidPlugin.canScheduleExactNotifications();
    print('[CAPABILITY] 精確排程權限: $canScheduleExact');
    
    return notificationsEnabled == true;
  }

  Future<void> initialize() async {
    print('[DEBUG] Initializing notification service');
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    _notificationBox = await Hive.openBox<NotificationTime>('notification_times');
    _affirmationBox = await Hive.openBox<AffirmationGroup>('affirmation_groups');

    final hasCapability = await _checkDeviceCapability();
    if (!hasCapability) {
      print('[WARNING] 設備通知能力不足，通知可能無法正常顯示');
    }

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
    print('[SCHEDULE] 初始化排程，共 ${_notificationBox.values.length} 個通知設定');
    await _notificationsPlugin.cancelAll();

    int enabledCount = 0;
    for (final notification in _notificationBox.values) {
      if (notification.enabled) {
        enabledCount++;
        print('[SCHEDULE] 準備排程啟用通知: ${notification.hour}:${notification.minute} (ID: ${notification.hashCode})');
        _scheduleNotification(notification);
      }
    }
    print('[SCHEDULE] 已完成排程，共 $enabledCount 個啟用通知');
  }

  Future<void> _scheduleNotification(NotificationTime notification) async {
    final now = tz.TZDateTime.now(tz.local);
    print('[SCHEDULE] 當前時間: ${now.toString()}');
    
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notification.hour,
      notification.minute,
    );
    print('[SCHEDULE] 原始排程時間: ${scheduledDate.toString()}');

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      print('[SCHEDULE] 調整後排程時間: ${scheduledDate.toString()} (已加1天)');
    }

    final affirmations = _getEnabledAffirmations();
    if (affirmations.isEmpty) {
      print('[SCHEDULE] 警告: 沒有啟用的肯定句，取消排程');
      return;
    }

    final randomAffirmation = affirmations[DateTime.now().millisecond % affirmations.length];
    print('[SCHEDULE] 將顯示肯定句: "${randomAffirmation.text}"');

    try {
      // 先嘗試精確排程
      await _notificationsPlugin.zonedSchedule(
        notification.hashCode,
        '肯定語句提醒',
        randomAffirmation.text,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'affirmation_channel',
            '肯定語句通知',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print('[SCHEDULE] 成功使用精確排程 ID: ${notification.hashCode}');
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        print('[SCHEDULE] 精確排程權限不足，改用非精確排程');
        try {
          await _notificationsPlugin.zonedSchedule(
            notification.hashCode,
            '肯定語句提醒',
            randomAffirmation.text,
            scheduledDate,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'affirmation_channel',
                '肯定語句通知',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          print('[SCHEDULE] 成功使用非精確排程 ID: ${notification.hashCode}');
        } on PlatformException catch (e) {
          print('[SCHEDULE] 排程失敗: $e');
        }
      } else {
        print('[SCHEDULE] 排程失敗: $e');
      }
    }
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
    final hasCapability = await _checkDeviceCapability();
    if (!hasCapability) {
      throw Exception('設備通知功能被限制，請檢查系統設置');
    }
    
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
