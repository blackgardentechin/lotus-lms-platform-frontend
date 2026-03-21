# Quick Start Guide - Flutter Migration

## 🚀 Getting Started in 5 Minutes

### Prerequisites
- [ ] Flutter SDK 3.0+ installed
- [ ] Git installed
- [ ] IDE (VS Code or Android Studio)

### Step 1: Clone & Setup (2 minutes)
```bash
# Clone the repository
git clone https://github.com/gitsaravanesh/lotus-lms-frontend.git
cd lotus-lms-frontend

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Configure Environment (1 minute)
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your credentials
# Minimum required:
# - API_BASE_URL
# - RAZORPAY_KEY_ID
# - AWS Cognito credentials
```

### Step 3: Run the App (2 minutes)
```bash
# Web (easiest to start with)
flutter run -d chrome

# Or Android (with emulator/device connected)
flutter run -d android

# Or iOS (macOS only, with simulator)
flutter run -d ios
```

That's it! The app should now be running. 🎉

---

## 🛠️ Common Commands

### Development
```bash
# Run app (auto-selects device)
flutter run

# Run with hot reload
flutter run --hot

# Run on specific device
flutter devices                 # List devices
flutter run -d chrome          # Run on Chrome
flutter run -d android         # Run on Android
```

### Build
```bash
# Web build
flutter build web --release

# Android APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release
```

### Code Generation
```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

---

## 📱 IDE Setup

### VS Code
1. Install "Flutter" extension
2. Install "Dart" extension
3. Press `F5` to run

### Android Studio
1. Install Flutter plugin
2. Click "Run" button
3. Select device

---

## 🔍 Project Structure Overview

```
lib/
├── main.dart               # App entry point - START HERE
├── app/
│   ├── app.dart           # Root widget
│   ├── router/            # Navigation
│   └── theme/             # Styling
├── features/              # Main features
│   ├── auth/             # Login/Signup
│   ├── courses/          # Courses
│   └── payment/          # Payments
├── core/                 # Utilities
└── shared/               # Reusable widgets
```

---

## 💡 Tips

### First Time?
1. Start by running on **Web** (easiest)
2. Then try **Android** (if you have Android Studio)
3. Finally **iOS** (requires macOS + Xcode)

### Hot Reload
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Debugging
1. Add breakpoints in your IDE
2. Run in debug mode (`F5` in VS Code)
3. Use Flutter DevTools

### Common Issues
- **"Flutter not found"**: Add Flutter to PATH
- **"No devices found"**: Start emulator or connect device
- **"Build failed"**: Run `flutter clean && flutter pub get`

---

## 📚 Learn More

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Riverpod Documentation](https://riverpod.dev/)

---

## 🆘 Need Help?

1. Check [README.md](README.md) - Full documentation
2. Check [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Detailed guide
3. Check [MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md) - Statistics
4. Open an issue on GitHub
5. Contact: support@lotuslms.com

---

**Happy Coding! 🎉**
