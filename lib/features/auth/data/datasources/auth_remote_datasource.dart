class AuthRemoteDataSource {
  Future<void> exchangeCodeForToken({
    required String authorizationCode,
    String? username,
  }) async {
    // TODO: call backend API
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // TODO: backend login
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}