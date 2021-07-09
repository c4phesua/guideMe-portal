class Todo {
  final int id;
  final int taskId;
  final String title;
  final int isDone;
  final int status;
  final int idServer;
  Todo({this.id, this.taskId, this.title, this.isDone, this.status, this.idServer});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
      'status':status == null?1:status,
      'idServer':idServer == null?-1:idServer,
    };
  }
}