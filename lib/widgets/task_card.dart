import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/utils/utils.dart';

class TaskCardWidget extends StatelessWidget {
  DatabaseHelper _dbHelper = DatabaseHelper();
  final String title;
  final String desc;
  final int taskId;
  final VoidCallback myVoidCallback;

  TaskCardWidget({this.title, this.desc, this.taskId,this.myVoidCallback});


  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Slidable(
    actionPane: SlidableDrawerActionPane(),
    actions:[
      IconSlideAction(
        color: Colors.indigoAccent,
        caption: '',
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

            child: Column(
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
    )
  );



   void deleteTodo(BuildContext context,int id) {
    this._dbHelper.deleteTask(id);
    this.myVoidCallback();

    Utils.showSnackBar(context, 'Deleted the task');
  }

  void shareTodo(BuildContext context,int id ){
     //
}
}