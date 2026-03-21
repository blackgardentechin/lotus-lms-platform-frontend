import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/auth_callback_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/providers/auth_state.dart';
import '../../features/courses/presentation/pages/dashboard_page.dart';

// ---------------------------------------------------------------------------
// RouterNotifier — bridges Riverpod auth state into a GoRouter listenable.
// When auth state changes, GoRouter re-evaluates redirect rules.
// ---------------------------------------------------------------------------
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = _ref.read(authProvider);
    final isAuthenticated = auth.status == AuthStatus.authenticated;
    final loc = state.matchedLocation;

    // If an OAuth code is in the URL, send to callback handler
    final uri = Uri.base;
    final hasCode = uri.queryParameters.containsKey('code');
    if (hasCode && loc != '/auth/callback') {
      return '/auth/callback?code=${uri.queryParameters['code']}';
    }

    // Unauthenticated users can only access login, signup, callback
    const publicRoutes = ['/', '/signup', '/auth/callback'];
    if (!isAuthenticated && !publicRoutes.contains(loc)) {
      return '/';
    }

    // Authenticated users should not stay on login/signup
    if (isAuthenticated && (loc == '/' || loc == '/signup')) {
      return '/dashboard';
    }

    return null;
  }
}

final _routerNotifierProvider = ChangeNotifierProvider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    debugLogDiagnostics: false,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/auth/callback',
        builder: (context, state) {
          final code = state.uri.queryParameters['code'] ?? '';
          return AuthCallbackPage(code: code);
        },
      ),
    ],
  );
});