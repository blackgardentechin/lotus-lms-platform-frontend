abstract class AuthRepository {
  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> exchangeCodeForToken({
    required String authorizationCode,
    String? username,
  });

  Future<void> logout();
}