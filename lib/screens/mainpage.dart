import 'package:flutter/material.dart';
import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/screens/Searchpage.dart';
import 'package:guideme/screens/homepage.dart';
import 'package:guideme/screens/loginpage.dart';
import 'package:guideme/screens/profilepage.dart';
import 'package:guideme/screens/taskpage.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 1;
  List<Widget> pageList = <Widget>[
    SearchPage(),
    Homepage(),
    ProfilePage(),
  ];
  bool isLogin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLogin = UserPrederences.isLogin() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: (value) async {
          isLogin = await UserPrederences.isLogin() ?? false;
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

