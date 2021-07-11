import 'dart:convert';

import 'package:guideme/models/item.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';
import '../models/todo.dart';

class DatabaseHelper {

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, "
            "title TEXT, description TEXT,dateExpired TEXT ,"
            "status INTEGER DEFAULT 1,idServer INTEGER,"
            "createBy INTEGER, updateAt TEXT,createAt TEXT "
            ")");
        await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, "
            "title TEXT, isDone INTEGER, status INTEGER DEFAULT 1, idServer INTEGER, "
            "updateAt TEXT,createAt TEXT , taskIdServer INTEGER)");

        return db;
      },
      // onUpgrade: (db, oldVersion, version) async {
      //   await db.execute("ALTER TABLE tasks ADD COLUMN dateExpired TEXT");
      //   await db.execute("ALTER TABLE tasks ADD COLUMN status INTEGER DEFAULT 1");
      //   await db.execute("ALTER TABLE tasks ADD COLUMN dateExpired TEXT");
      //   await db.execute("ALTER TABLE todo ADD COLUMN status INTEGER DEFAULT 1");
      // },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      taskId = value;
    });
    return taskId;
  }
  
  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    String updateAt = DateTime.now().toString();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' and updateAt = '$updateAt' WHERE id = '$id'");
  }
  Future<void> updateTaskExpiredDate(int id, DateTime date) async {
    Database _db = await database();
    String value = date.toString();
    String updateAt = DateTime.now().toString();
    await _db.rawUpdate("UPDATE tasks SET dateExpired = '$value' and updateAt = '$updateAt' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    String updateAt = DateTime.now().toString();
    await _db.rawUpdate("UPDATE tasks SET description = '$description' and updateAt = '$updateAt' WHERE id = '$id'");
  }

  Future<void> updateIdTaskServer(int id, int idServer) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET idServer = '$idServer' WHERE id = '$id'");
  }

  Future<void> updateIdTodoServer(int id, int idServer) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET idServer = '$idServer' WHERE id = '$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> insertTodos(List<Todo> todos) async {
    Database _db = await database();
    Batch batch = _db.batch();
    for(int i = 0;i<todos.length;i++) {
      await batch.insert('todo', todos[i].toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<int> getLastTaskId() async {
    Database _db = await database();
    List<Map> result = await _db.rawQuery('Select id from tasks order by id DESC limit 1');
    return result.length == 0?0:result[0]['id'];
  }


  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map> taskMap = await _db.rawQuery('Select * from tasks where status = 1');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          dateExpired: taskMap[index]['dateExpired'],
          status: taskMap[index]['status'],
          idServer: taskMap[index]['idServer'],
          updateAt: taskMap[index]['updateAt'],
          createAt: taskMap[index]['createAt'],
          createBy: taskMap[index]['createBy'],
        );

    });
  }

  Future<List<Task>> getAllTasks() async {
    Database _db = await database();
    List<Map> taskMap = await _db.rawQuery('Select * from tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
        dateExpired: taskMap[index]['dateExpired'],
        status: taskMap[index]['status'],
        idServer: taskMap[index]['idServer'],
        updateAt: taskMap[index]['updateAt'],
        createAt: taskMap[index]['createAt'],
        createBy: taskMap[index]['createBy'],
      );

    });
  }

  Future<List<Task>> getTasksWithKey(String key) async {
    Database _db = await database();
    List<Map> taskMap = await _db.rawQuery('Select * from tasks where title like ? and status = 1',["%"+key+"%"]);
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          dateExpired: taskMap[index]['dateExpired'],
          status: taskMap[index]['status'],
          idServer: taskMap[index]['idServer'],
        updateAt: taskMap[index]['updateAt'],
        createAt: taskMap[index]['createAt'],
        createBy: taskMap[index]['createBy'],
      );

    });
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId and status = 1");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          taskId: todoMap[index]['taskId'],
          isDone: todoMap[index]['isDone'],
          status: todoMap[index]['status'],
          idServer: todoMap[index]['idServer'],
        taskIdServer: todoMap[index]['taskIdServer'],
        updateAt: todoMap[index]['updateAt'],
        createAt: todoMap[index]['createAt'],
      );
    });
  }

  Future<List<Todo>> getAllTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        taskId: todoMap[index]['taskId'],
        isDone: todoMap[index]['isDone'],
        status: todoMap[index]['status'],
        idServer: todoMap[index]['idServer'],
        taskIdServer: todoMap[index]['taskIdServer'],
        updateAt: todoMap[index]['updateAt'],
        createAt: todoMap[index]['createAt'],
      );
    });
  }

  // Future<List<Item>> getAllItem() async {
  //   Database _db = await database();
  // }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    String updateAt = DateTime.now().toString();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone',updateAt = '$updateAt' WHERE id = '$id'");
  }

  Future<void> updateTodoTitle(int id, String title) async {
    Database _db = await database();
    String updateAt = DateTime.now().toString();
    await _db.rawUpdate("UPDATE todo SET title = '$title',updateAt = '$updateAt' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    String updateAt = DateTime.now().toString();
    await _db.rawUpdate("UPDATE tasks SET status = 0,updateAt = '$updateAt' WHERE id = '$id'");
    await _db.rawUpdate("UPDATE todo SET status = 0 ,updateAt = '$updateAt' WHERE taskId = '$id'");
  }

  Future<void> deleteTodo(int id) async {
    Database _db = await database();
    String updateAt = DateTime.now().toString();
    await _db.rawUpdate("UPDATE todo SET status = 0 ,updateAt = '$updateAt' WHERE id = '$id'");
  }

}