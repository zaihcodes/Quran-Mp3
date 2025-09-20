import 'package:flutter/material.dart';

/// A reusable error widget that displays error messages with retry functionality
class AppErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final String? errorCode;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final IconData errorIcon;

  const AppErrorWidget({
    super.key,
    this.errorMessage,
    this.errorCode,
    this.onRetry,
    this.retryButtonText = 'المحاولة مرة أخرى',
    this.errorIcon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                errorIcon,
                color: theme.colorScheme.onErrorContainer,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),

            // Error title
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error message
            Text(
              errorMessage ?? 'حدث خطأ غير متوقع',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            // Error code (for debugging purposes)
            if (errorCode != null) ...[
              const SizedBox(height: 8),
              Text(
                'رمز الخطأ: $errorCode',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Retry button
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryButtonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Audio-specific error widget
class AudioErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final String? errorCode;
  final VoidCallback? onRetry;

  const AudioErrorWidget({
    super.key,
    this.errorMessage,
    this.errorCode,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      errorMessage: errorMessage,
      errorCode: errorCode,
      onRetry: onRetry,
      errorIcon: Icons.music_off_rounded,
      retryButtonText: 'إعادة تشغيل',
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      errorMessage: errorMessage ?? 'تأكد من الاتصال بالإنترنت وحاول مرة أخرى',
      onRetry: onRetry,
      errorIcon: Icons.wifi_off_rounded,
      retryButtonText: 'إعادة الاتصال',
    );
  }
}

/// Data loading error widget
class DataErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const DataErrorWidget({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      errorMessage: errorMessage ?? 'فشل في تحميل البيانات',
      onRetry: onRetry,
      errorIcon: Icons.folder_off_rounded,
      retryButtonText: 'إعادة التحميل',
    );
  }
}

/// Utility class for showing error snackbars
class ErrorSnackBar {
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: action ??
            SnackBarAction(
              label: 'إغلاق',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}