// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '肯定語句';

  @override
  String get home => '首頁';

  @override
  String get affirmations => '肯定語句';

  @override
  String get settings => '設定';

  @override
  String get dailyAffirmations => '每日肯定語句';

  @override
  String get todaysAffirmation => '今天的肯定語句將顯示在這裡';

  @override
  String get myAffirmations => '我的肯定語句';

  @override
  String affirmationExample(Object index) {
    return '肯定語句範例 $index';
  }

  @override
  String get enableNotifications => '啟用通知';

  @override
  String get notificationTime => '通知時間';

  @override
  String get notificationTimes => '通知時間設定';

  @override
  String get noNotificationTimes => '尚未設定通知時間';

  @override
  String get themeColor => '主題顏色';

  @override
  String get confidence => '自信';

  @override
  String get health => '健康';

  @override
  String get success => '成功';

  @override
  String get add => '新增';

  @override
  String get language => '語言';

  @override
  String get lightTheme => '淺色';

  @override
  String get darkTheme => '深色';

  @override
  String get systemTheme => '系統預設';

  @override
  String get fontSize => '字體大小';

  @override
  String get small => '小';

  @override
  String get medium => '中';

  @override
  String get large => '大';

  @override
  String get timeDuplicate => '此時間已存在';

  @override
  String get addGroup => '新增群組';

  @override
  String get editGroup => '編輯群組';

  @override
  String get editAffirmation => '編輯肯定語句';

  @override
  String get affirmationText => '肯定語句內容';

  @override
  String get groupName => '群組名稱';
}
