import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

import '../../domain/models/menu_item.dart';

class MenuPerformanceChip extends StatelessWidget {
  const MenuPerformanceChip({required this.status, super.key});

  final MenuPerformanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      MenuPerformanceStatus.star => (
        AppColors.mintChip,
        AppColors.primaryStrong,
      ),
      MenuPerformanceStatus.reviewCost => (
        AppColors.warningChipAlt,
        AppColors.warningStrong,
      ),
      MenuPerformanceStatus.promote => (
        AppColors.infoSurface,
        AppColors.infoStrong,
      ),
      MenuPerformanceStatus.lowPerformer => (
        AppColors.neutral75,
        AppColors.mutedStatus,
      ),
      MenuPerformanceStatus.notEnoughData => (
        AppColors.neutral100,
        AppColors.neutral700,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
