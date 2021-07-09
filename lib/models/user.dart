class User {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String expiryDate;
  final String avatar;
  User({this.id, this.username, this.firstname, this.lastname, this.email, this.expiryDate, this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'expiryDate': expiryDate,
      'avatar': avatar,
    };
  }
}