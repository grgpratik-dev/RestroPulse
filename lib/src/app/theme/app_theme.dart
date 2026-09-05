import 'package:flutter/material.dart';
import 'package:restropulse/gen/fonts.gen.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Application-wide Material theme configuration.
abstract final class AppTheme {
  static final ThemeData light = _create();

  static ThemeData _create() {
    final generatedScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );
    final colorScheme = generatedScheme.copyWith(
      surface: AppColors.surface,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      error: AppColors.error,
    );
    const buttonRadius = BorderRadius.all(Radius.circular(AppRadius.md));

    return ThemeData(
      fontFamily: FontFamily.inter,
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,

        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceMd,
          vertical: AppSpacing.spaceMd,
        ),
        border: const OutlineInputBorder(borderRadius: buttonRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: buttonRadius,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: buttonRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: buttonRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: buttonRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(color: colorScheme.error),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          textStyle: AppTypography.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppTypography.titleMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        leadingAndTrailingTextStyle: AppTypography.labelLarge.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
      ),
      cardTheme: const CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
    );
  }
}
