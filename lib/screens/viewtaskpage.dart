import 'package:flutter/material.dart';
import 'package:guideme/models/item.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/models/task.dart';
import 'package:guideme/models/todo.dart';
import 'package:guideme/utils/utils.dart';
import 'package:guideme/widgets/to_do.dart';
import 'package:guideme/widgets/datetime_picker.dart';

class ViewTaskpage extends StatefulWidget {
  final Item item;

  ViewTaskpage({@required this.item});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<ViewTaskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();



  @override
  void initState() {
    if (widget.item != null) {
      // Set visibility to true
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
                            widget.item.title ?? "(Unnamed Task)",
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
                      widget.item.description ?? "No Description Added",
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                            itemCount: widget.item.todos == null?0:widget.item.todos.length,
                            itemBuilder: (context, index) {
                              return Container(
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
                                            widget.item.todos[index].title ?? "(Unnamed Todo)",
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
                                );
                            },
                          ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                      // download todo list save to database
                    DatabaseHelper _dbHelper = DatabaseHelper();
                    Task task = Task(
                        title: widget.item.title,
                        description: widget.item.description,
                        createAt: DateTime.now().toString(),
                        updateAt: DateTime.now().toString(),
                        dateExpired: DateTime.now().add(Duration(days: 15)).toString()
                    );
                    await _dbHelper.insertTask(task);
                    int lastId = 0;
                    await _dbHelper.getLastTaskId().then((int value) => lastId = value);
                    // print('id'+lastId.toString());
                    List<Todo> todos = List();
                    for(int i=0;i<widget.item.todos.length;i++){
                      todos.add(Todo(
                          title: widget.item.todos[i].title,
                          isDone: 0,
                          taskId: lastId,
                          createAt:  DateTime.now().toString(),
                          updateAt: DateTime.now().toString()
                      ));
                    }
                    await _dbHelper.insertTodos(todos);

                    Navigator.pop(context);
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
