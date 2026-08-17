import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/gen/fonts.gen.dart';
import 'package:restropulse/src/app/theme/app_theme.dart';
import 'package:restropulse/src/app/theme/app_typography.dart';

void main() {
  test('defines every Material typography role', () {
    final roles = <TextStyle?>[
      AppTypography.textTheme.displayLarge,
      AppTypography.textTheme.displayMedium,
      AppTypography.textTheme.displaySmall,
      AppTypography.textTheme.headlineLarge,
      AppTypography.textTheme.headlineMedium,
      AppTypography.textTheme.headlineSmall,
      AppTypography.textTheme.titleLarge,
      AppTypography.textTheme.titleMedium,
      AppTypography.textTheme.titleSmall,
      AppTypography.textTheme.bodyLarge,
      AppTypography.textTheme.bodyMedium,
      AppTypography.textTheme.bodySmall,
      AppTypography.textTheme.labelLarge,
      AppTypography.textTheme.labelMedium,
      AppTypography.textTheme.labelSmall,
    ];

    expect(roles, everyElement(isNotNull));
  });

  test('uses display and reading families for their intended roles', () {
    expect(AppTypography.headlineMedium.fontFamily, FontFamily.plusJakartaSans);
    expect(AppTypography.metricLarge.fontFamily, FontFamily.plusJakartaSans);
    expect(AppTypography.bodyMedium.fontFamily, FontFamily.inter);
    expect(AppTypography.labelLarge.fontFamily, FontFamily.inter);
  });

  test('maintains a clear size hierarchy and tabular metrics', () {
    expect(
      AppTypography.displayLarge.fontSize!,
      greaterThan(AppTypography.headlineLarge.fontSize!),
    );
    expect(
      AppTypography.headlineLarge.fontSize!,
      greaterThan(AppTypography.titleLarge.fontSize!),
    );
    expect(
      AppTypography.titleLarge.fontSize!,
      greaterThan(AppTypography.bodyMedium.fontSize!),
    );
    expect(AppTypography.metricLarge.fontFeatures, isNotEmpty);
  });

  test('light theme installs the RestroPulse text theme', () {
    final theme = AppTheme.light.textTheme;

    expect(
      theme.headlineMedium?.fontSize,
      AppTypography.headlineMedium.fontSize,
    );
    expect(theme.bodyMedium?.fontFamily, FontFamily.inter);
    expect(theme.displaySmall?.fontFamily, FontFamily.plusJakartaSans);
  });
}
