import 'package:flutter/material.dart';

/// Framework-independent typography tokens used to build the Material theme.
///
/// Widgets should normally use `Theme.of(context).textTheme` so text colors
/// stay consistent with the active application theme.
abstract final class AppTypography {
  static const interFontFamily = 'Inter';
  static const plusJakartaSansFontFamily = 'Plus Jakarta Sans';

  static const display = TextStyle(
    fontSize: 48,
    height: 56 / 48,
    fontWeight: FontWeight.w700,
  );

  static const headline = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
  );

  static const title = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  static const textTheme = TextTheme(
    displayLarge: display,
    headlineMedium: headline,
    titleLarge: title,
    bodyMedium: body,
    labelSmall: caption,
  );
}
