class AppUser {
  final String name;
  final String email;
  final String? password;
  final String role;

  AppUser({
    required this.name,
    required this.email,
    required this.role,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'],
      email: map['email'],
      role: map['role'],
    );
  }
}