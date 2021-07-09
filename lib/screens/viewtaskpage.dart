import 'package:flutter/material.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/models/task.dart';
import 'package:guideme/models/todo.dart';
import 'package:guideme/utils/utils.dart';
import 'package:guideme/widgets/to_do.dart';
import 'package:guideme/widgets/datetime_picker.dart';

class ViewTaskpage extends StatefulWidget {
  final Task task;

  ViewTaskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<ViewTaskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();


  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";
  DateTime _dateExpired = DateTime.now().add(Duration(days: 15));


  bool _contentVisile = false;


  @override
  void initState() {
    if (widget.task != null) {
      // Set visibility to true
      _contentVisile = true;

      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
      _dateExpired = widget.task.dateExpired==null?_dateExpired:DateTime.parse(widget.task.dateExpired);

    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _taskTitle ?? "(Unnamed Task)",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Text(
                      _taskDescription ?? "No Description Added",
                    ),
                  ),
                  FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                key: Key(UniqueKey().toString()),
                                background: Container(
                                  alignment: AlignmentDirectional.centerEnd,
                                  color: Colors.red,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                    child: Icon(Icons.delete,
                                      color: Colors.white,

                                    ),
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  await _dbHelper.deleteTodo(snapshot.data[index].id);
                                  setState(() {
                                  });
                                  Utils.showSnackBar(context, 'Deleted the todo');
                                },
                                // child: GestureDetector(
                                // onTap: () async {
                                //   if (snapshot.data[index].isDone == 0) {
                                //     await _dbHelper.updateTodoDone(
                                //         snapshot.data[index].id, 1);
                                //   } else {
                                //     await _dbHelper.updateTodoDone(
                                //         snapshot.data[index].id, 0);
                                //   }
                                //   setState(() {});
                                // },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        margin: EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        decoration: BoxDecoration(
                                            // color: snapshot.data[index].isDone == 1 ? Color(0xFF7349FE) : Colors.transparent,
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(6.0),
                                            // border: snapshot.data[index].isDone == 1 ? null : Border.all(
                                            //     color: Color(0xFF86829D),
                                            //     width: 1.5
                                            // )
                                            border: Border.all(
                                                color: Color(0xFF86829D),
                                                width: 1.5
                                            )
                                        ),
                                        child: Image(
                                          image: AssetImage('assets/images/check_icon.png'),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          snapshot.data[index].title ?? "(Unnamed Todo)",
                                          style: TextStyle(
                                            // color: snapshot.data[index].isDone == 1 ? Color(0xFF211551) : Color(0xFF86829D),
                                            color: Color(0xFF86829D),
                                            fontSize: 16.0,
                                            // fontWeight: snapshot.data[index].isDone == 1 ? FontWeight.bold : FontWeight.w500,
                                            fontWeight: FontWeight.bold,
                                          )
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                // )
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskId != 0) {
                      // download todo list save to database
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Icon(
                      Icons.download,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
