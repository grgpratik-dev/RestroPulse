import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_state_message.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class WastageStateMessage extends StatelessWidget {
  const WastageStateMessage({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.icon = AppIcons.delete_sweep_outlined,
    super.key,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final String icon;

  @override
  Widget build(BuildContext context) => AppStateMessage(
    icon: icon,
    title: title,
    message: message,
    iconBackgroundColor: AppColors.warningMuted,
    iconColor: AppColors.warning,
    actions: [FilledButton(onPressed: onAction, child: Text(actionLabel))],
  );
}

class WastageLoadingSkeleton extends StatelessWidget {
  const WastageLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final height in [230.0, 270.0, 320.0, 220.0]) ...[
          AppSkeleton(height: height),
          const SizedBox(height: AppSpacing.spaceMd),
        ],
      ],
    );
  }
}
