import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Example Unit Tests', () {
    test('String manipulation example', () {
      // Arrange
      const input = 'Lotus LMS';
      
      // Act
      final result = input.toLowerCase();
      
      // Assert
      expect(result, 'lotus lms');
      expect(result.length, 9);
    });

    test('List operations example', () {
      // Arrange
      final numbers = [1, 2, 3, 4, 5];
      
      // Act
      final sum = numbers.reduce((a, b) => a + b);
      final doubled = numbers.map((n) => n * 2).toList();
      
      // Assert
      expect(sum, 15);
      expect(doubled, [2, 4, 6, 8, 10]);
    });

    test('Math operations example', () {
      // Arrange
      const a = 10;
      const b = 5;
      
      // Act & Assert
      expect(a + b, 15);
      expect(a - b, 5);
      expect(a * b, 50);
      expect(a / b, 2);
    });
  });

  group('Boolean Logic Tests', () {
    test('Conditional logic example', () {
      // Arrange
      const isLoggedIn = true;
      const hasPermission = true;
      
      // Act
      const canAccess = isLoggedIn && hasPermission;
      
      // Assert
      expect(canAccess, true);
    });

    test('Null safety example', () {
      // Arrange
      String? nullableString;
      
      // Act
      final result = nullableString ?? 'default value';
      
      // Assert
      expect(result, 'default value');
      expect(nullableString, isNull);
    });
  });
}
