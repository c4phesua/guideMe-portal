import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guideme/models/task.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/utils/utils.dart';
import 'package:intl/intl.dart';

class ItemCardWidget extends StatelessWidget {
  DatabaseHelper _dbHelper = DatabaseHelper();
  final Task task;
  final VoidCallback myVoidCallback;

  ItemCardWidget({this.task,this.myVoidCallback});


  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.orange,
            caption: 'Download',
            onTap: () => downloadTodo(context,this.task),
            icon: Icons.download,
          )
        ],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
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

          child:
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.task.title ?? "(Unnamed Task)",
                      style: TextStyle(
                        color: Color(0xFF211551),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Container(
                        width: 200,
                        child: RichText(
                            text:TextSpan(
                              text: this.task.description ??"No Description Added",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFF86829D),
                                height: 1.5,
                              ),
                            )
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'User: ' + "Unknow 1",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF211551),
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],

                  ),
                ),
              ]
          ),
        ),
      )
  );



  void downloadTodo(BuildContext context,Task task) {
    // this._dbHelper.insertTask(Task(title:task.title,description: ));
    this.myVoidCallback();

    Utils.showSnackBar(context, 'Downloaded the task');
  }

  void shareTodo(BuildContext context,int id ){
    //
  }
}