class AuthState {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  final String? errorMessage;

  AuthState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.role = 'technician',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.errorMessage,
  });

  AuthState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? role,
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? errorMessage,
  }) {
    return AuthState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      errorMessage: errorMessage,
    );
  }
}