class Task {
  final int id;
  final String title;
  final String description;
  final String dateExpired;
  final int status;
  final int idServer;
  Task({this.id, this.title, this.description, this.dateExpired, this.status, this.idServer});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateExpired': dateExpired,
      'status':status == null?1:status,
      'idServer':idServer,
    };
  }
}