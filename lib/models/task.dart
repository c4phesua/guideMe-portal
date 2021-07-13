class Task {
  final int id;
  final String title;
  final String description;
  final String dateExpired;
  final String createAt;
  final String updateAt;
  final int createBy;
  final int status;
  final int idServer;
  Task({this.id, this.title, this.description, this.dateExpired, this.status, this.idServer, this.createAt, this.updateAt,this.createBy});

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
}