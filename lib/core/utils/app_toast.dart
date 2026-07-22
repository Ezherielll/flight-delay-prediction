import 'dart:async';
import 'package:flutter/material.dart';

/// WASM-compatible top-right floating toast overlay.
/// Replaces full-width bottom SnackBars with compact, top-right floating toasts.
class AppToast {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    // 1. Get overlay state directly from navigatorKey currentState or context
    final overlayState = navigatorKey.currentState?.overlay ??
        (navigatorKey.currentContext != null
            ? Overlay.maybeOf(navigatorKey.currentContext!)
            : null);

    if (overlayState == null) return;

    // Dismiss any active toast immediately
    dismiss();

    final context = navigatorKey.currentContext;
    final isDark = context != null && Theme.of(context).brightness == Brightness.dark;

    // Design system colors based on status and theme
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final Color iconColor;
    final IconData iconData;

    if (isError) {
      iconData = Icons.error_outline_rounded;
      if (isDark) {
        bgColor = const Color(0xFF450A0A).withValues(alpha: 0.95);
        borderColor = const Color(0xFFEF4444).withValues(alpha: 0.35);
        textColor = const Color(0xFFFEE2E2);
        iconColor = const Color(0xFFFCA5A5);
      } else {
        bgColor = const Color(0xFFFEF2F2).withValues(alpha: 0.98);
        borderColor = const Color(0xFFFCA5A5).withValues(alpha: 0.7);
        textColor = const Color(0xFF991B1B);
        iconColor = const Color(0xFFEF4444);
      }
    } else {
      iconData = Icons.check_circle_outline_rounded;
      if (isDark) {
        bgColor = const Color(0xFF0F172A).withValues(alpha: 0.95);
        borderColor = const Color(0xFF334155);
        textColor = const Color(0xFFF8FAFC);
        iconColor = const Color(0xFF34D399);
      } else {
        bgColor = Colors.white.withValues(alpha: 0.98);
        borderColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF0F172A);
        iconColor = const Color(0xFF10B981);
      }
    }

    _currentEntry = OverlayEntry(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final topPadding = mediaQuery.padding.top;
        final isMobile = screenWidth < 500;

        return Positioned(
          top: topPadding > 0 ? (topPadding + 12) : 24,
          right: isMobile ? 16 : 24,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset((1 - value) * 40, (1 - value) * -10),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? (screenWidth - 32) : 360,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.4)
                          : const Color(0xFF0F172A).withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      iconData,
                      color: iconColor,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: dismiss,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.close_rounded,
                          color: textColor.withValues(alpha: 0.5),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(_currentEntry!);

    _dismissTimer = Timer(duration, dismiss);
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
