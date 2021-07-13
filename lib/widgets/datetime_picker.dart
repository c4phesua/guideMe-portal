import 'package:guideme/models/notification.dart';
import 'package:guideme/models/task.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/utils/notification_helper.dart';
import 'package:guideme/widgets/button_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimePickerWidget extends StatefulWidget {
  final DateTime date;

  final int taskId;

  const DatetimePickerWidget({Key key, this.taskId, this.date}) : super(key: key);

  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState(dateTime: this.date);
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  DateTime dateTime;

  _DatetimePickerWidgetState({this.dateTime});

  int get taskId => this.widget.taskId;

  String getText() {
    if (dateTime == null) {
      return 'Select Date Expired';
    } else {
      return 'Date Expired: ' + DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonHeaderWidget(
      title: 'Date Expired',
      text: getText(),
      onClicked: () => pickDateTime(context),
    );
  }


  Future pickDateTime(BuildContext context) async {

    DatabaseHelper _dbHelper = DatabaseHelper();

    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      //add update time to db
    });
    int id = this.taskId;
    await _dbHelper.updateTaskExpiredDate(id, dateTime);
    await handleNotification(taskId, dateTime);
  }

  Future<void> handleNotification(int taskId, DateTime dateTime) async {
    NotificationHelper _notificationHelper = NotificationHelper();
    DatabaseHelper _dbHelper = DatabaseHelper();

    //get old if any, cancel old
    int oldNotiId = 0;

    await _dbHelper.getNotificationId(taskId).then((value) => oldNotiId = value);

    if (oldNotiId != 0) {
      _notificationHelper.cancelNotification(oldNotiId);
    }

    //create new
    LocalNotification _notification = LocalNotification(taskId: taskId);
    int notiId = await _dbHelper.insertNotification(_notification);
    //schedule
    Task task = await _dbHelper.getTaskById(taskId);
    _notificationHelper.scheduleNotification(notiId, dateTime.toString(), task.title);
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }
}