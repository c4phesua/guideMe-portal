class User {
  final int id;
  final String fullName;
  final String email;
  final String expiryDate;
  final String avatar;
  User({this.id, this.fullName, this.email, this.expiryDate, this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'expiryDate':expiryDate,
      'avatar': avatar,
    };
  }
  factory User.fromJson(Map<String, dynamic> json){
    return User(

      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      avatar: json['avatar'],
      expiryDate: json['expiryDate']
    );
  }
}