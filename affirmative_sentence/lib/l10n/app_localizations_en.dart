// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Affirmative Sentence';

  @override
  String get home => 'Home';

  @override
  String get affirmations => 'Affirmations';

  @override
  String get settings => 'Settings';

  @override
  String get dailyAffirmations => 'Daily Affirmations';

  @override
  String get todaysAffirmation => 'Today\'s affirmation will appear here';

  @override
  String get myAffirmations => 'My Affirmations';

  @override
  String affirmationExample(Object index) {
    return 'Affirmation Example $index';
  }

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String get notificationTimes => 'Notification Times';

  @override
  String get noNotificationTimes => 'No notification times set';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get confidence => 'Confidence';

  @override
  String get health => 'Health';

  @override
  String get success => 'Success';

  @override
  String get add => 'Add';

  @override
  String get language => 'Language';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get fontSize => 'Font Size';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get timeDuplicate => 'This time already exists';
}
