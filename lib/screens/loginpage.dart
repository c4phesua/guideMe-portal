import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guideme/controllers/api_handler.dart';
import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/models/item.dart';
import 'package:guideme/screens/profilepage.dart';
import 'package:guideme/screens/signuppage.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/utils/utils.dart';
import 'package:guideme/widgets/rounder_button.dart';
import 'package:guideme/widgets/textfield_container.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  VoidCallback myVoidCallback() {
    setState(() {});
  }

  FocusNode _emailFocus;
  FocusNode _passwordFocus;
  bool isLogin = false;

  bool showPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
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
  void dispose() {
    // TODO: implement dispose
    _emailFocus.dispose();
    _passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLogin?ProfilePage():Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                                      width: size.width*0.71,
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Color(0xFF211551),
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],

                  )
              ),
              TextFieldContainerWidget(
                child: TextField(
                  focusNode: _emailFocus,
                  controller: emailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color(0xFF6F35A5)
                    ),
                    hintText: "Your email",
                    border: InputBorder.none
                  ),
                  onSubmitted: (value) {
                    if(value != ""){
                      _passwordFocus.requestFocus();
                    }
                  },
                ),
              ),
              TextFieldContainerWidget(
                child: TextField(
                  focusNode: _passwordFocus,
                  controller: passwordController,
                  decoration: InputDecoration(
                    icon: Icon(
                        Icons.lock,
                        color: Color(0xFF6F35A5)
                    ),
                    hintText: "Password",
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(
                          showPassword?Icons.visibility_off:Icons.visibility
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                  obscureText: !showPassword,
                ),
              ),
              RounderButtonWidget(
                text: "LOGIN",
                press:() => login(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an Account ? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage()
                        ),
                      ).then(
                            (value) {
                          setState(() {});
                        },
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void login()  async {
    await ApiHandler.login(emailController.text.trim(), passwordController.text.trim());
    isLogin = await UserPrederences.isLogin()??false;
    if(isLogin) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Message'),
          content: Text('Do you want to sync your data?'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Yes');
                  DatabaseHelper _db = DatabaseHelper();
                  await _db.cleanDatabase();
                  List<Item> data;
                  await ApiHandler.syncData([]).then((List<Item> value) => data = value);
                  await _db.syncDataAfterLogin(data??[]);

                  setState(() {
                  });
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

    }else{
      Utils.showSnackBar(context, "Login Error");
    }
  }
}
