class Compte{

  String name;
  String username;
  String role;

  Compte({
    required this.name,
    required this.role,
    required this.username,
   });

  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
      name: json['name'], username: json['username'],
      role : json['role']
    );
  }

}