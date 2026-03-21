import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lotus_lms/core/config/cognito_config.dart';

void main() {
  group('CognitoConfig Environment Variable Tests', () {
    setUp(() {
      // Reset dotenv before each test
      dotenv.testLoad(fileInput: '');
    });

    test('should expose correct default Cognito identifiers', () {
      expect(CognitoConfig.userPoolId, 'ap-south-1_kaEBPbIxW');
      expect(
        CognitoConfig.clientId,
        '78cfqtlh63cj8q8eht4hka7om7',
      );
    });

    test('should expose correct region using dotenv fallback', () {
      dotenv.testLoad(fileInput: '''
AWS_REGION=ap-south-1
''');

      expect(CognitoConfig.region, 'ap-south-1');
    });

    test('should expose correct redirect and signout URIs', () {
      dotenv.testLoad(fileInput: '''
REDIRECT_URI=https://flutter.test.example.com/
SIGNOUT_URL=https://flutter.test.example.com/logout
''');

      expect(
        CognitoConfig.redirectUri,
        'https://flutter.test.example.com/',
      );
      expect(
        CognitoConfig.signoutUri,
        'https://flutter.test.example.com/logout',
      );
    });

    test('should strip https:// protocol from cognitoDomain', () {
      dotenv.testLoad(fileInput: '''
COGNITO_DOMAIN=https://test.domain.com
''');

      expect(CognitoConfig.cognitoDomain, 'test.domain.com');
    });

    test('should strip http:// protocol from cognitoDomain', () {
      dotenv.testLoad(fileInput: '''
COGNITO_DOMAIN=http://test.domain.com
''');

      expect(CognitoConfig.cognitoDomain, 'test.domain.com');
    });

    test('should fallback to default cognito domain when not set', () {
      expect(
        CognitoConfig.cognitoDomain,
        'lms-auth-dev-sarav.auth.ap-south-1.amazoncognito.com',
      );
    });

    test('should have correct scopes', () {
      expect(
        CognitoConfig.scopes,
        ['email', 'openid', 'profile'],
      );
    });

    test('should have correct Google provider', () {
      expect(CognitoConfig.googleProvider, 'Google');
    });
  });
}