import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.showCancelButton = true,
    this.icon = AppIcons.help_outline_rounded,
    this.isDestructive = false,
    this.confirmButtonKey,
    this.onConfirm,
    this.onCancel,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool showCancelButton;
  final String icon;
  final bool isDestructive;
  final Key? confirmButtonKey;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isDestructive ? theme.colorScheme.error : AppColors.primary;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.spaceLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: accent.withValues(alpha: 0.14)),
                ),
                child: SvgPicture.asset(icon),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              Row(
                children: [
                  if (showCancelButton) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            onCancel ?? () => Navigator.of(context).pop(false),
                        child: Text(cancelLabel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceSm),
                  ],
                  Expanded(
                    child: FilledButton(
                      key: confirmButtonKey,
                      onPressed:
                          onConfirm ?? () => Navigator.of(context).pop(true),
                      style: isDestructive
                          ? FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: theme.colorScheme.onError,
                            )
                          : null,
                      child: Text(confirmLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
