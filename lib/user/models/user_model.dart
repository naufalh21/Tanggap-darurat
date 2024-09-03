class User {
  String idUser;
  String username;
  String email;
  String level;
  String foto;

  User({
    required this.idUser,
    required this.username,
    required this.email,
    required this.level,
    required this.foto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user'],
      username: json['username'],
      email: json['email'],
      level: json['level'],
      foto: json['foto'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'username': username,
      'email': email,
      'level': level,
      'foto': foto,
    };
  }
}
