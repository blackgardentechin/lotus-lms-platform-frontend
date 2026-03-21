import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Error Banner Widget
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  
  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.error,
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}
