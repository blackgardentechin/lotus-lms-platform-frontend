import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CognitoConfig {
  static String get userPoolId => dotenv.env['AWS_COGNITO_USER_POOL_ID'] ?? '';
  static String get clientId => dotenv.env['AWS_COGNITO_CLIENT_ID'] ?? '';
  static String get clientSecret => dotenv.env['AWS_COGNITO_CLIENT_SECRET'] ?? '';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';

  static void loadConfig() {
    dotenv.load(fileName: ".env");
  }
  
  static bool isConfigured() {
    return userPoolId.isNotEmpty && clientId.isNotEmpty;
  }
}