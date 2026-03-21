import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';

/// Handles the OAuth redirect from Cognito Hosted UI.
/// 
/// The router passes the `code` query parameter here after Google login.
/// This page exchanges the code for tokens, then the router automatically
/// redirects to /dashboard once auth state becomes [AuthStatus.authenticated].
class AuthCallbackPage extends ConsumerStatefulWidget {
  final String code;

  const AuthCallbackPage({super.key, required this.code});

  @override
  ConsumerState<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends ConsumerState<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.code.isNotEmpty) {
        ref.read(authProvider.notifier).exchangeCodeForToken(widget.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: _buildContent(authState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AuthState state) {
    if (state.status == AuthStatus.error) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            state.errorMessage ?? 'Authentication failed',
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Loading or authenticated (router will redirect on authenticated)
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: AppColors.primary),
        SizedBox(height: 16),
        Text('Signing you in...'),
      ],
    );
  }
}