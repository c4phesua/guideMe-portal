import 'package:flutter/material.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/models/task.dart';
import 'package:guideme/models/todo.dart';
import 'package:guideme/utils/utils.dart';
import 'package:guideme/widgets/to_do.dart';
import 'package:guideme/widgets/datetime_picker.dart';

class Taskpage extends StatefulWidget {
  final Task task;

  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";
  DateTime _dateExpired;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;


  @override
  void initState() {
    if (widget.task != null) {
      // Set visibility to true
      _contentVisile = true;

      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
      _dateExpired = DateTime.now();
      //_dateExpired = widget.task.dateExpired; update when change db local
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
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
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              // Check if the field is not empty
                              if (value != "") {
                                // Check if the task is null
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisile = true;
                                    _taskTitle = value;
                                  });
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId, value);
                                  print("Task Updated");
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Enter Task Title",
                              border: InputBorder.none,
                            ),
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
                  Visibility(
                    visible: _contentVisile,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskDescription(
                                  _taskId, value);
                              _taskDescription = value;
                            }
                          }
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: "Enter Description for the task...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisile,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: DatetimePickerWidget(date:_dateExpired), //fix pass
                    ),
                  ),
                  Visibility(
                    visible: _contentVisile,
                    child: FutureBuilder(
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
                                        GestureDetector(
                                            onTap: () async {
                                              if (snapshot.data[index].isDone == 0) {
                                                await _dbHelper.updateTodoDone(
                                                    snapshot.data[index].id, 1);
                                              } else {
                                                await _dbHelper.updateTodoDone(
                                                    snapshot.data[index].id, 0);
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 30.0,
                                              height: 30.0,
                                              margin: EdgeInsets.only(
                                                right: 12.0,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: snapshot.data[index].isDone == 1 ? Color(0xFF7349FE) : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(6.0),
                                                  border: snapshot.data[index].isDone == 1 ? null : Border.all(
                                                      color: Color(0xFF86829D),
                                                      width: 1.5
                                                  )
                                              ),
                                              child: Image(
                                                image: AssetImage('assets/images/check_icon.png'),
                                              ),
                                            )
                                        ),
                                        Flexible(
                                          // child: Text(
                                          //   snapshot.data[index].title ?? "(Unnamed Todo)",
                                          //   style: TextStyle(
                                          //     color: snapshot.data[index].isDone == 1 ? Color(0xFF211551) : Color(0xFF86829D),
                                          //     fontSize: 16.0,
                                          //     fontWeight: snapshot.data[index].isDone == 1 ? FontWeight.bold : FontWeight.w500,
                                          //   )
                                          // ),
                                          child: TextField(
                                            controller: TextEditingController()..text = snapshot.data[index].title ?? "(Unnamed Todo)",
                                            onSubmitted: (value) async {
                                              // Check if the field is not empty
                                              if (value != "") {
                                                if (snapshot.data[index].id != 0) {
                                                  await _dbHelper.updateTodoTitle(snapshot.data[index].id,value);
                                                  setState(() {});
                                                } else {
                                                  print("Task doesn't exist");
                                                }
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Enter Todo item...",
                                              border: InputBorder.none,
                                            ),
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
                  ),
                  Visibility(
                    visible: _contentVisile,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
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
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Color(0xFF86829D), width: 1.5)),
                            child: Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                // Check if the field is not empty
                                if (value != "") {
                                  if (_taskId != 0) {
                                    // DatabaseHelper _dbHelper = DatabaseHelper();
                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                  } else {
                                    print("Task doesn't exist");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Todo item...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisile,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image(
                        image: AssetImage(
                          "assets/images/delete_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
