class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String role;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        role: json['role'] ?? 'user',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };
}
