import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/verse.dart';

class NotificationService {
  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  Future<void> scheduleDailyPractice(Verse verse) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_practice',
        'Daily Practice',
        channelDescription:
            'Daily reminders to review your current memory verse.',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _plugin.showDailyAtTime(
      1,
      'Practice ${verse.reference}',
      verse.text,
      const Time(8, 0, 0),
      details,
    );
  }

  Future<void> showCelebration(Verse verse) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'celebration',
        'Memorization Celebrations',
        channelDescription: 'Encouraging notifications when you memorize verses.',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Well done!',
      'You just memorized ${verse.reference}! Keep going!',
      details,
    );
  }
}
