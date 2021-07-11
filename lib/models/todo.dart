class Todo {
  final int id;
  final int taskId;
  final String title;
  final int isDone;
  final int status;
  final int idServer;
  final String createAt;
  final String updateAt;
  final int taskIdServer;
  Todo({this.id, this.taskId, this.title, this.isDone, this.status, this.idServer, this.taskIdServer, this.updateAt,this.createAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
      'status':status == null?1:status,
      'idServer':idServer == null?-1:idServer,
      'taskIdServer':taskIdServer == null?-1:taskIdServer,
    };
  }

  Map<String, dynamic> toMap2() {
    return {
      'localId': id,
      'cardTitle': title,
      'status':isDone == 1?"COMPLETED":status==1?"TODO":"DELETE",
      'publicId':idServer == -1?null:idServer,
      'cardNumber':null,
      'createAt':createAt,
      'updateAt':updateAt,
      'todoListPublicId':taskIdServer == -1?null:taskIdServer,
      'todoListLocalId':taskId??null,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(
      id: json['localId'],
      title: json['cardTitle'],
      status: json['status'] == "DELETE"?0:1,
      idServer: json['publicId'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      isDone: json['status'] == "COMPLETED"?1:0,
      taskId: json['todoListLocalId'],
      taskIdServer: json['todoListPublicId'],
    );
  }
}