import 'package:flutter/material.dart';

/// WASM-compatible toast/snackbar overlay.
/// Replaces `fluttertoast` which uses dart:html (incompatible with --wasm builds).
class AppToast {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void show(String message, {bool isError = false}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine color design system dynamically based on theme mode and status
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final Color iconColor;
    final IconData iconData;

    if (isError) {
      iconData = Icons.error_outline_rounded;
      if (isDark) {
        bgColor = const Color(0xFF7F1D1D).withValues(alpha: 0.95); // Deep warning red
        borderColor = const Color(0xFFFCA5A5).withValues(alpha: 0.25);
        textColor = const Color(0xFFFEE2E2);
        iconColor = const Color(0xFFFCA5A5);
      } else {
        bgColor = const Color(0xFFFEF2F2).withValues(alpha: 0.98); // Light warning red
        borderColor = const Color(0xFFFCA5A5).withValues(alpha: 0.6);
        textColor = const Color(0xFF991B1B);
        iconColor = const Color(0xFFEF4444);
      }
    } else {
      iconData = Icons.check_circle_outline_rounded;
      if (isDark) {
        bgColor = const Color(0xFF1E293B).withValues(alpha: 0.95); // Slate background
        borderColor = Colors.white.withValues(alpha: 0.08);
        textColor = const Color(0xFFF1F5F9); // Crisp white-slate text
        iconColor = const Color(0xFF34D399); // Emerald success green
      } else {
        bgColor = Colors.white.withValues(alpha: 0.98); // Crisp white background
        borderColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF0F172A); // Deep slate text
        iconColor = const Color(0xFF10B981);
      }
    }

    // Dismiss existing snackbars for instant feedback
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : const Color(0xFF0F172A).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
