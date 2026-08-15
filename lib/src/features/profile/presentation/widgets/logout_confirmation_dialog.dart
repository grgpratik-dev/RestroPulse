import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({
    required this.onCancel,
    required this.onConfirm,
    super.key,
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final error = colorScheme.error;

    return Dialog(
      key: const ValueKey('logout-confirmation-dialog'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceLg,
        vertical: AppSpacing.spaceLg,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: error.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                  border: Border.all(color: error.withValues(alpha: 0.12)),
                ),
                child: Icon(Icons.logout_rounded, color: error, size: 30),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              Text(
                'Log out of RestroPulse?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                'You’ll need to sign in again to access your restaurant dashboard and reports.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const ValueKey('logout-cancel-button'),
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        minimumSize: const Size.fromHeight(50),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Expanded(
                    child: FilledButton(
                      key: const ValueKey('logout-confirm-button'),
                      onPressed: onConfirm,
                      style: FilledButton.styleFrom(
                        backgroundColor: error,
                        foregroundColor: colorScheme.onError,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Log Out'),
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
