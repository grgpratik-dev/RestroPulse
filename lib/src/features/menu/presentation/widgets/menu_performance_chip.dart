import 'package:flutter/material.dart';

import '../../domain/models/menu_item.dart';

class MenuPerformanceChip extends StatelessWidget {
  const MenuPerformanceChip({required this.status, super.key});

  final MenuPerformanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      MenuPerformanceStatus.star => (
        const Color(0xFFDDF7EC),
        const Color(0xFF047857),
      ),
      MenuPerformanceStatus.reviewCost => (
        const Color(0xFFFFEDD5),
        const Color(0xFF9A3412),
      ),
      MenuPerformanceStatus.promote => (
        const Color(0xFFDBEAFE),
        const Color(0xFF1D4ED8),
      ),
      MenuPerformanceStatus.lowPerformer => (
        const Color(0xFFF3F4F6),
        const Color(0xFF6B3C34),
      ),
      MenuPerformanceStatus.notEnoughData => (
        const Color(0xFFF1F5F9),
        const Color(0xFF475569),
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
