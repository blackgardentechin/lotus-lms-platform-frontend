import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/cognito_config.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/jwt_parser.dart';
import 'auth_state.dart';

// ---------------------------------------------------------------------------
// Riverpod provider
// ---------------------------------------------------------------------------
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// ---------------------------------------------------------------------------
// AuthNotifier
// ---------------------------------------------------------------------------
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial()) {
    _restoreSession();
  }

  // Restore session from storage on app launch
  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.idTokenKey);
    if (token == null) return;

    final payload = JwtParser.parseJwt(token);
    if (payload == null) return;

    final exp = payload['exp'];
    if (exp != null) {
      final expiry = DateTime.fromMillisecondsSinceEpoch((exp as int) * 1000);
      if (DateTime.now().isAfter(expiry)) {
        await _clearStorage();
        return;
      }
    }

    final username = JwtParser.getUsernameFromPayload(payload) ?? '';
    final email = JwtParser.getEmailFromPayload(payload) ?? '';
    final name = JwtParser.getNameFromPayload(payload);

    final tenantData = await _fetchTenantMapping(username);
    if (tenantData == null) return;

    state = AuthState.authenticated(
      username: username,
      email: email,
      name: name,
      tenantId: tenantData['tenant_id'] as String,
      role: tenantData['role'] as String,
    );
  }

  // Email / Password Sign In
  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    try {
      final userPool = CognitoUserPool(
        CognitoConfig.userPoolId,
        CognitoConfig.directAuthClientId,
      );
      final cognitoUser = CognitoUser(email, userPool);
      final authDetails =
          AuthenticationDetails(username: email, password: password);

      final session = await cognitoUser.authenticateUser(authDetails);
      if (session == null) throw Exception('Authentication failed');

      final idToken = session.idToken?.jwtToken;
      if (idToken == null) throw Exception('No ID token received');

      await _finalizeLogin(idToken);
    } catch (e) {
      state = AuthState.error(_friendlyError(e.toString()));
    }
  }

  // Sign Up
  Future<void> signUp({required String email, required String password}) async {
    state = AuthState.loading();
    try {
      final userPool = CognitoUserPool(
        CognitoConfig.userPoolId,
        CognitoConfig.directAuthClientId,
      );
      await userPool.signUp(
        email,
        password,
        userAttributes: [AttributeArg(name: 'email', value: email)],
      );
      state = AuthState.signupSuccess();
    } catch (e) {
      state = AuthState.error(_friendlyError(e.toString()));
    }
  }

  // Google OAuth — open Cognito Hosted UI
  Future<void> signInWithGoogle() async {
    final url = Uri.https(
      CognitoConfig.cognitoDomain,
      '/oauth2/authorize',
      {
        'client_id': CognitoConfig.oauthClientId,
        'response_type': 'code',
        'scope': 'email openid profile',
        'redirect_uri': CognitoConfig.redirectUri,
        'identity_provider': 'Google',
      },
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      state = AuthState.error('Could not open Google login page.');
    }
  }

  // Exchange OAuth code for tokens (called from AuthCallbackPage)
  Future<void> exchangeCodeForToken(String code) async {
    state = AuthState.loading();
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://${CognitoConfig.cognitoDomain}/oauth2/token',
        data: {
          'grant_type': 'authorization_code',
          'client_id': CognitoConfig.oauthClientId,
          'code': code,
          'redirect_uri': CognitoConfig.redirectUri,
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      final idToken = response.data['id_token'] as String?;
      if (idToken == null) throw Exception('No ID token in response');

      await _finalizeLogin(idToken);
    } catch (e) {
      state = AuthState.error(_friendlyError(e.toString()));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _clearStorage();
    state = AuthState.initial();
  }

  // Store token, parse JWT, fetch tenant, set authenticated state
  Future<void> _finalizeLogin(String idToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.idTokenKey, idToken);

    final payload = JwtParser.parseJwt(idToken);
    if (payload == null) throw Exception('Failed to parse ID token');

    final username = JwtParser.getUsernameFromPayload(payload) ?? '';
    final email = JwtParser.getEmailFromPayload(payload) ?? '';
    final name = JwtParser.getNameFromPayload(payload);

    final tenantData = await _fetchTenantMapping(username);
    if (tenantData == null) {
      throw Exception(
          'Account not assigned to any organization. Contact support.');
    }

    state = AuthState.authenticated(
      username: username,
      email: email,
      name: name,
      tenantId: tenantData['tenant_id'] as String,
      role: tenantData['role'] as String,
    );
  }

  // Call backend GET /user/tenant?user_id=...
  Future<Map<String, dynamic>?> _fetchTenantMapping(String userId) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.userTenantEndpoint}',
        queryParameters: {'user_id': userId},
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.idTokenKey);
    await prefs.remove(AppConstants.usernameKey);
  }

  String _friendlyError(String raw) {
    if (raw.contains('UserNotFoundException') ||
        raw.contains('NotAuthorizedException')) {
      return 'Incorrect email or password.';
    }
    if (raw.contains('UsernameExistsException')) {
      return 'An account with this email already exists.';
    }
    if (raw.contains('InvalidPasswordException')) {
      return 'Password must be at least 8 characters with uppercase, lowercase, and a number.';
    }
    if (raw.contains('UserNotConfirmedException')) {
      return 'Please confirm your email before signing in.';
    }
    return raw.replaceFirst('Exception: ', '');
  }

  void reset() => state = AuthState.initial();
}