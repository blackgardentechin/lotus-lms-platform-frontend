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

  const AuthState({
    required this.status,
    this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading);
  }

  factory AuthState.authenticated() {
    return const AuthState(status: AuthStatus.authenticated);
  }

  factory AuthState.signupSuccess() {
    return const AuthState(status: AuthStatus.signupSuccess);
  }

  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: message,
    );
  }
}