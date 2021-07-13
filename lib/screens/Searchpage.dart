import 'package:flutter/material.dart';
import 'package:guideme/controllers/api_handler.dart';
import 'package:guideme/models/task.dart';
import 'package:guideme/screens/viewtaskpage.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/widgets/item_search.dart';
import 'package:guideme/widgets/no_glow_behaviour.dart';
import 'package:guideme/widgets/task_card.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  DatabaseHelper _dbHelper = DatabaseHelper();
  VoidCallback myVoidCallback() {
    setState(() {});
  }

  var keySearch = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              color: Color(0xFFFFFFFF),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 32.0,
                          bottom: 32.0,
                        ),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Row(

                              children: [
                                Image(
                                  image: AssetImage('assets/images/icon2.png'),
                                  height: 200,
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Public Todo list",
                                    style: TextStyle(
                                      color: Color(0xFF211551),
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin:EdgeInsets.symmetric(vertical: 20),
                                    alignment: Alignment.center,
                                    width: 320,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search public todo list..",
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF464A7E)
                                      ),
                                      suffixIcon: Icon(Icons.search),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 13)
                                    ),
                                    onSubmitted: (value) async {
                                        if(value!=""){
                                          keySearch = value;
                                        }
                                        myVoidCallback();
                                    },
                                  ),
                                ),
                              ],

                            ),

                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          initialData: [],
                          future: ApiHandler.searchPublicTodo(this.keySearch),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.done) {
                              return ScrollConfiguration(
                                behavior: NoGlowBehaviour(),
                                child: ListView.builder(
                                  itemCount: snapshot.data==null?0:snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewTaskpage(
                                              item: snapshot.data[index],
                                            ),
                                          ),
                                        ).then(
                                              (value) {
                                            setState(() {});
                                          },
                                        );
                                      },
                                      child: ItemCardWidget(
                                          task: Task(
                                              id: snapshot.data[index].id,
                                              title: snapshot.data[index].title,
                                              description: snapshot
                                                  .data[index].description,
                                              dateExpired: snapshot
                                                  .data[index].dateExpired),
                                          myVoidCallback: myVoidCallback),
                                    );
                                  },
                                ),
                              );
                          }else{
                              return Text('waiting...');
                            }
                        },
                        ),
                      )
                    ],
                  ),
                ],

              )
          ),
        ),
    );
  }
}
