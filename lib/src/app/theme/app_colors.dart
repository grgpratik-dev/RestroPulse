import 'package:flutter/material.dart';

/// Brand color tokens used to generate the application color schemes.
///
/// Widgets should normally read semantic colors from
/// `Theme.of(context).colorScheme` instead of referencing this class directly.
abstract final class AppColors {
  // Core brand and surfaces.
  static const background = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const splash = Color(0xFF047857);
  static const splashBright = Color(0xFF11B981);
  static const splashAccent = Color(0xFFB7F7DF);
  static const primary = Color(0xFF016C49);
  static const primaryStrong = Color(0xFF047857);
  static const secondary = Color(0xFF5C6BC0);
  static const accent = Color(0xFF00ACC1);
  static const error = Color(0xFFBA1A1A);
  static const success = Color(0xFF2E7D32);

  // Semantic surfaces and feedback.
  static const ink = Color(0xFF102037);
  static const mintSurface = Color(0xFFF0FBF7);
  static const mintSoft = Color(0xFFE4F5EF);
  static const mintChip = Color(0xFFDDF7EC);
  static const mintBright = Color(0xFF7DE2B8);
  static const successSurface = Color(0xFFEAF7EF);
  static const successStrong = Color(0xFF0F8A63);

  // Restaurant Pulse health visualization.
  static const pulseHealthy = Color(0xFFFB7185);
  static const pulseHealthyHighlight = Color(0xFFFFE4E6);
  static const pulseModerate = Color(0xFFF59E0B);
  static const pulseModerateHighlight = Color(0xFFFEF3C7);
  static const pulseLow = Color(0xFFEF4444);
  static const pulseLowHighlight = Color(0xFFFECACA);

  static const warning = Color(0xFFB45309);
  static const warningStrong = Color(0xFF9A3412);
  static const warningSurface = Color(0xFFFFF7ED);
  static const warningSoft = Color(0xFFFFF4E5);
  static const warningMuted = Color(0xFFFFF2DF);
  static const warningChip = Color(0xFFFFE8CC);
  static const warningChipAlt = Color(0xFFFFEDD5);
  static const warningBorder = Color(0xFFFED7AA);
  static const warningBorderStrong = Color(0xFFFDBA74);
  static const warningChart = Color(0xFFE38B2C);
  static const amber = Color(0xFFF59E0B);
  static const amberDark = Color(0xFFB7791F);

  // Money direction.
  static const expenseSurface = Color(0xFFFEF2F2);
  static const expenseBorder = Color(0xFFFECACA);
  static const expenseForeground = Color(0xFFB91C1C);
  static const expenseAccent = Color(0xFFDC2626);
  static const expenseSoft = Color(0xFFFFD5C7);
  static const expenseWarm = Color(0xFFFFC7A5);

  // Channels, charts, and performance statuses.
  static const info = Color(0xFF2563EB);
  static const infoStrong = Color(0xFF1D4ED8);
  static const infoForeground = Color(0xFF173B6C);
  static const infoSurface = Color(0xFFDBEAFE);
  static const infoSurfaceSoft = Color(0xFFDCEAFE);
  static const danger = Color(0xFF991B1B);
  static const dangerSurface = Color(0xFFFED7D7);
  static const mutedStatus = Color(0xFF6B3C34);

  // Neutral colors for text, borders, and subdued states.
  static const neutral950 = Color(0xFF0F172A);
  static const neutral900 = Color(0xFF1E293B);
  static const neutral800 = Color(0xFF334155);
  static const neutral700 = Color(0xFF475569);
  static const neutral600 = Color(0xFF64748B);
  static const neutral500 = Color(0xFF94A3B8);
  static const neutral400 = Color(0xFFCBD5E1);
  static const neutral300 = Color(0xFFE2E8F0);
  static const neutral200 = Color(0xFFE5E7EB);
  static const neutral100 = Color(0xFFF1F5F9);
  static const neutral75 = Color(0xFFF3F4F6);
  static const neutral50 = Color(0xFFF8FAFC);
  static const authBackground = Color(0xFFF3F8F6);

  // Backwards-compatible aliases while older widgets migrate.
  static const kNeutral900 = neutral950;
  static const kNeutral800 = neutral900;
  static const kNeutral700 = neutral800;
  static const kNeutral600 = neutral700;
  static const kNeutral500 = neutral600;
  static const kNeutral400 = Color(0xFF94A3BB);
  static const kNeutral300 = neutral400;
  static const kNeutral200 = neutral300;
  static const kNeutral100 = neutral100;
  static const kNeutral50 = neutral50;
}
