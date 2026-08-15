import 'package:flutter/material.dart';

/// Brand color tokens used to generate the application color schemes.
///
/// Widgets should normally read semantic colors from
/// `Theme.of(context).colorScheme` instead of referencing this class directly.
abstract final class AppColors {
  static const background = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const splash = Color(0xFF047857);
  static const splashAccent = Color(0xFFB7F7DF);
  static const primary = Color(0xFF016C49);
  static const secondary = Color(0xFF5C6BC0);
  static const accent = Color(0xFF00ACC1);
  static const error = Color(0xFFBA1A1A);
  static const success = Color(0xFF2E7D32);

  // neutral colors for texts

  static Color kNeutral900 = const Color(0xff0F172A);
  static Color kNeutral800 = const Color(0xff1E293B);
  static Color kNeutral700 = const Color(0xff334155);
  static Color kNeutral600 = const Color(0xff475569);
  static Color kNeutral500 = const Color(0xff64748B);
  static Color kNeutral400 = const Color(0xff94A3BB);
  static Color kNeutral300 = const Color(0xffCBD5E1);
  static Color kNeutral200 = const Color(0xffE2E8F0);
  static Color kNeutral100 = const Color(0xffF1F5F9);
  static Color kNeutral50 = const Color(0xffF8FAFC);

}
