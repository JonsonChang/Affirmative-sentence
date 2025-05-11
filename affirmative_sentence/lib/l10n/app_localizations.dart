import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class S {
  static const LocalizationsDelegate<S> delegate = _SDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('zh'),
  ];

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final Map<String, String> _localizedStrings;

  S(this._localizedStrings);

  String get appTitle => _localizedStrings['appTitle']!;
  String get home => _localizedStrings['home']!;
  String get affirmations => _localizedStrings['affirmations']!;
  String get settings => _localizedStrings['settings']!;
  String get dailyAffirmations => _localizedStrings['dailyAffirmations']!;
  String get todaysAffirmation => _localizedStrings['todaysAffirmation']!;
  String get myAffirmations => _localizedStrings['myAffirmations']!;
  String affirmationExample(int index) => _localizedStrings['affirmationExample']!.replaceFirst('{index}', index.toString());
  String get enableNotifications => _localizedStrings['enableNotifications']!;
  String get notificationTime => _localizedStrings['notificationTime']!;
  String get themeColor => _localizedStrings['themeColor']!;
  String get confidence => _localizedStrings['confidence']!;
  String get health => _localizedStrings['health']!;
  String get success => _localizedStrings['success']!;
  String get add => _localizedStrings['add']!;
  String get language => _localizedStrings['language']!;
  String get lightTheme => _localizedStrings['lightTheme']!;
  String get darkTheme => _localizedStrings['darkTheme']!;
  String get systemTheme => _localizedStrings['systemTheme']!;
  String get fontSize => _localizedStrings['fontSize']!;
  String get small => _localizedStrings['small']!;
  String get medium => _localizedStrings['medium']!;
  String get large => _localizedStrings['large']!;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(_lookupS(locale));
  }

  @override
  bool shouldReload(_SDelegate old) => false;
}

S _lookupS(Locale locale) {
  switch (locale.languageCode) {
    case 'zh':
      return S({
        'appTitle': '肯定語句',
        'home': '首頁',
        'affirmations': '肯定語',
        'settings': '設定',
        'dailyAffirmations': '每日肯定語',
        'todaysAffirmation': '今日肯定語將在這裡顯示',
        'myAffirmations': '我的肯定語',
        'affirmationExample': '肯定語範例 {index}',
        'enableNotifications': '啟用通知',
        'notificationTime': '通知時間',
        'themeColor': '主題顏色',
        'confidence': '自信',
        'health': '健康',
        'success': '成功',
        'add': '新增',
        'language': '語言',
        'lightTheme': '淺色',
        'darkTheme': '深色',
        'systemTheme': '系統預設',
        'fontSize': '字體大小',
        'small': '小',
        'medium': '中',
        'large': '大'
      });
    default:
      return S({
        'appTitle': 'Affirmative Sentence',
        'home': 'Home',
        'affirmations': 'Affirmations',
        'settings': 'Settings',
        'dailyAffirmations': 'Daily Affirmations',
        'todaysAffirmation': 'Today\'s affirmation will appear here',
        'myAffirmations': 'My Affirmations',
        'affirmationExample': 'Affirmation Example {index}',
        'enableNotifications': 'Enable Notifications',
        'notificationTime': 'Notification Time',
        'themeColor': 'Theme Color',
        'confidence': 'Confidence',
        'health': 'Health',
        'success': 'Success',
        'add': 'Add',
        'language': 'Language',
        'lightTheme': 'Light',
        'darkTheme': 'Dark',
        'systemTheme': 'System',
        'fontSize': 'Font Size',
        'small': 'Small',
        'medium': 'Medium',
        'large': 'Large'
      });
  }
}
