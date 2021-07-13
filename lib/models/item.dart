import 'dart:convert';

import 'package:guideme/models/todo.dart';
import 'package:guideme/utils/database_helper.dart';

class Item {
  final int id;
  final String title;
  final String description;
  final String dateExpired;
  final String createAt;
  final String updateAt;
  final int createBy;
  final int status;
  final int idServer;
  final List<Todo> todos;
  Item({this.id, this.title, this.description, this.dateExpired, this.status, this.idServer, this.createAt, this.updateAt,this.createBy,this.todos});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateExpired': dateExpired,
      'status':status == null?1:status,
      'idServer':idServer == null?null:idServer,
      'createBy':createBy == null?null:createBy,
      'createAt':createAt,
      'updateAt':updateAt
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': id,
      'title': title,
      'objective': description,
      'expired': dateExpired,
      'status':status == 1?"TODO":"DELETE",
      'userId':null,
      'publicId':idServer == -1?null:idServer,
      'createBy':createBy == -1?null:createBy,
      'createAt':createAt,
      'updateAt':updateAt,
      "cards":List<dynamic>.from(todos.map((e) => e.toMap2()))
    };
  }


  factory Item.fromTask(Map<String, dynamic> json, List<Todo> temp) {
    // List<Todo> temp;
    // await getTodos(json['id'], temp);
    return Item(

        id: json['id'],
        title: json['title'],
        description: json['description'],
        dateExpired: json['dateExpired'],
        status:json['status'],
        idServer:json['idServer'],
        createBy:json['createBy'],
        createAt:json['createAt'],
        updateAt:json['updateAt'],
        todos: temp
    );
  }


}