import 'package:flutter/material.dart';
import 'package:restropulse/gen/fonts.gen.dart';

/// RestroPulse's light-theme typography system.
///
/// Plus Jakarta Sans gives high-emphasis headings and financial metrics a
/// recognizable product voice. Inter is used for dense operational text,
/// controls, labels, and supporting copy where fast reading matters most.
abstract final class AppTypography {
  static const _displayFamily = FontFamily.plusJakartaSans;
  static const _readingFamily = FontFamily.inter;

  static const displayLarge = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 40,
    height: 48 / 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
  );

  static const displayMedium = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.65,
  );

  static const displaySmall = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const headlineLarge = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.35,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  static const headlineSmall = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.15,
  );

  static const titleLarge = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 18,
    height: 26 / 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
  );

  static const titleMedium = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w700,
  );

  static const titleSmall = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  static const bodySmall = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w400,
  );

  static const labelLarge = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.05,
  );

  static const labelMedium = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const labelSmall = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  /// Large financial totals and primary KPIs.
  static const metricLarge = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 32,
    height: 38 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.65,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Card-level financial totals and performance values.
  static const metricMedium = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Compact metric cards and list-level values.
  static const metricSmall = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Uppercase section markers such as ITEM BREAKDOWN.
  static const eyebrow = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static const chartLabel = TextStyle(
    fontFamily: _readingFamily,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w500,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
