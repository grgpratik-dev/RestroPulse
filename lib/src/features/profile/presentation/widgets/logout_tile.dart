import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;

    return Material(
      color: error.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        key: const ValueKey('profile-logout-button'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceMd,
            vertical: AppSpacing.spaceMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: error, size: 21),
              const SizedBox(width: AppSpacing.spaceXs),
              Text(
                'Log Out',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
