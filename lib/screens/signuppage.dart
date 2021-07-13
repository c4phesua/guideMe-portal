import 'package:flutter/material.dart';
import 'package:guideme/controllers/api_handler.dart';
import 'package:guideme/utils/utils.dart';
import 'package:guideme/widgets/rounder_button.dart';
import 'package:guideme/widgets/textfield_container.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {


  VoidCallback myVoidCallback() {
    setState(() {});
  }

  final emailController = TextEditingController();
  final fullnameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  String avatar = "https://static.toiimg.com/photo/msid-67586673/67586673.jpg?3918697";

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
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
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
                                      image: AssetImage(
                                          'assets/images/icon2.png'),
                                      width: size.width * 0.71,
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
                                                padding: const EdgeInsets.all(
                                                    10.0),
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
                  controller: emailController,
                  decoration: InputDecoration(
                      icon: Icon(
                          Icons.person,
                          color: Color(0xFF6F35A5)
                      ),
                      hintText: "Your email",
                      border: InputBorder.none
                  ),
                ),
              ),
              TextFieldContainerWidget(
                child: TextField(
                  focusNode: _nameFocus,
                  controller: fullnameController,
                  decoration: InputDecoration(
                      icon: Icon(
                          Icons.account_box,
                          color: Color(0xFF6F35A5)
                      ),
                      hintText: "Your fullname",
                      border: InputBorder.none
                  ),
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
                      onTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(
                          showPassword ? Icons.visibility_off : Icons.visibility
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                  obscureText: !showPassword,
                ),
              ),
              TextFieldContainerWidget(
                child: TextField(
                  focusNode: _rePasswordFocus,
                  controller: rePasswordController,
                  decoration: InputDecoration(
                    icon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF6F35A5)
                    ),
                    hintText: "RePassword",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(
                          showPassword ? Icons.visibility_off : Icons.visibility
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                  obscureText: !showPassword,
                ),
              ),

              RounderButtonWidget(
                text: "SIGNUP",
                color: Colors.deepPurpleAccent[100],
                textColor: Colors.black,
                press: () => signup(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void signup(BuildContext context) async {
    String mess = "";
    bool valid = true;
    String email = emailController.text.trim();
    String name = fullnameController.text.trim();
    String password = passwordController.text.trim();
    String rePass = rePasswordController.text.trim();
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
      valid = false;
      mess="Email error";
    }
    if(name.isEmpty && valid){
      valid = false;
      mess="Name error";
    }
    if(password.isEmpty&&valid){
      valid = false;
      mess="password error";
    }
    if(password != rePass&&valid){
      valid = false;
      mess="password doesn't match";
    }
    if(valid) {
      await ApiHandler.signup(
          fullnameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
          rePasswordController.text.trim(), avatar).then((String value) =>
      mess = value);
      // return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
    if (mess == "Register successfully") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
      Navigator.pop(context);
    }
  }


}
