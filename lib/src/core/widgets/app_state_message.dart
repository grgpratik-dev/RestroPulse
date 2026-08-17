import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

/// Consistent empty, error, and no-data presentation used across features.
class AppStateMessage extends StatelessWidget {
  const AppStateMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actions = const [],
    this.iconBackgroundColor,
    this.iconColor,
    this.verticalPadding = AppSpacing.space3xl,
    this.maxWidth = 330,
    super.key,
  });

  final String icon;
  final String title;
  final String message;
  final List<Widget> actions;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final double verticalPadding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: iconBackgroundColor ?? colors.primaryContainer,
                child: AppIcon(
                  icon,
                  color: iconColor ?? colors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.spaceLg),
                for (var index = 0; index < actions.length; index++) ...[
                  SizedBox(width: double.infinity, child: actions[index]),
                  if (index != actions.length - 1)
                    const SizedBox(height: AppSpacing.spaceXs),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
