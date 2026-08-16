import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_state_message.dart';

class MenuEmptyState extends StatelessWidget {
  const MenuEmptyState({required this.onAddItem, super.key});

  final VoidCallback onAddItem;

  @override
  Widget build(BuildContext context) {
    return AppStateMessage(
      icon: Icons.menu_book_outlined,
      title: 'Your menu is empty',
      message:
          'Add menu items so RestroPulse can track item sales, food cost, and profitability.',
      verticalPadding: AppSpacing.space2xl,
      maxWidth: 320,
      actions: [
        FilledButton(onPressed: onAddItem, child: const Text('Add Menu Item')),
      ],
    );
  }
}

class MenuNoResultsState extends StatelessWidget {
  const MenuNoResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppStateMessage(
      icon: Icons.search_off_rounded,
      title: 'No menu items found',
      message: 'Try another name, category, or performance filter.',
      verticalPadding: AppSpacing.space2xl,
      maxWidth: 320,
    );
  }
}

class MenuErrorState extends StatelessWidget {
  const MenuErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppStateMessage(
      icon: Icons.cloud_off_rounded,
      title: "Couldn't load your menu",
      message: 'Check your connection and try again.',
      verticalPadding: AppSpacing.space2xl,
      maxWidth: 320,
      actions: [
        FilledButton(onPressed: onRetry, child: const Text('Try Again')),
      ],
    );
  }
}

class MenuLoadingSkeleton extends StatelessWidget {
  const MenuLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => const AppSkeleton(height: 188))
          .expand(
            (widget) => [widget, const SizedBox(height: AppSpacing.spaceSm)],
          )
          .toList(),
    );
  }
}
