class User{

  String name;
  String username;
  String role;

  User({
    required this.name,
    required this.username,
    required this.role,

   });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      username: json['username'],
      role : json['role']
    );
  }
}