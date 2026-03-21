import '../datasources/auth_remote_datasource.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) {
    return remote.signIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> exchangeCodeForToken({
    required String authorizationCode,
    String? username,
  }) {
    return remote.exchangeCodeForToken(
      authorizationCode: authorizationCode,
      username: username,
    );
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }
}