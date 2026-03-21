import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../../../core/config/cognito_config.dart';
import 'auth_state.dart';

class AuthNotifier extends ChangeNotifier {
  AuthState _state = AuthState.initial();
  AuthState get state => _state;

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  // -----------------------------
  // SIGN UP – REAL COGNITO
  // -----------------------------
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    _setState(AuthState.loading());

    try {
      final userPool = CognitoUserPool(
        CognitoConfig.userPoolId,
        CognitoConfig.directAuthClientId,
      );

      final attributes = [
        AttributeArg(name: 'email', value: email),
      ];

      await userPool.signUp(
        email,
        password,
        userAttributes: attributes,
      );

      _setState(AuthState.signupSuccess());
    } catch (e) {
      _setState(AuthState.error(e.toString()));
    }
  }

  // -----------------------------
  // SIGN IN – PLACEHOLDER (NEXT STEP)
  // -----------------------------
  Future<void> signIn(String email, String password) async {
    _setState(AuthState.loading());

    try {
      final userPool = CognitoUserPool(
        CognitoConfig.userPoolId,
        CognitoConfig.directAuthClientId,
      );

      final cognitoUser = CognitoUser(email, userPool);
      final authDetails =
          AuthenticationDetails(username: email, password: password);

      await cognitoUser.authenticateUser(authDetails);

      _setState(AuthState.authenticated());
    } catch (e) {
      _setState(AuthState.error(e.toString()));
    }
  }

  // -----------------------------
  // GOOGLE OAUTH URL (STUB)
  // -----------------------------
  String getGoogleOAuthUrl() {
    return 'https://your-domain.auth.ap-south-1.amazoncognito.com/login'
        '?client_id=${CognitoConfig.oauthClientId}'
        '&response_type=code'
        '&scope=email+openid+profile'
        '&redirect_uri=https://your-redirect-uri';
  }

  void reset() {
    _setState(AuthState.initial());
  }
}