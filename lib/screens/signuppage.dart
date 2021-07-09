import 'package:flutter/material.dart';
import 'package:guideme/utils/database_helper.dart';
import 'package:guideme/widgets/rounder_button.dart';
import 'package:guideme/widgets/textfield_container.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  DatabaseHelper _dbHelper = DatabaseHelper();
  VoidCallback myVoidCallback() {
    setState(() {});
  }

  String _email = "";
  String _password = "";
  String _name = "";
  String _rePassword = "";
  FocusNode _emailFocus;
  FocusNode _passwordFocus;
  FocusNode _nameFocus;
  FocusNode _rePasswordFocus;

  bool showPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _nameFocus = FocusNode();
    _rePasswordFocus = FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _rePasswordFocus.dispose();
    _nameFocus.dispose();
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 6.0,
                                      ),
                                      child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/back_arrow_icon.png'),
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Register New Account",
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
                      _nameFocus.requestFocus();
                    }
                  },
                ),
              ),
              TextFieldContainerWidget(
                child: TextField(
                  focusNode: _nameFocus,
                  decoration: InputDecoration(
                      icon: Icon(
                          Icons.account_box,
                          color: Color(0xFF6F35A5)
                      ),
                      hintText: "Your fullname",
                      border: InputBorder.none
                  ),
                  onSubmitted: (value) {
                    _name = value;
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
                    _rePasswordFocus.requestFocus();
                  },
                  obscureText: !showPassword,
                ),
              ),
              TextFieldContainerWidget(
                child: TextField(
                  focusNode: _rePasswordFocus,
                  decoration: InputDecoration(
                    icon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF6F35A5)
                    ),
                    hintText: "RePassword",
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
                text: "SIGNUP",
                color: Colors.deepPurpleAccent[100],
                textColor: Colors.black,
                press: (){signup();},
              ),
            ],
          ),
        ),
      ),
    );
  }
  void signup(){
    print("signup with email " + _email +" and pass " + _password);
    // return true;
  }
}
