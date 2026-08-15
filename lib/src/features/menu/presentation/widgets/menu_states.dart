import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class MenuEmptyState extends StatelessWidget {
  const MenuEmptyState({required this.onAddItem, super.key});

  final VoidCallback onAddItem;

  @override
  Widget build(BuildContext context) {
    return _StateContent(
      icon: Icons.menu_book_outlined,
      title: 'Your menu is empty',
      message:
          'Add menu items so RestroPulse can track item sales, food cost, and profitability.',
      actionLabel: 'Add Menu Item',
      onAction: onAddItem,
    );
  }
}

class MenuNoResultsState extends StatelessWidget {
  const MenuNoResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StateContent(
      icon: Icons.search_off_rounded,
      title: 'No menu items found',
      message: 'Try another name, category, or performance filter.',
    );
  }
}

class MenuErrorState extends StatelessWidget {
  const MenuErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _StateContent(
      icon: Icons.cloud_off_rounded,
      title: "Couldn't load your menu",
      message: 'Check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }
}

class _StateContent extends StatelessWidget {
  const _StateContent({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.spaceLg),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MenuLoadingSkeleton extends StatelessWidget {
  const MenuLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          height: 188,
          margin: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
