class User {
  final int id;
  final String username;
  final String email;
  final bool isAdmin;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}