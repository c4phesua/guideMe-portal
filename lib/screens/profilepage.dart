import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/screens/loginpage.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogin = UserPrederences.isLogin()??false;
  }
  @override
  Widget build(BuildContext context) {
    return !isLogin?LoginPage():Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          // "add you image URL here "
                            "https://lh3.googleusercontent.com/a-/AOh14GiEGV9-O6Dbbo0czlE7ua8Yg_8f7gY0vmauioRc=s320-p-k-no-mo"),
                        fit: BoxFit.cover)),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment(0.0, 2.5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        // "Add you profile DP image URL here "
                          "https://lh3.googleusercontent.com/a-/AOh14GiEGV9-O6Dbbo0czlE7ua8Yg_8f7gY0vmauioRc=s320-p-k-no-mo"),
                      radius: 60.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "Fullname",
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
                "email",
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
                onPressed: null,
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
          ),
        ));
  }

  void logout() async {
    await UserPrederences.setToken("");
    await UserPrederences.setIsLogin(false);
    isLogin = await UserPrederences.isLogin()??false;
    setState(() {
    });
  }
}

