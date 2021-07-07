import 'package:guideme/widgets/button_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimePickerWidget extends StatefulWidget {
  final DateTime date;

  const DatetimePickerWidget({Key key, this.date}) : super(key: key);

  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState();
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  DateTime dateTime;
  String getText() {
    if (widget.date == null) {
      return 'Select Date Expired';
    } else {
      return 'Date Expired: ' + DateFormat('MM/dd/yyyy HH:mm').format(widget.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonHeaderWidget(
      title: 'Date Expired',
      text: getText(),
      onClicked: () => pickDateTime(context,widget.date),
    );
  }


  Future pickDateTime(BuildContext context,DateTime dateExpired) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateExpired = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      //add update time to db

    });
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