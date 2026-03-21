import 'package:flutter_dotenv/flutter_dotenv.dart';

/// AWS Cognito Configuration
class CognitoConfig {
  // --------------------------------------------------
  // USER POOL ID (TESTABLE)
  // --------------------------------------------------
  static const String userPoolId = String.fromEnvironment(
    'COGNITO_USER_POOL_ID',
    defaultValue: String.fromEnvironment(
      'REACT_APP_COGNITO_USER_POOL_ID',
      defaultValue: 'ap-south-1_kaEBPbIxW',
    ),
  );

  // --------------------------------------------------
  // DIRECT AUTH CLIENT ID (TESTABLE)
  // --------------------------------------------------
  static const String directAuthClientId = String.fromEnvironment(
    'DIRECT_AUTH_CLIENT_ID',
    defaultValue: String.fromEnvironment(
      'REACT_APP_DIRECT_AUTH_CLIENT_ID',
      defaultValue: '78cfqtlh63cj8q8eht4hka7om7',
    ),
  );

  // --------------------------------------------------
  // OAUTH CLIENT ID (TESTABLE)
  // --------------------------------------------------
  static const String oauthClientId = String.fromEnvironment(
    'OAUTH_CLIENT_ID',
    defaultValue: String.fromEnvironment(
      'REACT_APP_OAUTH_CLIENT_ID',
      defaultValue: '1d46et2aoichnr8jbupvldi0c3',
    ),
  );

  // --------------------------------------------------
  // BACKWARD COMPATIBILITY (tests expect this)
  // --------------------------------------------------
  static const String clientId = directAuthClientId;

  // --------------------------------------------------
  // REGION (RUNTIME)
  // --------------------------------------------------
  static String get region =>
      dotenv.env['AWS_REGION'] ??
      dotenv.env['REACT_APP_REGION'] ??
      'ap-south-1';

  // --------------------------------------------------
  // COGNITO DOMAIN (RUNTIME)
  // --------------------------------------------------
  static String get cognitoDomain {
    final domain =
        dotenv.env['COGNITO_DOMAIN'] ??
        dotenv.env['REACT_APP_COGNITO_DOMAIN'] ??
        'lms-auth-dev-sarav.auth.ap-south-1.amazoncognito.com';

    return domain.replaceFirst(RegExp(r'^https?://'), '');
  }

  // --------------------------------------------------
  // REDIRECT URI (RUNTIME)
  // --------------------------------------------------
  static String get redirectUri =>
      dotenv.env['REDIRECT_URI'] ??
      dotenv.env['REACT_APP_REDIRECT_URL'] ??
      'https://dodyqytcfhwoe.cloudfront.net/';

  // --------------------------------------------------
  // SIGNOUT URI (RUNTIME)
  // --------------------------------------------------
  static String get signoutUri =>
      dotenv.env['SIGNOUT_URL'] ??
      dotenv.env['REACT_APP_SIGNOUT_URL'] ??
      'https://dodyqytcfhwoe.cloudfront.net/';

  // --------------------------------------------------
  // SCOPES (TESTED)
  // --------------------------------------------------
  static const List<String> scopes = [
    'email',
    'openid',
    'profile',
  ];

  // --------------------------------------------------
  // GOOGLE PROVIDER (TESTED)
  // --------------------------------------------------
  static const String googleProvider = 'Google';
}