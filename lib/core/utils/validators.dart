/// Input Validators
class Validators {
  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// ✅ Students username validation (LMS business username)
  static String? validateStudentsUsername(
    String? value, {
    int minLength = 3,
  }) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.trim().length < minLength) {
      return 'Username must be at least $minLength characters';
    }

    return null;
  }

  /// ⚠️ Backward compatibility (optional)
  /// Keep this if older code still calls validateUsername
  static String? validateUsername(
    String? value, {
    int minLength = 3,
  }) {
    return validateStudentsUsername(value, minLength: minLength);
  }

  /// Password validation
  static String? validatePassword(
    String? value, {
    int minLength = 8,
  }) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Confirm password validation
  static String? validateConfirmPassword(
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}