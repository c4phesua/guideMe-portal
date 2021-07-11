import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guideme/controllers/api_handler.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/utils/utils.dart';
import 'package:intl/intl.dart';

class TaskCardWidget extends StatelessWidget {
  DatabaseHelper _dbHelper = DatabaseHelper();
  final String title;
  final String desc;
  final int taskId;
  final String date;
  final VoidCallback myVoidCallback;

  TaskCardWidget({this.title, this.desc, this.taskId, this.date,this.myVoidCallback});


  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Slidable(
    actionPane: SlidableDrawerActionPane(),
    actions:[
      IconSlideAction(
        color: Colors.indigoAccent,
        caption: 'Share',
        onTap: () => shareTodo(context,taskId),
        icon: Icons.share
      )
    ],
    secondaryActions: [
    IconSlideAction(
    color: Colors.red,
    caption: 'Delete',
    onTap: () => deleteTodo(context,taskId),
    icon: Icons.delete,
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
                    title ?? "(Unnamed Task)",
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
                      text: desc ??"No Description Added",
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
                        Icon(Icons.timelapse),
                        Text(
                          DateFormat('MM/dd/yyyy').format(DateTime.parse(this.date)),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF211551),
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm').format(DateTime.parse(this.date)),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF211551),
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],

                  ),
                ),
            ]
            ),
          ),
    )
  );



   void deleteTodo(BuildContext context,int id) {
    this._dbHelper.deleteTask(id);
    this.myVoidCallback();

    Utils.showSnackBar(context, 'Deleted the task');
  }

  void shareTodo(BuildContext context,int id ) async{
     //
    String mess = '';
    await ApiHandler.publicTodo(id).then((String value) => mess = value);

      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Message'), 
          content: Text(mess),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context, 'Ok');
                  myVoidCallback();
                },
                child: Text('Ok'))
          ],
        ),);
    }

}