import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/notifications/models/reminder.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  static Future<void> scheduleReminder(Reminder reminder) async {
    await initialize();

    final notificationId = _notificationIdForReminder(reminder.id);
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'investtrack_reminders',
        'InvestTrack Reminders',
        channelDescription: 'Scheduled reminder alerts for InvestTrack.',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final scheduledDate = tz.TZDateTime.from(reminder.dueDate, tz.local);

    if (reminder.repeat == ReminderRepeat.none) {
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        await _plugin.cancel(notificationId);
        return;
      }

      await _plugin.zonedSchedule(
        notificationId,
        reminder.title,
        reminder.description ?? 'Reminder is due now.',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return;
    }

    await _plugin.zonedSchedule(
      notificationId,
      reminder.title,
      reminder.description ?? 'Reminder is due now.',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: _repeatMatchComponent(reminder.repeat),
    );
  }

  static Future<void> cancelReminder(int reminderId) async {
    await initialize();
    await _plugin.cancel(_notificationIdForReminder(reminderId));
  }

  static Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }

  static int _notificationIdForReminder(int reminderId) {
    return (reminderId * 13) + 7000;
  }

  static DateTimeComponents? _repeatMatchComponent(ReminderRepeat repeat) {
    switch (repeat) {
      case ReminderRepeat.none:
        return null;
      case ReminderRepeat.daily:
        return DateTimeComponents.time;
      case ReminderRepeat.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case ReminderRepeat.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case ReminderRepeat.quarterly:
        return DateTimeComponents.dayOfMonthAndTime;
      case ReminderRepeat.yearly:
        return DateTimeComponents.dateAndTime;
      case ReminderRepeat.custom:
        return null;
    }
  }
}
