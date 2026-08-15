import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class WastageStateMessage extends StatelessWidget {
  const WastageStateMessage({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.icon = Icons.delete_sweep_outlined,
    super.key,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3xl),
    child: Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFFFF2DF),
            child: Icon(icon, color: const Color(0xFFB45309), size: 32),
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
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.spaceLg),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    ),
  );
}

class WastageLoadingSkeleton extends StatelessWidget {
  const WastageLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Column(
      children: [
        for (final height in [230.0, 270.0, 320.0, 220.0]) ...[
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
        ],
      ],
    );
  }
}
