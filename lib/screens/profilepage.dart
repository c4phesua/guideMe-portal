import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guideme/controllers/api_handler.dart';
import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/models/item.dart';
import 'package:guideme/models/task.dart';
import 'package:guideme/models/todo.dart';
import 'package:guideme/models/user.dart';
import 'package:guideme/screens/loginpage.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/utils/utils.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isLogin=false;
  User user= User();

  @override
  void initState() {
    // TODO: implement initState

    init();
    super.initState();
  }

  void init() async {
    isLogin = UserPrederences.isLogin()?? false;
    setState(() {
      isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    return !isLogin?LoginPage():FutureBuilder<User>(
        future: ApiHandler.getUserInfo(),
        builder: (context,AsyncSnapshot<User> snapshot){
          return
            Scaffold(
        body: SafeArea(
          child:
          Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            // "add you image URL here "
                            snapshot.data != null?snapshot.data.avatar:"https://static.toiimg.com/photo/msid-67586673/67586673.jpg?3918697"),
                          fit: BoxFit.cover)),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: Container(
                      alignment: Alignment(0.0, 2.5),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          // "Add you profile DP image URL here "
                            snapshot.data != null?snapshot.data.avatar:"https://static.toiimg.com/photo/msid-67586673/67586673.jpg?3918697"),
                        radius: 60.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  snapshot.data != null?snapshot.data.fullName:"Full Name",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data != null?snapshot.data.email:"email",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    syncData();
                  },
                  child: const Text(
                    'Sync data',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    logout();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
        )
            );
        }
    );
  }

  void logout() async {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text('Do you want logout without sync your data?'),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Yes');
                await UserPrederences.setToken("");
                await UserPrederences.setIsLogin(false);
                isLogin = await UserPrederences.isLogin()??false;

                setState(() {

                });;
              },
              child: Text('Yes')),
          TextButton(
              onPressed: (){
                Navigator.pop(context, 'No');
                setState(() {

                });;
              },
              child: Text('No'))
        ],
      ),);


  }

  void syncData() async {
    // return showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Message'),
    //     content: Text('Do you want to sync?'),
    //     actions: [
    //       TextButton(
    //           onPressed: () async {
    //             Navigator.pop(context, 'Yes');
    //             DatabaseHelper _db = DatabaseHelper();
    //             List<Task> tasks;
    //             await _db.getAllTasks().then((List<Task> value) => tasks = value);
    //             List<Item> temp = new List<Item>();
    //             for(int i=0;i<tasks.length;i++) {
    //               temp.add(await createItems(tasks[i]).then((Item value) => value));
    //             }
    //             // print(jsonEncode(temp));
    //             await ApiHandler.syncData(temp??[]);
    //
    //             await _db.cleanDatabase();
    //             List<Item> data;
    //             await ApiHandler.syncData([]).then((List<Item> value) => data = value);
    //             await _db.syncDataAfterLogin(data??[]);
    //
    //             Utils.showSnackBar(context, "Successful");
    //             setState(() {
    //
    //             });
    //           },
    //           child: Text('Yes')),
    //       TextButton(
    //           onPressed: (){
    //             Navigator.pop(context, 'No');
    //             setState(() {
    //
    //             });
    //           },
    //           child: Text('No'))
    //     ],
    //   ),);
    DatabaseHelper _db = DatabaseHelper();
    List<Task> tasks;
    await _db.getAllTasks().then((List<Task> value) => tasks = value);
    List<Item> temp = new List<Item>();
    for(int i=0;i<tasks.length;i++) {
      temp.add(await createItems(tasks[i]).then((Item value) => value));
    }
    // print(jsonEncode(temp));
    await ApiHandler.syncData(temp??[]);

    await _db.cleanDatabase();
    List<Item> data;
    await ApiHandler.syncData([]).then((List<Item> value) => data = value);
    await _db.syncDataAfterLogin(data??[]);

    Utils.showSnackBar(context, "Successful");


  }

  Future<Item> createItems(Task task) async {
    DatabaseHelper _db = DatabaseHelper();
    List<Todo> todos;
    await _db.getAllTodo(task.id).then((List<Todo> value) => todos = value);
    return Item.fromTask(task.toMap(), todos);
  }
}

