import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  final timezone = tz.getLocation('Asia/Ho_Chi_Minh');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void scheduleNotification(int id, String deadLineDate, String name) {

    DateTime dateTime = DateTime.parse(deadLineDate);

    tz.TZDateTime.from(dateTime, timezone);

    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "You have a deadline in ten minute",
        name + " is time up in 10 minutes.",
        tz.TZDateTime.from(dateTime, tz.local)
            .subtract(const Duration(minutes: 10))
            .add(const Duration(seconds: 3)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'CHANNEL_ID',
                'CHANNEL_NAME',
                'CHANNEL_DESCRIPTION')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}