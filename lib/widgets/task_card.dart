import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guideme/utils/database_helper.dart';

class TaskCardWidget extends StatelessWidget {
  DatabaseHelper _dbHelper = DatabaseHelper();
  final String title;
  final String desc;
  final int taskId;
  bool isRemove = false;

  TaskCardWidget({this.title, this.desc, this.taskId});


  @override
  Widget build(BuildContext context) {
    return Slidable(
    actionPane: SlidableScrollActionPane(),
    actionExtentRatio: 0.25,
    actions: <Widget>[
      new IconSlideAction(
        caption: 'Share',
        color: Colors.indigo[400],
        icon: Icons.share,
        onTap: () => print('Share'), //call action
      ),
    ],
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      margin: EdgeInsets.only(
        bottom: 5.0,
        top: 5.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFEEEDFF),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Unnamed Task)",
            style: TextStyle(
              
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              desc ?? "No Description Added",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF86829D),
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    ),
    );
  }
}