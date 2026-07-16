import 'package:flight_delay_predict/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('AppTheme', () {
    // ---------------------------------------------------------------
    // Static color constants
    // ---------------------------------------------------------------
    group('color constants', () {
      test('primaryColor is defined', () {
        expect(AppTheme.primaryColor, const Color(0xFF2563EB));
      });

      test('secondaryColor is defined', () {
        expect(AppTheme.secondaryColor, const Color(0xFF0F172A));
      });

      test('successColor is defined', () {
        expect(AppTheme.successColor, const Color(0xFF10B981));
      });

      test('dangerColor is defined', () {
        expect(AppTheme.dangerColor, const Color(0xFFEF4444));
      });

      test('warningColor is defined', () {
        expect(AppTheme.warningColor, const Color(0xFFF59E0B));
      });

      test('infoColor is defined', () {
        expect(AppTheme.infoColor, const Color(0xFF06B6D4));
      });

      test('cardRadius is 16.0', () {
        expect(AppTheme.cardRadius, 16.0);
      });
    });

    // ---------------------------------------------------------------
    // getConfidenceColor utility
    // ---------------------------------------------------------------
    group('getConfidenceColor', () {
      test('returns successColor for "high"', () {
        expect(
          AppTheme.getConfidenceColor('high'),
          AppTheme.successColor,
        );
      });

      test('returns successColor for "High" (case insensitive)', () {
        expect(
          AppTheme.getConfidenceColor('High'),
          AppTheme.successColor,
        );
      });

      test('returns successColor for "HIGH" (all caps)', () {
        expect(
          AppTheme.getConfidenceColor('HIGH'),
          AppTheme.successColor,
        );
      });

      test('returns warningColor for "medium"', () {
        expect(
          AppTheme.getConfidenceColor('medium'),
          AppTheme.warningColor,
        );
      });

      test('returns warningColor for "Medium" (case insensitive)', () {
        expect(
          AppTheme.getConfidenceColor('Medium'),
          AppTheme.warningColor,
        );
      });

      test('returns dangerColor for "low"', () {
        expect(
          AppTheme.getConfidenceColor('low'),
          AppTheme.dangerColor,
        );
      });

      test('returns dangerColor for "Low" (case insensitive)', () {
        expect(
          AppTheme.getConfidenceColor('Low'),
          AppTheme.dangerColor,
        );
      });

      test('returns dangerColor for unknown value (default)', () {
        expect(
          AppTheme.getConfidenceColor('unknown'),
          AppTheme.dangerColor,
        );
      });

      test('returns dangerColor for empty string (default)', () {
        expect(
          AppTheme.getConfidenceColor(''),
          AppTheme.dangerColor,
        );
      });
    });

    // ---------------------------------------------------------------
    // Light theme
    // ---------------------------------------------------------------
    group('lightTheme', () {
      test('uses Material 3', () {
        expect(AppTheme.lightTheme.useMaterial3, isTrue);
      });

      test('has light brightness', () {
        expect(
          AppTheme.lightTheme.colorScheme.brightness,
          Brightness.light,
        );
      });

      test('scaffold background is light slate', () {
        expect(
          AppTheme.lightTheme.scaffoldBackgroundColor,
          const Color(0xFFF8FAFC),
        );
      });

      test('card color is white', () {
        expect(AppTheme.lightTheme.cardTheme.color, Colors.white);
      });

      test('card shape has correct border radius', () {
        final shape = AppTheme.lightTheme.cardTheme.shape! as RoundedRectangleBorder;
        final radius = shape.borderRadius as BorderRadius;
        expect(radius.topLeft.x, AppTheme.cardRadius);
      });

      test('appbar is not elevated', () {
        expect(AppTheme.lightTheme.appBarTheme.elevation, 0);
      });

      test('appbar is centered', () {
        expect(AppTheme.lightTheme.appBarTheme.centerTitle, isTrue);
      });

      test('elevated button has primary color background', () {
        final style = AppTheme.lightTheme.elevatedButtonTheme.style!;
        final bgColor = style.backgroundColor!.resolve({});
        expect(bgColor, AppTheme.primaryColor);
      });

      test('input decoration uses filled mode', () {
        expect(AppTheme.lightTheme.inputDecorationTheme.filled, isTrue);
      });
    });

    // ---------------------------------------------------------------
    // Dark theme
    // ---------------------------------------------------------------
    group('darkTheme', () {
      test('uses Material 3', () {
        expect(AppTheme.darkTheme.useMaterial3, isTrue);
      });

      test('has dark brightness', () {
        expect(
          AppTheme.darkTheme.colorScheme.brightness,
          Brightness.dark,
        );
      });

      test('scaffold background is deep slate', () {
        expect(
          AppTheme.darkTheme.scaffoldBackgroundColor,
          const Color(0xFF0F172A),
        );
      });

      test('card color is slate-800', () {
        expect(
          AppTheme.darkTheme.cardTheme.color,
          const Color(0xFF1E293B),
        );
      });

      test('appbar background matches scaffold', () {
        expect(
          AppTheme.darkTheme.appBarTheme.backgroundColor,
          const Color(0xFF0F172A),
        );
      });

      test('input decoration uses filled mode', () {
        expect(AppTheme.darkTheme.inputDecorationTheme.filled, isTrue);
      });
    });
  });
}
