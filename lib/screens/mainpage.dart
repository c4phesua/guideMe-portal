import 'package:flutter/material.dart';
import 'package:guideme/screens/homepage.dart';
import 'package:guideme/screens/taskpage.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 1;
  List<Widget> pageList = <Widget>[
    Homepage(),
    Homepage(),
    Homepage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: (value) {
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

