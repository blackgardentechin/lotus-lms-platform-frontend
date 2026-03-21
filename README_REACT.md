# Lotus LMS - Flutter Frontend

> Multi-platform Learning Management System built with Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)

## 🌟 Overview

Lotus LMS is a modern, cross-platform learning management system built with Flutter. It supports Web, iOS, Android, Windows, macOS, and Linux platforms from a single codebase.

### ✨ Features

- **Multi-Platform Support**: Web, iOS, Android, Desktop (Windows, macOS, Linux)
- **AWS Cognito Authentication**: Email/password and Google OAuth
- **Multi-Tenant Architecture**: Isolated course content per organization
- **Razorpay Integration**: Secure payment processing for course enrollment
- **Material Design 3**: Modern, beautiful UI with custom theming
- **State Management**: Riverpod for predictable state management
- **Offline Support**: Secure local storage with flutter_secure_storage

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- For iOS development: Xcode 14+
- For Android development: Android Studio
- For Web: Chrome browser

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/gitsaravanesh/lotus-lms-frontend.git
   cd lotus-lms-frontend
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   
   Copy `.env.example` to `.env` and update with your configuration:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your credentials:
   ```env
   AWS_REGION=ap-south-1
   USER_POOL_ID=your_user_pool_id
   CLIENT_ID=your_client_id
   COGNITO_DOMAIN=your-domain.auth.region.amazoncognito.com
   REDIRECT_URI=https://your-frontend-url
   API_BASE_URL=https://your-api-gateway-url
   RAZORPAY_KEY_ID=your_razorpay_key_id
   ```

4. **Generate code (for JSON serialization)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Running the Application

#### Web
```bash
flutter run -d chrome --dart-define-from-file=.env
```

#### Android
```bash
flutter run -d android --dart-define-from-file=.env
```

#### iOS (macOS required)
```bash
flutter run -d ios --dart-define-from-file=.env
```

#### Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### Building for Production

#### Web
```bash
flutter build web --release --dart-define-from-file=.env
```
Output: `build/web/`

#### Android APK
```bash
flutter build apk --release --dart-define-from-file=.env
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS (requires Apple Developer account)
```bash
flutter build ios --release --dart-define-from-file=.env
```

#### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📁 Project Structure

```
lib/
├── main.dart                    # Application entry point
├── app/
│   ├── app.dart                 # Root widget
│   ├── router/
│   │   └── app_router.dart      # GoRouter configuration
│   └── theme/
│       ├── app_theme.dart       # Material Design 3 theme
│       └── app_colors.dart      # Color scheme
├── features/
│   ├── auth/                    # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   └── providers/
│   ├── courses/                 # Courses feature
│   │   └── ... (similar structure)
│   └── payment/                 # Payment feature
│       └── ... (similar structure)
├── core/
│   ├── api/                     # API client setup
│   ├── config/                  # Configuration
│   ├── constants/               # App constants
│   └── utils/                   # Utility functions
└── shared/
    └── widgets/                 # Reusable widgets
```

## 🏗️ Architecture

This project follows **Clean Architecture** principles:

- **Presentation Layer**: UI components (Pages, Widgets)
- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources, models, and repositories

### State Management

- **Riverpod**: Used for dependency injection and state management
- **Freezed**: Immutable state classes with unions
- **GoRouter**: Declarative routing

## 🔑 Key Technologies

### Dependencies

- `flutter_riverpod`: State management
- `amazon_cognito_identity_dart_2`: AWS Cognito authentication
- `google_sign_in`: Google OAuth integration
- `dio`: HTTP client
- `razorpay_flutter`: Payment gateway integration
- `go_router`: Navigation and routing
- `flutter_dotenv`: Environment configuration
- `google_fonts`: Custom typography (Poppins)
- `shared_preferences` & `flutter_secure_storage`: Data persistence

## 🔐 Authentication

### Email/Password Login
- AWS Cognito User Pool authentication
- JWT token storage in secure storage
- Automatic session management

### Google OAuth
- Federated identity through AWS Cognito
- Hosted UI flow
- Token exchange and validation

### Multi-Tenant Support
- Automatic tenant mapping from backend API
- Tenant ID header injection for all API calls
- Username persistence across sessions

## 💳 Payment Integration

### Razorpay Checkout
- Order creation via backend API
- Secure payment processing
- Transaction status tracking
- Success/failure callbacks
- Free course enrollment (skip payment)

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 📝 Code Generation

The project uses code generation for:
- JSON serialization (`json_serializable`)
- Immutable state classes (`freezed`)
- API clients (`retrofit`)

Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Watch for changes:
```bash
flutter pub run build_runner watch
```

## 🎨 Theming

The app uses Material Design 3 with a custom color scheme:

- **Primary**: `#0077b6` (Blue)
- **Secondary**: `#0096c7` (Light Blue)
- **Success**: `#28a745` (Green)
- **Error**: `#ff5252` (Red)
- **Font**: Poppins (Google Fonts)

## 🔄 Migration from React

This Flutter version replaces the previous React implementation. Key improvements:

- **Multi-platform support** (not just web)
- **Better performance** with native compilation
- **Improved offline capabilities**
- **Type-safe code** with Dart
- **Cleaner architecture** with Clean Architecture pattern

### Rollback Instructions

If you need to revert to the React version:

```bash
# The React code is still available in the repository
# You can restore it from Git history if needed
git log --oneline  # Find the commit before Flutter migration
git checkout <commit-hash>
```

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support, please contact support@lotuslms.com or open an issue in the repository.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- AWS Cognito for authentication
- Razorpay for payment processing
- All contributors to the open-source packages used
