import '../entities/user.dart';

/// Auth Repository Interface
abstract class AuthRepository {
  /// Sign up with email and password
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    String? topic,
  });
  
  /// Sign in with email/username and password
  Future<User> signIn({
    required String identifier,
    required String password,
  });
  
  /// Exchange authorization code for tokens (OAuth)
  Future<User> exchangeCodeForToken(String code, String? pendingUsername);
  
  /// Get current user session
  Future<User?> getCurrentUser();
  
  /// Sign out
  Future<void> signOut();
  
  /// Get hosted UI URL for Google OAuth
  String getGoogleOAuthUrl();
  
  /// Get logout URL
  String getLogoutUrl();
}
