import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

// ignore: avoid_classes_with_only_static_members
class NotificationManger {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id 4",
        "channel name",
        "channel descriprion",
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initSchedule = false}) async {
    const androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const iosSettings = IOSInitializationSettings();
    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return _notification.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static Future showScheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    return _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.UTC),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  static Future showNotificationDaily({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    const time = Time(6);

    return _notification.zonedSchedule(
      id,
      title,
      body,
      _scheduleTime(time),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _scheduleTime(Time time) {
    final DateTime scheduledDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      time.hour,
      time.minute,
    );

    final scheduleDate = tz.TZDateTime.from(scheduledDate, tz.local);
    return scheduleDate.isBefore(DateTime.now())
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }
}
