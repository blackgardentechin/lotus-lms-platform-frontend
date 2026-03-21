# React to Flutter Migration Guide

## 🎯 Overview

This document provides a comprehensive guide for the migration from React to Flutter for the Lotus LMS frontend application.

## 📋 Pre-Migration Checklist

### ✅ Backup Strategy

1. **Git Tag Created**: `v1.0.0-react-stable`
   ```bash
   git tag -a v1.0.0-react-stable -m "React stable version before Flutter migration"
   git push origin v1.0.0-react-stable
   ```

2. **Backup Branch Created**: `backup/react-original`
   ```bash
   git checkout -b backup/react-original
   git push origin backup/react-original
   ```

3. **React Code Preserved**: Original React files remain in the repository for reference

## 🔄 Migration Steps

### Step 1: Environment Setup

1. **Install Flutter SDK**
   - Follow instructions at: https://docs.flutter.dev/get-started/install
   - Verify installation: `flutter doctor`

2. **Clone Repository**
   ```bash
   git clone https://github.com/gitsaravanesh/lotus-lms-frontend.git
   cd lotus-lms-frontend
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure Environment Variables**
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

5. **Generate Code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Step 2: Feature Mapping

#### Authentication (React → Flutter)

| React Component | Flutter Equivalent | Status |
|----------------|-------------------|--------|
| `src/pages/Login.js` | `lib/features/auth/presentation/pages/login_page.dart` | ✅ |
| `src/pages/Signup.js` | `lib/features/auth/presentation/pages/signup_page.dart` | ✅ |
| `src/auth/AuthProvider.js` | `lib/features/auth/providers/auth_provider.dart` | ✅ |
| `src/auth/authService.js` | `lib/features/auth/data/datasources/` | ✅ |
| `amazon-cognito-identity-js` | `amazon_cognito_identity_dart_2` | ✅ |

#### Course Management (React → Flutter)

| React Component | Flutter Equivalent | Status |
|----------------|-------------------|--------|
| `src/pages/Dashboard.js` | `lib/features/courses/presentation/pages/dashboard_page.dart` | ✅ |
| Course API calls | `lib/features/courses/data/datasources/course_remote_datasource.dart` | ✅ |
| Course state | `lib/features/courses/providers/courses_provider.dart` | ✅ |

#### Payment Integration (React → Flutter)

| React Feature | Flutter Equivalent | Status |
|--------------|-------------------|--------|
| Razorpay checkout | `razorpay_flutter` package | ✅ |
| Transaction API | `lib/features/payment/data/datasources/transaction_remote_datasource.dart` | ✅ |
| Payment state | `lib/features/payment/providers/payment_provider.dart` | ✅ |

### Step 3: Architecture Changes

#### From React Context to Riverpod

**React (Context API)**:
```javascript
const { user, setUser } = useAuth();
```

**Flutter (Riverpod)**:
```dart
final authState = ref.watch(authProvider);
```

#### From Axios to Dio

**React (Axios)**:
```javascript
const response = await axios.get('/courses', {
  headers: { 'x-tenant-id': tenantId }
});
```

**Flutter (Dio)**:
```dart
final response = await _dio.get(
  '/courses',
  options: Options(
    headers: {'x-tenant-id': tenantId},
  ),
);
```

#### From React Router to GoRouter

**React Router**:
```javascript
<Route path="/dashboard" element={<Dashboard />} />
```

**Flutter GoRouter**:
```dart
GoRoute(
  path: '/dashboard',
  builder: (context, state) => const DashboardPage(),
)
```

### Step 4: Testing

1. **Unit Tests**
   ```bash
   flutter test
   ```

2. **Integration Tests**
   ```bash
   flutter test integration_test/
   ```

3. **Build Verification**
   ```bash
   flutter build web --release
   flutter build apk --release
   ```

### Step 5: Deployment

1. **Web Deployment**
   ```bash
   flutter build web --release
   # Deploy build/web/ to your hosting provider
   ```

2. **Mobile Deployment**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS (requires macOS and Xcode)
   flutter build ios --release
   ```

## 🔙 Rollback Procedures

### Quick Rollback (If Issues Found)

1. **Revert Merge Commit**
   ```bash
   git revert -m 1 <merge-commit-hash>
   git push origin main
   ```

2. **Restore from Backup Branch**
   ```bash
   git checkout backup/react-original
   git checkout -b main-restored
   git push origin main-restored --force
   ```

3. **Restore from Git Tag**
   ```bash
   git checkout v1.0.0-react-stable
   git checkout -b main-restored
   git push origin main-restored
   ```

### Gradual Rollback

1. **Run Both Versions in Parallel**
   - Deploy Flutter version to a different URL
   - Keep React version running on original URL
   - Gradually migrate users

2. **Feature Flags**
   - Use feature flags to toggle between implementations
   - Monitor metrics before full switch

## 📊 Comparison

### Benefits of Flutter

| Aspect | React | Flutter |
|--------|-------|---------|
| **Platforms** | Web only | Web, iOS, Android, Desktop |
| **Performance** | Good | Excellent (native compilation) |
| **Development** | JavaScript | Dart (type-safe) |
| **UI Consistency** | CSS-dependent | Pixel-perfect across platforms |
| **Code Sharing** | N/A | 100% code sharing |
| **Hot Reload** | ✅ | ✅ |
| **State Management** | Context/Redux | Riverpod (built-in) |

### Migration Effort

| Feature | Complexity | Time Estimate |
|---------|-----------|---------------|
| Authentication | Medium | 2-3 days |
| Course Management | Low | 1-2 days |
| Payment Integration | Medium | 2-3 days |
| UI/UX | Low | 1-2 days |
| Testing | Medium | 2-3 days |
| **Total** | - | **8-13 days** |

## 🚨 Known Issues & Solutions

### Issue 1: OAuth Redirect Handling

**Problem**: Web platform handles OAuth redirects differently

**Solution**: 
- Use `go_router` redirect handlers
- Parse URL parameters on app init
- Implemented in `lib/app/router/app_router.dart`

### Issue 2: Razorpay Web Integration

**Problem**: Razorpay needs JavaScript injection on web

**Solution**:
- Added Razorpay script to `web/index.html`
- Use `razorpay_flutter` package for mobile
- Platform-specific handling in payment datasource

### Issue 3: Environment Variables

**Problem**: Flutter doesn't support `.env` natively like React

**Solution**:
- Use `flutter_dotenv` package
- Load `.env` in `main.dart`
- Access with `dotenv.env['KEY']`

## 📝 Post-Migration Tasks

### Immediate (Week 1)

- [ ] Monitor error logs
- [ ] Track user authentication success rate
- [ ] Verify payment transactions
- [ ] Check multi-tenant isolation
- [ ] Performance monitoring

### Short-term (Month 1)

- [ ] Gather user feedback
- [ ] Optimize build size
- [ ] Improve loading times
- [ ] Add analytics
- [ ] Document common issues

### Long-term (Quarter 1)

- [ ] Launch mobile apps (iOS/Android)
- [ ] Desktop app releases
- [ ] Offline mode implementation
- [ ] Advanced features
- [ ] Scale testing

## 🔗 Resources

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Dio Documentation](https://pub.dev/packages/dio)

### Support
- GitHub Issues: [Project Issues](https://github.com/gitsaravanesh/lotus-lms-frontend/issues)
- Email: support@lotuslms.com
- Slack Channel: #flutter-migration

## ✅ Success Criteria

Migration is considered successful when:

1. ✅ All existing features work in Flutter
2. ✅ Authentication flow is functional (email + Google OAuth)
3. ✅ Course listing and enrollment work
4. ✅ Payment integration is functional
5. ✅ Multi-tenant isolation is maintained
6. ✅ Web build deploys successfully
7. ✅ Mobile apps build successfully
8. ✅ No critical bugs in production
9. ✅ Performance is equal or better than React
10. ✅ User satisfaction maintained or improved

## 📞 Contact

For questions or issues during migration:
- Technical Lead: [Email]
- DevOps Team: [Email]
- Support: support@lotuslms.com
