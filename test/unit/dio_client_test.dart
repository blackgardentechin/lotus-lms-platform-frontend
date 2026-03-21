import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lotus_lms/core/api/dio_client.dart';

void main() {
  group('DioClient Environment Variable Tests', () {
    setUp(() {
      // Reset DioClient and dotenv before each test
      DioClient.reset();
      dotenv.testLoad(fileInput: '');
    });

    tearDown(() {
      DioClient.reset();
    });

    test('should use Flutter-style API_BASE_URL when available', () {
      // Arrange
      dotenv.testLoad(fileInput: '''
API_BASE_URL=https://flutter.api.test.com
''');

      // Act
      final dio = DioClient.instance;

      // Assert
      expect(dio.options.baseUrl, 'https://flutter.api.test.com');
    });

    test('should fallback to React-style API_BASE_URL when Flutter variable not set', () {
      // Arrange
      dotenv.testLoad(fileInput: '''
REACT_APP_API_BASE_URL=https://react.api.test.com
''');

      // Act
      final dio = DioClient.instance;

      // Assert
      expect(dio.options.baseUrl, 'https://react.api.test.com');
    });

    test('should use default API URL when no environment variables set', () {
      // Arrange
      dotenv.testLoad(fileInput: '');

      // Act
      final dio = DioClient.instance;

      // Assert
      expect(dio.options.baseUrl, 'https://api.example.com');
    });

    test('should prefer Flutter variable over React variable when both are set', () {
      // Arrange
      dotenv.testLoad(fileInput: '''
API_BASE_URL=https://flutter.api.test.com
REACT_APP_API_BASE_URL=https://react.api.test.com
''');

      // Act
      final dio = DioClient.instance;

      // Assert
      expect(dio.options.baseUrl, 'https://flutter.api.test.com');
    });
  });
}
