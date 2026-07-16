import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static bool get _isTest {
    try {
      if (identical(0, 0.0)) {
        // Safe check for JS/Web runtime
        return false;
      }
      // kIsWeb is exported by package:flutter/foundation.dart, but is also available via material.dart
      if (kIsWeb) return false;
      return Platform.environment.containsKey('FLUTTER_TEST');
    } on Exception catch (_) {
      return false;
    }
  }

  // Brand colors
  static const Color primaryColor = Color(0xFF2563EB); // Modern Royal Blue
  static const Color secondaryColor = Color(0xFF0F172A); // Slate Blue/Dark Grey

  static const Color successColor = Color(0xFF10B981); // Emerald Green
  static const Color dangerColor = Color(0xFFEF4444); // Vibrant Red
  static const Color warningColor = Color(0xFFF59E0B); // Amber Yellow
  static const Color infoColor = Color(0xFF06B6D4); // Cyan

  // Card & Border Radius
  static const double cardRadius = 16;

  // Utility to determine confidence color
  static Color getConfidenceColor(String confidence) {
    switch (confidence.toLowerCase()) {
      case 'high':
        return successColor;
      case 'medium':
        return warningColor;
      case 'low':
      default:
        return dangerColor;
    }
  }

  // Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,

        primary: primaryColor,
        secondary: secondaryColor,
        error: dangerColor,
        surface: const Color(0xFFF8FAFC), // Very light slate grey
        surfaceContainerLowest: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      textTheme: (kIsWeb || _isTest)
          ? ThemeData.light().textTheme.copyWith(
              bodyMedium: ThemeData.light().textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF334155), // Slate-700
              ),
            )
          : GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
              bodyMedium: GoogleFonts.inter(
                textStyle: ThemeData.light().textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF334155), // Slate-700
                ),
              ),
            ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0F172A),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 1,
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9), // Slate-100
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)), // Slate-400
      ),
    );
  }

  // Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: const Color(0xFF60A5FA), // Lighter Blue
        secondary: const Color(0xFFE2E8F0),
        error: dangerColor,
        surface: const Color(0xFF0F172A), // Deep Slate
        surfaceContainerLowest: const Color(0xFF1E293B),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      textTheme: (kIsWeb || _isTest)
          ? ThemeData.dark().textTheme.copyWith(
              bodyMedium: ThemeData.dark().textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFCBD5E1), // Slate-300
              ),
            )
          : GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
              bodyMedium: GoogleFonts.inter(
                textStyle: ThemeData.dark().textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFCBD5E1), // Slate-300
                ),
              ),
            ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF1E293B), // Slate-800
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 1,
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B), // Slate-800
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: Color(0xFF64748B)), // Slate-500
      ),
    );
  }
}

// =================================================================
// Premium UI Widgets
// =================================================================

class VibrantBackground extends StatelessWidget {
  const VibrantBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        // Background base color
        Container(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        ),
        // Top Left Orb
        Positioned(
          top: -120,
          left: -120,
          width: 320,
          height: 320,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0xFF2563EB).withValues(alpha: 0.18)
                  : const Color(0xFF93C5FD).withValues(alpha: 0.35),
            ),
          ),
        ),
        // Bottom Right Orb
        Positioned(
          bottom: -150,
          right: -100,
          width: 360,
          height: 360,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0xFF7C3AED).withValues(alpha: 0.15)
                  : const Color(0xFFDDD6FE).withValues(alpha: 0.45),
            ),
          ),
        ),
        // Blur filter
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child, super.key,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding ?? const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.65)
            : Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFF2563EB).withValues(alpha: 0.05),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
