import 'dart:convert';

import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/models/user.dart';
import 'package:http/http.dart' as http;

class ApiHandler {

  static Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://guideme-service.herokuapp.com/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      await UserPrederences.setToken(json['accessToken']);
      await UserPrederences.setTokenType(json['tokenType']);
      await UserPrederences.setIsLogin(true);
    }else{
      print("login that bai");
      //login that bai

    }
  }

  

  static Future<User> getUserInfo() async {
    String token = await UserPrederences.getToken();
    String tokenType = await UserPrederences.getTokenType();
    final response = await http.get(
      Uri.parse('https://guideme-service.herokuapp.com/api/user'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$tokenType $token',
        'Accept': 'application/json; charset=UTF-8'
      },
    );

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      return User.fromJson(json);
    }else if(response.statusCode == 500){
      print("get user info that bai");

    }
  }
}