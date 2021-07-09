import 'package:flutter/material.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/widgets/rounder_button.dart';
import 'package:guideme/widgets/textfield_container.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  DatabaseHelper _dbHelper = DatabaseHelper();
  VoidCallback myVoidCallback() {
    setState(() {});
  }

  String _email = "";
  String _password = "";
  FocusNode _emailFocus;
  FocusNode _passwordFocus;

  bool showPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _emailFocus.requestFocus();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //     top: 10.0,
                          //     bottom: 6.0,
                          //   ),
                          //   child: Row(
                          //       children: [
                          //         InkWell(
                          //           onTap: () {
                          //             Navigator.pop(context);
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(10.0),
                          //             child: Image(
                          //               image: AssetImage(
                          //                   'assets/images/back_arrow_icon.png'),
                          //             ),
                          //           ),
                          //         ),
                          //       ]
                          //   ),
                          // ),
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
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color(0xFF6F35A5)
                    ),
                    hintText: "Your email",
                    border: InputBorder.none
                  ),
                  onSubmitted: (value) {
                    _email = value;
                    if(value != ""){
                      _passwordFocus.requestFocus();
                    }
                  },
                ),
              ),
              TextFieldContainerWidget(
                child: TextField(
                  focusNode: _passwordFocus,
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
                  onSubmitted: (value) {
                    _password = value;
                  },
                  obscureText: !showPassword,
                ),
              ),
              RounderButtonWidget(
                text: "LOGIN",
                press: (){
                  login();
                },
              ),
              RounderButtonWidget(
                text: "SIGNUP",
                color: Colors.deepPurpleAccent[100],
                textColor: Colors.black,
                press: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool login(){
    print("login with email " + _email +" and pass " + _password);
    return true;
  }
}
