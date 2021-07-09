import 'dart:convert';

import 'package:guideme/models/todo.dart';

class Item {
  final int id;
  final String title;
  final String description;
  final String dateExpired;
  final List<Todo> todos;
  Item({this.id, this.title, this.description, this.dateExpired, this.todos});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateExpired': dateExpired,
      'todos': jsonEncode(this.todos)
    };
  }
}