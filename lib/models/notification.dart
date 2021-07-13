class Notification {
  final int id;
  final int taskId;
  Notification({this.id, this.taskId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
    };
  }
}