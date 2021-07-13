import 'dart:convert';

import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/models/item.dart';
import 'package:guideme/models/todo.dart';
import 'package:guideme/models/user.dart';
import 'package:guideme/utils/database_helper.dart';
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
    int idSever = 0;
    DatabaseHelper _db = DatabaseHelper();
    await _db.getPublicTaskId(id).then((int value) => idSever = value??0);
    final response = await http.post(
      Uri.parse('https://guideme-service.herokuapp.com/api/todo/$idSever/public-todo-list'),
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
      if(idSever == 0){
        return 'Todo not exist in remote db, please sync your data';
      }
      return json['error']??"Error";

    }
  }

  static Future<List<Item>> searchPublicTodo(String keyword) async {
    String token = await UserPrederences.getToken();
    String tokenType = await UserPrederences.getTokenType();
    final response = await http.get(
      Uri.parse('https://guideme-service.herokuapp.com/api/public-todo-list?keyWord=$keyword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$tokenType $token',
        'Accept': 'application/json; charset=UTF-8'
      },
    );

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      if(json['todo-lists']!=null) {
        return List.generate(json['todo-lists'].length, (index) {
          return Item(
              id: json['todo-lists'][index]['localId'],
              updateAt: json['todo-lists'][index]['updateAt'],
              createAt: json['todo-lists'][index]['createAt'],
              dateExpired: json['todo-lists'][index]['expired'],
              idServer: json['todo-lists'][index]['publicId'],
              description: json['todo-lists'][index]['objective'],
              createBy: json['todo-lists'][index]['createBy'],
              status: json['todo-lists'][index]['status'] == "TODO" ? 1 : 0,
              title: json['todo-lists'][index]['title'],
              // todos: List<Todo>.from(json['todo-lists'][index]['cards'].where((Map<String, dynamic> x) => Todo.fromJson(x))),
              todos: List.generate(
                  json['todo-lists'][index]['cards'].length, (i) {
                return Todo.fromJson(json['todo-lists'][index]['cards'][i]);
              })
          );
        });
      }
      // return null;
    }else if(response.statusCode == 500){
      print("search that bai");

    }
  }
  static Future<List<Item>> syncData(List<Item> data) async {
    String token = await UserPrederences.getToken();
    String tokenType = await UserPrederences.getTokenType();
    final response = await http.post(
      Uri.parse('https://guideme-service.herokuapp.com/api/user/sync'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$tokenType $token',
        'Accept': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        "todo-lists": data??[],
      }),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      if(json['todo-lists']!=null) {
        return List.generate(json['todo-lists'].length, (index) {
          return Item(
              id: json['todo-lists'][index]['localId'],
              updateAt: json['todo-lists'][index]['updateAt'],
              createAt: json['todo-lists'][index]['createAt'],
              dateExpired: json['todo-lists'][index]['expired'],
              idServer: json['todo-lists'][index]['publicId'],
              description: json['todo-lists'][index]['objective'],
              createBy: json['todo-lists'][index]['createBy'],
              status: json['todo-lists'][index]['status'] == "TODO" ? 1 : 0,
              title: json['todo-lists'][index]['title'],
              // todos: List<Todo>.from(json['todo-lists'][index]['cards'].where((Map<String, dynamic> x) => Todo.fromJson(x))),
              todos: List.generate(
                  json['todo-lists'][index]['cards'].length, (i) {
                return Todo.fromJson(json['todo-lists'][index]['cards'][i]);
              })
          );
        });
      }
      // return null;
    }else if(response.statusCode == 500){
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json['error']);
    }
  }
}