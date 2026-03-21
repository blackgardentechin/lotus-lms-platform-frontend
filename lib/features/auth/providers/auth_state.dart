enum AuthStatus {
  initial,
  loading,
  authenticated,
  signupSuccess,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  // User data — populated after successful login
  final String? username;
  final String? email;
  final String? name;
  final String? tenantId;
  final String? role;

  const AuthState({
    required this.status,
    this.errorMessage,
    this.username,
    this.email,
    this.name,
    this.tenantId,
    this.role,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated({
    required String username,
    required String email,
    required String tenantId,
    required String role,
    String? name,
  }) {
    return AuthState(
      status: AuthStatus.authenticated,
      username: username,
      email: email,
      name: name,
      tenantId: tenantId,
      role: role,
    );
  }

  factory AuthState.signupSuccess() =>
      const AuthState(status: AuthStatus.signupSuccess);

  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
}