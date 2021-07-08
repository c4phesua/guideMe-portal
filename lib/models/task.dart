class Task {
  final int id;
  final String title;
  final String description;
  final String dateExpired;
  Task({this.id, this.title, this.description, this.dateExpired});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateExpired': dateExpired,
    };
  }
}