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

  static Future<String> signup(String name,String email, String password,String rePassword,String avatar) async {
    final response = await http.post(
      Uri.parse('https://guideme-service.herokuapp.com/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "fullname": name,
        "email": email,
        "password": password,
        "rePassword": rePassword,
        "avatar": avatar
      }),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      return json["message"];
    }else{
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json['error']);
      return json['error']??"Error";

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

  static Future<String> publicTodo(int id) async {
    String token = await UserPrederences.getToken();
    String tokenType = await UserPrederences.getTokenType();
    final response = await http.post(
      Uri.parse('https://guideme-service.herokuapp.com/api/todo/$id/public-todo-list'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$tokenType $token',
      },
    );

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      return json["message"];
    }else{
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json['error']);
      return json['error']??"Error";

    }
  }
}