class LocalNotification {
  final int id;
  final int taskId;
  LocalNotification({this.id, this.taskId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
    };
  }
}