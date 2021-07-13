import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void scheduleNotification(int id, String deadLineDate, String name) {

    DateTime dateTime = DateTime.parse(deadLineDate);

    tz.TZDateTime triggeredTime= getTriggeredTime(dateTime);

    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        name + " is time up in 10 minutes!!!",
        "Wake your mind up and check it out, come on!",
        triggeredTime,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'CHANNEL_ID',
                'CHANNEL_NAME',
                'CHANNEL_DESCRIPTION')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  tz.TZDateTime getTriggeredTime (DateTime dateTime) {
    tz.TZDateTime result = tz.TZDateTime.from(dateTime, tz.local)
        .subtract(const Duration(minutes: 10))
        .add(const Duration(seconds: 3));

    if (result.isBefore(tz.TZDateTime.now(tz.local))) {
      result = tz.TZDateTime.now(tz.local)
          .add(const Duration(seconds: 30));
    }

    return result;
  }

  void cancelNotification(int id) {
     flutterLocalNotificationsPlugin.cancel(id);
  }

}
