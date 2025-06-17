class AppUser {
  final String name;
  final String email;
  final String? password;

  AppUser({
    required this.name,
    required this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'],
      email: map['email'],
    );
  }
}