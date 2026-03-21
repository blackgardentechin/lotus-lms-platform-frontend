# Changelog

All notable changes to the Lotus LMS project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-01-01

### 🚀 Major Release: Flutter Migration

This is a complete rewrite of the Lotus LMS frontend using Flutter for multi-platform support.

### Added

#### Core Features
- ✨ **Multi-platform support**: Web, iOS, Android, Windows, macOS, Linux
- ✨ **Material Design 3** theme with custom branding
- ✨ **Clean Architecture** with separation of concerns
- ✨ **Type-safe code** with Dart
- ✨ **State management** with Riverpod
- ✨ **Declarative routing** with GoRouter

#### Authentication
- ✅ Email/Password authentication with AWS Cognito
- ✅ Google OAuth integration via Cognito Hosted UI
- ✅ JWT token management and secure storage
- ✅ Protected routes with navigation guards
- ✅ Multi-tenant user mapping
- ✅ Username persistence across sessions
- ✅ Comprehensive error handling

#### Course Management
- ✅ Course listing with tenant filtering
- ✅ Course detail pages
- ✅ Course enrollment system
- ✅ Free vs paid course differentiation
- ✅ Multi-tenant course filtering via `x-tenant-id` header

#### Payment Integration
- ✅ Razorpay checkout integration
- ✅ Order creation via backend API
- ✅ Transaction tracking and status updates
- ✅ Payment success/failure handling
- ✅ Transaction logging for failed/dismissed payments
- ✅ Free course enrollment (skip payment flow)

#### User Interface
- ✅ Modern Material Design 3 UI
- ✅ Custom color scheme matching brand identity
- ✅ Poppins font integration
- ✅ Responsive design for all screen sizes
- ✅ Loading states with indicators
- ✅ Error banners and user feedback
- ✅ Smooth page transitions

#### Developer Experience
- ✅ Code generation with `build_runner`
- ✅ Linting with `flutter_lints`
- ✅ Environment configuration with `.env`
- ✅ Comprehensive documentation
- ✅ Migration guide from React
- ✅ GitHub Actions CI/CD pipeline

### Changed

#### Architecture
- **Framework**: React → Flutter
- **Language**: JavaScript → Dart
- **State Management**: Context API → Riverpod
- **HTTP Client**: Axios → Dio
- **Routing**: React Router → GoRouter
- **Auth SDK**: amazon-cognito-identity-js → amazon_cognito_identity_dart_2
- **Payment SDK**: Razorpay JS → razorpay_flutter

#### Project Structure
- Reorganized into Clean Architecture layers
- Separated features into independent modules
- Created shared components library
- Implemented repository pattern
- Added domain entities and models

### Improved

- 🚀 **Performance**: Native compilation for better performance
- 📱 **Platform Support**: Now supports mobile and desktop platforms
- 🎨 **UI Consistency**: Pixel-perfect rendering across all platforms
- 🔒 **Type Safety**: Compile-time type checking with Dart
- 🧪 **Testability**: Better separation of concerns for easier testing
- 📦 **Code Reusability**: 100% code sharing across platforms
- 🔧 **Developer Tools**: Enhanced debugging and hot reload

### Deprecated

- React-based frontend (preserved in `backup/react-original` branch)
- JavaScript configuration files
- React-specific dependencies

### Removed

- Node.js dependencies (package.json)
- React components and pages
- JavaScript build configuration
- Create React App setup

### Fixed

- Enhanced error messages for auth failures
- Better handling of OAuth redirects
- Improved tenant mapping reliability
- More robust payment flow

### Security

- Secure token storage with `flutter_secure_storage`
- Enhanced JWT validation
- Better error handling to prevent information leakage
- Multi-tenant isolation improvements

### Documentation

- ✅ Comprehensive README with setup instructions
- ✅ Migration guide from React
- ✅ API integration documentation
- ✅ Rollback procedures
- ✅ Deployment guide

### Build & Deploy

- ✅ GitHub Actions workflow for Flutter CI/CD
- ✅ Automated web builds
- ✅ S3 deployment pipeline
- ✅ Android APK build support

## [1.0.0] - 2023-12-01

### Initial React Release

- Initial release with React frontend
- AWS Cognito authentication
- Basic course management
- Razorpay payment integration
- Dashboard and user management

---

## Migration Notes

### For Developers

If you need to reference the old React code:
- Check out branch: `backup/react-original`
- Or use git tag: `v1.0.0-react-stable`

### For Users

This update brings:
- Faster performance
- Support for mobile apps (coming soon)
- Better user experience
- More reliable authentication

All existing functionality is preserved and improved.

---

[2.0.0]: https://github.com/gitsaravanesh/lotus-lms-frontend/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/gitsaravanesh/lotus-lms-frontend/releases/tag/v1.0.0
